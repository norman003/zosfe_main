*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_PROC_DOCSNOELECT_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  OBTENER_CONSTANTES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM obtener_constantes .
  DATA:
    ls_vbtyp LIKE LINE OF gr_vbtyp.

  CLEAR gr_vbtyp.

  CLEAR ls_vbtyp.
  ls_vbtyp-sign   = 'I'.
  ls_vbtyp-option = 'EQ'.
  ls_vbtyp-low    = gc_charm.
  APPEND ls_vbtyp TO gr_vbtyp.
  ls_vbtyp-low    = gc_charo.
  APPEND ls_vbtyp TO gr_vbtyp.
  ls_vbtyp-low    = gc_charp.
  APPEND ls_vbtyp TO gr_vbtyp.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VALIDACION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM validacion .
  DATA:
    ls_tcsun LIKE LINE OF gr_tcsun.

  CLEAR gr_tcsun.

  IF  p_chkfac IS INITIAL
  AND p_chkbol IS INITIAL
  AND p_chknc  IS INITIAL
  AND p_chknd  IS INITIAL.
    gw_proc = gc_chare.
    MESSAGE text-e01 TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

  CHECK gw_proc NE gc_chare.

  SELECT SINGLE *
    INTO gs_constantes
    FROM zostb_consextsun
    WHERE bukrs EQ p_bukrs.
  IF sy-subrc NE 0.
    gw_proc = gc_chare.
    MESSAGE text-e04 TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

  CHECK gw_proc NE gc_chare.

  IF p_chkfac EQ gc_charx.
    CLEAR ls_tcsun.
    ls_tcsun-sign   = 'I'.
    ls_tcsun-option = 'EQ'.
    ls_tcsun-low    = gc_char01.
    APPEND ls_tcsun TO gr_tcsun.
  ENDIF.

  IF p_chkbol EQ gc_charx.
    CLEAR ls_tcsun.
    ls_tcsun-sign   = 'I'.
    ls_tcsun-option = 'EQ'.
    ls_tcsun-low    = gc_char03.
    APPEND ls_tcsun TO gr_tcsun.
  ENDIF.

  IF p_chknc EQ gc_charx.
    CLEAR ls_tcsun.
    ls_tcsun-sign   = 'I'.
    ls_tcsun-option = 'EQ'.
    ls_tcsun-low    = gc_char07.
    APPEND ls_tcsun TO gr_tcsun.
  ENDIF.

  IF p_chknd EQ gc_charx.
    CLEAR ls_tcsun.
    ls_tcsun-sign   = 'I'.
    ls_tcsun-option = 'EQ'.
    ls_tcsun-low    = gc_char08.
    APPEND ls_tcsun TO gr_tcsun.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  OBTENER_FACTURAS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM obtener_facturas .
  DATA:
    lth_bkpf TYPE HASHED TABLE OF   ty_bkpf WITH UNIQUE KEY awkey,
    lt_vbrk  TYPE STANDARD TABLE OF ty_vbrk,

    lw_inde1 TYPE  numc10.

  FIELD-SYMBOLS:
    <fs_vbrk> TYPE  ty_vbrk.

  CHECK gw_proc NE gc_chare.

  CLEAR: gt_vbrk,
         gt_log.

  CREATE OBJECT cl_extfac.

  SELECT  vbeln fkart vbtyp fkdat vkorg vtweg spart rfbsk fksto sfakn
          kunag kunrg netwr mwsbk waerk xblnr bukrs vbeln
    INTO TABLE gt_vbrk  ##TOO_MANY_ITAB_FIELDS
    FROM vbrk
    WHERE vbeln IN s_vbeln
      AND fkdat IN s_fkdat.

  DELETE gt_vbrk WHERE bukrs NE p_bukrs.
  DELETE gt_vbrk WHERE vbtyp NOT IN gr_vbtyp.
  DELETE gt_vbrk WHERE rfbsk NE gc_charc.
  DELETE gt_vbrk WHERE fksto NE space.
  DELETE gt_vbrk WHERE sfakn NE space.

  IF gt_vbrk[] IS INITIAL.
    gw_proc = gc_chare.
    MESSAGE text-e02 TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

  CHECK gw_proc NE gc_chare.

  lt_vbrk[] = gt_vbrk[].
  SORT lt_vbrk BY awkey ASCENDING.
  DELETE ADJACENT DUPLICATES FROM lt_vbrk COMPARING awkey.

  IF lt_vbrk[] IS NOT INITIAL.
    SELECT  bukrs belnr gjahr awtyp awkey
      INTO TABLE lth_bkpf
      FROM bkpf
      FOR ALL ENTRIES IN lt_vbrk
      WHERE awtyp EQ 'VBRK'
        AND awkey EQ lt_vbrk-awkey.
  ENDIF.

  lw_inde1 = 1.
  DO.
    READ TABLE gt_vbrk ASSIGNING <fs_vbrk> INDEX lw_inde1.
    IF sy-subrc NE 0. EXIT. ENDIF.
    ADD 1 TO lw_inde1.

    " Verificar documento contable generado
    READ TABLE lth_bkpf TRANSPORTING NO FIELDS
         WITH TABLE KEY awkey = <fs_vbrk>-awkey.
    IF sy-subrc NE 0.
      <fs_vbrk>-updkz = gc_chard.
      CONTINUE.
    ENDIF.
    " Tipo de comprobante Sunat
    <fs_vbrk>-codsunat = <fs_vbrk>-xblnr(2).
    " Icon sin Procesar
    <fs_vbrk>-icon     = '@EB@'.
  ENDDO.
  DELETE gt_vbrk WHERE updkz EQ gc_chard.
  DELETE gt_vbrk WHERE codsunat NOT IN gr_tcsun.

  IF gt_vbrk[] IS INITIAL.
    gw_proc = gc_chare.
    MESSAGE text-e02 TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

  CHECK gw_proc NE gc_chare.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MOSTRAR_FACTURAS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM mostrar_facturas .
  DATA:
    lt_fieldcat TYPE  slis_t_fieldcat_alv,
    lt_events   TYPE  slis_t_event,
    ls_fieldcat TYPE  slis_fieldcat_alv,
    ls_events   TYPE  slis_alv_event,
    ls_variant  TYPE  disvariant,
    ls_layout   TYPE  slis_layout_alv,
    lw_program  TYPE  sy-repid VALUE sy-repid.

  CHECK gw_proc NE gc_chare.

  CLEAR ls_fieldcat.
  ls_fieldcat-tabname         = 'GT_VBRK'.
  ls_fieldcat-fieldname       = 'ICON'.
  ls_fieldcat-icon            = gc_charx.
  ls_fieldcat-seltext_s       = text-001.
  ls_fieldcat-seltext_m       = text-001.
  ls_fieldcat-seltext_l       = text-001.
  ls_fieldcat-reptext_ddic    = text-001.
  ls_fieldcat-outputlen       = 6.
  ls_fieldcat-just            = 'C'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-tabname         = 'GT_VBRK'.
  ls_fieldcat-fieldname       = 'BUKRS'.
  ls_fieldcat-ref_tabname     = 'VBRK'.
  ls_fieldcat-ref_fieldname   = 'BUKRS'.
  ls_fieldcat-just            = 'L'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-tabname         = 'GT_VBRK'.
  ls_fieldcat-fieldname       = 'VBELN'.
  ls_fieldcat-ref_tabname     = 'VBRK'.
  ls_fieldcat-ref_fieldname   = 'VBELN'.
  ls_fieldcat-just            = 'L'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-tabname         = 'GT_VBRK'.
  ls_fieldcat-fieldname       = 'FKART'.
  ls_fieldcat-ref_tabname     = 'VBRK'.
  ls_fieldcat-ref_fieldname   = 'FKART'.
  ls_fieldcat-just            = 'L'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-tabname         = 'GT_VBRK'.
  ls_fieldcat-fieldname       = 'FKDAT'.
  ls_fieldcat-ref_tabname     = 'VBRK'.
  ls_fieldcat-ref_fieldname   = 'FKDAT'.
  ls_fieldcat-just            = 'L'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-tabname         = 'GT_VBRK'.
  ls_fieldcat-fieldname       = 'VKORG'.
  ls_fieldcat-ref_tabname     = 'VBRK'.
  ls_fieldcat-ref_fieldname   = 'VKORG'.
  ls_fieldcat-just            = 'L'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-tabname         = 'GT_VBRK'.
  ls_fieldcat-fieldname       = 'VTWEG'.
  ls_fieldcat-ref_tabname     = 'VBRK'.
  ls_fieldcat-ref_fieldname   = 'VTWEG'.
  ls_fieldcat-just            = 'L'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-tabname         = 'GT_VBRK'.
  ls_fieldcat-fieldname       = 'SPART'.
  ls_fieldcat-ref_tabname     = 'VBRK'.
  ls_fieldcat-ref_fieldname   = 'SPART'.
  ls_fieldcat-just            = 'L'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-tabname         = 'GT_VBRK'.
  ls_fieldcat-fieldname       = 'RFBSK'.
  ls_fieldcat-ref_tabname     = 'VBRK'.
  ls_fieldcat-ref_fieldname   = 'RFBSK'.
  ls_fieldcat-just            = 'L'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-tabname         = 'GT_VBRK'.
  ls_fieldcat-fieldname       = 'KUNRG'.
  ls_fieldcat-ref_tabname     = 'VBRK'.
  ls_fieldcat-ref_fieldname   = 'KUNRG'.
  ls_fieldcat-just            = 'L'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-tabname         = 'GT_VBRK'.
  ls_fieldcat-fieldname       = 'XBLNR'.
  ls_fieldcat-ref_tabname     = 'VBRK'.
  ls_fieldcat-ref_fieldname   = 'XBLNR'.
  ls_fieldcat-just            = 'L'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-tabname         = 'GT_VBRK'.
  ls_fieldcat-fieldname       = 'NETWR'.
  ls_fieldcat-ref_tabname     = 'VBRK'.
  ls_fieldcat-ref_fieldname   = 'NETWR'.
  ls_fieldcat-ctabname        = 'GT_VBRK'.
  ls_fieldcat-cfieldname      = 'WAERK'.
  ls_fieldcat-just            = 'R'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-tabname         = 'GT_VBRK'.
  ls_fieldcat-fieldname       = 'MWSBK'.
  ls_fieldcat-ref_tabname     = 'VBRK'.
  ls_fieldcat-ref_fieldname   = 'MWSBK'.
  ls_fieldcat-ctabname        = 'GT_VBRK'.
  ls_fieldcat-cfieldname      = 'WAERK'.
  ls_fieldcat-just            = 'R'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-tabname         = 'GT_VBRK'.
  ls_fieldcat-fieldname       = 'WAERK'.
  ls_fieldcat-ref_tabname     = 'VBRK'.
  ls_fieldcat-ref_fieldname   = 'WAERK'.
  ls_fieldcat-just            = 'L'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-tabname         = 'GT_VBRK'.
  ls_fieldcat-fieldname       = 'CODSUNAT'.
  ls_fieldcat-seltext_s       = TEXT-002.
  ls_fieldcat-seltext_m       = TEXT-002.
  ls_fieldcat-seltext_l       = TEXT-002.
  ls_fieldcat-reptext_ddic    = TEXT-002.
  ls_fieldcat-outputlen       = 8.
  ls_fieldcat-just            = 'L'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_events.
  ls_events-name = slis_ev_pf_status_set.
  ls_events-form = slis_ev_pf_status_set.
  APPEND ls_events TO lt_events.

  CLEAR ls_events.
  ls_events-name = slis_ev_user_command.
  ls_events-form = slis_ev_user_command.
  APPEND ls_events TO lt_events.

  ls_layout-box_fieldname = 'SELEC'.
  ls_layout-colwidth_optimize = gc_charx.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = lw_program
      is_layout          = ls_layout
      i_default          = space
      i_save             = 'A'
      is_variant         = ls_variant
      it_events          = lt_events
      it_fieldcat        = lt_fieldcat
    TABLES
      t_outtab           = gt_vbrk
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  pf_status_set
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PI_EXTAB   text
*----------------------------------------------------------------------*
FORM pf_status_set USING  pi_extab  TYPE  slis_t_extab ##CALLED.
  DATA:
        ls_extab    TYPE  slis_extab ##NEEDED.

  SET PF-STATUS 'STAT_1000' EXCLUDING pi_extab.

