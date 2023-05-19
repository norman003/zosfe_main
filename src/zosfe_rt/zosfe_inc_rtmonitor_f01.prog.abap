*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_PRMONITOR_F01
*&---------------------------------------------------------------------*

FORM get_data .

* Obtener datos LOG
  SELECT *
  FROM zostb_cplog
  INTO TABLE gt_cplog
  WHERE zzt_nrodocsap IN s_cnumb
    AND zzt_fcreacion IN s_fecha
    AND bukrs         EQ p_bukrs
    AND zzt_tipodoc   EQ '20'.
  IF sy-subrc NE 0.
    MESSAGE s208(00) WITH text-e01.
    EXIT.
  ENDIF.

* Obtener cabecera y detalle
  "Retencion
  SELECT *
    INTO TABLE gt_fertcab
    FROM zostb_fertcab
    FOR ALL ENTRIES IN gt_cplog
    WHERE crnumber EQ gt_cplog-zzt_nrodocsap
      AND zznrosun EQ gt_cplog-zzt_numeracion
      AND bukrs    EQ gt_cplog-bukrs.

ENDFORM.                    " GET_DATA

*&---------------------------------------------------------------------*
*&      Form  SET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_data .

  DATA: ls_reporte LIKE LINE OF gt_reporte,
*        ls_feprcab TYPE zostb_feprcab,
        ls_fertcab TYPE zostb_fertcab.

  REFRESH gt_reporte.

* Formar tabla final
  LOOP AT gt_cplog ASSIGNING <fs_cplog>.
    AT NEW zzt_numeracion.
      CLEAR: ls_reporte.
      REFRESH ls_reporte-zzt_errores.
    ENDAT.
    IF <fs_cplog>-zzt_errorext IS NOT INITIAL.
      APPEND <fs_cplog>-zzt_errorext TO ls_reporte-zzt_errores.
    ENDIF.
    AT END OF zzt_numeracion.
      MOVE-CORRESPONDING <fs_cplog> TO ls_reporte.

      READ TABLE gt_fertcab INTO ls_fertcab
           WITH TABLE KEY crnumber = <fs_cplog>-zzt_nrodocsap
                          zznrosun = <fs_cplog>-zzt_numeracion.
      IF sy-subrc EQ 0.
        ls_reporte-bukrs         = ls_fertcab-bukrs.
        ls_reporte-zzt_femision  = ls_fertcab-zzfecemi.
        ls_reporte-zzt_nombreraz = ls_fertcab-zzprvden.
      ENDIF.

      CASE <fs_cplog>-zzt_status_cdr.
        WHEN '0'. "Inactivo
          ls_reporte-semaforo = gc_semaf_rojo.
        WHEN '1'. "Aprobado
          ls_reporte-semaforo = gc_semaf_verd.
        WHEN '2'. "Enviado
          ls_reporte-semaforo = gc_semaf_rojo.
        WHEN '3'. "Rechazado
          ls_reporte-semaforo = gc_semaf_rojo.
        WHEN '4'. "Aprobado con Obs.
          ls_reporte-semaforo = gc_semaf_amar.
        WHEN '5'. "Error XSD
          ls_reporte-semaforo = gc_semaf_rojo.
        WHEN '6'. "Excepción SUNAT
          ls_reporte-semaforo = gc_semaf_rojo.
        WHEN '7'. "Error Conexión WS
          ls_reporte-semaforo = gc_semaf_rojo.
        WHEN '8'. "Baja
          ls_reporte-semaforo = gc_semaf_verd.
      ENDCASE.
      APPEND ls_reporte TO gt_reporte.
    ENDAT.
  ENDLOOP.

* Ordenar los mas recientes al comienzo
  SORT gt_reporte BY zzt_fcreacion DESCENDING
                     zzt_hcreacion DESCENDING.

ENDFORM.                    " SET_DATA

*&---------------------------------------------------------------------*
*&      Form  SHO_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sho_data .

  DATA: lt_fieldcat TYPE lvc_t_fcat,
        ls_fieldcat TYPE lvc_s_fcat,                                    "I-WMR-180117-3000006406
        ls_layout   TYPE lvc_s_layo.
  FIELD-SYMBOLS: <fs_fieldcat> LIKE LINE OF lt_fieldcat.

* Catálogo
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'ZOSES_FEMONITOR'
    CHANGING
      ct_fieldcat      = lt_fieldcat.
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
      WHEN 'ZZT_ERRORES'.
        <fs_fieldcat>-no_out = abap_true.
      WHEN 'SELEC'.
        <fs_fieldcat>-no_out = abap_true.
      WHEN 'SEMAFORO'.
        <fs_fieldcat>-just = 'C'.
        <fs_fieldcat>-reptext = 'Status'.
        <fs_fieldcat>-coltext = 'Status'.
        <fs_fieldcat>-hotspot = abap_true.
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

