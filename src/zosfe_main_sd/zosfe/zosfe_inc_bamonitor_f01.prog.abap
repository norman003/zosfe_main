*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_BAMONITOR_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  GET_CONSTANTES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_constantes .
  SELECT *
  FROM zostb_const_fe
  INTO TABLE gt_const
  WHERE modulo      = gc_mod
    AND aplicacion  = gc_apl.

  CHECK sy-subrc = 0.

  LOOP AT gt_const INTO gs_const.
    CASE gs_const-campo.
      WHEN 'FECBAJ'.
        gw_fecfac_d = gs_const-valor1.
    ENDCASE.
  ENDLOOP.
ENDFORM.                    " GET_CONSTANTES
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  CHECK gw_error = abap_off.                                                  "I-WMR-130319-3000010823

* Obtener datos LOG
  SELECT *
  FROM zostb_balog
  INTO TABLE gt_balog
  WHERE bukrs            EQ p_bukrs                                     "I-WMR-200715
    AND zzt_identifibaja IN s_idbaj
    AND zzt_fcreacion    IN s_fecha.
  IF sy-subrc NE 0.
    MESSAGE s208(00) WITH text-e01.
    EXIT.
  ENDIF.

* Obtener cabecera y detalle
  SELECT *
  FROM zostb_bacab
  INTO TABLE gt_bacab
  FOR ALL ENTRIES IN gt_balog
  WHERE bukrs           EQ gt_balog-bukrs                               "I-WMR-200715
    AND zz_identifibaja EQ gt_balog-zzt_identifibaja.
  IF sy-subrc EQ 0.
    SELECT *
    FROM zostb_badet
    INTO TABLE gt_badet
    FOR ALL ENTRIES IN gt_bacab
    WHERE bukrs           EQ gt_bacab-bukrs                             "I-WMR-200715
      AND zz_identifibaja EQ gt_bacab-zz_identifibaja.
  ENDIF.

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

  DATA: ls_reporte LIKE LINE OF gt_reporte.

  CHECK gw_error = abap_off.                                                  "I-WMR-130319-3000010823

  REFRESH gt_reporte.

* Formar tabla final
  LOOP AT gt_balog ASSIGNING <fs_balog>.
    AT NEW zzt_identifibaja.
      CLEAR: ls_reporte.
      REFRESH ls_reporte-zzt_errores.
    ENDAT.
    IF <fs_balog>-zzt_errorext IS NOT INITIAL.
      APPEND <fs_balog>-zzt_errorext TO ls_reporte-zzt_errores.
    ENDIF.
    AT END OF zzt_identifibaja.
      MOVE-CORRESPONDING <fs_balog> TO ls_reporte ##ENH_OK.
      READ TABLE gt_bacab ASSIGNING <fs_bacab>
                 WITH KEY zz_identifibaja = <fs_balog>-zzt_identifibaja.
      IF sy-subrc EQ 0.
        ls_reporte-zzt_femision  = <fs_bacab>-zz_femision.
      ENDIF.
      CASE <fs_balog>-zzt_status_cdr.
        WHEN '0'. "Inactivo
          ls_reporte-semaforo = gc_semaf_rojo.
        WHEN '1'. "Aprobado
          ls_reporte-semaforo = gc_semaf_verd.
        WHEN '2'. "Enviado
          ls_reporte-semaforo = gc_semaf_amar.
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
      ENDCASE.
      CASE <fs_balog>-zzt_status_cdr."Dia Reproceso
        WHEN 2 OR 3 OR 5 OR 6 OR 7.
          ls_reporte-zzt_dias = ( ls_reporte-zzt_fcreacion + gw_fecfac_d ) - sy-datum.
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
        ls_layout   TYPE lvc_s_layo.
  FIELD-SYMBOLS: <fs_fieldcat> LIKE LINE OF lt_fieldcat.

  CHECK gw_error = abap_off.                                                  "I-WMR-130319-3000010823

* Catálogo
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = gc_tabname
    CHANGING
      ct_fieldcat      = lt_fieldcat.
  LOOP AT lt_fieldcat ASSIGNING <fs_fieldcat>.
    CASE <fs_fieldcat>-fieldname.
*{  BEGIN OF INSERT WMR-200715
      WHEN 'BUKRS'.
        <fs_fieldcat>-key = abap_true.
*}  END OF INSERT WMR-200715
      WHEN 'ZZT_IDENTIFIBAJA'.
        <fs_fieldcat>-key = abap_true.
      WHEN 'ZZT_STATUS_CDR'.
        <fs_fieldcat>-key = abap_true.
      WHEN 'ZZT_ERRORES'.
        <fs_fieldcat>-no_out = abap_true.
      WHEN 'SEMAFORO'.
        <fs_fieldcat>-just = 'C'.
        <fs_fieldcat>-reptext = text-001.
        <fs_fieldcat>-coltext = text-001.
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

