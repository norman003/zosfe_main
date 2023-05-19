*&---------------------------------------------------------------------*
*&  Include           ZOSSD_INC_UPDCDR_WITH_WS_F01
*&---------------------------------------------------------------------*
FORM obtener_constantes.

*{  BEGIN OF DELETE WMR-190419-3000010823
*  DATA: lt_const TYPE TABLE OF zostb_const_fe,
*        ls_const TYPE          zostb_const_fe.
*
*
** Constantes
*  SELECT * INTO TABLE lt_const
*    FROM zostb_const_fe
*    WHERE modulo   = 'FE'
*      AND programa = 'ZOSFE_INT_UPDCDR_WITH_WS'.
*
*  "Lee clase de syncronización segun HOST
*  READ TABLE lt_const INTO ls_const WITH KEY aplicacion = 'WS_SYNC_FE'
*                                             campo      = 'CLASSPROXY'
*                                             valor1     = sy-host.
*  IF sy-subrc = 0.
*    SPLIT ls_const-valor2 AT '/'
*      INTO zconst-ws_clase zconst-ws_metodo.
*  ENDIF.
*}  END OF DELETE WMR-190419-3000010823

* Constantes FE
  SELECT * INTO TABLE gt_const_fe
    FROM zostb_consextsun.

ENDFORM.                    "obtener_constantes
*&---------------------------------------------------------------------*
*&      Form  OBTENER_DATOS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM obtener_datos .

  DATA: lt_balog   TYPE STANDARD TABLE OF zostb_balog,
        lt_rblog   TYPE STANDARD TABLE OF zostb_rblog,
        lt_rertlog TYPE STANDARD TABLE OF zostb_rertlog,                "I-WMR-230419-3000010823
        lt_reprlog TYPE STANDARD TABLE OF zostb_reprlog.                "I-WMR-230419-3000010823

  FIELD-SYMBOLS: <fs_felog>   LIKE LINE OF gt_felog,
                 <fs_balog>   LIKE LINE OF lt_balog,
                 <fs_rblog>   LIKE LINE OF lt_rblog,
                 <fs_rertlog> LIKE LINE OF lt_rertlog,                  "I-WMR-230419-3000010823
                 <fs_reprlog> LIKE LINE OF lt_reprlog.                  "I-WMR-230419-3000010823

  IF p_single EQ abap_true.
    SELECT *
      INTO CORRESPONDING FIELDS OF TABLE gt_felog
      FROM zostb_felog
      WHERE zzt_numeracion IN s_numero
        AND zzt_status_cdr IN s_status
        AND zzt_fcreacion  IN s_fecha
        AND bukrs          EQ p_bukrs
        AND zzt_tipodoc    IN s_tipdoc.

*{  BEGIN OF INSERT WMR-190419-3000010823
    " Retención y Percepción
    SELECT * APPENDING CORRESPONDING FIELDS OF TABLE gt_felog
      FROM zostb_cplog
      WHERE bukrs          EQ p_bukrs
        AND zzt_numeracion IN s_numero
        AND zzt_status_cdr IN s_status
        AND zzt_fcreacion  IN s_fecha
        AND zzt_tipodoc    IN s_tipdoc.
*}  END OF INSERT WMR-190419-3000010823
  ENDIF.

  IF p_resbol EQ abap_true.

*    IF s_tipdoc[] IS INITIAL OR 'RC' IN s_tipdoc[].                     "E-WMR-230419-3000010823
    IF s_tipdoc[] IS INITIAL OR gc_resbol IN s_tipdoc[].                "I-WMR-230419-3000010823
      SELECT *
        APPENDING CORRESPONDING FIELDS OF TABLE lt_rblog
        FROM zostb_rblog
        WHERE bukrs            EQ p_bukrs
          AND zzt_identifiresu IN s_numero
          AND zzt_status_cdr   IN s_status
          AND zzt_fcreacion    IN s_fecha.

      LOOP AT lt_rblog ASSIGNING <fs_rblog>.
        APPEND INITIAL LINE TO gt_felog ASSIGNING <fs_felog>.
        MOVE-CORRESPONDING <fs_rblog> TO <fs_felog>.
        <fs_felog>-zzt_numeracion = <fs_rblog>-zzt_identifiresu.
        <fs_felog>-zzt_tipodoc    = gc_resbol.
      ENDLOOP.
    ENDIF.
  ENDIF.

  IF p_combaj EQ abap_true.

*    IF s_tipdoc[] IS INITIAL OR 'RA' IN s_tipdoc[].                     "E-WMR-230419-3000010823
    IF s_tipdoc[] IS INITIAL OR gc_combaj IN s_tipdoc[].                "I-WMR-230419-3000010823
      SELECT *
        APPENDING CORRESPONDING FIELDS OF TABLE lt_balog
        FROM zostb_balog
        WHERE bukrs            EQ p_bukrs
          AND zzt_identifibaja IN s_numero
          AND zzt_status_cdr   IN s_status
          AND zzt_fcreacion    IN s_fecha.

      LOOP AT lt_balog ASSIGNING <fs_balog>.
        APPEND INITIAL LINE TO gt_felog ASSIGNING <fs_felog>.
        MOVE-CORRESPONDING <fs_balog> TO <fs_felog>.
        <fs_felog>-zzt_numeracion = <fs_balog>-zzt_identifibaja.
        <fs_felog>-zzt_tipodoc    = gc_combaj.
      ENDLOOP.
    ENDIF.
  ENDIF.

