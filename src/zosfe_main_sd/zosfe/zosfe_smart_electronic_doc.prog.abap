*&---------------------------------------------------------------------*
*& Report  ZOSFE_SMART_FACTURA_VENTA
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zosfe_smart_electronic_doc.

TYPE-POOLS: abap.

DATA: gw_license TYPE string.                                         "I-WMR-020517-3000007140


*{Replicar al smartforms
TYPES: tab_string TYPE TABLE OF string WITH DEFAULT KEY.

TYPES: BEGIN OF ty_cab3,
         xblnr                 TYPE vbrk-xblnr,
         nomsun                TYPE zostb_tcurt-nomsun,
         bukrs_logo            TYPE string,
         bukrs_tel_number      TYPE string,
         bukrs_fax_number      TYPE string,
         text1                 TYPE t052u-text1,

         zz_tipodoc_string     TYPE string,
         zz_femision_string    TYPE char10,
         zz_fec_vto_string     TYPE char10,
         zz_tip_ope_string     TYPE string,
         zz_vbeln_zz_entrega   TYPE string,
         zz_inco1_zz_inco2     TYPE string,
         zz_country_string     TYPE string,

         zz_desctot_string     TYPE string,
         zz_desctoglob_string  TYPE string,
         zz_totvvopinaf_string TYPE string,
         zz_imptotvent_string  TYPE string,
         zz_text_head          TYPE string,   "I-NTP290317-3000006749
         zz_fecdocmodif_string TYPE string,   "I-251021-NTP-3000017871

         "Texto constantes de impresion
         texto_electronica     TYPE string,
         texto_tipo_operacion  TYPE string,
       END OF ty_cab3,

       BEGIN OF ty_guirem,                    "I-WMR-220617-3000007448
         line TYPE string,   "I-WMR-220617-3000007448
       END OF ty_guirem,                      "I-WMR-220617-3000007448

       BEGIN OF ty_det.
    INCLUDE TYPE zostb_docexposde.
TYPES: zz_nroposicion_string  TYPE string,
       zz_material_string     TYPE string,    "I-NTP290317-3000006749
       zz_text_pos_tab        TYPE tab_string,
       zz_cantidad_string     TYPE string,
       zz_precioventa_string  TYPE string,
       zz_valunitario_string  TYPE string,
       zz_desctoxite_string   TYPE string,
       zz_afectigv0102_string TYPE string,
       zz_tipisc0102_string   TYPE string,
       zz_valvenxite_string   TYPE string,
       END OF ty_det.

TYPES: tt_det TYPE TABLE OF ty_det.
*}Replicar al smartforms



*----------------------------------------------------------------------*
FORM obtenerdatos_formulario USING is_data          TYPE zosfees_data_nojson
                             CHANGING es_cab        TYPE zostb_docexposca
                                      es_cab2       TYPE zostb_docexposc2
                                      es_cab3       TYPE ty_cab3
                                      es_cab4       TYPE zostb_docexpostc
                                      es_guirem     TYPE ty_guirem            "I-WMR-220617-3000007448
                                      es_consextsun TYPE zostb_consextsun
                                      et_det        TYPE tt_det ##CALLED.

  DATA: ls_header LIKE LINE OF is_data-t_text_header. "I-090920-NTP-3000015152

  CALL FUNCTION 'SLIC_GET_LICENCE_NUMBER'                             "I-WMR-020517-3000007140
    IMPORTING
      license_number = gw_license.

* Pais
  SET COUNTRY 'PE'.

* CABECERA 1 y 2
  READ TABLE is_data-t_header       INTO es_cab  INDEX 1.
  READ TABLE is_data-t_header2      INTO es_cab2 INDEX 1.

  "Determinar tipo de comprobante Sunat
  SELECT SINGLE * INTO es_consextsun FROM zostb_consextsun WHERE bukrs = es_cab-bukrs.