* Layout
  ls_layout-cwidth_opt = abap_true.

* Mostrar Reporte
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'ALV_FORM_STATUS'
      i_callback_user_command  = 'USER_COMMAND'
      is_layout_lvc            = ls_layout
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

  DATA: l_subrc  TYPE sysubrc.                                              "I-WMR-030517-3000007186

  CASE ucomm.
    WHEN '&IC1'.
      CASE selfield-fieldname.
        WHEN 'SEMAFORO'.
          PERFORM show_mensa USING selfield.
      ENDCASE.

    WHEN '&SYNC'.
      selfield-refresh = abap_true.
      PERFORM pf_sincronizar.
      PERFORM get_data.
      PERFORM set_data.

    WHEN '&REGUL'.                                                          "I-WMR-030517-3000007186
      PERFORM regularizar CHANGING l_subrc.                                 "I-WMR-030517-3000007186
      IF l_subrc EQ 0.                                                      "I-WMR-030517-3000007186
        PERFORM get_data.                                                   "I-WMR-030517-3000007186
        PERFORM set_data.                                                   "I-WMR-030517-3000007186
        selfield-refresh = selfield-col_stable = selfield-row_stable = abap_true. "I-WMR-030517-3000007186
      ENDIF.                                                                "I-WMR-030517-3000007186
  ENDCASE.

ENDFORM.                    "user_command

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
        lw_row      TYPE i,
        lw_text_1   TYPE char50 ##NEEDED,
        lw_text_2   TYPE string ##NEEDED.
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
*&      Form  PF_SINCRONIZAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pf_sincronizar.

  DATA: ls_reporte TYPE          zoses_bamonitor,
        l_answer   TYPE          char01,
        lr_numero  TYPE RANGE OF zoses_bamonitor-zzt_identifibaja,
        lr_fecha   TYPE RANGE OF sy-datum,
        lr_status  TYPE RANGE OF zosed_status_cdr,
        l_string   TYPE          string.

* Valida seleccion
  CHECK gt_reporte[] IS NOT INITIAL.

* Confirmación
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = text-i06
      text_question         = text-i07
      display_cancel_button = space
    IMPORTING
      answer                = l_answer
    EXCEPTIONS ##FM_SUBRC_OK
      text_not_found        = 1
      OTHERS                = 2.
  IF l_answer <> '1'.
    MESSAGE s000 WITH text-s01.   EXIT.     "M LJG-21.05.2018
  ENDIF.

* Proceso
  LOOP AT gt_reporte INTO ls_reporte.
    CONCATENATE 'IEQ' ls_reporte-zzt_identifibaja INTO l_string.
    APPEND l_string TO lr_numero.
  ENDLOOP.

  SUBMIT zosfe_int_updcdr_with_ws AND RETURN             "#EC CI_SUBMIT
    WITH p_bukrs = ls_reporte-bukrs
    WITH s_numero IN lr_numero
    WITH s_fecha  IN lr_fecha
    WITH s_status IN lr_status
    WITH p_previe = space
    WITH p_submit = abap_true
    WITH p_single = space
    WITH p_resbol = space
    WITH p_combaj = abap_true.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  alv_form_status
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PT_EXTAB   text
*----------------------------------------------------------------------*
FORM alv_form_status USING pt_extab TYPE slis_t_extab ##CALLED.

  SET PF-STATUS 'STAT_1000' EXCLUDING pt_extab.