ENDFORM.                    "pf_status_set
*---------------------------------------------------------------------*
*       FORM USER_COMMAND                                             *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM user_command  USING pi_ucomm LIKE sy-ucomm
                         ps_selfield TYPE slis_selfield ##CALLED.
  DATA  ls_vbrk   TYPE  ty_vbrk.

  CASE pi_ucomm.
    WHEN '&IC1'.
      READ TABLE gt_vbrk INTO ls_vbrk INDEX ps_selfield-tabindex.
      IF sy-subrc EQ 0.
        SET PARAMETER ID 'VF' FIELD ls_vbrk-vbeln.
        CALL TRANSACTION 'VF03' AND SKIP FIRST SCREEN.
      ENDIF.

    WHEN '&SERFEC'.
      PERFORM asignar_serie_fecha.
      ps_selfield-col_stable  = gc_charx.
      ps_selfield-row_stable  = gc_charx.
      ps_selfield-refresh     = gc_charx.

    WHEN '&PROC'.
      PERFORM procesar.
      ps_selfield-col_stable  = gc_charx.
      ps_selfield-row_stable  = gc_charx.
      ps_selfield-refresh     = gc_charx.

    WHEN '&LOG'.
      PERFORM mostrar_log.
      ps_selfield-col_stable  = gc_charx.
      ps_selfield-row_stable  = gc_charx.
      ps_selfield-refresh     = gc_charx.

  ENDCASE.

