*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_RESUMEN_COMP_IMP_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  GET_CONST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_const .

  SELECT * INTO TABLE gt_const
    FROM zostb_const_fe
    WHERE aplicacion EQ gc_aplic
      AND programa   EQ gc_prog.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  TYPES: BEGIN OF ty_marc,
           matnr TYPE marc-matnr,
           werks TYPE marc-werks,
           stawn TYPE marc-stawn,
         END OF ty_marc.

  TYPES: BEGIN OF ty_konv,
           knumv TYPE konv-knumv,
           kposn TYPE konv-kposn,
           kschl TYPE konv-kschl,
           kwert TYPE konv-kwert,
           kbetr TYPE konv-kbetr,
           kstat TYPE konv-kstat,
           kinak TYPE konv-kinak,
           koaid TYPE konv-koaid,
           kmein TYPE konv-kmein,
           kumza TYPE konv-kumza,
           kumne TYPE konv-kumne,
           kpein TYPE kpein,
           kherk TYPE kherk,
         END OF ty_konv.

  TYPES: BEGIN OF ty_vbap,
           vbeln TYPE vbap-vbeln,
           vgbel TYPE vbap-vgbel,
           vgtyp TYPE vbap-vgtyp,
         END OF ty_vbap.

  TYPES: BEGIN OF ty_vbak,
           vbeln TYPE vbak-vbeln,
           xblnr TYPE vbak-xblnr,
         END OF ty_vbak.

  TYPES: BEGIN OF ty_result,
           line TYPE char20,
         END OF ty_result.

  DATA: lt_vbrk TYPE STANDARD TABLE OF vbrk.
  DATA: lt_vbrk_ref TYPE HASHED TABLE OF vbrk WITH UNIQUE KEY vbeln.
  DATA: lt_vbrp TYPE STANDARD TABLE OF ty_vbrp.
  DATA: lt_kna1 TYPE STANDARD TABLE OF kna1.
  DATA: lt_marc TYPE SORTED TABLE OF ty_marc WITH NON-UNIQUE KEY matnr werks.
  DATA: lt_konv TYPE SORTED TABLE OF ty_konv WITH NON-UNIQUE KEY knumv kposn koaid.
  DATA: lt_vbap TYPE STANDARD TABLE OF ty_vbap.
  DATA: lt_vbap1 TYPE STANDARD TABLE OF ty_vbap.
  DATA: lt_vbak TYPE STANDARD TABLE OF ty_vbak.
  DATA: lt_constakonv TYPE STANDARD TABLE OF zostb_constakonv.
  DATA: lt_lotno TYPE STANDARD TABLE OF zostb_lotno.
  DATA: lt_fecab TYPE STANDARD TABLE OF zostb_fecab.
  DATA: lt_result TYPE STANDARD TABLE OF ty_result.

  DATA: ls_reporte TYPE ty_reporte.
  DATA: ls_result  TYPE ty_result.
  DATA: ls_vbrk_ref TYPE vbrk.
  DATA: ls_vbrp    TYPE ty_vbrp.

  DATA: lr_vbtyp TYPE RANGE OF vbrk-vbtyp.
  DATA: ls_vbtyp LIKE LINE OF lr_vbtyp.

  DATA: lw_kwert   TYPE konv-kwert.
  DATA: lw_tabix   TYPE sy-tabix.
  DATA: lw_string  TYPE string.

  DATA: lr_kschl TYPE RANGE OF konv-kschl.
  DATA: ls_kschl LIKE LINE OF lr_kschl.

  FIELD-SYMBOLS: <fs_vbrk> LIKE LINE OF lt_vbrk.
  FIELD-SYMBOLS: <fs_vbrp> LIKE LINE OF lt_vbrp.
  FIELD-SYMBOLS: <fs_kna1> LIKE LINE OF lt_kna1.
  FIELD-SYMBOLS: <fs_marc> LIKE LINE OF lt_marc.
  FIELD-SYMBOLS: <fs_konv> LIKE LINE OF lt_konv.
  FIELD-SYMBOLS: <fs_vbap> LIKE LINE OF lt_vbap.
  FIELD-SYMBOLS: <fs_vbak> LIKE LINE OF lt_vbak.
  FIELD-SYMBOLS: <fs_constakonv> LIKE LINE OF lt_constakonv.
  FIELD-SYMBOLS: <fs_lotno> LIKE LINE OF lt_lotno.
  FIELD-SYMBOLS: <fs_fecab> LIKE LINE OF lt_fecab.

  CHECK gw_error = abap_off.                                                  "I-WMR-130319-3000010823

* Obtener Lotno
  SELECT mandt lotno
    INTO TABLE lt_lotno
    FROM zostb_lotno.

* Rango Tipo de documento comercial
  ls_vbtyp-sign = 'I'.
  ls_vbtyp-option = 'EQ'.
  ls_vbtyp-low = 'M'.
  APPEND ls_vbtyp TO lr_vbtyp.

  ls_vbtyp-sign = 'I'.
  ls_vbtyp-option = 'EQ'.
  ls_vbtyp-low = 'O'.
  APPEND ls_vbtyp TO lr_vbtyp.

  ls_vbtyp-sign = 'I'.
  ls_vbtyp-option = 'EQ'.
  ls_vbtyp-low = 'P'.
  APPEND ls_vbtyp TO lr_vbtyp.

* Obtener Facturas (Datos de cabecera)
  SELECT *
    FROM vbrk
    INTO CORRESPONDING FIELDS OF TABLE lt_vbrk
    WHERE fkdat EQ p_fkdat
      AND bukrs EQ p_bukrs
      AND vbtyp IN lr_vbtyp
      AND fksto NE 'X'
      AND rfbsk EQ 'C'.

  CLEAR lw_tabix.
  LOOP AT lt_vbrk ASSIGNING <fs_vbrk>.
    lw_tabix = sy-tabix.
    READ TABLE lt_lotno ASSIGNING <fs_lotno>
      WITH KEY lotno = <fs_vbrk>-xblnr+4(4).
    IF sy-subrc EQ 0.
      DELETE lt_vbrk INDEX lw_tabix.
      CONTINUE.
    ENDIF.
    " Verificando referencia con Formato NN-NNNNN-NNNNNNN
    CLEAR lt_result.
    SPLIT <fs_vbrk>-xblnr AT '-' INTO TABLE lt_result.
    IF lines( lt_result ) EQ 3.
      " Tipo
      READ TABLE lt_result INTO ls_result INDEX 1.
      IF sy-subrc EQ 0.
        lw_string = ls_result-line.
        IF ( strlen( lw_string ) EQ 2 AND lw_string CO '0123456789' ).
        ELSE.
          DELETE lt_vbrk INDEX lw_tabix.
          CONTINUE.
        ENDIF.
      ENDIF.
      " Serie
      READ TABLE lt_result INTO ls_result INDEX 2.
      IF sy-subrc EQ 0.
        lw_string = ls_result-line.
        IF ( strlen( lw_string ) EQ 5 AND lw_string CO '0123456789' ).
        ELSE.
          DELETE lt_vbrk INDEX lw_tabix.
          CONTINUE.
        ENDIF.
      ENDIF.
      " Correlativo
      READ TABLE lt_result INTO ls_result INDEX 3.
      IF sy-subrc EQ 0.
        lw_string = ls_result-line.
        IF ( strlen( lw_string ) EQ 7 AND lw_string CO '0123456789' ).
        ELSE.
          DELETE lt_vbrk INDEX lw_tabix.
          CONTINUE.
        ENDIF.
      ENDIF.
    ELSE.
      DELETE lt_vbrk INDEX lw_tabix.
      CONTINUE.
    ENDIF.
  ENDLOOP.

  IF lt_vbrk[] IS NOT INITIAL.
    SELECT *
      FROM zostb_fecab
      INTO CORRESPONDING FIELDS OF TABLE lt_fecab
      FOR ALL ENTRIES IN lt_vbrk
      WHERE zzt_nrodocsap EQ lt_vbrk-vbeln ##SELECT_FAE_WITH_LOB[ZZT_LEYENDAS].
  ENDIF.

  CLEAR lw_tabix.
  LOOP AT lt_vbrk ASSIGNING <fs_vbrk>.
    lw_tabix = sy-tabix.
    READ TABLE lt_fecab ASSIGNING <fs_fecab>
      WITH KEY zzt_nrodocsap = <fs_vbrk>-vbeln
               zzt_numeracion = <fs_vbrk>-xblnr+4(12).
    IF sy-subrc EQ 0.
      DELETE lt_vbrk INDEX lw_tabix.
      CONTINUE.
    ENDIF.
  ENDLOOP.

  IF lines( lt_vbrk ) = 0.
    MESSAGE text-007 TYPE 'S' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  IF lt_vbrk[] IS NOT INITIAL.
