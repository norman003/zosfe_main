*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_PRMONITOR_F01
*&---------------------------------------------------------------------*

FORM get_cons.

  DATA: lt_const TYPE TABLE OF zostb_const_fe,
        ls_const TYPE zostb_const_fe.

  SELECT * INTO TABLE lt_const
    FROM zostb_const_fe
    WHERE modulo     = gc_mod
      AND aplicacion = gc_apl.

  LOOP AT lt_const INTO ls_const.
    CASE ls_const-campo.
      WHEN 'FECRES'. zconst-fecfac_d = ls_const-valor1.
    ENDCASE.
  ENDLOOP.

ENDFORM.

FORM get_data .

* Obtener datos LOG
  SELECT *
  FROM zostb_rertlog
  INTO TABLE gt_log
  WHERE bukrs         EQ p_bukrs
    AND zzidres       IN s_idres
    AND zzt_fcreacion IN s_fecha.
  IF sy-subrc NE 0.
    MESSAGE s208(00) WITH text-e01.
    EXIT.
  ENDIF.

* Obtener cabecera y detalle
  " Percepcion
  SELECT *
    INTO TABLE gt_rertcab
    FROM zostb_rertcab
    FOR ALL ENTRIES IN gt_log
    WHERE bukrs   EQ gt_log-bukrs
      AND zzidres EQ gt_log-zzidres.

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
        ls_rertcab TYPE zostb_rertcab.

  REFRESH gt_reporte.

* Formar tabla final
  LOOP AT gt_log ASSIGNING <fs_log>.
    AT NEW zzidres.
      CLEAR: ls_reporte.
      REFRESH ls_reporte-zzt_errores.
    ENDAT.
    IF <fs_log>-zzt_errorext IS NOT INITIAL.
      APPEND <fs_log>-zzt_errorext TO ls_reporte-zzt_errores.
    ENDIF.
    AT END OF zzidres.
      MOVE-CORRESPONDING <fs_log> TO ls_reporte.

      READ TABLE gt_rertcab INTO ls_rertcab
           WITH TABLE KEY zzidres = <fs_log>-zzidres.
      IF sy-subrc EQ 0.
        ls_reporte-zzt_femision  = ls_rertcab-zzfecemi.
      ENDIF.

      CASE <fs_log>-zzt_status_cdr.
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
      CASE <fs_log>-zzt_status_cdr.
        WHEN 2 OR 3 OR 5 OR 6 OR 7.
          ls_reporte-zzt_dias = ( ls_reporte-zzt_fcreacion +  zconst-fecfac_d ) - sy-datum.
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
        lt_events   TYPE slis_t_event,                                      "I-WMR-240417-3000007044
        ls_layout   TYPE lvc_s_layo,
        ls_events   TYPE slis_alv_event.                                    "I-WMR-240417-3000007044

  FIELD-SYMBOLS: <fs_fieldcat> LIKE LINE OF lt_fieldcat.

* Catálogo
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'ZOSES_REPRMONITOR'
    CHANGING
      ct_fieldcat      = lt_fieldcat.
  LOOP AT lt_fieldcat ASSIGNING <fs_fieldcat>.
    CASE <fs_fieldcat>-fieldname.
      WHEN 'BUKRS'.
        <fs_fieldcat>-key = abap_true.
      WHEN 'ZZIDRES'.
        <fs_fieldcat>-key = abap_true.
      WHEN 'ZZT_STATUS_CDR'.
        <fs_fieldcat>-key = abap_true.
      WHEN 'ZZT_ERRORES'.
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

* Layout
  ls_layout-cwidth_opt = abap_true.

  " Eventos                                                                 "I-WMR-240417-3000007044
  CLEAR ls_events.                                                          "I-WMR-240417-3000007044
  ls_events-name = slis_ev_pf_status_set.                                   "I-WMR-240417-3000007044
  ls_events-form = slis_ev_pf_status_set.                                   "I-WMR-240417-3000007044
  APPEND ls_events TO lt_events.                                            "I-WMR-240417-3000007044