*{  BEGIN OF INSERT WMR-190419-3000010823
  IF p_resrev = abap_true.
    " Reversiones de Retención
    IF s_tipdoc[] IS INITIAL OR gc_revret IN s_tipdoc[].
      SELECT *
        APPENDING CORRESPONDING FIELDS OF TABLE lt_rertlog
        FROM zostb_rertlog
        WHERE bukrs            EQ p_bukrs
          AND zzidres          IN s_numero
          AND zzt_status_cdr   IN s_status
          AND zzt_fcreacion    IN s_fecha.

      LOOP AT lt_rertlog ASSIGNING <fs_rertlog>.
        APPEND INITIAL LINE TO gt_felog ASSIGNING <fs_felog>.
        MOVE-CORRESPONDING <fs_rertlog> TO <fs_felog>.
        <fs_felog>-zzt_numeracion = <fs_rertlog>-zzidres.
        <fs_felog>-zzt_tipodoc    = gc_revret.
      ENDLOOP.
    ENDIF.

    " Reversiones de Percepción
    IF s_tipdoc[] IS INITIAL OR gc_revper IN s_tipdoc[].
      SELECT *
        APPENDING CORRESPONDING FIELDS OF TABLE lt_reprlog
        FROM zostb_reprlog
        WHERE bukrs            EQ p_bukrs
          AND zzidres          IN s_numero
          AND zzt_status_cdr   IN s_status
          AND zzt_fcreacion    IN s_fecha.

      LOOP AT lt_reprlog ASSIGNING <fs_reprlog>.
        APPEND INITIAL LINE TO gt_felog ASSIGNING <fs_felog>.
        MOVE-CORRESPONDING <fs_reprlog> TO <fs_felog>.
        <fs_felog>-zzt_numeracion = <fs_reprlog>-zzidres.
        <fs_felog>-zzt_tipodoc    = gc_revper.
      ENDLOOP.
    ENDIF.
  ENDIF.
*}  END OF INSERT WMR-190419-3000010823

  IF gt_felog[] IS INITIAL.
    gw_error = gc_chare.
    MESSAGE text-e01  TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

  CHECK gw_error NE gc_chare.

* Set icon gris
  LOOP AT gt_felog ASSIGNING <fs_felog>.
    <fs_felog>-semaforo = gc_gris.
  ENDLOOP.

ENDFORM.                    " OBTENER_DATOS
*&---------------------------------------------------------------------*
*&      Form  MOSTRAR_DATOS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM mostrar_datos .

  DATA: lt_fieldcat TYPE slis_t_fieldcat_alv,
        lt_events   TYPE slis_t_event,
        ls_events   TYPE slis_alv_event,
        ls_layout   TYPE slis_layout_alv,
        ls_print    TYPE slis_print_alv.

  FIELD-SYMBOLS: <fs_fieldcat> TYPE slis_fieldcat_alv.

  CHECK gw_error NE gc_chare.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZOSES_FEMONITOR'
      i_client_never_display = 'X'
      i_bypassing_buffer     = 'X'
    CHANGING
      ct_fieldcat            = lt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  IF sy-subrc NE 0.
    gw_error = gc_chare.
    MESSAGE text-e02 TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

  CHECK gw_error NE gc_chare.

  DELETE lt_fieldcat WHERE fieldname EQ 'SELEC'.

  LOOP AT lt_fieldcat ASSIGNING <fs_fieldcat>.
    CASE <fs_fieldcat>-fieldname.
      WHEN 'BUKRS'.
        <fs_fieldcat>-key = abap_true.
      WHEN 'ZZT_NRODOCSAP'.
        <fs_fieldcat>-key = abap_true.
        <fs_fieldcat>-hotspot = abap_true.
      WHEN 'ZZT_TIPODOC'.
        <fs_fieldcat>-key = abap_true.
      WHEN 'ZZT_NUMERACION'.
        <fs_fieldcat>-key = abap_true.
      WHEN 'ZZT_STATUS_CDR'.
        <fs_fieldcat>-key = abap_true.
      WHEN 'ZZT_ERRORES'  OR
           'ZZT_FEMISION' OR
           'ZZT_NOMBRERAZ'.
        <fs_fieldcat>-no_out = abap_true.
      WHEN 'SEMAFORO'.
        <fs_fieldcat>-just         = 'C'.
        <fs_fieldcat>-icon         = gc_charx.
        <fs_fieldcat>-reptext_ddic = 'Status'.
        <fs_fieldcat>-seltext_l    = 'Status'.
        <fs_fieldcat>-seltext_m    = 'Status'.
        <fs_fieldcat>-seltext_s    = 'Status'.
        <fs_fieldcat>-hotspot      = abap_true.
      WHEN 'ZZT_HCREACION'.
        <fs_fieldcat>-no_zero = abap_true.
      WHEN 'ZZT_IDCDR'    OR
           'ZZT_FECREC'   OR
           'ZZT_HORREC'   OR
           'ZZT_FECRES'   OR
           'ZZT_HORRES'   OR
           'ZZT_MENSACDR' OR
           'ZZT_OBSERCDR'.
        <fs_fieldcat>-emphasize = abap_true.
        IF <fs_fieldcat>-fieldname = 'ZZT_HORREC' OR
           <fs_fieldcat>-fieldname = 'ZZT_HORRES'.
          <fs_fieldcat>-no_zero = abap_true.
        ENDIF.
    ENDCASE.
  ENDLOOP.

  ls_layout-box_fieldname  = 'SELEC'.

  CLEAR ls_events.
  ls_events-name = slis_ev_pf_status_set.
  ls_events-form = slis_ev_pf_status_set.
  APPEND ls_events TO lt_events.

  CLEAR ls_events.
  ls_events-name = slis_ev_user_command.
  ls_events-form = slis_ev_user_command.
  APPEND ls_events TO lt_events.

  "Impresión
  ls_print-no_coverpage = gc_charx.
  ls_print-no_print_listinfos = gc_charx.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = ls_layout
      it_fieldcat        = lt_fieldcat
      i_default          = gc_charx
      i_save             = gc_chara
      it_events          = lt_events
      is_print           = ls_print
    TABLES
      t_outtab           = gt_felog
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc NE 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.                    " MOSTRAR_DATOS
*&---------------------------------------------------------------------*
*&      Form  PF_STATUS_SET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->RT_EXTAB   text
*----------------------------------------------------------------------*
FORM pf_status_set USING  rt_extab TYPE slis_t_extab.
  DATA:
    ls_extab TYPE slis_extab.

  IF p_previe = gc_charx.
  ELSE.
    APPEND '&SYNCR' TO rt_extab.
  ENDIF.

  SET PF-STATUS 'STAT_1000' EXCLUDING rt_extab.