*   Obtener Facturas (Datos de posición)
    SELECT b~knumv a~vbeln a~posnr a~vgbel a~vrkme a~fkimg a~arktx a~netwr a~mwsbp a~vgtyp
           a~autyp a~taxm1 a~aubel a~aupos a~pstyv a~matnr a~umvkz a~kzwi1 a~werks a~meins
           a~vkbur a~vgpos a~augru_auft
           b~vkorg b~vtweg b~fkdat
           a~kvgr1
      INTO CORRESPONDING FIELDS OF TABLE lt_vbrp
      FROM vbrp AS a INNER JOIN vbrk AS b ON b~vbeln = a~vbeln
      FOR ALL ENTRIES IN lt_vbrk
      WHERE a~vbeln EQ lt_vbrk-vbeln ##TOO_MANY_ITAB_FIELDS.

*   Obtener Maestro de clientes
    SELECT *
      INTO CORRESPONDING FIELDS OF TABLE lt_kna1
      FROM kna1
      FOR ALL ENTRIES IN lt_vbrk
      WHERE kunnr EQ lt_vbrk-kunag.
  ENDIF.

  IF lt_vbrp[] IS NOT INITIAL.
*   Obtener Datos MARC
    SELECT matnr werks stawn
      INTO TABLE lt_marc
      FROM marc
      FOR ALL ENTRIES IN lt_vbrp
      WHERE matnr EQ lt_vbrp-matnr
        AND werks EQ lt_vbrp-werks.

*   Condiciones (Datos operación)
    SELECT knumv kposn kschl kwert kbetr kstat kinak koaid kmein kumza kumne
      INTO CORRESPONDING FIELDS OF TABLE lt_konv
      FROM konv
      FOR ALL ENTRIES IN lt_vbrp
      WHERE knumv EQ lt_vbrp-knumv
        AND kposn EQ lt_vbrp-posnr ##TOO_MANY_ITAB_FIELDS.

*   Obtener Datos VBAP
    SELECT vbeln vgbel vgtyp
      INTO TABLE lt_vbap
      FROM vbap
      FOR ALL ENTRIES IN lt_vbrp
      WHERE vbeln EQ lt_vbrp-aubel.

  ENDIF.

  IF lt_vbap[] IS NOT INITIAL.

*   Obtener Datos VBAK
    SELECT vbeln xblnr
      INTO TABLE lt_vbak
      FROM vbak
      FOR ALL ENTRIES IN lt_vbap
      WHERE vbeln EQ lt_vbap-vbeln.

    " Referencia a Factura
    lt_vbap1[] = lt_vbap[].
    DELETE lt_vbap1 WHERE vgtyp NE 'M'.
    SORT lt_vbap1 BY vgbel ASCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_vbap1 COMPARING vgbel.

    IF lt_vbap1[] IS NOT INITIAL.
      SELECT vbeln xblnr
        INTO CORRESPONDING FIELDS OF TABLE lt_vbrk_ref
        FROM vbrk
        FOR ALL ENTRIES IN lt_vbap1
        WHERE vbeln EQ lt_vbap1-vgbel ##TOO_MANY_ITAB_FIELDS.
    ENDIF.

  ENDIF.

* Extractor datos Facturas - SUNAT Tabla de constantes KONV
  SELECT *
    INTO TABLE lt_constakonv
    FROM zostb_constakonv.

* Determinar afectación del IGV
  PERFORM determinar_afectacion_igv CHANGING lt_vbrp.

*** Detalle Resumen
  LOOP AT lt_vbrk ASSIGNING <fs_vbrk>.

    CLEAR ls_reporte.

*   Factura
    ls_reporte-vbeln = <fs_vbrk>-vbeln.

*   Motivo
    ls_reporte-motiv = ''.

*   Fecha Emisión
    ls_reporte-fecha_emisi = <fs_vbrk>-fkdat.

*   Tipo Comprobante
    ls_reporte-tipo_compr = <fs_vbrk>-xblnr+0(2).

*   Serie del comprobante
    ls_reporte-serie_compr = <fs_vbrk>-xblnr+4(4).

*   Número correlativo
    ls_reporte-numer_corre = <fs_vbrk>-xblnr+9(7).

*   Rango Ticket
    ls_reporte-rango_ticke = ''.

    READ TABLE lt_kna1 ASSIGNING <fs_kna1>
      WITH KEY kunnr = <fs_vbrk>-kunag.
    IF sy-subrc EQ 0.

*   Tipo Documento
      ls_reporte-tipo_docum = <fs_kna1>-stcdt.

*   Número de documento
      ls_reporte-numer_docum = <fs_kna1>-stcd1.

*   Razón Social o Ape.usuario
      CONCATENATE <fs_kna1>-name1 <fs_kna1>-name2 <fs_kna1>-name3 <fs_kna1>-name4
      INTO ls_reporte-razon_socia SEPARATED BY space.

    ENDIF.

    LOOP AT lt_vbrp ASSIGNING <fs_vbrp> WHERE vbeln EQ <fs_vbrk>-vbeln.

      IF <fs_vbrp>-afect_igv = gc_afecto_igv.

*       Total Operaciones Gravadas
        IF <fs_vbrk>-waerk NE gc_waers_pen.
          lw_kwert = <fs_vbrp>-netwr * <fs_vbrk>-kurrf.
        ELSE.
          lw_kwert = <fs_vbrp>-netwr.
        ENDIF.
        ADD lw_kwert TO ls_reporte-total_opera_grava.

*       Total IGV
        REFRESH lr_kschl.
        LOOP AT lt_constakonv ASSIGNING <fs_constakonv>
            WHERE zz_opcion01 = '8' AND zz_opcion02 = ''.
          ls_kschl-low = <fs_constakonv>-kschl.
          ls_kschl-sign = 'I'.
          ls_kschl-option = 'EQ'.
          APPEND ls_kschl TO lr_kschl.
        ENDLOOP.
        IF lr_kschl[] IS NOT INITIAL.
          LOOP AT lt_konv ASSIGNING <fs_konv> WHERE knumv EQ <fs_vbrk>-knumv
                                                AND kposn EQ <fs_vbrp>-posnr
                                                AND kschl IN lr_kschl
                                                AND kstat EQ space
                                                AND kinak EQ space.
            IF <fs_vbrk>-waerk NE gc_waers_pen.
              <fs_konv>-kwert = <fs_konv>-kwert * <fs_vbrk>-kurrf.
            ENDIF.
*           Impuesto General a las Ventas IGV
            ADD <fs_konv>-kwert TO ls_reporte-igv.
          ENDLOOP.
        ENDIF.

      ELSEIF ( <fs_vbrp>-afect_igv EQ gc_inafec_igv OR <fs_vbrp>-afect_igv EQ gc_exoner_igv ).

        READ TABLE lt_marc ASSIGNING <fs_marc> WITH KEY matnr = <fs_vbrp>-matnr
                                                        werks = <fs_vbrp>-werks.
        IF sy-subrc = 0.
          IF <fs_vbrk>-waerk NE gc_waers_pen.
            <fs_vbrp>-netwr = <fs_vbrp>-netwr * <fs_vbrk>-kurrf.
          ENDIF.

          CASE <fs_vbrp>-afect_igv.
            WHEN gc_exoner_igv.
*   Total Operaciones Exoneradas
              ADD <fs_vbrp>-netwr TO ls_reporte-total_opera_exone.
            WHEN gc_inafec_igv.
*   Total Operaciones Inafectas
              ADD <fs_vbrp>-netwr TO ls_reporte-total_opera_inafe.
          ENDCASE.
        ENDIF.

      ENDIF.

