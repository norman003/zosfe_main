*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_RBMONITOR_F01
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
      WHEN 'FECRES'.
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
  FROM zostb_rblog
  INTO TABLE gt_rblog
  WHERE bukrs            EQ p_bukrs                                     "I-WMR-200715
    AND zzt_identifiresu IN s_idres
    AND zzt_fcreacion    IN s_fecha.
  IF sy-subrc NE 0.
    MESSAGE s208(00) WITH text-e01.
    EXIT.
  ENDIF.

* Obtener cabecera y detalle
  SELECT *
  FROM zostb_rbcab
  INTO TABLE gt_rbcab
  FOR ALL ENTRIES IN gt_rblog
  WHERE bukrs           EQ gt_rblog-bukrs                               "I-WMR-200715
    AND zz_identifiresu EQ gt_rblog-zzt_identifiresu.
  IF sy-subrc EQ 0.
    SELECT *
    FROM zostb_rbdet
    INTO TABLE gt_rbdet
    FOR ALL ENTRIES IN gt_rbcab
    WHERE bukrs           EQ gt_rbcab-bukrs                             "I-WMR-200715
      AND zz_identifiresu EQ gt_rbcab-zz_identifiresu.
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
  LOOP AT gt_rblog ASSIGNING <fs_rblog>.
    AT NEW zzt_identifiresu.
      CLEAR: ls_reporte.
      REFRESH ls_reporte-zzt_errores.
    ENDAT.
    IF <fs_rblog>-zzt_errorext IS NOT INITIAL.
      APPEND <fs_rblog>-zzt_errorext TO ls_reporte-zzt_errores.
    ENDIF.
    AT END OF zzt_identifiresu.
      MOVE-CORRESPONDING <fs_rblog> TO ls_reporte ##ENH_OK.
      READ TABLE gt_rbcab ASSIGNING <fs_rbcab>
                 WITH KEY zz_identifiresu = <fs_rblog>-zzt_identifiresu.
      IF sy-subrc EQ 0.
        ls_reporte-zzt_femision  = <fs_rbcab>-zz_femision.
      ENDIF.
      CASE <fs_rblog>-zzt_status_cdr.
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
      CASE <fs_rblog>-zzt_status_cdr. "Dia Reproceso
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
      WHEN 'ZZT_IDENTIFIRESU'.
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

  DATA: l_subrc  TYPE sysubrc.                                              "I-WMR-270417-3000007167

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

    WHEN '&REGUL'.                                                          "I-WMR-270417-3000007167
      PERFORM regularizar CHANGING l_subrc.                                 "I-WMR-270417-3000007167
      IF l_subrc EQ 0.                                                      "I-WMR-270417-3000007167
        PERFORM get_data.                                                   "I-WMR-270417-3000007167
        PERFORM set_data.                                                   "I-WMR-270417-3000007167
        selfield-refresh = selfield-col_stable = selfield-row_stable = abap_true. "I-WMR-270417-3000007167
      ENDIF.                                                                "I-WMR-270417-3000007167
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

  DATA: ls_reporte TYPE          zoses_rbmonitor,
        l_answer   TYPE          char01,
        lr_numero  TYPE RANGE OF zoses_rbmonitor-zzt_identifiresu,
        lr_fecha   TYPE RANGE OF sy-datum,
        lr_status  TYPE RANGE OF zosed_status_cdr,
        l_string   TYPE          string.

* Valida seleccion
  CHECK gt_reporte[] IS NOT INITIAL.

* Confirmación
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = text-002
      text_question         = text-003
      display_cancel_button = space
    IMPORTING
      answer                = l_answer
    EXCEPTIONS             ##FM_SUBRC_OK
      text_not_found        = 1
      OTHERS                = 2.
  IF l_answer <> '1'.
    MESSAGE s000 WITH text-004. EXIT.
  ENDIF.