ENDFORM.                    "USER_COMMAND
*&---------------------------------------------------------------------*
*&      Form  PROCESAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM procesar .
  DATA:
    lt_vbrk         TYPE STANDARD TABLE OF ty_vbrk,
    lt_fecab        TYPE zostt_fecab,                       "#EC NEEDED
    lt_fecab2       TYPE zostt_fecab2,                      "#EC NEEDED
    lt_fedet        TYPE zostt_fedet,                       "#EC NEEDED
    lt_fecli        TYPE zostt_fecli,                       "#EC NEEDED
    lt_headtext     TYPE zostt_docexpostc, "#EC NEEDED                           "I-WMR-230615
    lt_message      TYPE bapiret2tab,

    ls_log          TYPE ty_log,
    ls_message      TYPE bapiret2,
    " Definiciones para el proceso de servicio web TEST
    ""    inputfc     TYPE zosws_wsosfc_documentos_reques,
    ""    inputbl     TYPE zosws_wsosbl_documentos_reques,
    ""    inputnc     TYPE zosws_wsosnc_documentos_reques,
    ""    inputnd     TYPE zosws_wsosnd_documentos_reques,

    lw_current      TYPE numc10,
    lw_percent      TYPE numc3,
    lw_lines        TYPE numc10,
    lw_error        TYPE char01,
    lw_bypasslotono   ##TYPE_CHAIN_OK.
  ""    lw_numeraci TYPE char12.

  FIELD-SYMBOLS:
    <fs_vbrk> TYPE  ty_vbrk.

  lt_vbrk[] = gt_vbrk[].
  DELETE lt_vbrk WHERE selec NE gc_charx.

  IF lt_vbrk[] IS INITIAL.
    MESSAGE text-e03 TYPE 'S' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  DELETE lt_vbrk WHERE process NE gc_chars.
  IF lt_vbrk[] IS NOT INITIAL.
    MESSAGE text-w01 TYPE 'I'.
  ENDIF.

  lt_vbrk[] = gt_vbrk[].
  DELETE lt_vbrk WHERE selec NE gc_charx.
  DESCRIBE TABLE lt_vbrk LINES lw_lines.

  lw_bypasslotono = gc_charx.
  EXPORT lw_bypasslotono = lw_bypasslotono TO MEMORY ID 'BYPASSLOTNO'.

  lw_current = 0.
  LOOP AT gt_vbrk ASSIGNING <fs_vbrk> WHERE selec   EQ gc_charx
                                        AND process NE gc_chars.
    ADD 1 TO lw_current.
    lw_percent = ( lw_current / lw_lines ) * 100.
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        percentage = lw_percent
        text       = TEXT-003.

    CLEAR:
           lt_fecab,
           lt_fecab2,
           lt_fedet,
           lt_fecli,
           lt_message,
           lw_error.
    ""           inputfc,
    ""           inputbl,
    ""           inputnc,
    ""           inputnd,
    ""           lw_numeraci.