*{I-090920-NTP-3000015152
  CASE gw_license.
    WHEN '0020311006'  "AIB
      OR '0020863116'. "AIB CLOUD
      LOOP AT is_data-t_text_header INTO ls_header.
        IF es_cab4-zz_text_head IS INITIAL.
          es_cab4-zz_text_head = ls_header-zz_text_head.
        ELSE.
          CONCATENATE es_cab4-zz_text_head ls_header-zz_text_head INTO es_cab4-zz_text_head SEPARATED BY space.
        ENDIF.
      ENDLOOP.

*}I-090920-NTP-3000015152
    WHEN OTHERS.
      READ TABLE is_data-t_text_header  INTO es_cab4 INDEX 1.
  ENDCASE.


  "Nombre del emisor en mayuscula
  TRANSLATE es_cab2-zz_nempreex TO UPPER CASE.

  "Direccion
  TRANSLATE es_cab-zz_street2     TO UPPER CASE.
  TRANSLATE es_cab-zz_house_num12 TO UPPER CASE.
  TRANSLATE es_cab-zz_str_suppl12 TO UPPER CASE.
  TRANSLATE es_cab-zz_city12      TO UPPER CASE.
  TRANSLATE es_cab-zz_city12      TO UPPER CASE.
  TRANSLATE es_cab-zz_city12      TO UPPER CASE.
  TRANSLATE es_cab-zz_country2    TO UPPER CASE.


  "Importes vacios
  IF es_cab2-zz_tot_seguro IS INITIAL.
    es_cab2-zz_tot_seguro = '0.00'.
  ENDIF.
  IF es_cab2-zz_tot_flete IS INITIAL.
    es_cab2-zz_tot_flete = '0.00'.
  ENDIF.
  IF es_cab2-zz_tot_otros IS INITIAL.                                 "I-WMR-040517-3000007140
    es_cab2-zz_tot_otros = '0.00'.                                    "I-WMR-040517-3000007140
  ENDIF.                                                              "I-WMR-040517-3000007140


* CABECERA 3
  PERFORM obtenercab3 USING es_cab es_cab2 es_consextsun CHANGING es_cab3.

*{  BEGIN OF INSERT WMR-220617-3000007448
  PERFORM obtener_guirem USING is_data-t_guirem CHANGING es_guirem.
*}  END OF INSERT WMR-220617-3000007448


* DETALLE
  PERFORM obtenerdetalle USING is_data-t_detail es_cab es_consextsun CHANGING et_det.


* NRO DE LINEAS
  PERFORM aumentarlineasvacias_detalle USING es_cab2 CHANGING et_det.


ENDFORM.                    "obtenercabecera3_formulario