*{  BEGIN OF INSERT WMR-180117-3000006406
  " Adicionar columna "Error Extractor"
  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos   = LINES( lt_fieldcat ) + 1.
  ls_fieldcat-fieldname = 'ZZT_ERROREXT'.
  ls_fieldcat-ref_field = 'ZZT_ERROREXT'.
  ls_fieldcat-ref_table = 'ZOSES_CPMONITOR'.
  ls_fieldcat-no_out    = abap_true.
  APPEND ls_fieldcat TO lt_fieldcat.
*}  END OF INSERT WMR-180117-3000006406

* Layout
  ls_layout-cwidth_opt = abap_true.
  ls_layout-box_fname  = 'SELEC'.

* Mostrar Reporte
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'ALV_FORM_STATUS'
      i_callback_user_command  = 'USER_COMMAND'
      is_layout_lvc            = ls_layout
      i_save                   = 'A'                                    "I-WMR-180117-3000006406
      it_fieldcat_lvc          = lt_fieldcat
    TABLES
      t_outtab                 = gt_reporte
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    " SHO_DATA

*&---------------------------------------------------------------------*
*&      Form  user_command
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->UCOMM      text
*      -->SELFIELD   text
*----------------------------------------------------------------------*
FORM user_command USING ucomm    LIKE sy-ucomm              "#EC CALLED
                        selfield TYPE slis_selfield.

  DATA: lw_error TYPE char1.

  CASE ucomm.
    WHEN '&IC1'.
      CASE selfield-fieldname.
        WHEN 'SEMAFORO'.
          PERFORM show_mensa USING selfield.
        WHEN 'ZZT_NRODOCSAP'.
*          PERFORM call_vf03 USING selfield.
        WHEN 'ZZT_NUMERACION'.
          PERFORM call_json USING selfield.
      ENDCASE.
    WHEN '&REPROC'.
      CLEAR lw_error.
      selfield-refresh = abap_true.
      PERFORM reprocesa CHANGING lw_error.
      IF lw_error IS INITIAL.
        PERFORM get_data.
        PERFORM set_data.
      ENDIF.
    WHEN '&REFRESCAR'.
      selfield-refresh = abap_true.
      PERFORM get_data.
      PERFORM set_data.

*{I-PBM040621-3000017076
    WHEN '&SYNCR'.
      selfield-refresh    = abap_true.
      PERFORM pf_syncronize CHANGING lw_error.
      IF lw_error IS INITIAL.
        PERFORM get_data.
        PERFORM set_data.
      ENDIF.
*}I-PBM040621-3000017076

  ENDCASE.

ENDFORM.                    "user_command

*&---------------------------------------------------------------------*
*&      Form  alv_form_status
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PT_EXTAB   text
*----------------------------------------------------------------------*
FORM alv_form_status USING pt_extab TYPE slis_t_extab.

  SET PF-STATUS 'STAT_1000' EXCLUDING pt_extab.

ENDFORM.                    "alv_form_status

*&---------------------------------------------------------------------*
*&      Form  show_mensa
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PI_SELFIELD  text
*----------------------------------------------------------------------*
FORM show_mensa USING pi_selfield TYPE slis_selfield.

  DATA: lt_messages TYPE bapiret2tab,
        ls_messages TYPE bapiret2,
        lw_row      TYPE i.
  FIELD-SYMBOLS: <fs> TYPE any.

* Armar tabla de mensajes
  READ TABLE gt_reporte ASSIGNING <fs_reporte> INDEX pi_selfield-tabindex.
  CHECK sy-subrc EQ 0.
  LOOP AT <fs_reporte>-zzt_errores ASSIGNING <fs>.
    CLEAR: ls_messages.
    ADD 1 TO lw_row.
    ls_messages-type       = 'E'.
    ls_messages-id         = '00'.
    ls_messages-number     = '398'.
    ls_messages-row        = lw_row.
    CALL FUNCTION 'CRM_MESSAGE_TEXT_SPLIT'
      EXPORTING
        iv_text    = <fs>
      IMPORTING
        ev_msgvar1 = ls_messages-message_v1
        ev_msgvar2 = ls_messages-message_v2
        ev_msgvar3 = ls_messages-message_v3
        ev_msgvar4 = ls_messages-message_v4.
    APPEND ls_messages TO lt_messages.
  ENDLOOP.

  CHECK lt_messages[] IS NOT INITIAL.

* Mostrar mensajes
  CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
    EXPORTING
      it_message = lt_messages.

ENDFORM.                    "show_mensa

