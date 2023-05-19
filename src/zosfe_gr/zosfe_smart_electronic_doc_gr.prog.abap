*----------------------------------------------------------------------*
*                         INFORMACION GENERAL
*----------------------------------------------------------------------*
* Módulo      : FE
* Descripción : Construir datos para formulario
* Ticket      : 3000007333 Omnia Solution SAC
* Autor       : Norman Tinco
* Fecha       : 31.05.2017
*----------------------------------------------------------------------*

REPORT  zosfe_smart_electronic_doc_gr.

TYPE-POOLS: abap.

DATA: gw_license TYPE string.

*----------------------------------------------------------------------*
FORM obtenerdatos_formulario USING is_data          TYPE zosfegres_data_nojson
                             CHANGING es_cab        TYPE zoses_fegrcab
                                      es_cab3       TYPE zosfees_data_cab3_gr
                                      es_consextsun TYPE zostb_consextsun
                                      et_det        TYPE zosfett_data_det_gr
                                      et_shipto     TYPE zostt_fecli.

* Licencia
  CALL FUNCTION 'SLIC_GET_LICENCE_NUMBER'
    IMPORTING
      license_number = gw_license.

* Pais
  SET COUNTRY 'PE'.

* CABECERA
  READ TABLE is_data-t_header  INTO es_cab  INDEX 1.


  "Determinar tipo de comprobante Sunat
  SELECT SINGLE * INTO es_consextsun FROM zostb_consextsun WHERE bukrs = es_cab-bukrs.

* DETALLE
  PERFORM obtenerdetalle USING es_cab is_data-t_detail CHANGING et_det es_cab3.
  PERFORM aumentarlineasvacias_detalle CHANGING et_det.

* CABECERA 3
  PERFORM obtenercab3 USING is_data-t_detail es_cab es_consextsun CHANGING es_cab3.

* SHIPTO
  et_shipto = is_data-t_shipto.


ENDFORM.                    "obtenercabecera3_formulario


*----------------------------------------------------------------------*
FORM obtenercab3 USING it_det TYPE zostt_fegrdet
                       is_cab TYPE zoses_fegrcab
                       is_consextsun TYPE zostb_consextsun
                 CHANGING es_cab3 TYPE zosfees_data_cab3_gr.

  DATA: lt_cat06  TYPE TABLE OF zostb_catalogo06,
        lt_cat18  TYPE TABLE OF zostb_catalogo18,
        lt_cat20  TYPE TABLE OF zostb_catalogo20,
        lt_string TYPE db2_t_string,                                  "I-WMR-280617-3000007333
        lt_lines  TYPE tline_tab,                                     "I-WMR-070318-3000008769

        ls_cat06  LIKE LINE OF lt_cat06,
        ls_cat18  LIKE LINE OF lt_cat18,
        ls_cat20  LIKE LINE OF lt_cat20,

        ls_thead  TYPE thead,                                          "I-WMR-070318-3000008769
        ls_lines  TYPE tline.                                          "I-WMR-070318-3000008769

  DATA: ls_cat17 TYPE zostb_catalogo17,
        ls_vbrk  TYPE vbrk,
        ls_t001  TYPE t001,                                           "I-WMR-020517-3000007140
        ls_tag   TYPE string,                                         "I-WMR-280617-3000007333
        l_string TYPE string,                                         "I-WMR-020517-3000007140
        l_palnum TYPE string,                                         "I-WMR-280617-3000007333
        l_unidad TYPE string.                                         "I-WMR-280617-3000007333

*GET
  SELECT * INTO TABLE lt_cat06 FROM zostb_catalogo06.
  SELECT * INTO TABLE lt_cat18 FROM zostb_catalogo18.
  SELECT * INTO TABLE lt_cat20 FROM zostb_catalogo20.

*BUILD
  "Textos
  es_cab3-texto_remitente = 'REMITENTE'.


  "Telefono y Fax
  SELECT SINGLE a~tel_number
                a~fax_number
    INTO (es_cab3-bukrs_tel_number,
          es_cab3-bukrs_fax_number)
    FROM adrc AS a INNER JOIN t001 AS b ON a~addrnumber = b~adrnr
    WHERE b~bukrs = is_cab-bukrs
      AND a~nation = space
      AND a~date_from = '00010101'.


  "Fecha de emisión
  CONCATENATE is_cab-zzfecemi+6(2)
              is_cab-zzfecemi+4(2)
              is_cab-zzfecemi(4)
              INTO es_cab3-zzfecemi_string SEPARATED BY '/'.

  "Fecha de entrega al transportista
  CONCATENATE is_cab-zztrafec+6(2)
              is_cab-zztrafec+4(2)
              is_cab-zztrafec(4)
              INTO es_cab3-zztrafec_string SEPARATED BY '/'.

  "Homologación
  READ TABLE lt_cat20 INTO ls_cat20 WITH KEY zz_codigo_sunat = is_cab-zztrsmot_h.
  IF sy-subrc = 0.
    es_cab3-zztrsmot_h_string = ls_cat20-zz_desc_cod_suna.
  ENDIF.

  READ TABLE lt_cat18 INTO ls_cat18 WITH KEY zz_codigo_sunat = is_cab-zztrsmod_h.
  IF sy-subrc = 0.
    es_cab3-zztrsmod_h_string = ls_cat18-zz_desc_cod_suna.
  ENDIF.