*     Sumatoria ISC
      REFRESH lr_kschl.
      LOOP AT lt_constakonv ASSIGNING <fs_constakonv> WHERE zz_opcion01 = '1' AND zz_opcion02 = '3'.
        ls_kschl-low = <fs_constakonv>-kschl.
        ls_kschl-sign = 'I'.
        ls_kschl-option = 'EQ'.
        APPEND ls_kschl TO lr_kschl.
      ENDLOOP.
      IF lr_kschl[] IS NOT INITIAL.
        LOOP AT lt_konv ASSIGNING <fs_konv> WHERE knumv EQ <fs_vbrk>-knumv
                                              AND kstat EQ space
                                              AND kinak EQ space.
          IF <fs_konv>-kschl IN lr_kschl[].
            IF <fs_vbrk>-waerk NE gc_waers_pen.
              <fs_konv>-kwert = <fs_konv>-kwert * <fs_vbrk>-kurrf.
            ENDIF.
*           Impuesto Selectivo Consumo ISC
            ADD <fs_konv>-kwert TO ls_reporte-isc.
          ENDIF.
        ENDLOOP.
      ENDIF.

*     Otros Tributos / Otros Cargos
      ls_reporte-otros_tribu_cargo = '' ##LITERAL.

*     Importe total
      ls_reporte-impte_total = ( ls_reporte-total_opera_grava + ls_reporte-total_opera_exone +
                                 ls_reporte-total_opera_inafe + ls_reporte-isc + ls_reporte-igv +
                                 ls_reporte-otros_tribu_cargo ).


      IF <fs_vbrk>-xblnr+0(2) EQ '07' OR <fs_vbrk>-xblnr+0(2) EQ '08'.

        READ TABLE lt_vbrp INTO ls_vbrp WITH KEY vbeln = <fs_vbrk>-vbeln.
        IF sy-subrc EQ 0.
          READ TABLE lt_vbap ASSIGNING <fs_vbap> WITH KEY vbeln = ls_vbrp-aubel.
          IF sy-subrc EQ 0.
            IF <fs_vbap>-vgbel IS INITIAL.
              READ TABLE lt_vbak ASSIGNING <fs_vbak> WITH KEY vbeln = <fs_vbap>-vbeln.
              IF sy-subrc EQ 0 AND <fs_vbak>-xblnr IS NOT INITIAL.
***               Tipo Comprobante Modifica
**                ls_reporte-tipo_compr_modif = <fs_vbak>-xblnr+0(2).
**
***               Serie del comprobante Modifica
**                ls_reporte-serie_compr_modif = <fs_vbak>-xblnr+4(4).
**
***               Número del comprobante Modifica
**                ls_reporte-numer_compr_modif = <fs_vbak>-xblnr+9(7).

                SPLIT <fs_vbak>-xblnr AT '-'
                  INTO ls_reporte-tipo_compr_modif    " Tipo Comprobante que se modifica
                       ls_reporte-serie_compr_modif   " Serie del comprobante que se modifica
                       ls_reporte-numer_compr_modif.  " Correlativo del comprobante que se modifica
                IF ls_reporte-serie_compr_modif IS NOT INITIAL.
                  ls_reporte-serie_compr_modif = ls_reporte-serie_compr_modif+1.
                ENDIF.
              ENDIF.

            ELSE. "Si <fs_vbap>-vgbel tiene dato

**              IF <fs_vbrk>-vbeln EQ <fs_vbap>-vgbel.
***               Tipo Comprobante Modifica
**                ls_reporte-tipo_compr_modif = <fs_vbrk>-xblnr+0(2).
**
***               Serie del comprobante Modifica
**                ls_reporte-serie_compr_modif = <fs_vbrk>-xblnr+4(4).
**
***               Número del comprobante Modifica
**                ls_reporte-numer_compr_modif = <fs_vbrk>-xblnr+9(7).
**              ENDIF.

              READ TABLE lt_vbrk_ref INTO ls_vbrk_ref
                   WITH TABLE KEY vbeln = <fs_vbap>-vgbel.
              IF sy-subrc EQ 0 AND ls_vbrk_ref-xblnr IS NOT INITIAL.
                SPLIT ls_vbrk_ref-xblnr AT '-'
                  INTO ls_reporte-tipo_compr_modif    " Tipo Comprobante que se modifica
                       ls_reporte-serie_compr_modif   " Serie del comprobante que se modifica
                       ls_reporte-numer_compr_modif.  " Correlativo del comprobante que se modifica
                IF ls_reporte-serie_compr_modif IS NOT INITIAL.
                  ls_reporte-serie_compr_modif = ls_reporte-serie_compr_modif+1.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

      ENDIF.

      " Moneda
      ls_reporte-waerk = gc_waers_pen.

      COLLECT ls_reporte INTO gt_reporte.

    ENDLOOP.

  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  ALV_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_display .

  DATA: ls_variant TYPE disvariant.

  IF go_container IS INITIAL.

* Crear el objeto contenedor
    CREATE OBJECT go_container
      EXPORTING
        container_name = gc_container.

* Para que aparezca la cabecera
    CREATE OBJECT go_dyndoc_top
      EXPORTING
        style = gc_style.

* Dividir el contenedor en 2 filas y 1 columna
    CREATE OBJECT go_splitter
      EXPORTING
        parent  = go_container
        rows    = 2
        columns = 1.

* Asignar la primera fila al contenedor de cabecera
    CALL METHOD go_splitter->get_container
      EXPORTING
        row       = 1
        column    = 1
      RECEIVING
        container = go_parent_html.

* Asignar la segunda fila al contenedor del reporte
    CALL METHOD go_splitter->get_container
      EXPORTING
        row       = 2
        column    = 1
      RECEIVING
        container = go_parent_grid.

* Set height for go_parent_html
    CALL METHOD go_splitter->set_row_height
      EXPORTING
        id     = 1
        height = 15.

* Set height for go_parent_grid
    CALL METHOD go_splitter->set_row_height
      EXPORTING
        id     = 2
        height = 70.

* Indicar que el separador horizontal sea no visible (type = 1 y value = 1 para visible)
    CALL METHOD go_splitter->set_row_sash
      EXPORTING
        id    = 1
        type  = 0
        value = 0.

* Crear el objeto grid
    CREATE OBJECT go_grid
      EXPORTING
        i_parent = go_parent_grid.

* Crear el objeto manejador de eventos
    CREATE OBJECT go_handler.
* Asignar los eventos del grid al objeto handler (event)
    SET HANDLER go_handler->top_of_page          FOR go_grid.
    SET HANDLER go_handler->handle_user_command  FOR go_grid.
    SET HANDLER go_handler->handle_toolbar       FOR go_grid.
    SET HANDLER go_handler->handle_user_command  FOR go_grid.
    SET HANDLER go_handler->double_click         FOR go_grid.
    SET HANDLER go_handler->handle_hotspot_click FOR go_grid.
    SET HANDLER go_handler->handle_user_onf4     FOR go_grid.

* Obtener variante del reporte
    CALL METHOD go_grid->get_variant
      IMPORTING
        es_variant = ls_variant.

    ls_variant-report = sy-repid.

* Ayuda de búsqueda Campo Motivo
    PERFORM register_f4_fields.  "set cells with search help

* LAYOUT
    PERFORM init_layout.

* FIELDCAT
    PERFORM build_fieldcatalog.

* EXCLUDE BUTTONS
    PERFORM exclude_buttons.

* Mostrar ALV
    CALL METHOD go_grid->set_table_for_first_display
      EXPORTING
        is_layout                     = gs_layout
        i_save                        = gc_save
        is_variant                    = ls_variant
        i_default                     = abap_true
        it_toolbar_excluding          = gt_exclude
      CHANGING
        it_outtab                     = gt_reporte
        it_fieldcatalog               = gt_fieldcat
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.

* Inicializar el documento
    CALL METHOD go_dyndoc_top->initialize_document
      EXPORTING
        background_color = cl_dd_area=>col_textarea.

* Lanzar el evento top of page
    CALL METHOD go_grid->list_processing_events
      EXPORTING
        i_event_name = gc_top_of_page
        i_dyndoc_id  = go_dyndoc_top.

  ELSE.