ENDFORM.                    " PF_STATUS_SET
*&---------------------------------------------------------------------*
*&      Form  USER_COMMAND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->R_UCOMM      text
*      -->RS_SELFIELD  text
*----------------------------------------------------------------------*
FORM user_command   USING r_ucomm     TYPE sy-ucomm
                          rs_selfield TYPE slis_selfield.

  DATA: ls_felog TYPE ty_felog.

  CASE r_ucomm.
    WHEN '&IC1'.
      READ TABLE gt_felog INTO ls_felog INDEX rs_selfield-tabindex.
      IF sy-subrc = 0.
        CASE rs_selfield-fieldname.
          WHEN 'SEMAFORO'. PERFORM _show_return USING ls_felog-return.
        ENDCASE.
      ENDIF.
    WHEN '&SYNCR'.
      rs_selfield-col_stable = gc_charx.
      rs_selfield-row_stable = gc_charx.
      rs_selfield-refresh    = gc_charx.

      PERFORM pf_syncronize USING gt_felog.

  ENDCASE.

ENDFORM.                    "USER_COMMAND
*&---------------------------------------------------------------------*
*&      Form  SYNCRONIZE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_FELOG  text
*----------------------------------------------------------------------*
FORM pf_syncronize  USING    pt_felog  TYPE tt_felog.

  DATA: ls_input  TYPE zosfe_ws_updcrdsaprequest,
        ls_felog  TYPE ty_felog,
        ls_docuin TYPE zosfetb_docuinac,                                "I-WMR-200219-3000011120
        l_answer  TYPE char01,
        l_message TYPE string,                                          "I-WMR-160318-3000008769
        l_envsun  TYPE zostb_envwsfe-envsun.                            "I-WMR-160318-3000008769

  FIELD-SYMBOLS: <fs_felog> LIKE LINE OF pt_felog.

* Seleccion
  IF p_previe = gc_charx.
    READ TABLE gt_felog WITH KEY selec = gc_charx TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      MESSAGE s000 WITH text-e04 DISPLAY LIKE 'E'. EXIT.  " Debe seleccionar linea(s)...
    ENDIF.
  ELSE.
    ls_felog-selec = gc_charx.
    MODIFY gt_felog FROM ls_felog TRANSPORTING selec WHERE selec = space.
  ENDIF.


* Confirma
  IF p_previe = gc_charx.

    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = text-t01  " 'Confirmar'
        text_question         = text-q01  " 'Desea sincronizar log'
        display_cancel_button = ''
      IMPORTING
        answer                = l_answer
      EXCEPTIONS
        text_not_found        = 1
        OTHERS                = 2.
    IF l_answer <> '1'.
      MESSAGE s000 WITH text-i01. EXIT. " 'Acción Cancelada...'
    ENDIF.
  ENDIF.


* Proceso - Syncronizar
  LOOP AT pt_felog ASSIGNING <fs_felog> WHERE selec = gc_charx.

*    ls_felog = <fs_felog>.                                              "E-WMR-230419-3000010823

    "Inicializa
    <fs_felog>-semaforo = gc_gris.

*{  BEGIN OF DELETE WMR-190419-3000010823
**    "Syncroniza datos
**    CLEAR: ls_input.
**    ls_input-bukrs    = <fs_felog>-bukrs.
**    ls_input-numera   = <fs_felog>-zzt_numeracion.
**    ls_input-tipo_doc = <fs_felog>-zzt_tipodoc.
**
***{  BEGIN OF INSERT WMR-160318-3000008769
**    " Determinar Ambiente Sunat
**    PERFORM determinar_ambiente_sunat CHANGING l_envsun l_message.
**
**    IF l_message IS NOT INITIAL.
**      <fs_felog>-semaforo = gc_red.
**      PERFORM _log_to_return USING gc_chare l_message CHANGING <fs_felog>-return.
**      CONTINUE.
**    ENDIF.
**
**    " Determinar Proxy y Método
**    SELECT SINGLE class method
**      INTO (zprocess-ws_clase, zprocess-ws_metodo)
**      FROM zostb_envwsfe
**      WHERE bukrs  EQ <fs_felog>-bukrs
**        AND envsun EQ l_envsun
**        AND tpproc EQ zprocess-ws_tpproc.
**
**    IF sy-subrc <> 0.
**      <fs_felog>-semaforo = gc_red.
**      l_message = 'No se pudo determinar Proxy'.
**      PERFORM _log_to_return USING gc_chare l_message CHANGING <fs_felog>-return.
**      CONTINUE.
**    ENDIF.
***}  END OF INSERT WMR-160318-3000008769
**
**    PERFORM pro_sync_ws USING ls_input
**                        CHANGING ls_felog.
*}  END OF DELETE WMR-190419-3000010823