*&---------------------------------------------------------------------*
*&      Form  reprocesa
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PO_ERROR   text
*----------------------------------------------------------------------*
FORM reprocesa CHANGING po_error TYPE char1.

  DATA: lw_text1   TYPE char50,
        lw_answer  TYPE char01,
        lt_return  TYPE bapirettab,
        ls_reporte LIKE LINE OF gt_reporte.

  DATA: lo_rt TYPE REF TO zossdcl_pro_extrac_fe_rt.

* Leer línea marcada
  READ TABLE gt_reporte INTO ls_reporte WITH KEY selec = abap_true.

  CHECK sy-subrc EQ 0.

* Validar status
  CASE ls_reporte-zzt_status_cdr.
    WHEN gc_status_0 OR gc_status_5 OR gc_status_6 OR gc_status_7.
    WHEN OTHERS.
      po_error = abap_true.
      MESSAGE s208(00) WITH text-e02.
      EXIT.
  ENDCASE.

* Popup de confirmación
  CONCATENATE 'El Documento'
              ls_reporte-zzt_nrodocsap
              'será enviado a SUNAT' INTO lw_text1 SEPARATED BY space.

  CALL FUNCTION 'POPUP_TO_CONFIRM_WITH_MESSAGE'
    EXPORTING
      diagnosetext1 = lw_text1
      textline1     = '¿Desea continuar?'
      titel         = 'Confirmar Reproceso'
    IMPORTING
      answer        = lw_answer.
  IF lw_answer NE 'J'.
    po_error = abap_true.
    EXIT.
  ENDIF.

* Llamar programa para reproceso
  CREATE OBJECT lo_rt.

  lo_rt->extrae_data_retencion(
    EXPORTING
      i_bukrs    = ls_reporte-bukrs
*      i_gjahr    = 2016
      i_crnumber = ls_reporte-zzt_nrodocsap
    IMPORTING
      et_return  = lt_return
    EXCEPTIONS
      error      = 1
  ).

ENDFORM.                    " REPROCESA

FORM call_json USING is_selfield TYPE slis_selfield.

  READ TABLE gt_reporte ASSIGNING <fs_reporte> INDEX is_selfield-tabindex.
  CHECK sy-subrc = 0.

  SUBMIT zosfe_rpt_json
    WITH p_bukrs  = <fs_reporte>-bukrs
    WITH p_nrosun = <fs_reporte>-zzt_numeracion
    WITH p_prefix = gc_prefix_rt
    AND RETURN.

ENDFORM.

*{I-PBM040621-3000017076
*&---------------------------------------------------------------------*
*&      Form  PF_SYNCRONIZE
*&---------------------------------------------------------------------*
FORM pf_syncronize CHANGING po_error TYPE char1.

  DATA: ls_reporte LIKE LINE OF gt_reporte,
        l_answer   TYPE          char01,
        lr_numero  TYPE RANGE OF zoses_femonitor-zzt_numeracion,
        lr_fecha   TYPE RANGE OF sy-datum,
        lr_status  TYPE RANGE OF zosed_status_cdr,
        l_string   TYPE          string.

* Valida selección
  READ TABLE gt_reporte INTO ls_reporte WITH KEY selec = abap_true.
  IF sy-subrc <> 0.
    po_error = abap_true.
    MESSAGE s000(zosfe) WITH text-s01 DISPLAY LIKE 'E'. EXIT.
  ENDIF.

*{+091122-NTP-3000020377
* Valida Status
  CASE ls_reporte-zzt_status_cdr.
    WHEN gc_status_8 OR gc_status_9.
      po_error = abap_true.
      MESSAGE s000(zosfe) WITH text-s04. EXIT.
  ENDCASE.
*}+091122-NTP-3000020377

* Confirmación
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = text-i05
      text_question         = text-i06
      display_cancel_button = space
    IMPORTING
      answer                = l_answer
    EXCEPTIONS ##FM_SUBRC_OK
      text_not_found        = 1
      OTHERS                = 2.
  IF l_answer <> '1'.
    po_error = abap_true.
    MESSAGE s000(zosfe) WITH text-s02. EXIT.
  ENDIF.

* Proceso
  LOOP AT gt_reporte INTO ls_reporte WHERE selec = abap_true.
    CONCATENATE 'IEQ' ls_reporte-zzt_numeracion INTO l_string.
    APPEND l_string TO lr_numero.
  ENDLOOP.

  SUBMIT zosfe_int_updcdr_with_ws AND RETURN
    WITH p_bukrs = ls_reporte-bukrs
    WITH s_numero IN lr_numero
    WITH s_fecha  IN lr_fecha
    WITH s_status IN lr_status
    WITH p_previe = space
    WITH p_submit = abap_true
    WITH p_single = abap_true
    WITH p_resbol = space.

ENDFORM.
*}I-PBM040621-3000017076