* Refrescar manteniendo la posición del cursor
    CALL METHOD go_grid->refresh_table_display( is_stable = gs_stable ).
  ENDIF.

  CALL METHOD go_grid->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_enter.

  CALL METHOD go_grid->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_modified.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INIT_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM init_layout .
  gs_layout-zebra      = 'X'.
  gs_layout-sel_mode   = 'A'.
  gs_layout-cwidth_opt = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_fieldcatalog .

  DATA: ls_fieldcat TYPE lvc_s_fcat.
  DATA: lw_col_pos  TYPE lvc_colpos.

  CLEAR ls_fieldcat.
  ADD 1 TO lw_col_pos.
  ls_fieldcat-col_pos       = lw_col_pos.
  ls_fieldcat-edit          = 'X'.
  ls_fieldcat-f4availabl    = 'X'.
  ls_fieldcat-fieldname     = 'MOTIV'.
  ls_fieldcat-tabname       = 'GT_REPORTE'.
  ls_fieldcat-scrtext_l     = text-008.
  ls_fieldcat-scrtext_m     = text-008.
  ls_fieldcat-scrtext_s     = text-008.
  ls_fieldcat-reptext       = text-008.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ADD 1 TO lw_col_pos.
  ls_fieldcat-col_pos       = lw_col_pos.
  ls_fieldcat-fieldname     = 'FECHA_EMISI'.
  ls_fieldcat-tabname       = 'GT_REPORTE'.
  ls_fieldcat-scrtext_l     = text-009.
  ls_fieldcat-scrtext_m     = text-009.
  ls_fieldcat-scrtext_s     = text-009.
  ls_fieldcat-reptext       = text-009.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ADD 1 TO lw_col_pos.
  ls_fieldcat-col_pos       = lw_col_pos.
  ls_fieldcat-fieldname     = 'VBELN'.
  ls_fieldcat-tabname       = 'GT_REPORTE'.
  ls_fieldcat-ref_field     = 'VBELN'.
  ls_fieldcat-ref_table     = 'VBRK'.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ADD 1 TO lw_col_pos.
  ls_fieldcat-col_pos       = lw_col_pos.
  ls_fieldcat-fieldname     = 'TIPO_COMPR'.
  ls_fieldcat-tabname       = 'GT_REPORTE'.
  ls_fieldcat-scrtext_l     = text-010.
  ls_fieldcat-scrtext_m     = text-010.
  ls_fieldcat-scrtext_s     = text-010.
  ls_fieldcat-reptext       = text-010.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ADD 1 TO lw_col_pos.
  ls_fieldcat-col_pos       = lw_col_pos.
  ls_fieldcat-fieldname     = 'SERIE_COMPR'.
  ls_fieldcat-tabname       = 'GT_REPORTE'.
  ls_fieldcat-scrtext_l     = text-011.
  ls_fieldcat-scrtext_m     = text-011.
  ls_fieldcat-scrtext_s     = text-011.
  ls_fieldcat-reptext       = text-011.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ADD 1 TO lw_col_pos.
  ls_fieldcat-col_pos       = lw_col_pos.
  ls_fieldcat-fieldname     = 'NUMER_CORRE'.
  ls_fieldcat-tabname       = 'GT_REPORTE'.
  ls_fieldcat-scrtext_l     = text-012.
  ls_fieldcat-scrtext_m     = text-012.
  ls_fieldcat-scrtext_s     = text-012.
  ls_fieldcat-reptext       = text-012.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ADD 1 TO lw_col_pos.
  ls_fieldcat-col_pos       = lw_col_pos.
  ls_fieldcat-fieldname     = 'RANGO_TICKE'.
  ls_fieldcat-tabname       = 'GT_REPORTE'.
  ls_fieldcat-scrtext_l     = text-013.
  ls_fieldcat-scrtext_m     = text-013.
  ls_fieldcat-scrtext_s     = text-013.
  ls_fieldcat-reptext       = text-013.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ADD 1 TO lw_col_pos.
  ls_fieldcat-col_pos       = lw_col_pos.
  ls_fieldcat-fieldname     = 'TIPO_DOCUM'.
  ls_fieldcat-tabname       = 'GT_REPORTE'.
  ls_fieldcat-scrtext_l     = text-014.
  ls_fieldcat-scrtext_m     = text-014.
  ls_fieldcat-scrtext_s     = text-014.
  ls_fieldcat-reptext       = text-014.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ADD 1 TO lw_col_pos.
  ls_fieldcat-col_pos       = lw_col_pos.
  ls_fieldcat-fieldname     = 'NUMER_DOCUM'.
  ls_fieldcat-tabname       = 'GT_REPORTE'.
  ls_fieldcat-scrtext_l     = text-015.
  ls_fieldcat-scrtext_m     = text-015.
  ls_fieldcat-scrtext_s     = text-015.
  ls_fieldcat-reptext       = text-015.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ADD 1 TO lw_col_pos.
  ls_fieldcat-col_pos       = lw_col_pos.
  ls_fieldcat-fieldname     = 'RAZON_SOCIA'.
  ls_fieldcat-tabname       = 'GT_REPORTE'.
  ls_fieldcat-scrtext_l     = text-016.
  ls_fieldcat-scrtext_m     = text-016.
  ls_fieldcat-scrtext_s     = text-016.
  ls_fieldcat-reptext       = text-016.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ADD 1 TO lw_col_pos.
  ls_fieldcat-col_pos       = lw_col_pos.
  ls_fieldcat-fieldname     = 'TOTAL_OPERA_GRAVA'.
  ls_fieldcat-tabname       = 'GT_REPORTE'.
  ls_fieldcat-scrtext_l     = text-017.
  ls_fieldcat-scrtext_m     = text-017.
  ls_fieldcat-scrtext_s     = text-017.
  ls_fieldcat-reptext       = text-017.
  ls_fieldcat-cfieldname    = 'WAERK'.
  ls_fieldcat-just          = 'R'.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ADD 1 TO lw_col_pos.
  ls_fieldcat-col_pos       = lw_col_pos.
  ls_fieldcat-fieldname     = 'TOTAL_OPERA_EXONE'.
  ls_fieldcat-tabname       = 'GT_REPORTE'.
  ls_fieldcat-scrtext_l     = text-018.
  ls_fieldcat-scrtext_m     = text-018.
  ls_fieldcat-scrtext_s     = text-018.
  ls_fieldcat-reptext       = text-018.
  ls_fieldcat-cfieldname    = 'WAERK'.
  ls_fieldcat-just          = 'R'.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ADD 1 TO lw_col_pos.
  ls_fieldcat-col_pos       = lw_col_pos.
  ls_fieldcat-fieldname     = 'TOTAL_OPERA_INAFE'.
  ls_fieldcat-tabname       = 'GT_REPORTE'.
  ls_fieldcat-scrtext_l     = text-019.
  ls_fieldcat-scrtext_m     = text-019.
  ls_fieldcat-scrtext_s     = text-019.
  ls_fieldcat-reptext       = text-019.
  ls_fieldcat-cfieldname    = 'WAERK'.
  ls_fieldcat-just          = 'R'.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ADD 1 TO lw_col_pos.
  ls_fieldcat-col_pos       = lw_col_pos.
  ls_fieldcat-fieldname     = 'ISC'.
  ls_fieldcat-tabname       = 'GT_REPORTE'.
  ls_fieldcat-scrtext_l     = text-020.
  ls_fieldcat-scrtext_m     = text-020.
  ls_fieldcat-scrtext_s     = text-020.
  ls_fieldcat-reptext       = text-020.
  ls_fieldcat-cfieldname    = 'WAERK'.
  ls_fieldcat-just          = 'R'.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ADD 1 TO lw_col_pos.
  ls_fieldcat-col_pos       = lw_col_pos.
  ls_fieldcat-fieldname     = 'IGV'.
  ls_fieldcat-tabname       = 'GT_REPORTE'.
  ls_fieldcat-scrtext_l     = text-021.
  ls_fieldcat-scrtext_m     = text-021.
  ls_fieldcat-scrtext_s     = text-021.
  ls_fieldcat-reptext       = text-021.
  ls_fieldcat-cfieldname    = 'WAERK'.
  ls_fieldcat-just          = 'R'.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ADD 1 TO lw_col_pos.
  ls_fieldcat-col_pos       = lw_col_pos.
  ls_fieldcat-fieldname     = 'OTROS_TRIBU_CARGO'.
  ls_fieldcat-tabname       = 'GT_REPORTE'.
  ls_fieldcat-scrtext_l     = text-022.
  ls_fieldcat-scrtext_m     = text-022.
  ls_fieldcat-scrtext_s     = text-022.
  ls_fieldcat-reptext       = text-022.
  ls_fieldcat-cfieldname    = 'WAERK'.
  ls_fieldcat-just          = 'R'.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ADD 1 TO lw_col_pos.
  ls_fieldcat-col_pos       = lw_col_pos.
  ls_fieldcat-fieldname     = 'IMPTE_TOTAL'.
  ls_fieldcat-tabname       = 'GT_REPORTE'.
  ls_fieldcat-scrtext_l     = text-023.
  ls_fieldcat-scrtext_m     = text-023.
  ls_fieldcat-scrtext_s     = text-023.
  ls_fieldcat-reptext       = text-023.
  ls_fieldcat-cfieldname    = 'WAERK'.
  ls_fieldcat-just          = 'R'.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ADD 1 TO lw_col_pos.
  ls_fieldcat-col_pos       = lw_col_pos.
  ls_fieldcat-fieldname     = 'TIPO_COMPR_MODIF'.
  ls_fieldcat-tabname       = 'GT_REPORTE'.
  ls_fieldcat-scrtext_l     = text-024.
  ls_fieldcat-scrtext_m     = text-024.
  ls_fieldcat-scrtext_s     = text-024.
  ls_fieldcat-reptext       = text-024.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ADD 1 TO lw_col_pos.
  ls_fieldcat-col_pos       = lw_col_pos.
  ls_fieldcat-fieldname     = 'SERIE_COMPR_MODIF'.
  ls_fieldcat-tabname       = 'GT_REPORTE'.
  ls_fieldcat-scrtext_l     = text-025.
  ls_fieldcat-scrtext_m     = text-025.
  ls_fieldcat-scrtext_s     = text-025.
  ls_fieldcat-reptext       = text-025.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ADD 1 TO lw_col_pos.
  ls_fieldcat-col_pos       = lw_col_pos.
  ls_fieldcat-fieldname     = 'NUMER_COMPR_MODIF'.
  ls_fieldcat-tabname       = 'GT_REPORTE'.
  ls_fieldcat-scrtext_l     = text-026.
  ls_fieldcat-scrtext_m     = text-026.
  ls_fieldcat-scrtext_s     = text-026.
  ls_fieldcat-reptext       = text-026.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ADD 1 TO lw_col_pos.
  ls_fieldcat-col_pos       = lw_col_pos.
  ls_fieldcat-fieldname     = 'WAERK'.
  ls_fieldcat-tabname       = 'GT_REPORTE'.
  ls_fieldcat-ref_field     = 'WAERK'.
  ls_fieldcat-ref_table     = 'VBRK'.
  APPEND ls_fieldcat TO gt_fieldcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  EXCLUDE_BUTTONS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM exclude_buttons .
  DATA: ls_exclude TYPE ui_func.

  REFRESH: gt_exclude.

  CLEAR ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_insert_row.
  APPEND ls_exclude TO gt_exclude.

  CLEAR ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_undo.
  APPEND ls_exclude TO gt_exclude.

  CLEAR ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_check.
  APPEND ls_exclude TO gt_exclude.

  CLEAR ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_append_row.
  APPEND ls_exclude TO gt_exclude.

  CLEAR ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_copy.
  APPEND ls_exclude TO gt_exclude.

  CLEAR ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_copy_row.
  APPEND ls_exclude TO gt_exclude.

  CLEAR ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_cut.
  APPEND ls_exclude TO gt_exclude.

  CLEAR ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_delete_row.
  APPEND ls_exclude TO gt_exclude.

  CLEAR ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_move_row.
  APPEND ls_exclude TO gt_exclude.

  CLEAR ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_paste.
  APPEND ls_exclude TO gt_exclude.

  CLEAR ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_paste_new_row.
  APPEND ls_exclude TO gt_exclude.

  CLEAR ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_print.
  APPEND ls_exclude TO gt_exclude.

  CLEAR ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_graph.
  APPEND ls_exclude TO gt_exclude.

  CLEAR ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_help.
  APPEND ls_exclude TO gt_exclude.

  CLEAR ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_detail.
  APPEND ls_exclude TO gt_exclude.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DETERMINAR_AFECTACION_IGV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LT_VBRP  text