*{  BEGIN OF INSERT WMR-190419-3000010823
    " Sincronizar
    PERFORM sincronizar_status USING    <fs_felog>
                               CHANGING <fs_felog>-semaforo
                                        <fs_felog>-return
                                        ls_felog.
*}  END OF INSERT WMR-190419-3000010823

    "Guarda en DB lo syncronizado
    IF ls_felog-semaforo = gc_green.
      CASE ls_felog-zzt_tipodoc.
        WHEN gc_resbol. " Resumen de Boletas
          PERFORM pro_sync_save_resbol USING ls_felog.
        WHEN gc_combaj. " Comunicación de Bajas
          PERFORM pro_sync_save_combaj USING ls_felog.
        WHEN gc_revret. " Reversiones Retención                         "I-WMR-190419-3000010823
          PERFORM pro_sync_save_revret USING ls_felog.                  "I-WMR-190419-3000010823
        WHEN gc_revper. " Reversiones Percepción                        "I-WMR-190419-3000010823
          PERFORM pro_sync_save_revper USING ls_felog.                  "I-WMR-190419-3000010823
        WHEN OTHERS.    " Documentos Individuales
          PERFORM pro_sync_save_factu USING ls_felog.
      ENDCASE.
    ENDIF.

    IF ls_felog-semaforo = gc_green
    OR ls_felog-semaforo = gc_yellow.                                   "I-WMR-310819-3000010823

      MOVE-CORRESPONDING ls_felog TO <fs_felog>.
*{  BEGIN OF INSERT WMR-200219-3000011120
      " Si existe en tabla de documentos inactivos, al Actualizar CDR borrar de la tabla
      TRY .
          CLEAR ls_docuin.
          SELECT SINGLE * INTO ls_docuin FROM zosfetb_docuinac
            WHERE bukrs          = <fs_felog>-bukrs
              AND zzt_tipodoc    = <fs_felog>-zzt_tipodoc
              AND zzt_numeracion = <fs_felog>-zzt_numeracion
              AND updkz          = 'I'.
          IF sy-subrc = 0.
            UPDATE zosfetb_docuinac SET updkz            = 'U'
                                    WHERE bukrs          = <fs_felog>-bukrs
                                      AND zzt_tipodoc    = <fs_felog>-zzt_tipodoc
                                      AND zzt_numeracion = <fs_felog>-zzt_numeracion.
            IF sy-subrc = 0.
              COMMIT WORK.
            ELSE.
              ROLLBACK WORK.
            ENDIF.
          ENDIF.
        CATCH cx_root.
      ENDTRY.
*}  END OF INSERT WMR-200219-3000011120
*{  BEGIN OF DELETE WMR-190419-3000010823
**    ELSE.
**      <fs_felog>-semaforo = ls_felog-semaforo.
**      <fs_felog>-return = ls_felog-return.
*}  END OF DELETE WMR-190419-3000010823
    ENDIF.
  ENDLOOP.


  READ TABLE gt_felog WITH KEY semaforo = gc_red TRANSPORTING NO FIELDS.
  IF sy-subrc = 0.
    MESSAGE s000 WITH text-e08 DISPLAY LIKE gc_chare.
  ELSE.
    READ TABLE gt_felog WITH KEY semaforo = gc_yellow TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      MESSAGE s000 WITH text-w01 DISPLAY LIKE gc_charw.
    ELSE.
      MESSAGE s000 WITH text-s01.
    ENDIF.
  ENDIF.

ENDFORM.                    " SYNCRONIZE

*&---------------------------------------------------------------------*
*&      Form  pro_sync_ws
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->INPUT      text
*      -->CS_FELOG   text
*----------------------------------------------------------------------*
FORM pro_sync_ws USING input TYPE zosfe_ws_updcrdsaprequest
                 CHANGING cs_felog TYPE ty_felog.


  DATA: output   TYPE zosfe_ws_updcrdsapresponse,
        ls_cdr   TYPE zosfe_c_cdr,
        l_char10 TYPE char10.

  DATA: lo_obj    TYPE REF TO object,
        lo_cx     TYPE REF TO cx_root,
        l_message TYPE        string.

  DATA: ls_const_fe TYPE zostb_consextsun.


*0. Constante Sociedad
  READ TABLE gt_const_fe INTO ls_const_fe WITH KEY bukrs = cs_felog-bukrs.
  IF sy-subrc = 0.
    input-user = ls_const_fe-zz_usuario_web.
    input-pass = ls_const_fe-zz_pass_web.
  ENDIF.


*1. Llamada dinamica por sy-host = DEV,QAS,PRD
  TRY.
      CREATE OBJECT lo_obj
        TYPE
*          (zconst-ws_clase)                                                       "E-WMR-051018-3000010624
          (zprocess-ws_clase)                                                     "I-WMR-051018-3000010624
        EXPORTING
          logical_port_name = ls_const_fe-zz_proxy_name.    "ZP01
      TRY.
*          CALL METHOD lo_obj->(zconst-ws_metodo)                                  "E-WMR-051018-3000010624
          CALL METHOD lo_obj->(zprocess-ws_metodo)                                "I-WMR-051018-3000010624
            EXPORTING
              input  = input
            IMPORTING
              output = output.

        CATCH cx_ai_system_fault      INTO lo_cx.
        CATCH cx_ai_application_fault INTO lo_cx.
      ENDTRY.
    CATCH cx_ai_system_fault INTO lo_cx.
  ENDTRY.