* Mostrar Reporte
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_callback_program      = sy-repid
      i_callback_user_command = 'USER_COMMAND'
      is_layout_lvc           = ls_layout
      it_fieldcat_lvc         = lt_fieldcat
      it_events               = lt_events                                   "I-WMR-240417-3000007044
    TABLES
      t_outtab                = gt_reporte
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    " SHO_DATA
*&---------------------------------------------------------------------*
*&      Form  PF_STATUS_SET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pf_status_set USING rt_extab TYPE slis_t_extab.

  DATA: ls_extab  TYPE slis_extab.

  CLEAR rt_extab.

  SET PF-STATUS 'STAT_1000' EXCLUDING rt_extab.

ENDFORM.                    " PF_STATUS_SET
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

  DATA: lw_error TYPE char1,
        l_subrc  TYPE sysubrc.                                              "I-WMR-240417-3000007044

  CASE ucomm.
    WHEN '&IC1'.
      CASE selfield-fieldname.
        WHEN 'SEMAFORO'.
          PERFORM show_mensa USING selfield.
        WHEN 'ZZIDRES'.
          PERFORM call_json USING selfield.
      ENDCASE.
    WHEN '&REFRESCAR'.
      selfield-refresh = abap_true.
      PERFORM get_data.
      PERFORM set_data.
    WHEN '&REGUL'.                                                          "I-WMR-240417-3000007044
      PERFORM regularizar CHANGING l_subrc.                                 "I-WMR-240417-3000007044
      IF l_subrc EQ 0.                                                      "I-WMR-240417-3000007044
        PERFORM get_data.                                                   "I-WMR-240417-3000007044
        PERFORM set_data.                                                   "I-WMR-240417-3000007044
        selfield-refresh = selfield-col_stable = selfield-row_stable = abap_true. "I-WMR-240417-3000007044
      ENDIF.                                                                "I-WMR-240417-3000007044
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
*&      Form  call_json
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->IS_SELFIELD  text
*----------------------------------------------------------------------*
FORM call_json USING is_selfield TYPE slis_selfield.

  READ TABLE gt_reporte ASSIGNING <fs_reporte> INDEX is_selfield-tabindex.
  CHECK sy-subrc = 0.

  SUBMIT zosfe_rpt_json
    WITH p_bukrs  = <fs_reporte>-bukrs
    WITH p_idres  = <fs_reporte>-zzidres
    WITH p_prefix = gc_prefix_rr
    AND RETURN.