*{  BEGIN OF INSERT WMR-030717-3000007333
  CASE is_cab-zzdsttpd_h.
    WHEN '1'. es_cab3-zzdsttpd_h_string = 'DNI'.
    WHEN '6'. es_cab3-zzdsttpd_h_string = 'RUC'.
  ENDCASE.
*}  END OF INSERT WMR-030717-3000007333

*{  BEGIN OF INSERT WMR-070318-3000008769
  CASE gw_license.
    WHEN '0020886706'.  " PIRAMIDE
      CLEAR: es_cab3-zzdsttpd_h_string.
  ENDCASE.
*}  END OF INSERT WMR-070318-3000008769

*  "Moneda
*  SELECT SINGLE nomsun INTO es_cab3-nomsun
*    FROM zostb_tcurt
*    WHERE waers = is_cab-zz_moneda
*      AND begda <= is_cab-zzfecmi
*      AND endda >= is_cab-zzfecmi.
*
  "Pais
*  SELECT SINGLE landx INTO es_cab3-zz_country_string
*    FROM t005t
*    WHERE spras = sy-langu
*      AND land1 = is_cab-zz_country.
*
*  TRANSLATE es_cab3-zz_country_string TO UPPER CASE.

  "Logo
*{ M-ACZ260118-3000008769: Cambiar Logo
*  CONCATENATE 'ZOSLOGOCR' is_cab-bukrs INTO es_cab3-bukrs_logo SEPARATED BY '_'.
  IF is_cab-bukrs IS NOT INITIAL.
    CONCATENATE 'ZOSFELOGO' is_cab-bukrs INTO es_cab3-bukrs_logo SEPARATED BY '_'.
  ENDIF.
*} M-ACZ260118-3000008769

  "Referencia sunat
  SELECT SINGLE xblnr INTO es_cab3-xblnr FROM likp WHERE vbeln = is_cab-zznrosap.


  "Entrega/Pedido/Entr.Ref.
  IF 1 = 2.
    CONCATENATE is_cab-zznrosap is_cab-vgbel es_cab3-xblnr
          INTO es_cab3-nrodocs_string SEPARATED BY ' / '.
  ENDIF.

  "Transbordo programado
  CASE is_cab-zzindtnb.
    WHEN abap_on. es_cab3-zzindtnb_string = 'TRUE'.
    WHEN abap_off. es_cab3-zzindtnb_string = 'FALSE'.
  ENDCASE.

  "Importes Totales a string
  PERFORM convert_to_string USING is_cab-zzundtot CHANGING es_cab3-zzundtot_string.

* Tipo de comprobante Sunat y ajustes
  es_cab3-tipdoc_string = 'GUIA REMISIÓN'.

*{  BEGIN OF INSERT WMR-280617-3000007333
  " Bulto Mayor
  IF is_cab-zzpalnum GT 0.
    l_palnum = is_cab-zzpalnum. CONDENSE l_palnum NO-GAPS.
    CONCATENATE l_palnum 'PALETAS' INTO l_palnum SEPARATED BY space.
  ENDIF.

  IF is_cab-zzundtot GT 0.
    l_unidad = is_cab-zzundtot. CONDENSE l_unidad NO-GAPS.
    CONCATENATE l_unidad is_cab-zzunddes INTO l_unidad SEPARATED BY space.
  ENDIF.

  IF l_palnum IS NOT INITIAL OR l_unidad IS NOT INITIAL.
    ls_tag = 'BULTO MAYOR:'.  APPEND ls_tag TO es_cab3-zztagadd_string.
    IF l_palnum IS NOT INITIAL AND l_unidad IS INITIAL.
      ls_tag = l_palnum.  APPEND ls_tag TO es_cab3-zztagadd_string.
    ELSEIF l_palnum IS INITIAL AND l_unidad IS NOT INITIAL.
      ls_tag = l_unidad.  APPEND ls_tag TO es_cab3-zztagadd_string.
    ELSE.
      CONCATENATE l_palnum ',' l_unidad INTO ls_tag SEPARATED BY space.
      APPEND ls_tag TO es_cab3-zztagadd_string.
    ENDIF.
  ENDIF.

  " Precintos
  IF is_cab-zzprecin IS NOT INITIAL.
    IF es_cab3-zztagadd_string[] IS NOT INITIAL.
      CLEAR ls_tag. APPEND ls_tag TO es_cab3-zztagadd_string.
    ENDIF.
    SPLIT is_cab-zzprecin AT '#' INTO TABLE lt_string.
    APPEND LINES OF lt_string TO es_cab3-zztagadd_string.
  ENDIF.
*}  END OF INSERT WMR-280617-3000007333

