*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_NC_POR_VALOR_C01
*&---------------------------------------------------------------------*
CLASS zcl_amp DEFINITION DEFERRED.
DATA: amp TYPE REF TO zcl_amp.

CLASS zcl_amp DEFINITION.
  PUBLIC SECTION.
    "Tipos
    TYPES: tab_ofibm TYPE TABLE OF ofibm.

    TYPES: BEGIN OF gty_bseg,
             vbeln    TYPE vbrk-vbeln,
             bukrs    TYPE bkpf-bukrs,
             belnr    TYPE bkpf-belnr,
             gjahr    TYPE bkpf-gjahr,
             buzei    TYPE bseg-buzei,
             dmbtr    TYPE bseg-dmbtr,
             wrbtr    TYPE bseg-wrbtr,
             zfbdt    TYPE bseg-zfbdt,
             ztag1    TYPE t052-ztag1,
             zterm    TYPE bseg-zterm,
             fdtag    TYPE bseg-fdtag,
             shkzg    TYPE bseg-shkzg,
             koart    TYPE bseg-koart,
             zbd1t    TYPE bseg-zbd1t,
             zbd2t    TYPE bseg-zbd2t,
             zbd3t    TYPE bseg-zbd3t,
             rebzg    TYPE bseg-rebzg,
             rebzt    TYPE bseg-rebzt,
             zterm_db TYPE bseg-zterm,
           END OF gty_bseg.

    "Data
    DATA: BEGIN OF zamp,
            is_edicion  TYPE xfeld,
            is_sociedad TYPE xfeld,
            is_active   TYPE xfeld,

          END OF zamp.
    DATA: BEGIN OF zconst,
            f_active TYPE datum,

            r_auart  TYPE RANGE OF vbak-auart,
            augru    TYPE vbak-augru,
          END OF zconst.

    DATA: gt_bseg TYPE TABLE OF gty_bseg.

    "Object
    DATA: go_100 TYPE REF TO cl_gui_alv_grid.

    "Metodos
    METHODS inicializa EXCEPTIONS error.
    METHODS validacion01
      IMPORTING  is_t180 TYPE t180 OPTIONAL
                 is_vbak TYPE vbak
      EXCEPTIONS error.
    METHODS validacion02
      IMPORTING  is_bkpf TYPE bkpf
                 i_aktyp TYPE t020-aktyp
      EXCEPTIONS error.

    "Accion
    METHODS amp01a_va01_inicializa_vbak
      IMPORTING  is_t180 TYPE t180
      CHANGING   cs_vbak TYPE vbak
      EXCEPTIONS error.
    METHODS amp01b_va01_disablefields
      IMPORTING  is_t180 TYPE t180
                 is_vbak TYPE vbak
      EXCEPTIONS error.
    METHODS amp01c_va01_presave
      IMPORTING  is_t180 TYPE t180
                 is_vbak TYPE vbak
                 is_vbkd TYPE vbkdvb
                 it_vbap TYPE tab_xyvbap
      EXPORTING  e_subrc TYPE clike
      EXCEPTIONS error.
    METHODS amp01d_va01_save
      IMPORTING  is_t180 TYPE t180
                 is_vbak TYPE vbak
                 is_vbkd TYPE vbkdvb
      EXCEPTIONS error.

    METHODS amp02a_fb02_disablefiels
      IMPORTING  is_bkpf  TYPE bkpf
                 i_aktyp  TYPE t020-aktyp
      CHANGING   et_field TYPE tab_ofibm
      EXCEPTIONS error.

    METHODS amp03a_wsp_cdr_updatedocfi
      CHANGING   cs_felog TYPE zostb_felog
      EXCEPTIONS error.

    METHODS: r100_st CHANGING ct_excl TYPE slis_t_extab.
    METHODS: r100_uc IMPORTING i_ucomm TYPE clike CHANGING cs_sel TYPE slis_selfield.

  PRIVATE SECTION.
    METHODS: determine_due_date IMPORTING is_bseg TYPE gty_bseg EXPORTING e_netdt TYPE dats.
    METHODS: alv_condicionpago_cuotas.
    METHODS: r100_changed FOR EVENT data_changed_finished OF cl_gui_alv_grid IMPORTING e_modified et_good_cells.