*----------------------------------------------------------------------*
FORM determinar_afectacion_igv  CHANGING po_vbrp TYPE tt_vbrp.

  DATA: ls_matexon TYPE zostb_matexon.
  DATA: lr_taxm1 TYPE RANGE OF vbrp-taxm1,
        ls_taxm1 LIKE LINE OF lr_taxm1.
  DATA: lw_index   TYPE numc10.

  FIELD-SYMBOLS: <fs_const> LIKE LINE OF gt_const.
  FIELD-SYMBOLS: <fs_vbrp> LIKE LINE OF po_vbrp.

* Indicador Fiscal de Material Exonerados
  LOOP AT gt_const ASSIGNING <fs_const>.
    CASE <fs_const>-campo.
      WHEN 'TAXM1EX'.
        CLEAR ls_taxm1.
        ls_taxm1-sign   = <fs_const>-signo.
        ls_taxm1-option = <fs_const>-opcion.
        ls_taxm1-low    = <fs_const>-valor1.
        ls_taxm1-high   = <fs_const>-valor2.
        APPEND ls_taxm1 TO lr_taxm1.
    ENDCASE.
  ENDLOOP.

  lw_index = 1.
  DO.
    READ TABLE po_vbrp ASSIGNING <fs_vbrp> INDEX lw_index.
    IF sy-subrc NE 0. EXIT. ENDIF.
    ADD 1 TO lw_index.

    CLEAR ls_matexon.
    IF <fs_vbrp>-mwsbp EQ 0.
      SELECT SINGLE mandt vkorg vtweg matnr datab datbi
        INTO ls_matexon
        FROM zostb_matexon
        WHERE vkorg EQ <fs_vbrp>-vkorg
          AND vtweg EQ <fs_vbrp>-vtweg
          AND matnr EQ <fs_vbrp>-matnr
          AND datab LE <fs_vbrp>-fkdat
          AND datbi GE <fs_vbrp>-fkdat ##WARN_OK.
      IF sy-subrc NE 0.
        SELECT SINGLE mandt vkorg vtweg matnr datab datbi
          INTO ls_matexon
          FROM zostb_matexon
          WHERE vtweg EQ <fs_vbrp>-vtweg
            AND matnr EQ <fs_vbrp>-matnr
            AND datab LE <fs_vbrp>-fkdat
            AND datbi GE <fs_vbrp>-fkdat  ##WARN_OK.
        IF sy-subrc NE 0.
          SELECT SINGLE mandt vkorg vtweg matnr datab datbi
            INTO ls_matexon
            FROM zostb_matexon
            WHERE matnr EQ <fs_vbrp>-matnr
              AND datab LE <fs_vbrp>-fkdat
              AND datbi GE <fs_vbrp>-fkdat  ##WARN_OK.
        ENDIF.
      ENDIF.

      IF ls_matexon IS NOT INITIAL
      OR ( <fs_vbrp>-taxm1 IN lr_taxm1 AND lr_taxm1[] IS NOT INITIAL ).
        <fs_vbrp>-afect_igv = gc_exoner_igv.  " Exonerado del IGV
      ELSE.
        <fs_vbrp>-afect_igv = gc_inafec_igv.  " Inafecto al IGV
      ENDIF.

    ELSE.
      <fs_vbrp>-afect_igv = gc_afecto_igv.  " Afecto al IGV
    ENDIF.
  ENDDO.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F4_RUTA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_PATH1  text