*----------------------------------------------------------------------*
FORM obtenercab3 USING is_cab TYPE zostb_docexposca
                       is_cab2 TYPE zostb_docexposc2
                       is_consextsun TYPE zostb_consextsun
                 CHANGING es_cab3 TYPE ty_cab3.

  DATA: ls_cat17 TYPE zostb_catalogo17,
        ls_cat51 TYPE zostb_catalogo51,                               "I-080720-NTP-3000014674
        ls_vbrk  TYPE vbrk,
        ls_t001  TYPE t001,                                           "I-WMR-020517-3000007140
        l_string TYPE string.                                         "I-WMR-020517-3000007140


  "Textos
  es_cab3-texto_electronica    = 'ELECTRONICA'.
  es_cab3-texto_tipo_operacion = 'TIPO DE OPERACIÓN:'.


  "Telefono y Fax
  SELECT SINGLE a~tel_number ##WARN_OK
                a~fax_number
    INTO (es_cab3-bukrs_tel_number,
          es_cab3-bukrs_fax_number)
    FROM adrc AS a INNER JOIN t001 AS b ON a~addrnumber = b~adrnr "#EC CI_BUFFJOIN
    WHERE b~bukrs = is_cab-bukrs
      AND a~nation = space
      AND a~date_from = '00010101'.


  "Fecha de emisión
  CONCATENATE is_cab-zz_femision+6(2)
              is_cab-zz_femision+4(2)
              is_cab-zz_femision(4)
              INTO es_cab3-zz_femision_string SEPARATED BY '/'.


  "Fecha de vencimiento
  CONCATENATE is_cab2-zz_fec_vto+8(2)
              is_cab2-zz_fec_vto+5(2)
              is_cab2-zz_fec_vto(4)
              INTO es_cab3-zz_fec_vto_string SEPARATED BY '/'.

  "Fecha de doc modif
  CONCATENATE is_cab2-zz_fecdocmodif+6(2)
              is_cab2-zz_fecdocmodif+4(2)
              is_cab2-zz_fecdocmodif(4)
              INTO es_cab3-zz_fecdocmodif_string SEPARATED BY '/'.

  "Pedido/Entrega
  IF is_cab2-zz_entrega IS INITIAL.
    es_cab3-zz_vbeln_zz_entrega = is_cab-zz_vbeln.
  ELSE.
    CONCATENATE is_cab-zz_vbeln is_cab2-zz_entrega INTO es_cab3-zz_vbeln_zz_entrega SEPARATED BY ' / '.
  ENDIF.


  "Incoterm
  CONCATENATE is_cab-zz_inco1 is_cab2-zz_inco2 INTO es_cab3-zz_inco1_zz_inco2 SEPARATED BY ' - '.

  "Moneda
  SELECT SINGLE nomsun INTO es_cab3-nomsun ##WARN_OK
    FROM zostb_tcurt
    WHERE waers = is_cab-zz_moneda
      AND begda <= is_cab-zz_femision
      AND endda >= is_cab-zz_femision.

  "Pais
  SELECT SINGLE landx INTO es_cab3-zz_country_string
    FROM t005t
    WHERE spras = sy-langu
      AND land1 = is_cab-zz_country.

  TRANSLATE es_cab3-zz_country_string TO UPPER CASE.

  "Texto incoterm
  IF is_cab-zz_zterm IS NOT INITIAL.
    SELECT SINGLE text1 INTO es_cab3-text1
      FROM t052u
      WHERE spras = sy-langu
        AND zterm = is_cab-zz_zterm
        AND ztagg = space.

*{  BEGIN OF INSERT WMR-020517-3000007140
    CASE gw_license.
      WHEN '0020974592'.  " Danper
*{I-NTP130318-3000008836
        IF sy-tcode = 'ZSDOS038'.
          PERFORM amp01_get_zterm_zlsch IN PROGRAM zossd_rpt_moni_fact_acep IF FOUND
            CHANGING es_cab3-text1.
        ELSE.
*}I-NTP130318-3000008836
          " Obtener País de la Sociedad
          CLEAR ls_t001.
          SELECT SINGLE land1 INTO ls_t001-land1 FROM t001 WHERE bukrs EQ is_cab-bukrs.

          SELECT SINGLE zlsch INTO ls_vbrk-zlsch
            FROM vbrk WHERE vbeln EQ is_cab-zz_nrodocsap.

          " Obtener Descripción de la Vía de Pago
          CLEAR l_string.
          SELECT SINGLE text2 INTO l_string FROM t042zt
            WHERE spras EQ sy-langu AND land1 EQ ls_t001-land1 AND zlsch EQ ls_vbrk-zlsch.
          IF l_string IS NOT INITIAL.
            " Concatenar Denominación de Condición de Pago y Descripción de la Vía de Pago
            CONCATENATE es_cab3-text1 '-' l_string INTO es_cab3-text1 SEPARATED BY space.
          ENDIF.
        ENDIF.
    ENDCASE.
*}  END OF INSERT WMR-020517-3000007140
  ENDIF.


  "Logo
  CONCATENATE 'ZOSLOGOCR' is_cab-bukrs INTO es_cab3-bukrs_logo SEPARATED BY '_'.


  "Referencia sunat
  SELECT SINGLE xblnr INTO es_cab3-xblnr FROM vbrk WHERE vbeln = is_cab-zz_nrodocsap.


  "Tipo de operacion
  IF is_cab2-zz_tip_ope IS NOT INITIAL.
    CASE is_cab-zz_verubl.
      WHEN '2.0'.
        SELECT SINGLE * INTO ls_cat17 FROM zostb_catalogo17 WHERE zz_codigo_sunat = is_cab2-zz_tip_ope.
        CONCATENATE is_cab2-zz_tip_ope ls_cat17-zz_desc_cod_suna INTO es_cab3-zz_tip_ope_string SEPARATED BY ' - '.