*2. Sin excepción (conexión OK)
  IF lo_cx IS INITIAL.

    "Save syncronizado
    ""    READ TABLE output-d_cdrs-d_cdr INTO ls_cdr INDEX 1.
    ls_cdr = output-c_cdr.

    ""    IF sy-subrc = 0.

    "Verifica estatus, el campo no se puede evaluar hay que pasar a una variable intermedia
    l_char10 = ls_cdr-status.
    IF l_char10 IS INITIAL.
      cs_felog-semaforo = gc_yellow.
      l_message = text-e07. " 'No hay data a sincronizar'.
      PERFORM _log_to_return USING gc_charw l_message CHANGING cs_felog-return.

    ELSE.
      "Solo copiar los valores no vacios
      cs_felog-semaforo = gc_green.

      l_char10 = ls_cdr-idcdr.
      IF l_char10 IS NOT INITIAL.
        cs_felog-zzt_idcdr = ls_cdr-idcdr.
      ENDIF.

      l_char10 = ls_cdr-fecrec.
      IF l_char10 IS NOT INITIAL.
        CONCATENATE l_char10+0(4) l_char10+5(2) l_char10+8(2) INTO cs_felog-zzt_fecrec.
      ENDIF.

      l_char10 = ls_cdr-horrec.
      IF l_char10 IS NOT INITIAL.
        CONCATENATE l_char10+0(2) l_char10+3(2) l_char10+6(2) INTO cs_felog-zzt_horrec.
      ENDIF.

      l_char10 = ls_cdr-fecres.
      IF l_char10 IS NOT INITIAL.
        CONCATENATE l_char10+0(4) l_char10+5(2) l_char10+8(2) INTO cs_felog-zzt_fecres.
      ENDIF.

      l_char10 = ls_cdr-horres.
      IF l_char10 IS NOT INITIAL.
        CONCATENATE l_char10+0(2) l_char10+3(2) l_char10+6(2) INTO cs_felog-zzt_horres.
      ENDIF.

      l_char10 = ls_cdr-mensacdr.
      IF l_char10 IS NOT INITIAL.
        cs_felog-zzt_mensacdr = ls_cdr-mensacdr.
      ENDIF.

      l_char10 = ls_cdr-obsercdr.
      IF l_char10 IS NOT INITIAL.
        cs_felog-zzt_iderrsun = ls_cdr-obsercdr.
      ENDIF.

      l_char10 = ls_cdr-status.
      IF l_char10 IS NOT INITIAL.
        cs_felog-zzt_status_cdr = ls_cdr-status.
      ENDIF.

      l_char10 = ls_cdr-iderrsun.
      IF l_char10 IS NOT INITIAL.
        cs_felog-zzt_iderrsun = ls_cdr-iderrsun.
      ENDIF.
    ENDIF.
    ""    ENDIF.

  ELSE.
* Excepción (error de conexión)
    cs_felog-semaforo = gc_red.
    ""    l_message = 'Error de Conexión con el Servicio Web. Verificar log en transacción SRT_UTIL'.
    l_message = lo_cx->get_text( ).
    PERFORM _log_to_return USING gc_chare l_message CHANGING cs_felog-return.
  ENDIF.

ENDFORM.                    "pro_sync_ws


*&---------------------------------------------------------------------*
*&      Form  pro_sync_save_resbol
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->IS_FELOG   text
*----------------------------------------------------------------------*
FORM pro_sync_save_resbol USING is_felog TYPE ty_felog.

  DATA: ls_rblog TYPE zostb_rblog.

  "BEGIN OF OFV 04.12.2015
  SELECT SINGLE * INTO ls_rblog FROM zostb_rblog
  WHERE bukrs EQ is_felog-bukrs AND
        zzt_identifiresu EQ is_felog-zzt_numeracion.
  "END OF OFV 04.12.2015

  ls_rblog-bukrs            = is_felog-bukrs.
  ls_rblog-zzt_identifiresu = is_felog-zzt_numeracion.
  ls_rblog-zzt_idcdr      = is_felog-zzt_idcdr.
  ls_rblog-zzt_fecrec     = is_felog-zzt_fecrec.
  ls_rblog-zzt_horrec     = is_felog-zzt_horrec.
  ls_rblog-zzt_fecres     = is_felog-zzt_fecres.
  ls_rblog-zzt_horres     = is_felog-zzt_horres.
  ls_rblog-zzt_mensacdr   = is_felog-zzt_mensacdr.
  ls_rblog-zzt_obsercdr   = is_felog-zzt_obsercdr.
  ls_rblog-zzt_status_cdr = is_felog-zzt_status_cdr.
  ls_rblog-zzt_errorext   = is_felog-zzt_obsercdr.
  ls_rblog-zzt_iderrsun   = is_felog-zzt_iderrsun.
  MODIFY zostb_rblog FROM ls_rblog.

  IF ( sy-subrc EQ 0 ).
    CASE is_felog-zzt_status_cdr.
      WHEN gc_stat_1
        OR gc_stat_4.

      WHEN OTHERS.
        COMMIT WORK.
        EXIT.
    ENDCASE.

    UPDATE zostb_felog
    SET: zzt_idcdr      = is_felog-zzt_idcdr
         zzt_fecrec     = is_felog-zzt_fecrec
         zzt_horrec     = is_felog-zzt_horrec
         zzt_fecres     = is_felog-zzt_fecres
         zzt_horres     = is_felog-zzt_horres
         zzt_mensacdr   = is_felog-zzt_mensacdr
         zzt_obsercdr   = is_felog-zzt_obsercdr
         zzt_status_cdr = is_felog-zzt_status_cdr
         zzt_errorext   = is_felog-zzt_obsercdr "OFV 21.09.2015
         zzt_iderrsun   = is_felog-zzt_iderrsun
     WHERE zzt_identifiresu EQ is_felog-zzt_numeracion
       AND bukrs            EQ is_felog-bukrs.

    IF ( sy-subrc EQ 0 ).
      COMMIT WORK.
    ELSE.
      ROLLBACK WORK.
      is_felog-semaforo = gc_red.
      PERFORM _log_to_return USING gc_chare text-e13 CHANGING is_felog-return.
    ENDIF.
  ELSE.
    ROLLBACK WORK.
    is_felog-semaforo = gc_red.
    PERFORM _log_to_return USING gc_chare text-e14 CHANGING is_felog-return.
  ENDIF.

ENDFORM.                    "pro_sync_save_resbol