ENDFORM.
*{  BEGIN OF INSERT WMR-240417-3000007044
*&---------------------------------------------------------------------*
*&      Form  REGULARIZAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_L_SUBRC  text
*----------------------------------------------------------------------*
FORM regularizar  CHANGING ep_subrc TYPE sysubrc.

  DATA: lo_grid     TYPE REF TO cl_gui_alv_grid,
        lt_rows     TYPE lvc_t_roid,
        lt_rertdet  TYPE STANDARD TABLE OF zostb_rertdet,
        lt_cplog    TYPE STANDARD TABLE OF zostb_cplog,
        lt_temp     TYPE STANDARD TABLE OF zostb_cplog,

        ls_rows     TYPE lvc_s_roid,
        ls_reporte  LIKE LINE OF gt_reporte,
        ls_rertlog  TYPE zostb_rertlog,
        ls_cplog    TYPE zostb_cplog,
        ls_usrautreg TYPE zostb_usrautreg,                              "I-WMR-090617-3000007486
        ls_auditoria TYPE zosfees_auditregul,                           "I-WMR-090617-3000007486

        l_lines     TYPE i,
        l_text      TYPE string,
        l_answer    TYPE char01.

  FIELD-SYMBOLS: <fs_rertdet> TYPE zostb_rertdet,
                 <fs_cplog>   TYPE zostb_cplog.

  ep_subrc = 0.

  " Verificar Autorización a Regularizar                                "I-WMR-090617-3000007486
  SELECT SINGLE * INTO ls_usrautreg                                     "I-WMR-090617-3000007486
    FROM zostb_usrautreg                                                "I-WMR-090617-3000007486
    WHERE bukrs EQ p_bukrs                                              "I-WMR-090617-3000007486
      AND uname EQ sy-uname                                             "I-WMR-090617-3000007486
      AND rrrtele EQ abap_true.                                         "I-WMR-090617-3000007486

  IF ls_usrautreg IS INITIAL.                                           "I-WMR-090617-3000007486
    SELECT SINGLE * INTO ls_usrautreg                                   "I-WMR-090617-3000007486
      FROM zostb_usrautreg                                              "I-WMR-090617-3000007486
      WHERE bukrs EQ space                                              "I-WMR-090617-3000007486
        AND uname EQ sy-uname                                           "I-WMR-090617-3000007486
        AND rrrtele EQ abap_true.                                       "I-WMR-090617-3000007486
  ENDIF.                                                                "I-WMR-090617-3000007486

  IF ls_usrautreg IS INITIAL.                                           "I-WMR-090617-3000007486
    MESSAGE i208(00) WITH 'Ud. no tiene autorización a Regularizar'.    "I-WMR-090617-3000007486
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
    MESSAGE i208(00) WITH 'Seleccione un sólo documento a regularizar'.
    ep_subrc = 4. RETURN.
  ENDIF.

  READ TABLE lt_rows INTO ls_rows INDEX 1.
  IF sy-subrc EQ 0.
    READ TABLE gt_reporte INTO ls_reporte INDEX ls_rows-row_id.
    CHECK sy-subrc EQ 0.

    " Confirmación
    CONCATENATE 'El Resumen'
                ls_reporte-zzidres
                'será regularizado' INTO l_text SEPARATED BY space.
    CALL FUNCTION 'POPUP_TO_CONFIRM_WITH_MESSAGE'
      EXPORTING
        diagnosetext1 = l_text
        textline1     = '¿Desea continuar?'
        titel         = 'Confirmar Regularización'
      IMPORTING
        answer        = l_answer.

    IF l_answer NE 'J'.
      ep_subrc = 4. RETURN.
    ENDIF.

    CASE ls_reporte-zzt_status_cdr.
      WHEN '1'  "Aprobado
        OR '4'. "Aprobado con Obs.
      WHEN OTHERS.
        MESSAGE i208(00) WITH 'Resumen seleccionado debe estar Aceptado'.
        ep_subrc = 4. RETURN.
    ENDCASE.

    TRANSLATE ls_reporte-zzt_obsercdr TO UPPER CASE.
    FIND 'SUNAT NO DEVOLVIÓ CDR' IN ls_reporte-zzt_obsercdr.
    IF sy-subrc NE 0.
      MESSAGE i208(00) WITH 'Resumen seleccionado no debe tener CDR'.
      ep_subrc = 4. RETURN.
    ENDIF.

    " Obtener Log de Resumen seleccionado
    SELECT SINGLE * INTO ls_rertlog
      FROM zostb_rertlog
      WHERE bukrs   EQ ls_reporte-bukrs
        AND zzidres EQ ls_reporte-zzidres.

    " Obtener detalle de Resumen seleccionado
    SELECT bukrs zzidres zznfila zztipdoc ctnumber zzcrlser zzcrlnro
      INTO CORRESPONDING FIELDS OF TABLE lt_rertdet
      FROM zostb_rertdet
      WHERE bukrs   EQ ls_reporte-bukrs
        AND zzidres EQ ls_reporte-zzidres.

    IF lt_rertdet[] IS INITIAL.
      MESSAGE i208(00) WITH 'No existe detalle para el Resumen seleccionado'.
      ep_subrc = 4. RETURN.
    ENDIF.

    " Obtener Comprobantes de retención asociados al detalle del Resumen seleccionado
    LOOP AT lt_rertdet ASSIGNING <fs_rertdet>.
      APPEND INITIAL LINE TO lt_temp ASSIGNING <fs_cplog>.
      <fs_cplog>-bukrs = <fs_rertdet>-bukrs.
      CONCATENATE <fs_rertdet>-zzcrlser <fs_rertdet>-zzcrlnro INTO <fs_cplog>-zzt_nrodocsap.
      CONCATENATE <fs_rertdet>-zzcrlser <fs_rertdet>-zzcrlnro INTO <fs_cplog>-zzt_numeracion SEPARATED BY abap_undefined.
      <fs_cplog>-zzt_tipodoc = <fs_rertdet>-zztipdoc.
    ENDLOOP.

    SELECT * INTO TABLE lt_cplog
      FROM zostb_cplog
      FOR ALL ENTRIES IN lt_temp
      WHERE bukrs           EQ lt_temp-bukrs
        AND zzt_nrodocsap   EQ lt_temp-zzt_nrodocsap
        AND zzt_numeracion  EQ lt_temp-zzt_numeracion
        AND zzt_tipodoc     EQ lt_temp-zzt_tipodoc.

    FREE lt_temp.

    IF lt_cplog[] IS INITIAL.
      MESSAGE i208(00) WITH 'No existen Comprobantes para el Resumen seleccionado'.
      ep_subrc = 4. RETURN.
    ENDIF.

    " Fijar datos de auditoría de Regularización                        "I-WMR-090617-3000007486
    ls_auditoria-usuregu = sy-uname.                                    "I-WMR-090617-3000007486
    ls_auditoria-fecregu = sy-datum.                                    "I-WMR-090617-3000007486
    ls_auditoria-horregu = sy-uzeit.                                    "I-WMR-090617-3000007486

    LOOP AT lt_cplog ASSIGNING <fs_cplog>.
      <fs_cplog>-zzt_identifibaja = ls_reporte-zzidres.
      <fs_cplog>-zzt_status_cdr   = '8'. "Status Baja para los documento individuales
      <fs_cplog>-zzt_errorext     = ls_rertlog-zzt_errorext.
      <fs_cplog>-zzt_iderrsun     = ls_rertlog-zzt_iderrsun.
      <fs_cplog>-zzt_idcdr        = ls_rertlog-zzt_idcdr.
      <fs_cplog>-zzt_fecrec       = ls_rertlog-zzt_fecrec.
      <fs_cplog>-zzt_horrec       = ls_rertlog-zzt_horrec.
      <fs_cplog>-zzt_fecres       = ls_rertlog-zzt_fecres.
      <fs_cplog>-zzt_horres       = ls_rertlog-zzt_horres.
      <fs_cplog>-zzt_mensacdr     = ls_rertlog-zzt_mensacdr.
      <fs_cplog>-zzt_obsercdr     = ls_rertlog-zzt_obsercdr.
      <fs_cplog>-usuregu          = ls_auditoria-usuregu.               "I-WMR-090617-3000007486
      <fs_cplog>-fecregu          = ls_auditoria-fecregu.               "I-WMR-090617-3000007486
      <fs_cplog>-horregu          = ls_auditoria-horregu.               "I-WMR-090617-3000007486
    ENDLOOP.

    MODIFY zostb_cplog FROM TABLE lt_cplog.
    IF sy-subrc EQ 0.
      COMMIT WORK.
      CONCATENATE 'El Resumen'
                  ls_reporte-zzidres
                  'ha sido regularizado correctamente' INTO l_text SEPARATED BY space.
      MESSAGE i208(00) WITH l_text.
    ELSE.
      ROLLBACK WORK.
      CONCATENATE 'Error al regularizar Resumen'
                  ls_reporte-zzidres INTO l_text SEPARATED BY space.
      MESSAGE i208(00) WITH l_text.
      ep_subrc = 4.
    ENDIF.
  ENDIF.

ENDFORM.                    " REGULARIZAR
*}  END OF INSERT WMR-240417-3000007044