*{I-080720-NTP-3000014674
      WHEN '2.1'.
        SELECT SINGLE * INTO ls_cat51 FROM zostb_catalogo51 WHERE codsun = is_cab2-zz_tip_ope.
        CONCATENATE is_cab2-zz_tip_ope ls_cat51-dessun INTO es_cab3-zz_tip_ope_string SEPARATED BY ' - '.
*}I-080720-NTP-3000014674
      WHEN OTHERS.
    ENDCASE.

  ENDIF.


  "Importes Totales a string
  PERFORM convert_to_string USING is_cab-zz_desctot CHANGING es_cab3-zz_desctot_string.
  PERFORM convert_to_string USING is_cab-zz_desctoglob CHANGING es_cab3-zz_desctoglob_string.
  PERFORM convert_to_string USING is_cab-zz_totvvopinaf CHANGING es_cab3-zz_totvvopinaf_string.
  PERFORM convert_to_string USING is_cab-zz_imptotvent CHANGING es_cab3-zz_imptotvent_string.



* Tipo de comprobante Sunat y ajustes
  CASE is_cab-zz_tipodoc.
    WHEN is_consextsun-zz_tdocfactura.
      es_cab3-zz_tipodoc_string = 'FACTURA'.

    WHEN is_consextsun-zz_tdocboleta.
      es_cab3-zz_tipodoc_string = 'BOLETA DE VENTA'.

    WHEN is_consextsun-zz_tdocnotacre.
      es_cab3-zz_tipodoc_string = 'NOTA DE CRÉDITO'.

      IF  gw_license <> '0020311006'  "AIB
      AND gw_license <> '0020863116'. "AIB CLOUD
        PERFORM limpiarcampos_notacredeb CHANGING is_cab is_cab2 es_cab3.
      ENDIF.

    WHEN is_consextsun-zz_tdocnotadeb.
      es_cab3-zz_tipodoc_string = 'NOTA DE DÉBITO'.

      CASE gw_license.                                                    "I-WMR-15122021-3000018127
        WHEN '0020311006'.  " AIB                                         "I-WMR-15122021-3000018127
        WHEN '0020863116'.  " AIB CLOUD
        WHEN OTHERS.                                                      "I-WMR-15122021-3000018127
          PERFORM limpiarcampos_notacredeb CHANGING is_cab is_cab2 es_cab3.
      ENDCASE.                                                            "I-WMR-15122021-3000018127

  ENDCASE.


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
FORM obtenerdetalle USING it_detail TYPE zostt_docexposde
                          is_cab    TYPE zostb_docexposca
                          is_consextsun TYPE zostb_consextsun
                    CHANGING et_det TYPE tt_det.


  DATA: ls_detail LIKE LINE OF it_detail,
        ls_det    TYPE ty_det.

  DATA: l_posnr     TYPE numc3.



  LOOP AT it_detail INTO ls_detail.

    MOVE-CORRESPONDING ls_detail TO ls_det.


    "Nro de posicion segun tipo documento
    CASE is_cab-zz_tipodoc.
      WHEN is_consextsun-zz_tdocnotadeb OR
           is_consextsun-zz_tdocnotacre.
        ls_det-zz_nroposicion_string = l_posnr = sy-tabix.
      WHEN OTHERS.
        ls_det-zz_nroposicion_string = ls_det-zz_nroposicion+3(3).
    ENDCASE.


    "Texto de posición en tabla de cada #
    SPLIT ls_det-zz_text_pos AT '#' INTO TABLE ls_det-zz_text_pos_tab.


    "String
    ls_det-zz_material_string = ls_det-zz_material.     "I-NTP290317-3000006749
    PERFORM convert_to_string USING ls_det-zz_cantidad    CHANGING ls_det-zz_cantidad_string.
    PERFORM convert_to_string USING ls_det-zz_precioventa CHANGING ls_det-zz_precioventa_string.
    PERFORM convert_to_string USING ls_det-zz_valunitario CHANGING ls_det-zz_valunitario_string.
    PERFORM convert_to_string USING ls_det-zz_desctoxite  CHANGING ls_det-zz_desctoxite_string.
    PERFORM convert_to_string USING ls_det-zz_afectigv0102 CHANGING ls_det-zz_afectigv0102_string.
    PERFORM convert_to_string USING ls_det-zz_tipisc0102  CHANGING ls_det-zz_tipisc0102_string.
    PERFORM convert_to_string USING ls_det-zz_valvenxite  CHANGING ls_det-zz_valvenxite_string.

    APPEND ls_det TO et_det.
    CLEAR ls_det.
  ENDLOOP.