*----------------------------------------------------------------------*
FORM f4_ruta  USING    pi_path1  ##PERF_NO_TYPE.

  DATA : lw_window_title TYPE string.

  lw_window_title = text-027.

  CALL METHOD cl_gui_frontend_services=>directory_browse
    EXPORTING
      window_title         = lw_window_title
      initial_folder       = 'C:\'
    CHANGING
      selected_folder      = pi_path1
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      OTHERS               = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GENERAR_ARCHIVO_TXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM generar_archivo_txt .

  DATA: ls_archivo_txt TYPE ty_archivo_txt.
  DATA: lw_fecha_emisi TYPE char10.
  DATA: lw_value       TYPE string.
  DATA: lw_netwr       TYPE vbrk-netwr.
  DATA: lw_charimp     TYPE string.

  FIELD-SYMBOLS: <fs_reporte> LIKE LINE OF gt_reporte.

  CLEAR gt_archivo_txt.
  LOOP AT gt_reporte ASSIGNING <fs_reporte>.

    CLEAR ls_archivo_txt.

    " Motivo
    CLEAR lw_value.
    lw_value = <fs_reporte>-motiv.
    PERFORM agregar_campo USING 1
                       CHANGING lw_value
                                ls_archivo_txt.

    " Fecha de emisión
    CLEAR lw_value.
    CLEAR lw_fecha_emisi.
    WRITE <fs_reporte>-fecha_emisi TO lw_fecha_emisi USING EDIT MASK '__/__/____'.
    lw_value = lw_fecha_emisi.
    PERFORM agregar_campo USING 10
                       CHANGING lw_value
                                ls_archivo_txt.

    " Tipo del comprobante
    CLEAR lw_value.
    lw_value = <fs_reporte>-tipo_compr.
    PERFORM agregar_campo USING 2
                       CHANGING lw_value
                                ls_archivo_txt.

    " Serie del comprobante
    CLEAR lw_value.
    lw_value = <fs_reporte>-serie_compr.
    PERFORM agregar_campo USING 20
                       CHANGING lw_value
                                ls_archivo_txt.

    " Número correlativo
    CLEAR lw_value.
    lw_value = <fs_reporte>-numer_corre.
    PERFORM agregar_campo USING 20
                       CHANGING lw_value
                                ls_archivo_txt.

    " Rango ticket
    CLEAR lw_value.
    lw_value = <fs_reporte>-rango_ticke.
    PERFORM agregar_campo USING 20
                       CHANGING lw_value
                                ls_archivo_txt.

    " Tipo de documento del adquirente
    CLEAR lw_value.
    lw_value = <fs_reporte>-tipo_docum.
    PERFORM agregar_campo USING 1
                       CHANGING lw_value
                                ls_archivo_txt.

    " Número de documento del adquirente
    CLEAR lw_value.
    lw_value = <fs_reporte>-numer_docum.
    PERFORM agregar_campo USING 15
                       CHANGING lw_value
                                ls_archivo_txt.

    " Razón social o Apellidos y Nombres del adquirente
    CLEAR lw_value.
    lw_value = <fs_reporte>-razon_socia.
    PERFORM agregar_campo USING 60
                       CHANGING lw_value
                                ls_archivo_txt.

    " Total Operaciones Gravadas
    CLEAR lw_value.
    CLEAR: lw_charimp, lw_netwr.
    lw_netwr   = abs( <fs_reporte>-total_opera_grava ).
    lw_charimp = lw_netwr.
    IF <fs_reporte>-total_opera_grava LT 0.
      CONCATENATE '-' lw_charimp INTO lw_value.
    ELSE.
      lw_value = lw_charimp.
    ENDIF.
    PERFORM agregar_campo USING 18
                       CHANGING lw_value
                                ls_archivo_txt.

    " Total Operaciones Exoneradas
    CLEAR lw_value.
    CLEAR: lw_charimp, lw_netwr.
    lw_netwr   = abs( <fs_reporte>-total_opera_exone ).
    lw_charimp = lw_netwr.
    IF <fs_reporte>-total_opera_exone LT 0.
      CONCATENATE '-' lw_charimp INTO lw_value.
    ELSE.
      lw_value = lw_charimp.
    ENDIF.
    PERFORM agregar_campo USING 18
                       CHANGING lw_value
                                ls_archivo_txt.

    " Total Operaciones Inafectas
    CLEAR lw_value.
    CLEAR: lw_charimp, lw_netwr.
    lw_netwr   = abs( <fs_reporte>-total_opera_inafe ).
    lw_charimp = lw_netwr.
    IF <fs_reporte>-total_opera_inafe LT 0.
      CONCATENATE '-' lw_charimp INTO lw_value.
    ELSE.
      lw_value = lw_charimp.
    ENDIF.
    PERFORM agregar_campo USING 18
                       CHANGING lw_value
                                ls_archivo_txt.

    " ISC: Impuesto Selectivo al Consumo
    CLEAR lw_value.
    CLEAR: lw_charimp, lw_netwr.
    lw_netwr   = abs( <fs_reporte>-isc ).
    lw_charimp = lw_netwr.
    IF <fs_reporte>-isc LT 0.
      CONCATENATE '-' lw_charimp INTO lw_value.
    ELSE.
      lw_value = lw_charimp.
    ENDIF.
    PERFORM agregar_campo USING 18
                       CHANGING lw_value
                                ls_archivo_txt.

    " IGV: Impuesto General a las Ventas
    CLEAR lw_value.
    CLEAR: lw_charimp, lw_netwr.
    lw_netwr   = abs( <fs_reporte>-igv ).
    lw_charimp = lw_netwr.
    IF <fs_reporte>-igv LT 0.
      CONCATENATE '-' lw_charimp INTO lw_value.
    ELSE.
      lw_value = lw_charimp.
    ENDIF.
    PERFORM agregar_campo USING 18
                       CHANGING lw_value
                                ls_archivo_txt.

    " Otros Tributos/ Otros Cargos
    CLEAR lw_value.
    CLEAR: lw_charimp, lw_netwr.
    lw_netwr   = abs( <fs_reporte>-otros_tribu_cargo ).
    lw_charimp = lw_netwr.
    IF <fs_reporte>-otros_tribu_cargo LT 0.
      CONCATENATE '-' lw_charimp INTO lw_value.
    ELSE.
      lw_value = lw_charimp.
    ENDIF.
    PERFORM agregar_campo USING 18
                       CHANGING lw_value
                                ls_archivo_txt.

    " Importe Total
    CLEAR lw_value.
    CLEAR: lw_charimp, lw_netwr.
    lw_netwr   = abs( <fs_reporte>-impte_total ).
    lw_charimp = lw_netwr.
    IF <fs_reporte>-impte_total LT 0.
      CONCATENATE '-' lw_charimp INTO lw_value.
    ELSE.
      lw_value = lw_charimp.
    ENDIF.
    PERFORM agregar_campo USING 18
                       CHANGING lw_value
                                ls_archivo_txt.

    " Tipo del comprobante que se modifica
    CLEAR lw_value.
    lw_value = <fs_reporte>-tipo_compr_modif.
    PERFORM agregar_campo USING 2
                       CHANGING lw_value
                                ls_archivo_txt.

    " Serie del comprobante que se modifica
    CLEAR lw_value.
    lw_value = <fs_reporte>-serie_compr_modif.
    PERFORM agregar_campo USING 20
                       CHANGING lw_value
                                ls_archivo_txt.

    " Número correlativo del comprobante que se modifica
    CLEAR lw_value.
    lw_value = <fs_reporte>-numer_compr_modif.
    PERFORM agregar_campo USING 20
                       CHANGING lw_value
                                ls_archivo_txt.

**    CLEAR lw_fecha_emisi.
**    CONCATENATE <fs_reporte>-fecha_emisi+6(2) <fs_reporte>-fecha_emisi+4(2) <fs_reporte>-fecha_emisi+0(4)
**    INTO lw_fecha_emisi SEPARATED BY '/'.
**
**    CONCATENATE <fs_reporte>-motiv
**                lw_fecha_emisi
**                <fs_reporte>-tipo_compr
**                <fs_reporte>-serie_compr
**                <fs_reporte>-numer_corre
**                <fs_reporte>-rango_ticke
**                <fs_reporte>-tipo_docum
**                <fs_reporte>-numer_docum
**                <fs_reporte>-razon_socia
**                <fs_reporte>-total_opera_grava
**                <fs_reporte>-total_opera_exone
**                <fs_reporte>-total_opera_inafe
**                <fs_reporte>-isc
**                <fs_reporte>-igv
**                <fs_reporte>-otros_tribu_cargo
**                <fs_reporte>-impte_total
**                <fs_reporte>-tipo_compr_modif
**                <fs_reporte>-serie_compr_modif
**                <fs_reporte>-numer_compr_modif
**    INTO ls_archivo_txt-campo SEPARATED BY '|'.

    APPEND ls_archivo_txt TO gt_archivo_txt.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DESCARGAR_ARCHIVO_TXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM descargar_archivo_txt .

  DATA: lw_path1        TYPE string.
  DATA: lw_ruc          TYPE t001z-paval.
  DATA: lw_numer_envio  TYPE numc2. " zostb_res_com_im-numer_envio_dato.
  DATA: lw_strlen       TYPE int4.

  DATA: lr_identity     TYPE RANGE OF zostb_rcicab-zz_identifirci,
        ls_identity     LIKE LINE OF lr_identity,
        lw_identity     TYPE zostb_rcicab-zz_identifirci,
        lw_window_title TYPE string.

