*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_FEMONITOR_F02
*&---------------------------------------------------------------------*
*{+010922-NTP-3000018956
*----------------------------------------------------------------------*
* alv_getselected
*----------------------------------------------------------------------*
FORM alv_getselected USING i_message TYPE clike
                     CHANGING e_index TYPE sy-index
                              e_subrc TYPE sy-subrc.

  DATA: lo_grid TYPE REF TO cl_gui_alv_grid,
        lt_row  TYPE lvc_t_roid,
        ls_row  LIKE LINE OF lt_row.

  IF lo_grid IS NOT BOUND.
    CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
      IMPORTING
        e_grid = lo_grid.
  ENDIF.

  IF lo_grid IS BOUND.
    lo_grid->get_selected_rows(
      IMPORTING
        et_row_no = lt_row
    ).
  ENDIF.

  DESCRIBE TABLE lt_row.

  IF sy-tfill = 0 OR sy-tfill > 1.
    MESSAGE i208(00) WITH i_message.
    e_subrc = 1.
  ELSE.
    READ TABLE lt_row INTO ls_row INDEX 1.
    e_index = ls_row-row_id.
  ENDIF.

ENDFORM.

*----------------------------------------------------------------------*
* reenumerar
*----------------------------------------------------------------------*
FORM reenumerar_btn CHANGING e_subrc TYPE sy-subrc.
  DATA: l_index    TYPE sy-index,
        l_subrc    TYPE sy-subrc,
        ls_reporte LIKE LINE OF gt_reporte.

  e_subrc = 1.

  "Seleccion
  PERFORM alv_getselected USING 'Seleccione un sólo documento a Reenumerar' CHANGING l_index l_subrc.
  IF l_subrc = 0.
    READ TABLE gt_reporte INTO ls_reporte INDEX l_index.
    IF sy-subrc EQ 0.
      "Procesar
      PERFORM reenumerar_idcp USING ls_reporte CHANGING e_subrc.
    ENDIF.
  ENDIF.
ENDFORM.

*----------------------------------------------------------------------*
* reenumerar_idcp
*----------------------------------------------------------------------*
FORM reenumerar_idcp USING is_reporte TYPE zoses_femonitor
                     CHANGING e_subrc TYPE sy-subrc.

  DATA: lt_bi     TYPE tab_bdcdata,
        lt_return TYPE bapirettab,
        l_rgtno   TYPE idcn_loma-rgtno,
        l_lotno   TYPE string,
        l_ldest   TYPE string,
        l_kschl   TYPE string,
        l_kunnr   TYPE kunnr,
        l_vkorg   TYPE string,
        l_vstel   TYPE string,
        l_xblnr   TYPE string,
        l_werks   TYPE string,
        l_field   TYPE string,
        l_where   TYPE string,
        l_temp    TYPE string.


  "1. Lote
  SELECT SINGLE lotno INTO l_lotno FROM idcn_loma
    WHERE bukrs = is_reporte-bukrs
      AND invtp = is_reporte-zzt_tipodoc
      AND rgtno = is_reporte-zzt_numeracion(4).
  IF sy-subrc <> 0.
    CONCATENATE '0' is_reporte-zzt_numeracion(4) INTO l_rgtno.
    SELECT SINGLE lotno INTO l_lotno FROM idcn_loma
      WHERE bukrs = is_reporte-bukrs
        AND invtp = is_reporte-zzt_tipodoc
        AND rgtno = l_rgtno.
  ENDIF.


  "2. Factura / Entrega
  SELECT SINGLE kunrg vkorg xblnr INTO (l_kunnr, l_vkorg, l_xblnr) FROM vbrk
    WHERE vbeln = is_reporte-zzt_nrodocsap.
  IF sy-subrc <> 0.
    "Entrega
    SELECT SINGLE a~kunnr a~vstel a~xblnr b~werks
      INTO (l_kunnr, l_vstel, l_xblnr, l_werks)
      FROM likp AS a LEFT JOIN lips AS b ON a~vbeln = b~vbeln
      WHERE a~vbeln EQ is_reporte-zzt_nrodocsap.
  ENDIF.
  SELECT COUNT(*) FROM zostb_felog WHERE bukrs = is_reporte-bukrs AND zzt_numeracion = l_xblnr+3.
  IF sy-subrc = 0.
    CLEAR l_xblnr.
  ELSE.
    SPLIT l_xblnr AT '-' INTO l_temp l_temp l_xblnr.
  ENDIF.


  "3. Message y printer
  SELECT COUNT(*) FROM dd02l WHERE tabname = 'APOC_D_OR_ITEM'.
  IF sy-subrc = 0.
    l_field = 'output_type print_queue_name'.
    SELECT SINGLE (l_field) INTO (l_kschl, l_ldest)
      FROM ('apoc_d_or_item')
      WHERE ('appl_object_id = is_reporte-zzt_nrodocsap and channel = `PRINT`').
  ENDIF.
  IF l_kschl IS INITIAL.
    SELECT SINGLE kschl ldest INTO (l_kschl, l_ldest)
      FROM nast
      WHERE objky = is_reporte-zzt_nrodocsap AND vstat = 1 AND ldest <> space.
  ENDIF.
  IF sy-subrc <> 0.
    IF l_field IS NOT INITIAL.
      l_where = 'output_type LIKE `Z%` AND sender_organization_id = is_reporte-bukrs AND sender_org_unit_id = l_vkorg and channel = `PRINT`'.
      SELECT SINGLE (l_field) INTO (l_kschl, l_ldest)
        FROM ('apoc_d_or_item')
        WHERE (l_where).
    ENDIF.
    IF l_kschl IS NOT INITIAL.
      IF l_vkorg IS INITIAL.
        SELECT SINGLE kschl ldest INTO (l_kschl, l_ldest)
          FROM nast
          WHERE kappl = 'V3'
            AND kschl LIKE 'Z%'
            AND parnr = l_kunnr AND vstat = 1 AND ldest <> space.
      ELSE.
        SELECT SINGLE kschl ldest INTO (l_kschl, l_ldest)
          FROM nast
          WHERE kappl IN ('V2','E1')
            AND kschl LIKE 'Z%'
            AND parnr = l_kunnr AND vstat = 1 AND ldest <> space.
      ENDIF.
    ENDIF.
  ENDIF.


  "4. IDCP
  IF l_vkorg IS NOT INITIAL. "Factura
    PERFORM batch_dynpro USING 'IDPRCNINVOICE' '1000' 'ONLI' CHANGING lt_bi.
    PERFORM batch_field USING 'CHK_BILL' abap_on CHANGING lt_bi.
    PERFORM batch_field USING 'CHK_DELI' abap_off CHANGING lt_bi.
    PERFORM batch_field USING 'VKORG' l_vkorg CHANGING lt_bi.
    PERFORM batch_field USING 'L_VSTEL' space CHANGING lt_bi.
    PERFORM batch_field USING 'WERKS' space CHANGING lt_bi.
    PERFORM batch_field USING 'LOTNO' l_lotno CHANGING lt_bi.
    PERFORM batch_field USING 'BOKNO' '01' CHANGING lt_bi.

    PERFORM batch_dynpro USING 'IDPRCNINVOICE' '0111' '=CRET' CHANGING lt_bi.
    IF l_xblnr IS NOT INITIAL.
      PERFORM batch_field USING 'PR_LOW' l_xblnr CHANGING lt_bi.
    ENDIF.
    PERFORM batch_field USING 'PR_NUM' l_ldest CHANGING lt_bi.
    PERFORM batch_field USING 'VBELN-LOW' is_reporte-zzt_nrodocsap CHANGING lt_bi.
    PERFORM batch_field USING 'MSG_TYPE' l_kschl CHANGING lt_bi.
    PERFORM batch_field USING 'RFBSK_AB' abap_on CHANGING lt_bi.
    PERFORM batch_field USING 'RFBSK_C' abap_on CHANGING lt_bi.
    PERFORM batch_field USING 'CHK_RPRT' abap_on CHANGING lt_bi.
  ELSE.
    PERFORM batch_dynpro USING 'IDPRCNINVOICE' '1000' 'ONLI' CHANGING lt_bi.
    PERFORM batch_field USING 'CHK_BILL' abap_off CHANGING lt_bi.
    PERFORM batch_field USING 'CHK_DELI' abap_on CHANGING lt_bi.
    PERFORM batch_field USING 'VKORG' space CHANGING lt_bi.
    PERFORM batch_field USING 'L_VSTEL' l_vstel CHANGING lt_bi.
    PERFORM batch_field USING 'WERKS' l_werks CHANGING lt_bi.
    PERFORM batch_field USING 'LOTNO' l_lotno CHANGING lt_bi.
    PERFORM batch_field USING 'BOKNO' '01' CHANGING lt_bi.

    PERFORM batch_dynpro USING 'IDPRCNINVOICE' '0222' '=CRET' CHANGING lt_bi.
    IF l_xblnr IS NOT INITIAL.
      PERFORM batch_field USING 'L_PR_LOW' l_xblnr CHANGING lt_bi.
    ENDIF.
    PERFORM batch_field USING 'L_PR_NUM' l_ldest CHANGING lt_bi.
    PERFORM batch_field USING 'L_VBELN-LOW' is_reporte-zzt_nrodocsap CHANGING lt_bi.
    PERFORM batch_field USING 'LMSGTYPE' l_kschl CHANGING lt_bi.
    PERFORM batch_field USING 'WBSTK_C' abap_on CHANGING lt_bi.
    PERFORM batch_field USING 'LCHKRPRT' abap_on CHANGING lt_bi.
  ENDIF.

  PERFORM batch_dynpro USING 'SAPLSLVC_FULLSCREEN' '0500' '=&ALL' CHANGING lt_bi.
  PERFORM batch_dynpro USING 'SAPLSLVC_FULLSCREEN' '0500' '=BTCI' CHANGING lt_bi.
  IF l_vkorg IS INITIAL.
    PERFORM batch_dynpro USING 'SAPLSPO1' '0300' '=YES' CHANGING lt_bi.
  ENDIF.
  PERFORM batch_dynpro USING 'SAPLSLVC_FULLSCREEN' '0500' '=BACK' CHANGING lt_bi.
  PERFORM batch_dynpro USING 'IDPRCNINVOICE' '1000' '/EE' CHANGING lt_bi.

  PERFORM batch_call USING 'IDCP' '493' 'E' CHANGING lt_bi lt_return e_subrc.
ENDFORM.

*----------------------------------------------------------------------*
* reefacturar_btn
*----------------------------------------------------------------------*
FORM reefacturar_btn CHANGING e_subrc TYPE sy-subrc.
  DATA: l_index    TYPE sy-index,
        l_subrc    TYPE sy-subrc,
        ls_reporte LIKE LINE OF gt_reporte.

  e_subrc = 1.

  "Seleccion
  PERFORM alv_getselected USING 'Seleccione un sólo documento a Reefacturar' CHANGING l_index l_subrc.
  IF l_subrc = 0.
    READ TABLE gt_reporte INTO ls_reporte INDEX l_index.
    IF sy-subrc EQ 0.
      PERFORM refacturar USING ls_reporte CHANGING e_subrc.
    ENDIF.
  ENDIF.
ENDFORM.

*----------------------------------------------------------------------*
* reefacturar
*----------------------------------------------------------------------*
FORM refacturar USING is_reporte TYPE zoses_femonitor
                CHANGING e_subrc TYPE sy-subrc.
  "Anular factura
  DATA: lt_return TYPE bapirettab,
        ls_vbrk   TYPE vbrk,
        ls_return LIKE LINE OF lt_return,
        l_error   TYPE char4,
        lt_log    TYPE zoses_femonitor-zzt_errores.

  IF is_reporte-zzt_status_cdr = 0 OR is_reporte-zzt_status_cdr = 5 OR is_reporte-zzt_status_cdr = 6 OR is_reporte-zzt_status_cdr = 7.
    PERFORM pro_cancelar_documento USING is_reporte abap_off CHANGING l_error." lt_return lt_log.
  ELSE.
    PERFORM anular_documento USING is_reporte CHANGING l_error(1) ls_vbrk lt_return.
    IF l_error IS INITIAL.
      MESSAGE s000 WITH 'Debe ejecutar zosfe003 para la baja...'.
    ENDIF.
  ENDIF.
  IF l_error IS INITIAL.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.

    "Crear factura
    DATA: ls_vbrp TYPE vbrp,
          lt_cab  TYPE TABLE OF bapivbrk,
          lt_cond TYPE TABLE OF bapikomv,
          lt_card TYPE TABLE OF bapiccard_vf,
          ls_cab  LIKE LINE OF lt_cab.

    SELECT SINGLE * INTO ls_vbrp FROM vbrp WHERE vbeln = is_reporte-zzt_nrodocsap.
    ls_cab-bill_date  = sy-datlo.
    ls_cab-created_by = sy-uname.
    ls_cab-ref_doc    = ls_vbrp-vgbel.
    ls_cab-ref_doc_ca = ls_vbrp-vgtyp.
    APPEND ls_cab TO lt_cab.

    CALL FUNCTION 'BAPI_BILLINGDOC_CREATEFROMDATA'
      TABLES
        billing_data_in   = lt_cab
        condition_data_in = lt_cond
        returnlog_out     = lt_return
        ccard_data_in     = lt_card.

    READ TABLE lt_return INTO ls_return WITH KEY type = 'S' id = 'VF' number = '050'.
    IF sy-subrc EQ 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.

      "Enumerar factura
      is_reporte-zzt_nrodocsap = ls_return-message_v1.
      PERFORM reenumerar_idcp USING is_reporte CHANGING e_subrc.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ENDIF.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  ENDIF.
ENDFORM.
*}+010922-NTP-3000018956