*{BE NTP-060616
*    CASE <fs_vbrk>-codsunat.
*      WHEN gc_char01. " Factura
*        CALL METHOD cl_extfac->extrae_data_facturas
*          EXPORTING
*            p_vbeln    = <fs_vbrk>-vbeln
*          IMPORTING
*            p_fecab    = lt_fecab
*            p_fecab2   = lt_fecab2
*            p_fedet    = lt_fedet
*            p_fecli    = lt_fecli
*            p_headtext = lt_headtext                                    "I-WMR-230615
*            p_error    = lw_error
*            p_message  = lt_message.
*
*        IF lw_error EQ space.
*          PERFORM update_documents  USING     <fs_vbrk>
*                                    CHANGING  lt_fecab
*                                              lt_fecab2
*                                              lt_fedet
*                                              lt_fecli.
*
*          ""          CALL METHOD cl_extfac->set_ws_fa
*          ""            EXPORTING
*          ""              pi_user     = gs_constantes-zz_usuario_web
*          ""              pi_pass     = gs_constantes-zz_pass_web
*          ""              pi_fecab    = lt_fecab
*          ""              pi_fecab2   = lt_fecab2
*          ""              pi_fedet    = lt_fedet
*          ""              pi_fecli    = lt_fecli
*          ""            IMPORTING
*          ""              pe_datosws  = inputfc
*          ""              pe_numeraci = lw_numeraci.
*
*          ""          CALL METHOD cl_extfac->call_ws_1
*          ""            EXPORTING
*          ""              pi_tipdoc   = <fs_vbrk>-codsunat
*          ""              pi_proxy    = gs_constantes-zz_proxy_name
*          ""              pi_input    = inputfc
*          ""              pi_numeraci = lw_numeraci
*          ""              pi_vbeln    = <fs_vbrk>-vbeln
*          ""            IMPORTING
*          ""              pe_message  = lt_message.
*        ENDIF.
*
*      WHEN gc_char03. " Boleta
*        CALL METHOD cl_extfac->extrae_data_boletas
*          EXPORTING
*            p_vbeln    = <fs_vbrk>-vbeln
*          IMPORTING
*            p_fecab    = lt_fecab
*            p_fecab2   = lt_fecab2
*            p_fedet    = lt_fedet
*            p_fecli    = lt_fecli
*            p_headtext = lt_headtext                                    "I-WMR-230615
*            p_error    = lw_error
*            p_message  = lt_message.
*
*        IF lw_error EQ space.
*          PERFORM update_documents  USING     <fs_vbrk>
*                                    CHANGING  lt_fecab
*                                              lt_fecab2
*                                              lt_fedet
*                                              lt_fecli.
*
*          ""          CALL METHOD cl_extfac->set_ws_bl
*          ""            EXPORTING
*          ""              pi_user     = gs_constantes-zz_usuario_web
*          ""              pi_pass     = gs_constantes-zz_pass_web
*          ""              pi_fecab    = lt_fecab
*          ""              pi_fecab2   = lt_fecab2
*          ""              pi_fedet    = lt_fedet
*          ""              pi_fecli    = lt_fecli
*          ""            IMPORTING
*          ""              pe_datosws  = inputbl
*          ""              pe_numeraci = lw_numeraci.
*
*          ""          CALL METHOD cl_extfac->call_ws_1
*          ""            EXPORTING
*          ""              pi_tipdoc   = <fs_vbrk>-codsunat
*          ""              pi_proxy    = gs_constantes-zz_proxy_name
*          ""              pi_input    = inputbl
*          ""              pi_numeraci = lw_numeraci
*          ""              pi_vbeln    = <fs_vbrk>-vbeln
*          ""            IMPORTING
*          ""              pe_message  = lt_message.
*        ENDIF.
*
*      WHEN gc_char07. " NC
*        CALL METHOD cl_extfac->extrae_data_nc
*          EXPORTING
*            p_vbeln    = <fs_vbrk>-vbeln
*          IMPORTING
*            p_fecab    = lt_fecab
*            p_fecab2   = lt_fecab2
*            p_fedet    = lt_fedet
*            p_fecli    = lt_fecli
*            p_headtext = lt_headtext                                    "I-WMR-230615
*            p_error    = lw_error
*            p_message  = lt_message.
*
*        IF lw_error EQ space.
*          PERFORM update_documents  USING     <fs_vbrk>
*                                    CHANGING  lt_fecab
*                                              lt_fecab2
*                                              lt_fedet
*                                              lt_fecli.
*
*          ""          CALL METHOD cl_extfac->set_ws_nc
*          ""            EXPORTING
*          ""              pi_user     = gs_constantes-zz_usuario_web
*          ""              pi_pass     = gs_constantes-zz_pass_web
*          ""              pi_fecab    = lt_fecab
*          ""              pi_fecab2   = lt_fecab2
*          ""              pi_fedet    = lt_fedet
*          ""              pi_fecli    = lt_fecli
*          ""            IMPORTING
*          ""              pe_datosws  = inputnc
*          ""              pe_numeraci = lw_numeraci.
*
*          ""          CALL METHOD cl_extfac->call_ws_1
*          ""            EXPORTING
*          ""              pi_tipdoc   = <fs_vbrk>-codsunat
*          ""              pi_proxy    = gs_constantes-zz_proxy_name
*          ""              pi_input    = inputnc
*          ""              pi_numeraci = lw_numeraci
*          ""              pi_vbeln    = <fs_vbrk>-vbeln
*          ""            IMPORTING
*          ""              pe_message  = lt_message.
*        ENDIF.
*
*      WHEN gc_char08. " ND
*        CALL METHOD cl_extfac->extrae_data_nd
*          EXPORTING
*            p_vbeln    = <fs_vbrk>-vbeln
*          IMPORTING
*            p_fecab    = lt_fecab
*            p_fecab2   = lt_fecab2
*            p_fedet    = lt_fedet
*            p_fecli    = lt_fecli
*            p_headtext = lt_headtext                                    "I-WMR-230615
*            p_error    = lw_error
*            p_message  = lt_message.
*
*        IF lw_error EQ space.
*          PERFORM update_documents  USING     <fs_vbrk>
*                                    CHANGING  lt_fecab
*                                              lt_fecab2
*                                              lt_fedet
*                                              lt_fecli.
*
*          ""          CALL METHOD cl_extfac->set_ws_nd
*          ""            EXPORTING
*          ""              pi_user     = gs_constantes-zz_usuario_web
*          ""              pi_pass     = gs_constantes-zz_pass_web
*          ""              pi_fecab    = lt_fecab
*          ""              pi_fecab2   = lt_fecab2
*          ""              pi_fedet    = lt_fedet
*          ""              pi_fecli    = lt_fecli
*          ""            IMPORTING
*          ""              pe_datosws  = inputnd
*          ""              pe_numeraci = lw_numeraci.
*
*          ""          CALL METHOD cl_extfac->call_ws_1
*          ""            EXPORTING
*          ""              pi_tipdoc   = <fs_vbrk>-codsunat
*          ""              pi_proxy    = gs_constantes-zz_proxy_name
*          ""              pi_input    = inputnd
*          ""              pi_numeraci = lw_numeraci
*          ""              pi_vbeln    = <fs_vbrk>-vbeln
*          ""            IMPORTING
*          ""              pe_message  = lt_message.
*        ENDIF.
*
*    ENDCASE.
*}EE NTP-060616

    IF lw_error EQ gc_charx.
      <fs_vbrk>-process = gc_chare.
      <fs_vbrk>-icon    = '@0A@'.
    ELSE.
      <fs_vbrk>-process = gc_chars.
      <fs_vbrk>-icon    = '@08@'.
    ENDIF.

    CLEAR ls_log.
    ls_log-vbeln = <fs_vbrk>-vbeln.
    LOOP AT lt_message INTO ls_message.
      MOVE-CORRESPONDING ls_message TO ls_log.
      CASE ls_log-type.
        WHEN 'S'.
          ls_log-icon = '3'.
        WHEN 'W' OR 'I'.
          ls_log-icon = '2'.
        WHEN 'E' OR 'A'.
          ls_log-icon = '1'.
        WHEN OTHERS.
          ls_log-icon = '0'.
      ENDCASE.
      APPEND ls_log TO gt_log.
    ENDLOOP.
  ENDLOOP.

  FREE MEMORY ID 'BYPASSLOTNO'.

  LOOP AT gt_vbrk ASSIGNING <fs_vbrk> WHERE selec EQ gc_charx.
    CLEAR <fs_vbrk>-selec.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MOSTRAR_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM mostrar_log .
  DATA:
    lt_fieldcat TYPE slis_t_fieldcat_alv,
    ls_fieldcat TYPE slis_fieldcat_alv,
    ls_layout   TYPE slis_layout_alv.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname     = 'VBELN'.
  ls_fieldcat-outputlen     = '10'.
  ls_fieldcat-ref_fieldname = 'VBELN'.
  ls_fieldcat-ref_tabname   = 'VBRK'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname     = 'MESSAGE'.
  ls_fieldcat-outputlen     = '70'.
  ls_fieldcat-seltext_l     = TEXT-004.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_layout.
  ls_layout-lights_fieldname = 'ICON'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      is_layout             = ls_layout
      it_fieldcat           = lt_fieldcat
      i_grid_title          = TEXT-005
      i_screen_start_column = 5
      i_screen_start_line   = 5
      i_screen_end_column   = 110
      i_screen_end_line     = 15
    TABLES
      t_outtab              = gt_log
    EXCEPTIONS ##FM_SUBRC_OK
      OTHERS                = 1.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPDATE_DOCUMENTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LT_FECAB  text