*********************DESCARGA DE ARCHIVO************************
  lw_window_title = text-027.
  CALL METHOD cl_gui_frontend_services=>directory_browse
    EXPORTING
      window_title         = lw_window_title
      initial_folder       = 'C:\'
    CHANGING
      selected_folder      = p_path1
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      OTHERS               = 4.
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CHECK p_path1 IS NOT INITIAL.

  lw_strlen = strlen( p_path1 ) - 1.

  IF p_path1+lw_strlen(1) NE '\'.
    CONCATENATE p_path1 '\' INTO p_path1.
  ENDIF.

  SELECT SINGLE paval
    INTO lw_ruc
    FROM t001z
    WHERE bukrs EQ p_bukrs
      AND party EQ 'TAXNR'.

  " Generar Identificador de Resumen del Comprobantes Impresos
  CLEAR ls_identity.
  ls_identity-sign    = 'I'.
  ls_identity-option  = 'CP'.
  CONCATENATE 'RF-' p_fkdat '*' INTO ls_identity-low.
  APPEND ls_identity TO lr_identity.

  SELECT MAX( zz_identifirci )
    INTO lw_identity
    FROM zostb_rcicab
    WHERE bukrs           EQ p_bukrs
      AND zz_identifirci IN lr_identity
      AND zz_femision     = p_fkdat.

  IF lw_identity IS NOT INITIAL.
    lw_numer_envio = lw_identity+12(2).
  ENDIF.
  ADD 1 TO lw_numer_envio.

  " Nombre del arhcivo txt a descargar
**  IF lt_res_com_imp[] IS INITIAL.
**    CONCATENATE p_path1 '\' lw_ruc '-' 'RF' sy-datum '-' '01' '.txt'
**    INTO lw_path1.
**  ELSE.
**    SORT lt_res_com_imp BY numer_envio_dato DESCENDING.
**    READ TABLE lt_res_com_imp ASSIGNING <fs_res_com_imp> INDEX 1.
**    IF sy-subrc EQ 0.
**      lw_numer_envio = <fs_res_com_imp>-numer_envio_dato.
**    ENDIF.
**    ADD 1 TO lw_numer_envio.
**    CONCATENATE p_path1 '\' lw_ruc '-' 'RF' sy-datum '-' lw_numer_envio '.txt'
**    INTO lw_path1.
**  ENDIF.
  CONCATENATE p_path1 lw_ruc '-' 'RF' p_fkdat '-' lw_numer_envio '.txt'
    INTO lw_path1.

* Grabar datos en la tabla ZOSTB_RES_COM_IM
  PERFORM guardar_datos USING lw_numer_envio.

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename                = lw_path1
      filetype                = 'ASC'
    TABLES
      data_tab                = gt_archivo_txt
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.                   "#EC ARGCHECKED

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    MESSAGE s836(sd) WITH text-i01 p_path1.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GUARDAR_DATOS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PI_NUMER_ENVIO  text
*----------------------------------------------------------------------*
FORM guardar_datos  USING    pi_numer_envio TYPE numc2.

**  DATA: ls_res_com_imp TYPE zostb_res_com_im.
**
**  FIELD-SYMBOLS: <fs_reporte> LIKE LINE OF gt_reporte.
**
**  LOOP AT gt_reporte ASSIGNING <fs_reporte>.
**
**    ls_res_com_imp-mandt = sy-mandt.
**    ls_res_com_imp-motiv = <fs_reporte>-motiv.
**    ls_res_com_imp-fecha_emisi = <fs_reporte>-fecha_emisi.
**    ls_res_com_imp-tipo_compr = <fs_reporte>-tipo_compr.
**    ls_res_com_imp-serie_compr = <fs_reporte>-serie_compr.
**    ls_res_com_imp-numer_corre = <fs_reporte>-numer_corre.
**    ls_res_com_imp-rango_ticke = <fs_reporte>-rango_ticke.
**    ls_res_com_imp-tipo_docum = <fs_reporte>-tipo_docum.
**    ls_res_com_imp-numer_docum = <fs_reporte>-numer_docum.
**    ls_res_com_imp-razon_socia = <fs_reporte>-razon_socia.
**    ls_res_com_imp-total_opera_grav = <fs_reporte>-total_opera_grava.
**    ls_res_com_imp-total_opera_exon = <fs_reporte>-total_opera_exone.
**    ls_res_com_imp-total_opera_inaf = <fs_reporte>-total_opera_inafe.
**    ls_res_com_imp-isc = <fs_reporte>-isc.
**    ls_res_com_imp-igv = <fs_reporte>-igv.
**    ls_res_com_imp-otros_tribu = <fs_reporte>-otros_tribu_cargo.
**    ls_res_com_imp-impte_total = <fs_reporte>-impte_total.
**    ls_res_com_imp-tipo_compr_modif = <fs_reporte>-tipo_compr_modif.
**    ls_res_com_imp-serie_compr_modi = <fs_reporte>-serie_compr_modif.
**    ls_res_com_imp-numer_compr_modi = <fs_reporte>-numer_compr_modif.
**    ls_res_com_imp-numer_envio_dato = pi_numer_envio.
**
**    MODIFY zostb_res_com_im FROM ls_res_com_imp.
**
**  ENDLOOP.

  DATA: ls_rcicab  TYPE zostb_rcicab,
        lt_rcidet  TYPE STANDARD TABLE OF zostb_rcidet,
        ls_rcidet  TYPE zostb_rcidet,
        ls_reporte LIKE LINE OF gt_reporte.

  CLEAR ls_rcicab.
  ls_rcicab-bukrs          = p_bukrs.
  CONCATENATE 'RF' p_fkdat pi_numer_envio
    INTO ls_rcicab-zz_identifirci SEPARATED BY '-'.
  ls_rcicab-zz_fgenerarci  = sy-datum.
  ls_rcicab-zz_femision    = p_fkdat.
  SELECT SINGLE paval
    INTO ls_rcicab-zz_nroruc
    FROM t001z
    WHERE bukrs EQ p_bukrs
      AND party EQ 'TAXNR'.

  LOOP AT gt_reporte INTO ls_reporte.
    CLEAR ls_rcidet.
    ls_rcidet-bukrs            = ls_rcicab-bukrs.
    ls_rcidet-zz_identifirci   = ls_rcicab-zz_identifirci.
    ls_rcidet-zz_nrofila       = lines( lt_rcidet ) + 1.
    ls_rcidet-motiv            = ls_reporte-motiv.
    ls_rcidet-fecha_emisi      = ls_reporte-fecha_emisi.
    ls_rcidet-tipo_compr       = ls_reporte-tipo_compr.
    ls_rcidet-serie_compr      = ls_reporte-serie_compr.
    ls_rcidet-numer_corre      = ls_reporte-numer_corre.
    ls_rcidet-rango_ticke      = ls_reporte-rango_ticke.
    ls_rcidet-tipo_docum       = ls_reporte-tipo_docum.
    ls_rcidet-numer_docum      = ls_reporte-numer_docum.
    ls_rcidet-razon_socia      = ls_reporte-razon_socia.
    ls_rcidet-total_opera_grav = ls_reporte-total_opera_grava.
    ls_rcidet-total_opera_exon = ls_reporte-total_opera_exone.
    ls_rcidet-total_opera_inaf = ls_reporte-total_opera_inafe.
    ls_rcidet-isc              = ls_reporte-isc.
    ls_rcidet-igv              = ls_reporte-igv.
    ls_rcidet-otros_tribu      = ls_reporte-otros_tribu_cargo.
    ls_rcidet-impte_total      = ls_reporte-impte_total.
    ls_rcidet-tipo_compr_modif = ls_reporte-tipo_compr_modif.
    ls_rcidet-serie_compr_modi = ls_reporte-serie_compr_modif.
    ls_rcidet-numer_compr_modi = ls_reporte-numer_compr_modif.
    APPEND ls_rcidet TO lt_rcidet.
  ENDLOOP.

  MODIFY zostb_rcicab FROM ls_rcicab.
  MODIFY zostb_rcidet FROM TABLE lt_rcidet.
  COMMIT WORK.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  D0100_EVENT_ONF4
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_E_FIELDNAME  text
*      -->P_E_FIELDVALUE  text
*      -->P_ES_ROW_NO  text
*      -->P_ER_EVENT_DATA  text
*      -->P_ET_BAD_CELLS  text
*      -->P_E_DISPLAY  text
*----------------------------------------------------------------------*
FORM d0100_event_onf4  USING  pi_e_fieldname   TYPE lvc_fname
                              pi_e_fieldvalue  TYPE lvc_value
                              pi_es_row_no     TYPE lvc_s_roid
                              pi_er_event_data TYPE REF TO cl_alv_event_data
                              pi_et_bad_cells  TYPE lvc_t_modi "#EC NEEDED
                              pi_e_display     TYPE char01.