*&---------------------------------------------------------------------*
*&      Form  pro_sync_save_combaj
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->IS_FELOG   text
*----------------------------------------------------------------------*
FORM pro_sync_save_combaj USING is_felog TYPE ty_felog.

  DATA: ls_balog TYPE zostb_balog,
        w_status TYPE sy-subrc.

  "BEGIN OF OFV 04.12.2015
  SELECT SINGLE * INTO ls_balog FROM zostb_balog
  WHERE bukrs EQ is_felog-bukrs AND
        zzt_identifibaja EQ is_felog-zzt_numeracion.
  "END OF OFV 04.12.2015

  ls_balog-bukrs          = is_felog-bukrs.
  ls_balog-zzt_identifibaja = is_felog-zzt_numeracion.
  ls_balog-zzt_idcdr      = is_felog-zzt_idcdr.
  ls_balog-zzt_fecrec     = is_felog-zzt_fecrec.
  ls_balog-zzt_horrec     = is_felog-zzt_horrec.
  ls_balog-zzt_fecres     = is_felog-zzt_fecres.
  ls_balog-zzt_horres     = is_felog-zzt_horres.
  ls_balog-zzt_mensacdr   = is_felog-zzt_mensacdr.
  ls_balog-zzt_obsercdr   = is_felog-zzt_obsercdr.
  ls_balog-zzt_status_cdr = is_felog-zzt_status_cdr.
  ls_balog-zzt_errorext   = is_felog-zzt_obsercdr.
  ls_balog-zzt_iderrsun   = is_felog-zzt_iderrsun.
  MODIFY zostb_balog FROM ls_balog.

  IF ( sy-subrc EQ 0 ).
    CLEAR w_status.
    CASE is_felog-zzt_status_cdr.
      WHEN gc_stat_1
        OR gc_stat_4.
        w_status = gc_stat_8.

      WHEN OTHERS.
        COMMIT WORK.
        EXIT.
    ENDCASE.

    UPDATE zostb_felog
    SET: zzt_idcdr      = is_felog-zzt_idcdr
         zzt_fecrec     = is_felog-zzt_fecrec
         zzt_horrec     = is_felog-zzt_horrec
         zzt_fecres     = is_felog-zzt_fecres
         zzt_horres     = is_felog-zzt_horres
         zzt_mensacdr   = is_felog-zzt_mensacdr
         zzt_obsercdr   = is_felog-zzt_obsercdr
         zzt_status_cdr = w_status
         zzt_errorext   = is_felog-zzt_obsercdr "OFV 21.09.2015
         zzt_iderrsun   = is_felog-zzt_iderrsun
     WHERE zzt_identifibaja EQ is_felog-zzt_numeracion
       AND bukrs            EQ is_felog-bukrs.

    IF ( sy-subrc EQ 0 ).
      COMMIT WORK.
    ELSE.
      ROLLBACK WORK.
      is_felog-semaforo = gc_red.
      PERFORM _log_to_return USING gc_chare text-e13 CHANGING is_felog-return.
    ENDIF.
  ELSE.
    ROLLBACK WORK.
    is_felog-semaforo = gc_red.
    PERFORM _log_to_return USING gc_chare text-e15 CHANGING is_felog-return.
  ENDIF.
ENDFORM.                    "pro_sync_save_combaj

*&---------------------------------------------------------------------*
*&      Form  pro_sync_save_factu
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->IS_FELOG   text
*----------------------------------------------------------------------*
FORM pro_sync_save_factu USING is_felog TYPE ty_felog.
  DATA: ls_felog TYPE zostb_felog. "I-120321-NTP-3000016017

  CASE is_felog-zzt_tipodoc.                                            "I-WMR-190419-3000010823
    WHEN '01'   " Factura                                               "I-WMR-190419-3000010823
      OR '03'   " Boleta                                                "I-WMR-190419-3000010823
      OR '07'   " Nota de crédito                                       "I-WMR-190419-3000010823
      OR '08'   " Nota de débito                                        "I-WMR-190419-3000010823
      OR '09'.  " Guía de remisión                                      "I-WMR-190419-3000010823
  UPDATE zostb_felog
  SET: zzt_idcdr      = is_felog-zzt_idcdr
       zzt_fecrec     = is_felog-zzt_fecrec
       zzt_horrec     = is_felog-zzt_horrec
       zzt_fecres     = is_felog-zzt_fecres
       zzt_horres     = is_felog-zzt_horres
       zzt_mensacdr   = is_felog-zzt_mensacdr
       zzt_obsercdr   = is_felog-zzt_obsercdr
       zzt_status_cdr = is_felog-zzt_status_cdr
       zzt_errorext   = is_felog-zzt_obsercdr "OFV 21.09.2015
   WHERE zzt_numeracion EQ is_felog-zzt_numeracion
     AND bukrs          EQ is_felog-bukrs
     AND zzt_tipodoc    EQ is_felog-zzt_tipodoc.

  IF ( sy-subrc EQ 0 ).
    COMMIT WORK.
  ELSE.
    ROLLBACK WORK.
    is_felog-semaforo = gc_red.
    PERFORM _log_to_return USING gc_chare 'No existe en ZOSTB_FELOG' CHANGING is_felog-return.
  ENDIF.

  MOVE-CORRESPONDING is_felog TO ls_felog.                                                "I-120321-NTP-3000016017
  PERFORM amp03a_wsp_cdr_updatedocfi IN PROGRAM zosfe_amp_formadepago CHANGING ls_felog.  "I-060321-NTP-3000016407