ENDCLASS.

CLASS zcl_amp IMPLEMENTATION.
*----------------------------------------------------------------------*
* Inicializa
*----------------------------------------------------------------------*
  METHOD inicializa.
    DATA: lt_const TYPE TABLE OF zostb_constantes,
          ls_const LIKE LINE OF lt_const,
          l_string TYPE string.

    "01. Get
    IMPORT zconst = zconst FROM MEMORY ID sy-repid.
    IF zconst IS INITIAL.
      SELECT * INTO TABLE lt_const FROM zostb_constantes
        WHERE aplicacion = 'AMPLIACION'
          AND programa   = sy-repid.

      "01.1 Read
      LOOP AT lt_const INTO ls_const.
        CONCATENATE ls_const-signo ls_const-opcion ls_const-valor1 INTO l_string.
        CASE ls_const-campo.
            "01.11 Fecha activa
          WHEN 'F_ACTIVE'.
            CONCATENATE ls_const-valor1+6(4)
                        ls_const-valor1+3(2)
                        ls_const-valor1+0(2) INTO zconst-f_active.
          WHEN 'AUART'. APPEND l_string TO zconst-r_auart.
          WHEN 'AUGRU'. zconst-augru = ls_const-valor1.
        ENDCASE.
      ENDLOOP.

      "01.2 Mandatory
      IF zconst-augru IS INITIAL.
        RAISE error.
      ENDIF.
      EXPORT zconst = zconst TO MEMORY ID sy-repid.
    ENDIF.
  ENDMETHOD.                    "get_constantes