*{  BEGIN OF REPLACE WMR-050815
  ""  DATA: hf_field_tab LIKE help_value OCCURS 2 WITH HEADER LINE.

  ""  DATA: BEGIN OF hf_value_tab OCCURS 0,
  ""          VALUE(29),
  ""        END OF hf_value_tab.

  ""  TYPES: BEGIN OF ty_motrescoim.
  ""          INCLUDE TYPE zostb_motrescoim.
  ""  TYPES:
  ""         END OF ty_motrescoim.

  ""  DATA: lt_motrescoim TYPE STANDARD TABLE OF ty_motrescoim.
  ""  DATA: ls_modi         TYPE lvc_s_modi.

  ""  DATA: lw_e_fieldvalue TYPE zostb_motrescoim-id_mrcim.

  ""  FIELD-SYMBOLS: <fs_motrescoim> LIKE LINE OF lt_motrescoim.
  ""  FIELD-SYMBOLS: <fs>     TYPE lvc_t_modi,
  ""                 <fs_rep> LIKE LINE OF gt_reporte.

  ""*  lw_e_fieldvalue = pi_e_fieldvalue.

  ""* Matchcode para el Motivo Resumen de Comprobante Impreso
  ""  IF pi_e_fieldname = 'MOTIV'.
  ""    hf_field_tab-tabname    = 'ZOSTB_MOTRESCOIM'.
  ""    hf_field_tab-fieldname  = 'ID_MRCIM'.
  ""    hf_field_tab-selectflag = 'X'.
  ""    APPEND hf_field_tab.
  ""  ENDIF.


  ""  SELECT * FROM zostb_motrescoim
  ""    INTO TABLE lt_motrescoim.

  ""  LOOP AT lt_motrescoim ASSIGNING <fs_motrescoim>.
  ""    CONCATENATE <fs_motrescoim>-id_mrcim <fs_motrescoim>-descr_mrcim
  ""    INTO hf_value_tab SEPARATED BY space.
  ""    APPEND hf_value_tab.
  ""  ENDLOOP.

  ""  READ TABLE hf_value_tab INDEX 1.
  ""  IF sy-subrc = 0.
  ""    CALL FUNCTION 'HELP_VALUES_GET_WITH_TABLE'
  ""      EXPORTING
  ""        display      = ' '
  ""        fieldname    = hf_field_tab-fieldname
  ""        tabname      = hf_field_tab-tabname
  ""      IMPORTING
  ""        select_value = pi_e_fieldvalue
  ""      TABLES
  ""        valuetab     = hf_value_tab
  ""        fields       = hf_field_tab.
  ""  ENDIF.

  ""  lw_e_fieldvalue = pi_e_fieldvalue+0(1).

  ""*---Acotamiento tratado
  ""  pi_er_event_data->m_event_handled = 'X'.

  ""  IF NOT pi_e_fieldvalue IS INITIAL.
  ""    READ TABLE gt_reporte ASSIGNING <fs_rep> INDEX pi_es_row_no-row_id.
  ""    IF sy-subrc EQ 0.
  ""      READ TABLE lt_motrescoim ASSIGNING <fs_motrescoim> WITH KEY id_mrcim = lw_e_fieldvalue.
  ""      IF sy-subrc EQ 0.
  ""        <fs_rep>-motiv = <fs_motrescoim>-id_mrcim.
  ""        pi_e_fieldvalue = <fs_motrescoim>-id_mrcim.
  ""      ENDIF.
  ""    ENDIF .
  ""  ENDIF.

  ""*---Actualizar al nuevo dato seleccionado
  ""  ls_modi-row_id     = pi_es_row_no-row_id.
  ""  ls_modi-sub_row_id = pi_es_row_no-sub_row_id.
  ""  ls_modi-fieldname  = pi_e_fieldname.
  ""  ls_modi-value      = pi_e_fieldvalue.
  ""  ASSIGN pi_er_event_data->m_data->* TO <fs>.
  ""  APPEND ls_modi TO <fs>.
  TYPES:  BEGIN OF ty_motivos,
            id_mrcim    TYPE zostb_motrescoim-id_mrcim,
            descr_mrcim TYPE zostb_motrescoim-descr_mrcim,
          END OF ty_motivos.

  DATA: lt_motivos   TYPE STANDARD TABLE OF ty_motivos,
        lt_returntab TYPE STANDARD TABLE OF ddshretval,
        ls_returntab TYPE ddshretval,
        ls_modi      TYPE lvc_s_modi.

  FIELD-SYMBOLS: <fs>     TYPE lvc_t_modi,
                 <fs_rep> LIKE LINE OF gt_reporte.

  CASE pi_e_fieldname.
    WHEN 'MOTIV'.
      SELECT id_mrcim descr_mrcim
        INTO TABLE lt_motivos
        FROM zostb_motrescoim.

      CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
        EXPORTING
          retfield        = 'ID_MRCIM'
          window_title    = text-008
          value_org       = 'S'
        TABLES
          value_tab       = lt_motivos[]
          return_tab      = lt_returntab
        EXCEPTIONS
          parameter_error = 1
          no_values_found = 2
          OTHERS          = 3.
      IF sy-subrc EQ 0.
        READ TABLE lt_returntab INTO ls_returntab INDEX 1.
        IF sy-subrc EQ 0.
          pi_e_fieldvalue = ls_returntab-fieldval.

          " Acotamiento tratado
          pi_er_event_data->m_event_handled = 'X'.

          IF NOT pi_e_fieldvalue IS INITIAL.
            READ TABLE gt_reporte ASSIGNING <fs_rep> INDEX pi_es_row_no-row_id.
            IF sy-subrc EQ 0.
              <fs_rep>-motiv  = ls_returntab-fieldval.
              pi_e_fieldvalue = ls_returntab-fieldval.
            ENDIF .
          ENDIF.

          " Actualizar al nuevo dato seleccionado
          ls_modi-row_id     = pi_es_row_no-row_id.
          ls_modi-sub_row_id = pi_es_row_no-sub_row_id.
          ls_modi-fieldname  = pi_e_fieldname.
          ls_modi-value      = pi_e_fieldvalue.
          ASSIGN pi_er_event_data->m_data->* TO <fs>.
          APPEND ls_modi TO <fs>.
        ENDIF.
      ENDIF.
  ENDCASE.

*}  END OF REPLACE WMR-050815

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  REGISTER_F4_FIELDS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM register_f4_fields .

  DATA: lt_f4 TYPE lvc_t_f4.
  DATA: ls_f4_data TYPE lvc_s_f4.

  ls_f4_data-fieldname  = 'MOTIV'.
  ls_f4_data-register   = 'X'.
  ls_f4_data-getbefore  = ' '.
  ls_f4_data-chngeafter = ' '.
  INSERT ls_f4_data INTO TABLE lt_f4.

  CALL METHOD go_grid->register_f4_for_fields
    EXPORTING
      it_f4 = lt_f4.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  agregar_campo
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PI_LONGI     text
*      -->PE_CAMPO     text
*      -->PE_PLESUNAT  text
*----------------------------------------------------------------------*
FORM agregar_campo USING pi_longi TYPE i
                CHANGING pe_campo
                         pe_file  TYPE ty_archivo_txt ##PERF_NO_TYPE.

  DATA: lw_longi TYPE i.

  lw_longi = strlen( pe_file ).
  pe_file+lw_longi(pi_longi) = pe_campo.

  lw_longi = lw_longi + pi_longi.
  pe_file+lw_longi(1) = '|'.
ENDFORM.                    "agregar_campo
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