*{  BEGIN OF INSERT WMR-190419-3000010823
    WHEN '20'   " Comprobante de retención
      OR '40'.  " Comprobante de percepción

      UPDATE zostb_cplog
      SET: zzt_idcdr      = is_felog-zzt_idcdr
           zzt_fecrec     = is_felog-zzt_fecrec
           zzt_horrec     = is_felog-zzt_horrec
           zzt_fecres     = is_felog-zzt_fecres
           zzt_horres     = is_felog-zzt_horres
           zzt_mensacdr   = is_felog-zzt_mensacdr
           zzt_obsercdr   = is_felog-zzt_obsercdr
           zzt_status_cdr = is_felog-zzt_status_cdr
           zzt_errorext   = is_felog-zzt_obsercdr
       WHERE bukrs          EQ is_felog-bukrs
         AND zzt_numeracion EQ is_felog-zzt_numeracion
         "AND gjahr          EQ is_felog-gjahr           "I-3000012056-NTP-050719
         AND zzt_nrodocsap  EQ is_felog-zzt_nrodocsap.

      IF ( sy-subrc EQ 0 ).
        COMMIT WORK.
      ELSE.
        ROLLBACK WORK.
        is_felog-semaforo = gc_red.
        PERFORM _log_to_return USING gc_chare text-e16 CHANGING is_felog-return.
      ENDIF.

  ENDCASE.
*}  END OF INSERT WMR-190419-3000010823

ENDFORM.                    "pro_sync_save_factu

*&---------------------------------------------------------------------*
*&      Form  _log_to_return
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->I_TYPE     text
*      -->I_TEXT     text
*      -->CT_RETURN  text
*----------------------------------------------------------------------*
FORM _log_to_return USING i_type TYPE any
                          i_text TYPE clike
                    CHANGING ct_return TYPE bapirettab.

  DATA: l_char    TYPE char200,
        ls_return TYPE bapiret2.

  l_char = i_text.
  ls_return-type = i_type.
  ls_return-message_v1 = l_char(50).
  ls_return-message_v2 = l_char+50(50).
  ls_return-message_v3 = l_char+100(50).
  ls_return-message_v4 = l_char+150(50).
  ls_return-id         = 'ZOSFE'.
  ls_return-number     = '000'.
  APPEND ls_return TO ct_return.

ENDFORM.                    "_log_to_return

*&---------------------------------------------------------------------*
*&      Form  _show_return
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->RETURN     text
*----------------------------------------------------------------------*
FORM _show_return USING return TYPE bapirettab.
  CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
    EXPORTING
      it_message = return.

ENDFORM.                    "_show_return
*{  BEGIN OF INSERT WMR-160318-3000008769
*&---------------------------------------------------------------------*
*&      Form  DETERMINAR_AMBIENTE_SUNAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_L_ENVSUN  text
*      <--P_L_MESSAGE  text
*----------------------------------------------------------------------*
FORM determinar_ambiente_sunat  CHANGING ep_envsun  TYPE zostb_envwsfe-envsun
                                         ep_message TYPE string.

  DATA: l_system  TYPE string.

  SELECT SINGLE valor2 INTO l_system
    FROM zostb_const_fe
    WHERE modulo     EQ gc_modul
      AND aplicacion EQ gc_aplic
      AND programa   EQ gc_progr
      AND valor1     EQ sy-host.

  IF sy-subrc <> 0.
    ep_message = text-e05.  " 'No se pudo determinar ambiente Sunat'.
    EXIT.
  ENDIF.

  CASE l_system.
    WHEN zossdcl_pro_extrac_fe=>gc_system_qas.
      ep_envsun = 'TES'.
    WHEN zossdcl_pro_extrac_fe=>gc_system_prd.
      ep_envsun = 'PRD'.
    WHEN OTHERS.
      ep_message = text-e05.  " 'No se pudo determinar ambiente Sunat'.
      EXIT.
  ENDCASE.

ENDFORM.
*{  BEGIN OF INSERT WMR-190419-3000010823
*}  END OF INSERT WMR-160318-3000008769
*&---------------------------------------------------------------------*
*&      Form  SINCRONIZAR_STATUS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<FS_FELOG>  text
*      <--P_<FS_FELOG>_SEMAFORO  text
*      <--P_<FS_FELOG>_RETURN  text
*      <--P_LS_FELOG  text
*----------------------------------------------------------------------*
FORM sincronizar_status  USING    is_felog     TYPE ty_felog
                         CHANGING cp_semaforo  TYPE icon_d
                                  ct_return    TYPE bapirettab
                                  cs_new_log   TYPE ty_felog.

  DATA: ls_input  TYPE zosfe_ws_updcrdsaprequest,
        l_message TYPE string,
        l_envsun  TYPE zostb_envwsfe-envsun.

  CLEAR: cs_new_log.

  ls_input-bukrs    = is_felog-bukrs.
  ls_input-numera   = is_felog-zzt_numeracion.
  ls_input-tipo_doc = is_felog-zzt_tipodoc.

  " Determinar Ambiente Sunat
  PERFORM determinar_ambiente_sunat CHANGING l_envsun l_message.

  IF l_message IS NOT INITIAL.
    cp_semaforo = gc_red.
    PERFORM _log_to_return USING gc_chare l_message CHANGING ct_return.
  ENDIF.
  CHECK cp_semaforo <> gc_red.

  " Determinar Proxy y Método
  SELECT SINGLE class method
    INTO (zprocess-ws_clase, zprocess-ws_metodo)
    FROM zostb_envwsfe
    WHERE bukrs  EQ is_felog-bukrs
      AND envsun EQ l_envsun
      AND tpproc EQ zprocess-ws_tpproc.

  IF sy-subrc <> 0.
    cp_semaforo = gc_red.
    l_message = text-e06. " 'No se pudo determinar Proxy'.
    PERFORM _log_to_return USING gc_chare l_message CHANGING ct_return.
  ENDIF.
  CHECK cp_semaforo <> gc_red.

  cs_new_log = is_felog.

  " Consumir WS
  PERFORM pro_sync_ws USING ls_input
                      CHANGING cs_new_log.

ENDFORM.
*}  END OF INSERT WMR-190419-3000010823
*&---------------------------------------------------------------------*
*&      Form  PRO_SYNC_SAVE_REVRET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_FELOG  text
*----------------------------------------------------------------------*
FORM pro_sync_save_revret  USING    is_felog  TYPE ty_felog.

  DATA: ls_rertlog TYPE zostb_rertlog.

  SELECT SINGLE * INTO ls_rertlog FROM zostb_rertlog
    WHERE bukrs   = is_felog-bukrs
      AND zzidres = is_felog-zzt_numeracion.

  CHECK sy-subrc = 0.

  ls_rertlog-zzt_idcdr      = is_felog-zzt_idcdr.
  ls_rertlog-zzt_fecrec     = is_felog-zzt_fecrec.
  ls_rertlog-zzt_horrec     = is_felog-zzt_horrec.
  ls_rertlog-zzt_fecres     = is_felog-zzt_fecres.
  ls_rertlog-zzt_horres     = is_felog-zzt_horres.
  ls_rertlog-zzt_mensacdr   = is_felog-zzt_mensacdr.
  ls_rertlog-zzt_obsercdr   = is_felog-zzt_obsercdr.
  ls_rertlog-zzt_status_cdr = is_felog-zzt_status_cdr.
  ls_rertlog-zzt_errorext   = is_felog-zzt_obsercdr.
  ls_rertlog-zzt_iderrsun   = is_felog-zzt_iderrsun.
  MODIFY zostb_rertlog FROM ls_rertlog.

  IF sy-subrc = 0.
    CASE is_felog-zzt_status_cdr.
      WHEN gc_stat_1
        OR gc_stat_4.

      WHEN OTHERS.
        COMMIT WORK.
        EXIT.
    ENDCASE.

    UPDATE zostb_cplog
    SET: zzt_idcdr      = is_felog-zzt_idcdr
         zzt_fecrec     = is_felog-zzt_fecrec
         zzt_horrec     = is_felog-zzt_horrec
         zzt_fecres     = is_felog-zzt_fecres
         zzt_horres     = is_felog-zzt_horres
         zzt_mensacdr   = is_felog-zzt_mensacdr
         zzt_obsercdr   = is_felog-zzt_obsercdr
         zzt_status_cdr = gc_stat_8
         zzt_errorext   = is_felog-zzt_obsercdr
         zzt_iderrsun   = is_felog-zzt_iderrsun
     WHERE bukrs            = is_felog-bukrs
       AND zzt_identifibaja = is_felog-zzt_numeracion.
       "AND gjahr            = is_felog-gjahr.         "I-3000012056-NTP-050719

    IF sy-subrc = 0.
      COMMIT WORK.
    ELSE.
      ROLLBACK WORK.
      is_felog-semaforo = gc_red.
      PERFORM _log_to_return USING gc_chare text-e16 CHANGING is_felog-return.
    ENDIF.
  ELSE.
    ROLLBACK WORK.
    is_felog-semaforo = gc_red.
    PERFORM _log_to_return USING gc_chare text-e17 CHANGING is_felog-return.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PRO_SYNC_SAVE_REVPER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_FELOG  text