ENDFORM.                    "obtenerdetalle

*----------------------------------------------------------------------*
FORM limpiarcampos_notacredeb CHANGING cs_cab        TYPE zostb_docexposca ##NEEDED
                                       cs_cab2       TYPE zostb_docexposc2 ##NEEDED
                                       cs_cab3       TYPE ty_cab3.
  CLEAR: cs_cab3-text1,
         cs_cab3-zz_fec_vto_string,
         cs_cab3-zz_tip_ope_string,
         cs_cab3-zz_inco1_zz_inco2,
         cs_cab3-texto_tipo_operacion.
ENDFORM.                    "limpiarcampos_notacredeb

*----------------------------------------------------------------------*
FORM aumentarlineasvacias_detalle USING is_cab2   TYPE zostb_docexposc2
                                  CHANGING et_det TYPE tt_det.

  DATA: l_lineas       TYPE i,
        l_lineas_total TYPE i,
        ls_det         TYPE ty_det.

  DATA: lc_tipoexportacion TYPE string VALUE '02'. " Exportación


  CASE is_cab2-zz_tip_ope.
    WHEN lc_tipoexportacion.
      l_lineas_total = 25.
    WHEN OTHERS.
      l_lineas_total = 30.
  ENDCASE.

*{  BEGIN OF REPLACE WMR-230318-3000008836
  ""  "Aumentar a 30 lineas para el reporte
  ""  l_lineas = lines( et_det ).
  ""  l_lineas = l_lineas_total - l_lineas.

  ""  DO l_lineas TIMES.
  ""    APPEND ls_det TO et_det.
  ""  ENDDO.

  " Aumentar máximo 18 líneas para llegar a las líneas totales por página
  l_lineas = l_lineas_total - ( ( lines( et_det ) ) MOD l_lineas_total ).
  IF l_lineas > 18.
    l_lineas = 18.
  ENDIF.
  IF l_lineas > 0.
    DO l_lineas TIMES.
      APPEND ls_det TO et_det.
    ENDDO.
  ENDIF.
*}  END OF REPLACE WMR-230318-3000008836

ENDFORM.                    "aumentarlineas_reporte


*&---------------------------------------------------------------------*
FORM convert_to_string USING input TYPE any
                       CHANGING output TYPE string.

  DATA l_char20 TYPE char20.

  WRITE input TO l_char20 DECIMALS 2.
  CONDENSE l_char20.
  output = l_char20.

ENDFORM.                    "convert_to_string
*{  BEGIN OF INSERT WMR-220617-3000007448
*&---------------------------------------------------------------------*
*&      Form  OBTENER_GUIREM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IS_DATA_T_GUIREM  text
*      <--P_ES_GUIREM  text
*----------------------------------------------------------------------*
FORM obtener_guirem  USING    it_guirem TYPE zosfett_docexposgr
                     CHANGING es_guirem TYPE ty_guirem.

  DATA: ls_guirem TYPE zostb_docexposgr.

  CHECK it_guirem[] IS NOT INITIAL.

  LOOP AT it_guirem INTO ls_guirem WHERE xblnr IS NOT INITIAL.
    IF es_guirem-line IS INITIAL.
      es_guirem-line = ls_guirem-xblnr.
    ELSE.
      CONCATENATE es_guirem-line ls_guirem-xblnr INTO es_guirem-line SEPARATED BY '; '.
    ENDIF.
  ENDLOOP.

ENDFORM.
*}  END OF INSERT WMR-220617-3000007448