*---------------------------------------------------------------------*
* Inicializa
*---------------------------------------------------------------------*
  METHOD validacion01.

    "01. Inicializa
    inicializa( EXCEPTIONS error = 1 ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.

    "02. Edicion
    IF is_t180-trtyp <> 'A'. "View exclude
      "02.1 Si tiene registrado clase o tiene asignado motivo
      IF ( is_vbak-auart IN zconst-r_auart AND zconst-r_auart IS NOT INITIAL ) OR
        is_vbak-augru = zconst-augru.
        zamp-is_edicion = abap_on.
      ENDIF.
    ENDIF.

    "03. Sociedad
    zamp-is_sociedad = abap_on.

    "04. Fecha de activacion
    IF zconst-f_active <= sy-datum.
      zamp-is_active = abap_on.
    ENDIF.

    "05. Resultado
    IF zamp-is_edicion = abap_off OR zamp-is_sociedad = abap_off OR zamp-is_active = abap_off.
      RAISE error.
    ENDIF.

  ENDMETHOD.                    "amp01_iniciliza

*--------------------------------------------------------------------*
* Accion
*--------------------------------------------------------------------*
  METHOD amp01a_va01_inicializa_vbak.

    "01. Valida
    validacion01(
      EXPORTING is_t180 = is_t180
                is_vbak = cs_vbak
      EXCEPTIONS error = 1 ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.

    "02. Inicializar motivo, asignacion
    IF cs_vbak-augru IS INITIAL.
      cs_vbak-augru = zconst-augru.
    ENDIF.
    IF cs_vbak-zuonr IS INITIAL.
      cs_vbak-zuonr = cs_vbak-vgbel.
    ENDIF.

  ENDMETHOD.

*--------------------------------------------------------------------*
* Accion
*--------------------------------------------------------------------*
  METHOD amp01b_va01_disablefields.

    "01. Valida
    validacion01(
      EXPORTING is_t180 = is_t180
                is_vbak = is_vbak
      EXCEPTIONS error = 1 ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.

    "02. Deshabilitar campos
    IF sy-dynnr = 4440 OR sy-dynnr = 4301.
      IF screen-name = 'VBAK-AUGRU'.
        screen-input = 0.
      ENDIF.
    ENDIF.
    IF sy-dynnr = 4311.
      IF screen-name = 'VBAK-XBLNR' OR
         screen-name = 'VBAK-ZUONR'.
        screen-input = 0.
      ENDIF.
    ENDIF.
    IF sy-dynnr = 4303 OR sy-dynnr = 4440.
      IF screen-name = 'VBKD-FBUDA'.
        screen-input = 0.
      ENDIF.
    ENDIF.

  ENDMETHOD.

*--------------------------------------------------------------------*
* Accion
*--------------------------------------------------------------------*
  METHOD amp01c_va01_presave.

    DATA: ls_vbap LIKE LINE OF it_vbap.

    "01. Valida
    validacion01(
      EXPORTING is_t180 = is_t180
                is_vbak = is_vbak
      EXCEPTIONS error = 1 ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.

    "02. Valida condicion
    SELECT COUNT(*) FROM vbrk WHERE vbeln = is_vbak-vgbel AND zterm = is_vbkd-zterm.
    IF sy-subrc = 0.

      "02.1 Cuotas no aplica
      SELECT COUNT(*) FROM t052 WHERE zterm = is_vbkd-zterm AND xsplt = abap_on.
      IF sy-subrc <> 0.
        e_subrc = 'ENT1'.
        MESSAGE e000 WITH 'Condiciones de solicitud debe ser' 'distinta a la factura'.
      ENDIF.
    ENDIF.

    "03. Validar posicion
    DESCRIBE TABLE it_vbap.
    IF sy-tfill > 1.
      e_subrc = 'ENT1'.
      MESSAGE e000 WITH 'Solo esta permitido una posicion'.
    ENDIF.

  ENDMETHOD.

*--------------------------------------------------------------------*
* Accion
*--------------------------------------------------------------------*
  METHOD amp01d_va01_save.
    DATA: lt_bkpf   TYPE TABLE OF bkpf_key,
          lt_bsegfp TYPE TABLE OF zosfetb_bsegfp,
          ls_bsegfp LIKE LINE OF lt_bsegfp.
    FIELD-SYMBOLS: <fs_bseg> LIKE LINE OF gt_bseg.


    "01. Valida
    validacion01(
      EXPORTING is_t180 = is_t180
                is_vbak = is_vbak
      EXCEPTIONS error = 1 ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.

    "02. Doc FI
    SELECT mandt bukrs belnr gjahr
      INTO TABLE lt_bkpf
      FROM bkpf
      WHERE awkey = is_vbak-vgbel
        AND awtyp = 'VBRK'.
    IF lt_bkpf IS INITIAL.
      RAISE error.
    ENDIF.

    SELECT bukrs belnr gjahr buzei dmbtr wrbtr zfbdt zterm fdtag
           shkzg koart zbd1t zbd2t zbd3t rebzg rebzt zterm AS zterm_db
      INTO CORRESPONDING FIELDS OF TABLE gt_bseg
      FROM bseg
      FOR ALL ENTRIES IN lt_bkpf
      WHERE bukrs = lt_bkpf-bukrs
        AND belnr = lt_bkpf-belnr
        AND gjahr = lt_bkpf-gjahr.

    "03. Actualizado
    SELECT * INTO TABLE lt_bsegfp FROM zosfetb_bsegfp
      FOR ALL ENTRIES IN lt_bkpf
      WHERE bukrs = lt_bkpf-bukrs
        AND belnr = lt_bkpf-belnr
        AND gjahr = lt_bkpf-gjahr.

    "04. Actualizar
    DELETE gt_bseg WHERE koart <> 'D'.
    LOOP AT gt_bseg ASSIGNING <fs_bseg>.
      <fs_bseg>-vbeln = is_vbak-vgbel.

      "04.1 zterm actualizado
      READ TABLE lt_bsegfp INTO ls_bsegfp WITH KEY bukrs = <fs_bseg>-bukrs
                                                   belnr = <fs_bseg>-belnr
                                                   gjahr = <fs_bseg>-gjahr
                                                   buzei = <fs_bseg>-buzei.
      IF sy-subrc = 0.
        <fs_bseg>-zterm = ls_bsegfp-zterm.
      ENDIF.

      "04.2 zterm dias
      SELECT SINGLE ztag1 INTO <fs_bseg>-ztag1 FROM t052 WHERE zterm = <fs_bseg>-zterm.
    ENDLOOP.

    "05. Tipo de pago
    SELECT COUNT(*) FROM t052 WHERE zterm = is_vbkd-zterm AND xsplt = abap_on.
    IF sy-subrc = 0.
      "05.1 Varias Cuotas
      "05.2 Determinar fecha de vencimiento
      LOOP AT gt_bseg ASSIGNING <fs_bseg>.
        determine_due_date( EXPORTING is_bseg = <fs_bseg>
                            IMPORTING e_netdt = <fs_bseg>-fdtag ).
      ENDLOOP.

      "05.3 Actualizar condiciones de pago
      alv_condicionpago_cuotas( ).

      "05.4 Pre-save: Solo modificados
      LOOP AT gt_bseg ASSIGNING <fs_bseg>.
        IF <fs_bseg>-zterm <> <fs_bseg>-zterm_db.
          MOVE-CORRESPONDING <fs_bseg> TO ls_bsegfp.
          APPEND ls_bsegfp TO lt_bsegfp.
        ENDIF.
      ENDLOOP.
    ELSE.
      "05.5 Una Cuota
      READ TABLE gt_bseg ASSIGNING <fs_bseg> INDEX 1.
      IF sy-subrc = 0.
        MOVE-CORRESPONDING <fs_bseg> TO ls_bsegfp.

        ls_bsegfp-zterm = is_vbkd-zterm.
        APPEND ls_bsegfp TO lt_bsegfp.
      ENDIF.
    ENDIF.

    "06. Save
    MODIFY zosfetb_bsegfp FROM TABLE lt_bsegfp.
  ENDMETHOD.

*----------------------------------------------------------------------*
*	Determina fecha de vencimiento
*----------------------------------------------------------------------*
  METHOD determine_due_date.
    DATA: ls_faede TYPE faede,
          ls_t052  TYPE t052.

    ls_faede-shkzg  = is_bseg-shkzg.
    ls_faede-koart  = is_bseg-koart.
    ls_faede-zfbdt  = is_bseg-zfbdt.
    ls_faede-rebzg  = is_bseg-rebzg.
    ls_faede-rebzt  = is_bseg-rebzt.

    SELECT SINGLE * INTO ls_t052 FROM t052 WHERE zterm = is_bseg-zterm.
    IF sy-subrc = 0.
      ls_faede-zbd1t  = ls_t052-ztag1.
      ls_faede-zbd2t  = ls_t052-ztag2.
      ls_faede-zbd3t  = ls_t052-ztag3.
    ENDIF.

    CALL FUNCTION 'DETERMINE_DUE_DATE'
      EXPORTING
        i_faede = ls_faede
      IMPORTING
        e_faede = ls_faede.

    e_netdt = ls_faede-netdt.
  ENDMETHOD.

*----------------------------------------------------------------------*
*	Alv popup para actualizar condicion de pago de cuotas
*----------------------------------------------------------------------*
  METHOD alv_condicionpago_cuotas.
    DATA: lo_alv  TYPE REF TO cl_salv_table,
          lo_cols TYPE REF TO cl_salv_columns_table,
          lo_aggr TYPE REF TO cl_salv_aggregations,
          lt_fcat TYPE lvc_t_fcat,
          ls_layo TYPE lvc_s_layo.
    FIELD-SYMBOLS: <fs_fcat> LIKE LINE OF lt_fcat.

    ls_layo-cwidth_opt = abap_on.

    "01. Fcat
    TRY.
        cl_salv_table=>factory( IMPORTING r_salv_table = lo_alv CHANGING t_table = gt_bseg ).
        lo_cols = lo_alv->get_columns( ).
        lo_aggr = lo_alv->get_aggregations( ).
        lt_fcat = cl_salv_controller_metadata=>get_lvc_fieldcatalog( r_columns = lo_cols r_aggregations = lo_aggr ).
      CATCH cx_root.
    ENDTRY.

    LOOP AT lt_fcat ASSIGNING <fs_fcat>.
      CASE <fs_fcat>-fieldname.
        WHEN 'ZTERM'.
          <fs_fcat>-edit = abap_on.
          <fs_fcat>-outputlen = 10.
          <fs_fcat>-ref_table = 'ZOSFETB_BSEGFP'.
          <fs_fcat>-ref_field = 'ZTERM'.
          <fs_fcat>-f4availabl = 'X'.
        WHEN 'SHKZG' OR 'KOART' OR 'ZBD1T' OR 'ZBD2T' OR 'ZBD3T' OR 'REBZG' OR 'REBZT' OR 'ZTERM_DB'.
          <fs_fcat>-no_out = 'X'.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.

    "02. Actualizar condicion de pagos
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
      EXPORTING
        i_callback_program       = sy-repid
        is_layout_lvc            = ls_layo
        it_fieldcat_lvc          = lt_fcat
        i_callback_pf_status_set = 'R100_ST'
        i_callback_user_command  = 'R100_UC'
        i_screen_start_column    = 30
        i_screen_start_line      = 1
        i_screen_end_column      = 120
        i_screen_end_line        = 8
      TABLES
        t_outtab                 = gt_bseg
      EXCEPTIONS
        program_error            = 1
        OTHERS                   = 2.
  ENDMETHOD.

*----------------------------------------------------------------------*
*	R100_st
*----------------------------------------------------------------------*
  METHOD r100_st.
    SET PF-STATUS 'R100_ST' OF PROGRAM 'ZOSFE_AMP_FORMADEPAGO'.

    CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
      IMPORTING
        e_grid = go_100.

    SET HANDLER r100_changed FOR go_100.
    go_100->register_edit_event( cl_gui_alv_grid=>mc_evt_modified ).
    go_100->register_edit_event( cl_gui_alv_grid=>mc_evt_enter ).
  ENDMETHOD.

*----------------------------------------------------------------------*
*	R100_uc
*----------------------------------------------------------------------*
  METHOD r100_uc.
    DATA: ls_bseg LIKE LINE OF gt_bseg.

    CASE i_ucomm.
      WHEN '&SAVE'.
        LOOP AT gt_bseg INTO ls_bseg.
          IF ls_bseg-zterm <> ls_bseg-zterm_db.
            cs_sel-exit = abap_on.
          ENDIF.
        ENDLOOP.

        IF cs_sel-exit IS INITIAL.
          MESSAGE e000 WITH 'No se ha modificado' 'ninguna condicion de pago'.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.

*----------------------------------------------------------------------*
*	R100_changed
*----------------------------------------------------------------------*
  METHOD r100_changed.
    DATA: ls_stable TYPE lvc_s_stbl VALUE 'XX',
          ls_cell   LIKE LINE OF et_good_cells.

    FIELD-SYMBOLS: <fs_bseg> LIKE LINE OF gt_bseg.

    LOOP AT et_good_cells INTO ls_cell.
      READ TABLE gt_bseg ASSIGNING <fs_bseg> INDEX ls_cell-row_id.
      IF sy-subrc = 0.
        determine_due_date(
          EXPORTING
            is_bseg = <fs_bseg>
          IMPORTING
            e_netdt = <fs_bseg>-fdtag
        ).

        SELECT SINGLE ztag1 INTO <fs_bseg>-ztag1 FROM t052 WHERE zterm = <fs_bseg>-zterm.
      ENDIF.
    ENDLOOP.

    go_100->refresh_table_display( is_stable = ls_stable ).
  ENDMETHOD.

*---------------------------------------------------------------------*
* Inicializa
*---------------------------------------------------------------------*
  METHOD validacion02.

    "01. Inicializa
    inicializa( EXCEPTIONS error = 1 ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.

    "02. Edicion
    IF i_aktyp = 'V' AND sy-calld = space. "Edit y no batch
      IF is_bkpf-awtyp = 'VBRK'.
        zamp-is_edicion = abap_on.
      ENDIF.
    ENDIF.

    "03. Sociedad
    zamp-is_sociedad = abap_on.

    "04. Fecha de activacion
    IF zconst-f_active <= sy-datum.
      zamp-is_active = abap_on.
    ENDIF.

    "05. Resultado
    IF zamp-is_edicion = abap_off OR zamp-is_sociedad = abap_off OR zamp-is_active = abap_off.
      RAISE error.
    ENDIF.

  ENDMETHOD.

*--------------------------------------------------------------------*
* Accion
*--------------------------------------------------------------------*
  METHOD amp02a_fb02_disablefiels.

    "01. Valida
    validacion02(
      EXPORTING is_bkpf = is_bkpf
                i_aktyp = i_aktyp
      EXCEPTIONS error = 1 ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.

    "02. Campo a deshabilitar
    IF sy-dynnr = 0301.
      APPEND 'BSEG-ZTERM' TO et_field.
      APPEND 'BSEG-ZFBDT' TO et_field.
    ENDIF.

  ENDMETHOD.

*--------------------------------------------------------------------*
* Accion
*--------------------------------------------------------------------*
  METHOD amp03a_wsp_cdr_updatedocfi.

    DATA: ls_vbak   TYPE vbak,
          lt_bseg   TYPE TABLE OF zosfetb_bsegfp,
          ui        TYPE REF TO zcl_util,
          ls_return TYPE bapiret2.
    FIELD-SYMBOLS: <fs_bseg> LIKE LINE OF lt_bseg.

    "01. Validar sea aceptado por SUNAT o error al actualizar documento FI
    CHECK cs_felog-zzt_status_cdr = '1' OR cs_felog-zzt_status_cdr = 'A'.

    "02. Get pedido
    SELECT SINGLE a~vbeln a~auart a~vgbel
      INTO CORRESPONDING FIELDS OF ls_vbak
      FROM vbak AS a INNER JOIN vbrp AS b ON a~vbeln = b~aubel
      WHERE b~vbeln = cs_felog-zzt_nrodocsap.

    "03. Valida
    validacion01(
      EXPORTING is_vbak = ls_vbak
      EXCEPTIONS error = 1 ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.

    "04. Get docfi with zterm updated
    SELECT * INTO TABLE lt_bseg FROM zosfetb_bsegfp WHERE vbeln = ls_vbak-vgbel.

    CHECK lt_bseg IS NOT INITIAL.

    "05. Actualizar docfi via fb02 batch input
    CREATE OBJECT ui.
    LOOP AT lt_bseg ASSIGNING <fs_bseg>.
      ui->batch_dynpro( i_program = 'SAPMF05L' i_dynpro = '0102' i_key = '/00' ).
      ui->batch_field( i_field = 'RF05L-BUKRS' i_value = <fs_bseg>-bukrs ).
      ui->batch_field( i_field = 'RF05L-BELNR' i_value = <fs_bseg>-belnr ).
      ui->batch_field( i_field = 'RF05L-GJAHR' i_value = <fs_bseg>-gjahr ).
      ui->batch_field( i_field = 'RF05L-BUZEI' i_value = <fs_bseg>-buzei ).

      ui->batch_dynpro( i_program = 'SAPMF05L' i_dynpro = '0301' i_key = 'AE' ).
      ui->batch_field( i_field = 'BSEG-ZTERM' i_value = <fs_bseg>-zterm ).

      ui->batch_call( i_tcode = 'FB09' ).
      READ TABLE ui->gt_batchret WITH KEY number = '300' TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.

        "05.11 Save: Si tiene error de actualizacion
        IF cs_felog-zzt_status_cdr = 'A'.
          cs_felog-zzt_status_cdr = '1'.
          MODIFY zostb_felog FROM cs_felog.
        ENDIF.
      ELSE.

        "05.12 Save: Error de actualizacion documento FI
        READ TABLE ui->gt_batchret WITH KEY number = '303' TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          READ TABLE ui->gt_batchret INTO ls_return INDEX 1.
          cs_felog-zzt_errorext = ls_return-message.
          cs_felog-zzt_status_cdr = 'A'.

          MODIFY zostb_felog FROM cs_felog.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

*----------------------------------------------------------------------*
* Alv - Status
*----------------------------------------------------------------------*
FORM r100_st CHANGING ct_excl TYPE slis_t_extab.
  amp->r100_st( CHANGING ct_excl = ct_excl ).
ENDFORM.

*----------------------------------------------------------------------*
* Alv - Uc
*----------------------------------------------------------------------*
FORM r100_uc USING i_ucomm TYPE sy-ucomm
                   cs_sel  TYPE slis_selfield.
  amp->r100_uc( EXPORTING i_ucomm = i_ucomm CHANGING cs_sel = cs_sel ).
ENDFORM.                    "r100_uc