*----------------------------------------------------------------------*
FORM pro_sync_save_revper  USING    is_felog  TYPE ty_felog.

  DATA: ls_reprlog TYPE zostb_reprlog.

  SELECT SINGLE * INTO ls_reprlog FROM zostb_reprlog
    WHERE bukrs   = is_felog-bukrs
      AND zzidres = is_felog-zzt_numeracion.

  CHECK sy-subrc = 0.

  ls_reprlog-zzt_idcdr      = is_felog-zzt_idcdr.
  ls_reprlog-zzt_fecrec     = is_felog-zzt_fecrec.
  ls_reprlog-zzt_horrec     = is_felog-zzt_horrec.
  ls_reprlog-zzt_fecres     = is_felog-zzt_fecres.
  ls_reprlog-zzt_horres     = is_felog-zzt_horres.
  ls_reprlog-zzt_mensacdr   = is_felog-zzt_mensacdr.
  ls_reprlog-zzt_obsercdr   = is_felog-zzt_obsercdr.
  ls_reprlog-zzt_status_cdr = is_felog-zzt_status_cdr.
  ls_reprlog-zzt_errorext   = is_felog-zzt_obsercdr.
  ls_reprlog-zzt_iderrsun   = is_felog-zzt_iderrsun.
  MODIFY zostb_reprlog FROM ls_reprlog.

  IF sy-subrc = 0.
    CASE is_felog-zzt_status_cdr.
      WHEN gc_stat_1
        OR gc_stat_4.

      WHEN OTHERS.
        COMMIT WORK.
        EXIT.
    ENDCASE.

    UPDATE zostb_cplog
    SET: zzt_idcdr      = is_felog-zzt_idcdr
         zzt_fecrec     = is_felog-zzt_fecrec
         zzt_horrec     = is_felog-zzt_horrec
         zzt_fecres     = is_felog-zzt_fecres
         zzt_horres     = is_felog-zzt_horres
         zzt_mensacdr   = is_felog-zzt_mensacdr
         zzt_obsercdr   = is_felog-zzt_obsercdr
         zzt_status_cdr = gc_stat_8
         zzt_errorext   = is_felog-zzt_obsercdr
         zzt_iderrsun   = is_felog-zzt_iderrsun
     WHERE bukrs            = is_felog-bukrs
       AND zzt_identifibaja = is_felog-zzt_numeracion.
       "AND gjahr            = is_felog-gjahr.         "I-3000012056-NTP-050719

    IF sy-subrc = 0.
      COMMIT WORK.
    ELSE.
      ROLLBACK WORK.
      is_felog-semaforo = gc_red.
      PERFORM _log_to_return USING gc_chare text-e16 CHANGING is_felog-return.
    ENDIF.
  ELSE.
    ROLLBACK WORK.
    is_felog-semaforo = gc_red.
    PERFORM _log_to_return USING gc_chare text-e18 CHANGING is_felog-return.
  ENDIF.

ENDFORM.