*----------------------------------------------------------------------*
FORM update_documents   USING    ps_vbrk    TYPE  ty_vbrk
                        CHANGING pt_fecab   TYPE  zostt_fecab
                                 pt_fecab2  TYPE  zostt_fecab2
                                 pt_fedet   TYPE  zostt_fedet
                                 pt_fecli   TYPE  zostt_fecli ##CALLED.
  DATA:
    lt_docexposde TYPE STANDARD TABLE OF zostb_docexposde,
    lt_fedet      TYPE STANDARD TABLE OF zostb_fedet,
    lt_felog      TYPE STANDARD TABLE OF zostb_felog,

    ls_docexposca TYPE  zostb_docexposca,
    ls_docexposc2 TYPE  zostb_docexposc2,
    ls_docexposde TYPE  zostb_docexposde,
    ls_fecab      TYPE  zostb_fecab,
    ls_fecab2     TYPE  zostb_fecab2,
    ls_fedet      TYPE  zostb_fedet,
    ls_fecli      TYPE  zostb_fecli,
    ls_felog      TYPE  zostb_felog.

  FIELD-SYMBOLS:
    <fs_fecab>  LIKE LINE OF pt_fecab,
    <fs_fecab2> LIKE LINE OF pt_fecab2,
    <fs_fedet>  LIKE LINE OF pt_fedet,
    <fs_fecli>  LIKE LINE OF pt_fecli.

  LOOP AT pt_fecab ASSIGNING <fs_fecab>.
    CLEAR:
          ls_docexposca,
          ls_docexposc2,
          lt_docexposde,
          ls_fecab,
          ls_fecab2,
          lt_fedet,
          ls_fecli,
          lt_felog.

    SELECT SINGLE *
      INTO ls_docexposca
      FROM zostb_docexposca
      WHERE bukrs         EQ ps_vbrk-bukrs
        AND zz_nrodocsap  EQ <fs_fecab>-zzt_nrodocsap
        AND zz_numeracion EQ <fs_fecab>-zzt_numeracion.
    IF sy-subrc EQ 0.
      DELETE FROM zostb_docexposca WHERE bukrs         EQ ps_vbrk-bukrs
                                     AND zz_nrodocsap  EQ <fs_fecab>-zzt_nrodocsap
                                     AND zz_numeracion EQ <fs_fecab>-zzt_numeracion.
      COMMIT WORK.

      ls_docexposca-zz_numeracion = ps_vbrk-xblnr+4.
      ls_docexposca-zz_femision   = ps_vbrk-fkdat.
      MODIFY zostb_docexposca FROM ls_docexposca.
      COMMIT WORK.
    ENDIF.

    SELECT SINGLE *
      INTO ls_docexposc2
      FROM zostb_docexposc2
      WHERE bukrs         EQ ps_vbrk-bukrs
        AND zz_nrodocsap  EQ <fs_fecab>-zzt_nrodocsap
        AND zz_numeracion EQ <fs_fecab>-zzt_numeracion.
    IF sy-subrc EQ 0.
      DELETE FROM zostb_docexposc2 WHERE bukrs         EQ ps_vbrk-bukrs
                                     AND zz_nrodocsap  EQ <fs_fecab>-zzt_nrodocsap
                                     AND zz_numeracion EQ <fs_fecab>-zzt_numeracion.
      COMMIT WORK.

      ls_docexposc2-zz_numeracion = ps_vbrk-xblnr+4.
      MODIFY zostb_docexposc2 FROM ls_docexposc2.
      COMMIT WORK.
    ENDIF.

    SELECT *
      INTO TABLE lt_docexposde
      FROM zostb_docexposde
      WHERE zz_nrodocsap  EQ <fs_fecab>-zzt_nrodocsap
        AND zz_numeracion EQ <fs_fecab>-zzt_numeracion.
    IF sy-subrc EQ 0.
      DELETE FROM zostb_docexposde WHERE zz_nrodocsap  EQ <fs_fecab>-zzt_nrodocsap
                                     AND zz_numeracion EQ <fs_fecab>-zzt_numeracion.
      COMMIT WORK.

      LOOP AT lt_docexposde INTO ls_docexposde.
        ls_docexposde-zz_numeracion = ps_vbrk-xblnr+4.
        MODIFY lt_docexposde FROM ls_docexposde INDEX sy-tabix.
      ENDLOOP.
      MODIFY zostb_docexposde FROM TABLE lt_docexposde.
      COMMIT WORK.
    ENDIF.

    SELECT SINGLE *
      INTO ls_fecab
      FROM zostb_fecab
      WHERE zzt_nrodocsap   EQ <fs_fecab>-zzt_nrodocsap
        AND zzt_numeracion  EQ <fs_fecab>-zzt_numeracion.
    IF sy-subrc EQ 0.
      DELETE FROM zostb_fecab WHERE zzt_nrodocsap   EQ <fs_fecab>-zzt_nrodocsap
                                AND zzt_numeracion  EQ <fs_fecab>-zzt_numeracion.
      COMMIT WORK.

      ls_fecab-zzt_numeracion = ps_vbrk-xblnr+4.
      ls_fecab-zzt_femision   = ps_vbrk-fkdat.
      MODIFY zostb_fecab FROM ls_fecab.
      COMMIT WORK.
    ENDIF.

    SELECT SINGLE *
      INTO ls_fecab2
      FROM zostb_fecab2
      WHERE zzt_nrodocsap   EQ <fs_fecab>-zzt_nrodocsap
        AND zzt_numeracion  EQ <fs_fecab>-zzt_numeracion.
    IF sy-subrc EQ 0.
      DELETE FROM zostb_fecab2 WHERE zzt_nrodocsap   EQ <fs_fecab>-zzt_nrodocsap
                                 AND zzt_numeracion  EQ <fs_fecab>-zzt_numeracion.
      COMMIT WORK.

      ls_fecab2-zzt_numeracion = ps_vbrk-xblnr+4.
      MODIFY zostb_fecab2 FROM ls_fecab2.
      COMMIT WORK.
    ENDIF.

    SELECT *
      INTO TABLE lt_fedet
      FROM zostb_fedet
      WHERE zzt_nrodocsap  EQ <fs_fecab>-zzt_nrodocsap
        AND zzt_numeracion EQ <fs_fecab>-zzt_numeracion.
    IF sy-subrc EQ 0.
      DELETE FROM zostb_fedet WHERE zzt_nrodocsap  EQ <fs_fecab>-zzt_nrodocsap
                                AND zzt_numeracion EQ <fs_fecab>-zzt_numeracion.
      COMMIT WORK.

      LOOP AT lt_fedet INTO ls_fedet.
        ls_fedet-zzt_numeracion = ps_vbrk-xblnr+4.
        MODIFY lt_fedet FROM ls_fedet INDEX sy-tabix.
      ENDLOOP.
      MODIFY zostb_fedet FROM TABLE lt_fedet.
      COMMIT WORK.
    ENDIF.

    SELECT SINGLE *
      INTO ls_fecli
      FROM zostb_fecli
      WHERE zzt_nrodocsap   EQ <fs_fecab>-zzt_nrodocsap
        AND zzt_numeracion  EQ <fs_fecab>-zzt_numeracion.
    IF sy-subrc EQ 0.
      DELETE FROM zostb_fecli WHERE zzt_nrodocsap   EQ <fs_fecab>-zzt_nrodocsap
                                AND zzt_numeracion  EQ <fs_fecab>-zzt_numeracion.
      COMMIT WORK.

      ls_fecli-zzt_numeracion = ps_vbrk-xblnr+4.
      MODIFY zostb_fecli FROM ls_fecli.
      COMMIT WORK.
    ENDIF.

    SELECT *
      INTO TABLE lt_felog
      FROM zostb_felog
      WHERE zzt_nrodocsap  EQ <fs_fecab>-zzt_nrodocsap
        AND zzt_numeracion EQ <fs_fecab>-zzt_numeracion.
    IF sy-subrc EQ 0.
      DELETE FROM zostb_felog WHERE zzt_nrodocsap  EQ <fs_fecab>-zzt_nrodocsap
                                AND zzt_numeracion EQ <fs_fecab>-zzt_numeracion
                                AND zzt_correlativ NE 01.                        "I-3000011101-NTP200319
      COMMIT WORK.

      LOOP AT lt_felog INTO ls_felog.
        ls_felog-zzt_numeracion = ps_vbrk-xblnr+4.
        MODIFY lt_felog FROM ls_felog INDEX sy-tabix.
      ENDLOOP.
      DELETE lt_felog FROM 2.
      MODIFY zostb_felog FROM TABLE lt_felog.
      COMMIT WORK.
    ELSE.
      CLEAR ls_felog.
      ls_felog-zzt_nrodocsap  = ps_vbrk-vbeln.
      ls_felog-zzt_numeracion = ps_vbrk-xblnr+4.
      ls_felog-zzt_correlativ = 1.
      ls_felog-zzt_status_cdr = '0'.
      ls_felog-zzt_fcreacion  = sy-datum.
      ls_felog-zzt_hcreacion  = sy-uzeit.
      ls_felog-zzt_ucreacion  = sy-uname.
      APPEND ls_felog TO lt_felog.

      MODIFY zostb_felog FROM TABLE lt_felog.
      COMMIT WORK.
    ENDIF.

    LOOP AT pt_fecab2 ASSIGNING <fs_fecab2> WHERE zzt_nrodocsap   EQ <fs_fecab>-zzt_nrodocsap
                                              AND zzt_numeracion  EQ <fs_fecab>-zzt_numeracion.
      <fs_fecab2>-zzt_numeracion = ps_vbrk-xblnr+4.
    ENDLOOP.

    LOOP AT pt_fedet ASSIGNING <fs_fedet> WHERE zzt_nrodocsap   EQ <fs_fecab>-zzt_nrodocsap
                                            AND zzt_numeracion  EQ <fs_fecab>-zzt_numeracion.
      <fs_fedet>-zzt_numeracion = ps_vbrk-xblnr+4.
    ENDLOOP.

    LOOP AT pt_fecli ASSIGNING <fs_fecli> WHERE zzt_nrodocsap   EQ <fs_fecab>-zzt_nrodocsap
                                            AND zzt_numeracion  EQ <fs_fecab>-zzt_numeracion.
      <fs_fecli>-zzt_numeracion = ps_vbrk-xblnr+4.
    ENDLOOP.

    <fs_fecab>-zzt_femision   = ps_vbrk-fkdat.
    <fs_fecab>-zzt_numeracion = ps_vbrk-xblnr+4.
  ENDLOOP.

  COMMIT WORK AND WAIT.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ASIGNAR_SERIE_FECHA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM asignar_serie_fecha .
  DATA:
    lt_vbrk   TYPE STANDARD TABLE OF ty_vbrk,
    lt_fields TYPE STANDARD TABLE OF sval,

    ls_fields LIKE LINE OF lt_fields,

    lw_return TYPE char01.

  FIELD-SYMBOLS:
    <fs_vbrk> TYPE  ty_vbrk.

  lt_vbrk[] = gt_vbrk[].
  DELETE lt_vbrk WHERE selec NE gc_charx.

  IF lt_vbrk[] IS INITIAL.
    MESSAGE text-e03 TYPE 'S' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  DELETE lt_vbrk WHERE process NE gc_chars.
  IF lt_vbrk[] IS NOT INITIAL.
    MESSAGE text-w01 TYPE 'I'.
  ENDIF.

  CLEAR ls_fields.
  ls_fields-tabname    = 'ZOSTB_LOTNO'.
  ls_fields-fieldname  = 'LOTNO'.
  ls_fields-fieldtext  = TEXT-006.
  ls_fields-field_obl  = gc_charx.
  APPEND ls_fields TO lt_fields.

  CALL FUNCTION 'POPUP_GET_VALUES_DB_CHECKED'
    EXPORTING
      popup_title     = TEXT-007
      start_column    = '2'
      start_row       = '3'
    IMPORTING
      returncode      = lw_return
    TABLES
      fields          = lt_fields
    EXCEPTIONS
      error_in_fields = 1
      OTHERS          = 2.

  IF sy-subrc EQ 0.
    CASE lw_return.
      WHEN space.
        LOOP AT gt_vbrk ASSIGNING <fs_vbrk> WHERE selec   EQ gc_charx
                                              AND process NE gc_chars.
          LOOP AT lt_fields INTO ls_fields.
            CASE ls_fields-fieldname.
              WHEN 'LOTNO'.
                <fs_vbrk>-xblnr+4(4) = ls_fields-value.
                <fs_vbrk>-fkdat      = sy-datum.
            ENDCASE.
          ENDLOOP.
        ENDLOOP.
      WHEN gc_chara.
        MESSAGE text-e05 TYPE 'S'.
    ENDCASE.
  ELSE.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  LOOP AT gt_vbrk ASSIGNING <fs_vbrk> WHERE selec EQ gc_charx.
    CLEAR <fs_vbrk>-selec.
  ENDLOOP.

ENDFORM.