* Proceso
  LOOP AT gt_reporte INTO ls_reporte.
    CONCATENATE 'IEQ' ls_reporte-zzt_identifiresu INTO l_string.
    APPEND l_string TO lr_numero.
  ENDLOOP.

  SUBMIT zosfe_int_updcdr_with_ws AND RETURN "#EC CI_SUBMIT
    WITH p_bukrs = ls_reporte-bukrs
    WITH s_numero IN lr_numero
    WITH s_fecha  IN lr_fecha
    WITH s_status IN lr_status
    WITH p_previe = space
    WITH p_submit = abap_true
    WITH p_single = space
    WITH p_resbol = abap_true
    WITH p_combaj = space.

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
*{  BEGIN OF INSERT WMR-270417-3000007167
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
        lt_rbdet     TYPE STANDARD TABLE OF zostb_rbdet,
        lt_rbdet_v2  TYPE STANDARD TABLE OF zostb_rbdet_v2,             "I-WMR-080118-3000008865
        lt_felog     TYPE STANDARD TABLE OF zostb_felog,
        lt_temp      TYPE STANDARD TABLE OF zostb_rbdet,

        ls_rows      TYPE lvc_s_roid,
        ls_reporte   LIKE LINE OF gt_reporte,
        ls_rblog     TYPE zostb_rblog,
        ls_felog     TYPE zostb_felog ##NEEDED,
        ls_usrautreg TYPE zostb_usrautreg,                              "I-WMR-090617-3000007486
        ls_auditoria TYPE zosfees_auditregul,                           "I-WMR-090617-3000007486
        ls_ubl       TYPE zosfetb_ubl,                                  "I-WMR-080118-3000008865

        l_lines      TYPE i,
        l_text       TYPE string,
        l_answer     TYPE char01.

  FIELD-SYMBOLS: <fs_rbdet> TYPE zostb_rbdet,
                 <fs_rbdet_v2> TYPE zostb_rbdet_v2,
                 <fs_temp>  TYPE zostb_rbdet,
                 <fs_felog> TYPE zostb_felog.

  ep_subrc = 0.

  " Verificar Autorización a Regularizar                                "I-WMR-090617-3000007486
  SELECT SINGLE * INTO ls_usrautreg                                     "I-WMR-090617-3000007486
    FROM zostb_usrautreg                                                "I-WMR-090617-3000007486
    WHERE bukrs EQ p_bukrs                                              "I-WMR-090617-3000007486
      AND uname EQ sy-uname                                             "I-WMR-090617-3000007486
      AND rbfaele EQ abap_true.                                         "I-WMR-090617-3000007486

  IF ls_usrautreg IS INITIAL.                                           "I-WMR-090617-3000007486
    SELECT SINGLE * INTO ls_usrautreg                                   "I-WMR-090617-3000007486
      FROM zostb_usrautreg                                              "I-WMR-090617-3000007486
      WHERE bukrs EQ space                                              "I-WMR-090617-3000007486
        AND uname EQ sy-uname                                           "I-WMR-090617-3000007486
        AND rbfaele EQ abap_true.                                       "I-WMR-090617-3000007486
  ENDIF.                                                                "I-WMR-090617-3000007486

  IF ls_usrautreg IS INITIAL.                                           "I-WMR-090617-3000007486
    MESSAGE i208(00) WITH text-005.                                     "I-WMR-090617-3000007486
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
    MESSAGE i208(00) WITH text-006.
    ep_subrc = 4. RETURN.
  ENDIF.

  READ TABLE lt_rows INTO ls_rows INDEX 1.
  IF sy-subrc EQ 0.
    READ TABLE gt_reporte INTO ls_reporte INDEX ls_rows-row_id.
    CHECK sy-subrc EQ 0.

    " Confirmación
    CONCATENATE text-007
                ls_reporte-zzt_identifiresu
                text-008 INTO l_text SEPARATED BY space.
    CALL FUNCTION 'POPUP_TO_CONFIRM_WITH_MESSAGE' ##FM_OLDED
      EXPORTING
        diagnosetext1 = l_text
        textline1     = text-009
        titel         = text-010
      IMPORTING
        answer        = l_answer.

    IF l_answer NE 'J'.
      ep_subrc = 4. RETURN.
    ENDIF.

    " Obtener Log de Resumen seleccionado
    SELECT SINGLE * INTO ls_rblog
      FROM zostb_rblog
      WHERE bukrs            EQ ls_reporte-bukrs
        AND zzt_identifiresu EQ ls_reporte-zzt_identifiresu ##WARN_OK.

    CASE ls_rblog-zzt_status_cdr.
      WHEN '1'  "Aprobado
        OR '4'. "Aprobado con Obs.
      WHEN OTHERS.
        MESSAGE i208(00) WITH text-011.
        ep_subrc = 4. RETURN.
    ENDCASE.

**    TRANSLATE ls_rblog-zzt_errorext TO UPPER CASE.
**    FIND 'EL SERVIDOR DE SUNAT NO ESTA RETORNANDO CDR' IN ls_reporte-zzt_obsercdr.
**    IF sy-subrc NE 0.
**      MESSAGE i208(00) WITH 'Resumen de Boletas seleccionado no debe tener CDR'.
**      ep_subrc = 4. RETURN.
**    ENDIF.

*{  BEGIN OF INSERT WMR-080118-3000008865
    " Obtener Versión de Resumen de Boletas en base a fecha de emisión
    SELECT SINGLE * INTO ls_ubl
      FROM zosfetb_ubl
      WHERE tpproc = gc_prefix_rb                       "Tipo de facturación electronica SUNAT
        AND begda <= ls_reporte-zzt_femision            "Fecha de inicio de validez
        AND endda >= ls_reporte-zzt_femision ##WARN_OK. "Fecha fin de validez

    IF sy-subrc <> 0.
      MESSAGE i208(00) WITH text-012.
      ep_subrc = 4. RETURN.
    ENDIF.

    CASE ls_ubl-zz_versivigen.
      WHEN gc_version_1.
*}  END OF INSERT WMR-080118-3000008865

        " Obtener detalle de Resumen seleccionado
        SELECT bukrs zz_identifiresu zz_nrofila zz_tipodoc zz_serie zz_correla_low zz_correla_high
          INTO CORRESPONDING FIELDS OF TABLE lt_rbdet  ##TOO_MANY_ITAB_FIELDS
          FROM zostb_rbdet
          WHERE bukrs           EQ ls_reporte-bukrs
            AND zz_identifiresu EQ ls_reporte-zzt_identifiresu.

        IF lt_rbdet[] IS INITIAL.
          MESSAGE i208(00) WITH text-013.
          ep_subrc = 4. RETURN.
        ENDIF.

        " Obtener Boletas asociados al detalle del Resumen seleccionado
        LOOP AT lt_rbdet ASSIGNING <fs_rbdet>.
          APPEND INITIAL LINE TO lt_temp ASSIGNING <fs_temp>.
          <fs_temp>-bukrs = <fs_rbdet>-bukrs.
          CONCATENATE <fs_rbdet>-zz_serie <fs_rbdet>-zz_correla_low  INTO <fs_temp>-zz_correla_low  SEPARATED BY abap_undefined.
          CONCATENATE <fs_rbdet>-zz_serie <fs_rbdet>-zz_correla_high INTO <fs_temp>-zz_correla_high SEPARATED BY abap_undefined.
          <fs_temp>-zz_tipodoc = <fs_rbdet>-zz_tipodoc.
        ENDLOOP.

        SELECT * INTO TABLE lt_felog
          FROM zostb_felog
          FOR ALL ENTRIES IN lt_temp
          WHERE ( zzt_numeracion GE lt_temp-zz_correla_low AND zzt_numeracion LE lt_temp-zz_correla_high )
            AND bukrs           EQ lt_temp-bukrs
            AND zzt_tipodoc     EQ lt_temp-zz_tipodoc.

        FREE lt_temp.

*{  BEGIN OF INSERT WMR-080118-3000008865
      WHEN gc_version_2.

        " Obtener detalle de Resumen seleccionado
        SELECT bukrs zz_identifiresu zz_nrofila zz_tipodoc zz_serie
               zz_estadoitem                                                                              "I-NTP300118-3000008976
          INTO CORRESPONDING FIELDS OF TABLE lt_rbdet_v2  ##TOO_MANY_ITAB_FIELDS
          FROM zostb_rbdet_v2
          WHERE bukrs           EQ ls_reporte-bukrs
            AND zz_identifiresu EQ ls_reporte-zzt_identifiresu.

        IF lt_rbdet_v2[] IS INITIAL.
          MESSAGE i208(00) WITH text-014.
          ep_subrc = 4. RETURN.
        ENDIF.

        SELECT * INTO TABLE lt_felog
          FROM zostb_felog
          FOR ALL ENTRIES IN lt_rbdet_v2
          WHERE zzt_numeracion  EQ lt_rbdet_v2-zz_serie(15)
            AND bukrs           EQ lt_rbdet_v2-bukrs
            AND zzt_tipodoc     EQ lt_rbdet_v2-zz_tipodoc.

    ENDCASE.
*}  END OF INSERT WMR-080118-3000008865

    IF lt_felog[] IS INITIAL.
      MESSAGE i208(00) WITH text-015.
      ep_subrc = 4. RETURN.
    ENDIF.

    " Fijar datos de auditoría de Regularización                        "I-WMR-090617-3000007486
    ls_auditoria-usuregu = sy-uname.                                    "I-WMR-090617-3000007486
    ls_auditoria-fecregu = sy-datum.                                    "I-WMR-090617-3000007486
    ls_auditoria-horregu = sy-uzeit.                                    "I-WMR-090617-3000007486

    LOOP AT lt_felog ASSIGNING <fs_felog>.

*{I-NTP300118-3000008976
    CASE ls_ubl-zz_versivigen.
      WHEN gc_version_1.
        <fs_felog>-zzt_status_cdr   = '1'. "Status Aceptado para los documento individuales
      WHEN gc_version_2.
        READ TABLE lt_rbdet_v2 ASSIGNING <fs_rbdet_v2> WITH KEY bukrs = <fs_felog>-bukrs
                                                                zz_tipodoc = <fs_felog>-zzt_tipodoc
                                                                zz_serie = <fs_felog>-zzt_numeracion.
        IF sy-subrc = 0.
          CASE <fs_rbdet_v2>-zz_estadoitem.
            WHEN '1'. <fs_felog>-zzt_status_cdr   = '1'. "Status Aceptado para los documento individuales
            WHEN '3'. <fs_felog>-zzt_status_cdr   = '8'. "Status Baja
          ENDCASE.
        ENDIF.
      ENDCASE.
*}I-NTP300118-3000008976

      <fs_felog>-zzt_identifiresu = ls_rblog-zzt_identifiresu.
*      <fs_felog>-zzt_status_cdr   = '1'. "Status Aceptado para los documento individuales        "E-NTP300118-3000008976
      <fs_felog>-zzt_errorext     = ls_rblog-zzt_errorext.
      <fs_felog>-zzt_iderrsun     = ls_rblog-zzt_iderrsun.
      <fs_felog>-zzt_idcdr        = ls_rblog-zzt_idcdr.
      <fs_felog>-zzt_fecrec       = ls_rblog-zzt_fecrec.
      <fs_felog>-zzt_horrec       = ls_rblog-zzt_horrec.
      <fs_felog>-zzt_fecres       = ls_rblog-zzt_fecres.
      <fs_felog>-zzt_horres       = ls_rblog-zzt_horres.
      <fs_felog>-zzt_mensacdr     = ls_rblog-zzt_mensacdr.
      <fs_felog>-zzt_obsercdr     = ls_rblog-zzt_obsercdr.
      <fs_felog>-usuregu          = ls_auditoria-usuregu.               "I-WMR-090617-3000007486
      <fs_felog>-fecregu          = ls_auditoria-fecregu.               "I-WMR-090617-3000007486
      <fs_felog>-horregu          = ls_auditoria-horregu.               "I-WMR-090617-3000007486
    ENDLOOP.

    MODIFY zostb_felog FROM TABLE lt_felog.
    IF sy-subrc EQ 0.
      COMMIT WORK.
      CONCATENATE text-007
                  ls_reporte-zzt_identifiresu
                  text-016 INTO l_text SEPARATED BY space.
      MESSAGE i208(00) WITH l_text.
    ELSE.
      ROLLBACK WORK. "#EC CI_ROLLBACK
      CONCATENATE text-017
                  ls_reporte-zzt_identifiresu INTO l_text SEPARATED BY space.
      MESSAGE i208(00) WITH l_text.
      ep_subrc = 4.
    ENDIF.
  ENDIF.

ENDFORM.                    " REGULARIZAR
*}  END OF INSERT WMR-270417-3000007167
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