*{  BEGIN OF INSERT WMR-070318-3000008769
  " Texto adicional sólo visible en SAP
  CASE gw_license.
    WHEN '0020886706'.  " PIRAMIDE
      ls_thead-tdobject = 'VBBK'.
      SELECT SINGLE valor1 INTO ls_thead-tdid
        FROM zostb_const_fe
        WHERE aplicacion = 'EXTRACTOR'
          AND programa   = 'ZOSSD_PRO_EXTRAC'
          AND campo      = 'TXTADDOS'.
      ls_thead-tdname   = is_cab-zznrosap.
      ls_thead-tdspras  = sy-langu.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = ls_thead-tdid
          language                = ls_thead-tdspras
          name                    = ls_thead-tdname
          object                  = ls_thead-tdobject
        TABLES
          lines                   = lt_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.

      LOOP AT lt_lines INTO ls_lines.
        IF es_cab3-zztxtaddos_string IS INITIAL.
          es_cab3-zztxtaddos_string = ls_lines-tdline.
        ELSE.
          CONCATENATE es_cab3-zztxtaddos_string ls_lines-tdline INTO es_cab3-zztxtaddos_string SEPARATED BY space.
        ENDIF.
      ENDLOOP.
  ENDCASE.
*}  END OF INSERT WMR-070318-3000008769

  "Pie totales
  PERFORM convert_to_string USING is_cab-zztotblt CHANGING es_cab3-zztotblt_string. "I-051219-NTP-3000013055
  perform convert_to_string using is_cab-btgew CHANGING es_cab3-zzitepbt_total. "I-100120-NTP-3000013055

ENDFORM.                    "obtenercab3


*&---------------------------------------------------------------------*
*&      Form  obtenerdetalle
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->IT_DETAIL      text
*      -->IS_CAB         text
*      -->IS_CONSEXTSUN  text
*      -->ET_DET         text
*----------------------------------------------------------------------*
FORM obtenerdetalle USING is_cab type zoses_fegrcab
                          it_detail TYPE zostt_fegrdet
                    CHANGING et_det TYPE zosfett_data_det_gr
                             es_cab3 TYPE zosfees_data_cab3_gr.

  DATA: ls_detail LIKE LINE OF it_detail,
        ls_det    LIKE LINE OF et_det,
        l_pbt_tot TYPE lips-brgew,                                                "I-WMR-070318-3000008769
        lt_string TYPE TABLE OF string,                                           "I-051219-NTP-3000013055
        ls_string LIKE LINE OF lt_string.                                         "I-051219-NTP-3000013055


  LOOP AT it_detail INTO ls_detail.

    MOVE-CORRESPONDING ls_detail TO ls_det.

    "String
    PERFORM convert_to_string USING ls_det-zzitepos CHANGING ls_det-zzitepos_string.
    PERFORM convert_to_string USING ls_det-zziteqty CHANGING ls_det-zziteqty_string.
    PERFORM convert_to_string USING ls_det-zzitepbr CHANGING ls_det-zzitepbr_string.
    PERFORM convert_to_string USING ls_det-zzitepbt CHANGING ls_det-zzitepbt_string.

    "Totales
*    ADD ls_det-zzitepbt TO es_cab3-zzitepbt_total. "E-100120-NTP-3000013055

    APPEND ls_det TO et_det.
    CLEAR ls_det.
  ENDLOOP.

*{I-051219-NTP-3000013055
  "Adicionar linea vacia
  APPEND ls_det TO et_det.

  " Textos adicionales
  SPLIT is_cab-zztdadi1 AT '#' INTO TABLE lt_string.  "I-051219-NTP-3000013055
  LOOP AT lt_string INTO ls_string.
    ls_det-zzitedes = ls_string.
    APPEND ls_det TO et_det.
    CLEAR ls_det.
  ENDLOOP.
*}I-051219-NTP-3000013055

*{  BEGIN OF INSERT WMR-070318-3000008769
  CASE gw_license.
    WHEN '0020886706'.  " PIRAMIDE
      l_pbt_tot = es_cab3-zzitepbt_total / 1000.
      es_cab3-zzitepbt_total = l_pbt_tot.
  ENDCASE.
*}  END OF INSERT WMR-070318-3000008769

ENDFORM.                    "obtenerdetalle


*----------------------------------------------------------------------*
FORM aumentarlineasvacias_detalle CHANGING et_det TYPE zosfett_data_det_gr.

  DATA: l_lineas       TYPE i,
        l_lineas_total TYPE i,
        ls_det         LIKE LINE OF et_det.


  l_lineas_total = 30.


  "Aumentar a 30 lineas para el reporte
  l_lineas = lines( et_det ).
  l_lineas = l_lineas_total - l_lineas.

  DO l_lineas TIMES.
    APPEND ls_det TO et_det.
  ENDDO.

ENDFORM.                    "aumentarlineas_reporte


*&---------------------------------------------------------------------*
FORM convert_to_string USING input TYPE any
                       CHANGING output TYPE string.

  DATA l_char20 TYPE char20.

  WRITE input TO l_char20.
  CONDENSE l_char20.
  output = l_char20.

ENDFORM.                    "convert_to_string