ENDFORM.                    "alv_form_status
*{  BEGIN OF INSERT WMR-030517-3000007186
*&---------------------------------------------------------------------*
*&      Form  REGULARIZAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_L_SUBRC  text
*----------------------------------------------------------------------*
FORM regularizar  CHANGING ep_subrc TYPE sysubrc.

  DATA: lo_grid      TYPE REF TO cl_gui_alv_grid,
        lt_rows      TYPE lvc_t_roid,
        lt_badet     TYPE STANDARD TABLE OF zostb_badet,
        lt_felog     TYPE STANDARD TABLE OF zostb_felog,
        lt_temp      TYPE STANDARD TABLE OF zostb_felog,

        ls_rows      TYPE lvc_s_roid,
        ls_reporte   LIKE LINE OF gt_reporte,
        ls_balog     TYPE zostb_balog,
        ls_felog     TYPE zostb_felog ##NEEDED,
        ls_usrautreg TYPE zostb_usrautreg,                              "I-WMR-090617-3000007486
        ls_auditoria TYPE zosfees_auditregul,                           "I-WMR-090617-3000007486

        l_lines      TYPE i,
        l_text       TYPE string,
        l_answer     TYPE char01.

  FIELD-SYMBOLS: <fs_badet> TYPE zostb_badet,
                 <fs_temp>  TYPE zostb_felog,
                 <fs_felog> TYPE zostb_felog.

  ep_subrc = 0.

  " Verificar Autorización a Regularizar                                "I-WMR-090617-3000007486
  SELECT SINGLE * INTO ls_usrautreg                                     "I-WMR-090617-3000007486
    FROM zostb_usrautreg                                                "I-WMR-090617-3000007486
    WHERE bukrs EQ p_bukrs                                              "I-WMR-090617-3000007486
      AND uname EQ sy-uname                                             "I-WMR-090617-3000007486
      AND cbfaele EQ abap_true.                                         "I-WMR-090617-3000007486

  IF ls_usrautreg IS INITIAL.                                           "I-WMR-090617-3000007486
    SELECT SINGLE * INTO ls_usrautreg                                   "I-WMR-090617-3000007486
      FROM zostb_usrautreg                                              "I-WMR-090617-3000007486
      WHERE bukrs EQ space                                              "I-WMR-090617-3000007486
        AND uname EQ sy-uname                                           "I-WMR-090617-3000007486
        AND cbfaele EQ abap_true.                                       "I-WMR-090617-3000007486
  ENDIF.                                                                "I-WMR-090617-3000007486

  IF ls_usrautreg IS INITIAL.                                           "I-WMR-090617-3000007486
    MESSAGE i208(00) WITH text-i01.         "M LJG21.05.2018            "I-WMR-090617-3000007486
    ep_subrc = 4. RETURN.                                               "I-WMR-090617-3000007486
  ENDIF.                                                                "I-WMR-090617-3000007486

  IF lo_grid IS NOT BOUND.
    CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
      IMPORTING
        e_grid = lo_grid.
  ENDIF.

  IF lo_grid IS BOUND.
    lo_grid->get_selected_rows(
      IMPORTING
        et_row_no = lt_rows
    ).
  ENDIF.

  l_lines = lines( lt_rows ).

  IF l_lines EQ 0 OR l_lines > 1.
    MESSAGE i208(00) WITH text-i02.                "M LJG-21.05.2018
    ep_subrc = 4. RETURN.
  ENDIF.

  READ TABLE lt_rows INTO ls_rows INDEX 1.
  IF sy-subrc EQ 0.
    READ TABLE gt_reporte INTO ls_reporte INDEX ls_rows-row_id.
    CHECK sy-subrc EQ 0.

    " Confirmación
    CONCATENATE text-i08
                ls_reporte-zzt_identifibaja
                text-i09  INTO l_text SEPARATED BY space.
    CALL FUNCTION 'POPUP_TO_CONFIRM_WITH_MESSAGE'
      EXPORTING
        diagnosetext1 = l_text
        textline1     = text-i10
        titel         = text-i11
      IMPORTING
        answer        = l_answer ##FM_OLDED.

    IF l_answer NE 'J'.
      ep_subrc = 4. RETURN.
    ENDIF.

    " Obtener Log de Resumen seleccionado
    SELECT SINGLE * INTO ls_balog
      FROM zostb_balog
      WHERE bukrs            EQ ls_reporte-bukrs
        AND zzt_identifibaja EQ ls_reporte-zzt_identifibaja ##WARN_OK.

    CASE ls_balog-zzt_status_cdr.
      WHEN '1'  "Aprobado
        OR '4'. "Aprobado con Obs.
      WHEN OTHERS.
        MESSAGE i208(00) WITH text-i03.                    "M LJG-21.05.2018
        ep_subrc = 4. RETURN.
    ENDCASE.

**    TRANSLATE ls_rblog-zzt_errorext TO UPPER CASE.
**    FIND 'EL SERVIDOR DE SUNAT NO ESTA RETORNANDO CDR' IN ls_reporte-zzt_obsercdr.
**    IF sy-subrc NE 0.
**      MESSAGE i208(00) WITH 'Resumen de Boletas seleccionado no debe tener CDR'.
**      ep_subrc = 4. RETURN.
**    ENDIF.

    " Obtener detalle de Comunicado seleccionado
    SELECT bukrs zz_identifibaja zz_nrofila zz_tipodoc zz_serie zz_correlativo
      INTO CORRESPONDING FIELDS OF TABLE lt_badet ##TOO_MANY_ITAB_FIELDS
      FROM zostb_badet
      WHERE bukrs           EQ ls_reporte-bukrs
        AND zz_identifibaja EQ ls_reporte-zzt_identifibaja ##WARN_OK.

    IF lt_badet[] IS INITIAL.
      MESSAGE i208(00) WITH text-i04.             "M LJG-21.05.2018
      ep_subrc = 4. RETURN.
    ENDIF.

    " Obtener documentos asociados al detalle del Comunicado seleccionado
    LOOP AT lt_badet ASSIGNING <fs_badet>.
      APPEND INITIAL LINE TO lt_temp ASSIGNING <fs_temp>.
      <fs_temp>-bukrs       = <fs_badet>-bukrs.
      <fs_temp>-zzt_tipodoc = <fs_badet>-zz_tipodoc.
      CONCATENATE <fs_badet>-zz_serie <fs_badet>-zz_correlativo INTO <fs_temp>-zzt_numeracion SEPARATED BY abap_undefined.
    ENDLOOP.

    SELECT * INTO TABLE lt_felog
      FROM zostb_felog
      FOR ALL ENTRIES IN lt_temp
      WHERE zzt_numeracion EQ lt_temp-zzt_numeracion
        AND bukrs          EQ lt_temp-bukrs
        AND zzt_tipodoc    EQ lt_temp-zzt_tipodoc.

    FREE lt_temp.

    IF lt_felog[] IS INITIAL.
      MESSAGE i208(00) WITH text-i05.                  "M LJG-21.05.2018
      ep_subrc = 4. RETURN.
    ENDIF.

    " Fijar datos de auditoría de Regularización                        "I-WMR-090617-3000007486
    ls_auditoria-usuregu = sy-uname.                                    "I-WMR-090617-3000007486
    ls_auditoria-fecregu = sy-datum.                                    "I-WMR-090617-3000007486
    ls_auditoria-horregu = sy-uzeit.                                    "I-WMR-090617-3000007486

    LOOP AT lt_felog ASSIGNING <fs_felog>.
      <fs_felog>-zzt_identifibaja = ls_balog-zzt_identifibaja.
      <fs_felog>-zzt_status_cdr   = '8'. "Status Baja para los documentos individuales
      <fs_felog>-zzt_errorext     = ls_balog-zzt_errorext.
      <fs_felog>-zzt_iderrsun     = ls_balog-zzt_iderrsun.
      <fs_felog>-zzt_idcdr        = ls_balog-zzt_idcdr.
      <fs_felog>-zzt_fecrec       = ls_balog-zzt_fecrec.
      <fs_felog>-zzt_horrec       = ls_balog-zzt_horrec.
      <fs_felog>-zzt_fecres       = ls_balog-zzt_fecres.
      <fs_felog>-zzt_horres       = ls_balog-zzt_horres.
      <fs_felog>-zzt_mensacdr     = ls_balog-zzt_mensacdr.
      <fs_felog>-zzt_obsercdr     = ls_balog-zzt_obsercdr.
      <fs_felog>-usuregu          = ls_auditoria-usuregu.               "I-WMR-090617-3000007486
      <fs_felog>-fecregu          = ls_auditoria-fecregu.               "I-WMR-090617-3000007486
      <fs_felog>-horregu          = ls_auditoria-horregu.               "I-WMR-090617-3000007486
    ENDLOOP.

    MODIFY zostb_felog FROM TABLE lt_felog.
    IF sy-subrc EQ 0.
      COMMIT WORK.
      CONCATENATE text-i12
                  ls_reporte-zzt_identifibaja
                  text-i13  INTO l_text SEPARATED BY space.
      MESSAGE i208(00) WITH l_text.
    ELSE.
      ROLLBACK WORK.                                  "#EC CI_ROLLBACK.
      CONCATENATE text-i14
                  ls_reporte-zzt_identifibaja INTO l_text SEPARATED BY space.
      MESSAGE i208(00) WITH l_text.
      ep_subrc = 4.
    ENDIF.
  ENDIF.

ENDFORM.                    " REGULARIZAR
*}  END OF INSERT WMR-030517-3000007186
*{  BEGIN OF INSERT WMR-130319-3000010823
*&---------------------------------------------------------------------*
*&      Form  CHECKS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM checks .

  gw_error = abap_off.

  " Validar autorización a Sociedad
  zosclpell_libros_legales=>_authority_check_f_bkpf_buk(
    EXPORTING  i_bukrs = p_bukrs
    EXCEPTIONS error   = 1
               OTHERS  = 2 ).
  IF sy-subrc <> 0.
    gw_error = abap_on.
    MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 DISPLAY LIKE 'E'.
  ENDIF.

  CHECK gw_error = abap_off.

ENDFORM.
*}  END OF INSERT WMR-130319-3000010823
