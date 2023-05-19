*----------------------------------------------------------------------*
***INCLUDE LZOSGF_IDCPF01.
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  GET_CONST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_const .

  DATA: lt_const TYPE TABLE OF zostb_const_fe,
        ls_const LIKE LINE OF lt_const.

  DATA: ls_fkart_anu LIKE LINE OF gr_fkart_anu,
        ls_fkart_not LIKE LINE OF gr_fkart_not,
*{  BEGIN OF INSERT WMR-030615
        ls_augru     LIKE LINE OF gr_augru_mde,
*}  END OF INSERT WMR-030615
        ls_motsref   LIKE LINE OF gr_motsref.                             "I-WMR-261118-3000009765

  SELECT *
  FROM zostb_const_fe
  INTO TABLE lt_const
  WHERE modulo      = gc_mod
    AND aplicacion  = gc_apl
    AND programa    = gc_prg.

  CHECK sy-subrc EQ 0.

  REFRESH: gr_fkart_anu, gr_fkart_not.
  LOOP AT lt_const INTO ls_const.
    CASE ls_const-campo.
      WHEN gc_cama. "Facturas anuladas
        ls_fkart_anu-sign   = ls_const-signo.
        ls_fkart_anu-option = ls_const-opcion.
        ls_fkart_anu-low    = ls_const-valor1.
        ls_fkart_anu-high   = ls_const-valor2.
        APPEND ls_fkart_anu TO gr_fkart_anu.
      WHEN gc_cam. "Notas
        ls_fkart_not-sign   = ls_const-signo.
        ls_fkart_not-option = ls_const-opcion.
        ls_fkart_not-low    = ls_const-valor1.
        APPEND ls_fkart_not TO gr_fkart_not.
*{  BEGIN OF INSERT WMR-030615
      WHEN 'AUGRUMDE'.    " Motivos NC/ND que aplican máximo de días de emisión
        CLEAR ls_augru.
        ls_augru-sign       = ls_const-signo.
        ls_augru-option     = ls_const-opcion.
        ls_augru-low        = ls_const-valor1.
        ls_augru-high       = ls_const-valor2.
        APPEND ls_augru TO gr_augru_mde.
*}  END OF INSERT WMR-030615
    ENDCASE.
  ENDLOOP.

*{  BEGIN OF INSERT WMR-261118-3000009765
  SELECT *
  FROM zostb_const_fe
  INTO TABLE lt_const
  WHERE modulo      = gc_mod
    AND aplicacion  = gc_apl
    AND programa    = 'ZOSSD_PRO_EXTRAC'.

  REFRESH gr_motsref.
  LOOP AT lt_const INTO ls_const.
    CASE ls_const-campo.
      WHEN 'MOTNDSRE'." Motivo ND sin referencia documento que modifica
        CLEAR ls_motsref.
        ls_motsref-sign   = ls_const-signo.
        ls_motsref-option = ls_const-opcion.
        ls_motsref-low    = ls_const-valor1.
        ls_motsref-high   = ls_const-valor2.
        APPEND ls_motsref TO gr_motsref.
      WHEN 'FECFAC'.
        gw_fecfac_d = ls_const-valor1.
    ENDCASE.
  ENDLOOP.
*}  END OF INSERT WMR-261118-3000009765

*{  BEGIN OF INSERT WMR-150119-3000011134
  " Nro. Instalación Sap
  CALL FUNCTION 'SLIC_GET_LICENCE_NUMBER'
    IMPORTING
      license_number = gw_license.
*}  END OF INSERT WMR-150119-3000011134

ENDFORM.                    " GET_CONST

*&---------------------------------------------------------------------*
*&      Form  chk_values
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PI_VBELN   text
*      -->PO_ERROR   text
*----------------------------------------------------------------------*
FORM chk_values USING pi_vbeln TYPE vbeln_vf
             CHANGING po_error TYPE char1
                      po_rgtno TYPE rgtno
                      ps_idcn_loma  TYPE idcn_loma.           "I-WMR-290915

  DATA: lw_lotno TYPE zostb_lotno-lotno,
        lw_aubel TYPE vbrp-aubel,
        lw_xblnr TYPE vbrk-xblnr,
        lw_vgbel TYPE vbap-vgbel.

  FIELD-SYMBOLS: <fs> TYPE any.

* Limpiar datos globales
  CLEAR: gs_vbrk, gs_vbrk_ref,
         gs_vbak_solncnd.                                     "I-WMR-270815

* Verificar transacción
  IF sy-tcode NE 'IDCP'.
    po_error = abap_true.
    EXIT.
  ENDIF.

* Verificamos es factura
  SELECT SINGLE *
  FROM vbrk
  INTO gs_vbrk
  WHERE vbeln EQ pi_vbeln.
  IF sy-subrc NE 0.
    po_error = abap_true.
    EXIT.
  ENDIF.

* Validar serie
  ASSIGN ('(IDPRCNINVOICE)LOTNO') TO <fs>.
  IF sy-subrc EQ 0.
*{  BEGIN OF REPLACE WMR-290915
    ""    SELECT SINGLE rgtno
    ""    FROM idcn_loma
    ""    INTO po_rgtno
    ""*{  BEGIN OF REPLACE WMR-010815
    """"    WHERE lotno EQ <fs>.
    ""    WHERE bukrs EQ gs_vbrk-bukrs
    ""      AND lotno EQ <fs>.
    ""*}  END OF REPLACE WMR-010815
    ""    IF sy-subrc EQ 0.
    SELECT SINGLE *
      INTO ps_idcn_loma
      FROM idcn_loma
      WHERE bukrs EQ gs_vbrk-bukrs
        AND lotno EQ <fs>.
    IF sy-subrc EQ 0.
      po_rgtno = ps_idcn_loma-rgtno.
*}  END OF REPLACE WMR-290915
      SHIFT po_rgtno LEFT DELETING LEADING '0'.                         "I-WMR-190918-3000009765
      SELECT SINGLE lotno
      INTO lw_lotno
      FROM zostb_lotno
      WHERE lotno = po_rgtno.                                           "I-WMR-190918-3000009765
*      WHERE lotno EQ po_rgtno+1.                                        "E-WMR-190918-3000009765
    ENDIF.
  ENDIF.
  IF lw_lotno IS INITIAL.
    po_error = abap_true.
    EXIT.
  ENDIF.

* Obtener Comprobante referenciado (casos NC y ND)
  IF gs_vbrk-fkart IN gr_fkart_not.
*   Caso con Referencia
    SELECT SINGLE aubel
    FROM vbrp
    INTO lw_aubel
    WHERE vbeln EQ gs_vbrk-vbeln.
    IF sy-subrc EQ 0.
      SELECT SINGLE vgbel
      FROM vbap
      INTO lw_vgbel
      WHERE vbeln EQ lw_aubel.
      IF lw_vgbel IS INITIAL.                                               "I-WMR-030216
        " Si no está a nivel de posición, se busca a nivel de cabecera      "I-WMR-030216
        SELECT SINGLE vgbel                                                 "I-WMR-030216
          INTO lw_vgbel                                                     "I-WMR-030216
          FROM vbak                                                         "I-WMR-030216
          WHERE vbeln EQ lw_aubel.                                          "I-WMR-030216
      ENDIF.                                                                "I-WMR-030216
      ""      IF sy-subrc EQ 0.                                                     "E-WMR-030216
      IF lw_vgbel IS NOT INITIAL.                                           "I-WMR-030216
        SELECT SINGLE *
        FROM vbrk
        INTO gs_vbrk_ref
        WHERE vbeln EQ lw_vgbel
          AND fksto EQ space
          AND fkart NOT IN gr_fkart_anu.
      ENDIF.
    ENDIF.
*   Caso sin referencia
    IF gs_vbrk_ref IS INITIAL.
      SELECT SINGLE xblnr
      FROM vbak
      INTO lw_xblnr
      WHERE vbeln EQ lw_aubel.
      IF sy-subrc EQ 0.
        SELECT SINGLE *
        FROM vbrk
        INTO gs_vbrk_ref
        WHERE xblnr EQ lw_xblnr
          AND fksto EQ space
          AND fkart NOT IN gr_fkart_anu.
        IF sy-subrc NE 0.                                     "I-WMR-270815
          " Si no existe Factura en el Sistema,               "I-WMR-270815
          " tomar Referencia SUNAT de la solicitud NC/ND      "I-WMR-270815
          SELECT SINGLE vbeln xblnr                           "I-WMR-270815
            INTO (gs_vbak_solncnd-vbeln,                      "I-WMR-270815
                  gs_vbak_solncnd-xblnr)                      "I-WMR-270815
            FROM vbak                                         "I-WMR-270815
            WHERE vbeln EQ lw_aubel.                          "I-WMR-270815
        ENDIF.                                                "I-WMR-270815
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.                    " CHK_VALUES

*&---------------------------------------------------------------------*
*&      Form  chk_lotno
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PI_RGTNO   text
*----------------------------------------------------------------------*
FORM chk_lotno USING pi_rgtno TYPE rgtno
                     ps_idcn_loma TYPE idcn_loma.             "I-WMR-290915

  DATA: lw_doccls TYPE doccls.
  DATA: ls_sunat   TYPE ty_sunat,                              "I-WMR-270815
        ls_t003_i  TYPE t003_i,                                "I-WMR-290915
        ls_excep   TYPE zostb_t003_i,                          "I-WMR-150716
        lw_length  TYPE i,                                     "I-WMR-270815
        l_continue TYPE xfeld.                                          "I-WMR-261118-3000009765

  " Verificar Clase de documento oficial vs Tipo formulario   "I-WMR-290915
  SELECT SINGLE t~land1 t~blart t~doccls                      "I-WMR-290915
    INTO CORRESPONDING FIELDS OF ls_t003_i                    "I-WMR-290915
    FROM tvfk AS b INNER JOIN t003_i AS t                     "I-WMR-290915
    ON t~blart EQ b~blart                                     "I-WMR-290915
    WHERE b~fkart EQ gs_vbrk-fkart                            "I-WMR-290915
      AND t~land1 EQ gc_peru.                                 "I-WMR-290915
  IF sy-subrc EQ 0.                                           "I-WMR-290915
    IF ls_t003_i-doccls NE ps_idcn_loma-invtp.                "I-WMR-290915
*{  BEGIN OF REPLACE WMR-150716
      ""      RAISE error_pila.                                       "I-WMR-290915

      " Excepción por clase de factura
      CLEAR ls_excep.
      SELECT SINGLE *
        INTO ls_excep
        FROM zostb_t003_i
        WHERE land1 EQ gc_peru
          AND fkart EQ gs_vbrk-fkart.
      IF sy-subrc EQ 0.
        IF ls_excep-doccls NE ps_idcn_loma-invtp.
          RAISE error_pila.
        ENDIF.
      ELSE.
        RAISE error_pila.
      ENDIF.
*}  END OF REPLACE WMR-150716
    ENDIF.                                                    "I-WMR-290915
  ENDIF.                                                      "I-WMR-290915

* Caso Facturas y boletas
  IF gs_vbrk-fkart NOT IN gr_fkart_not.
    SELECT SINGLE a~doccls
    FROM t003_i AS a INNER JOIN tvfk AS b ON a~blart = b~blart
    INTO lw_doccls
    WHERE b~fkart = gs_vbrk-fkart
*{  BEGIN OF INSERT WMR-160615
      AND a~land1 EQ gc_peru.
*}  END OF INSERT WMR-160615

*{  BEGIN OF INSERT WMR-150716
    " Excepción por clase de factura
    CLEAR ls_excep.
    SELECT SINGLE *
      INTO ls_excep
      FROM zostb_t003_i
      WHERE land1 EQ gc_peru
        AND fkart EQ gs_vbrk-fkart.
    IF sy-subrc EQ 0.
      lw_doccls = ls_excep-doccls.
    ENDIF.
*}  END OF INSERT WMR-150716

*    CASE pi_rgtno+1(1).                                                 "E-WMR-190918-3000009765
    CASE pi_rgtno(1).                                                   "I-WMR-190918-3000009765
      WHEN gc_charf.
        IF lw_doccls <> gc_tipdoc_fa.
          RAISE error_serie.
        ENDIF.
      WHEN gc_charb.
        IF lw_doccls <> gc_tipdoc_bl.
          RAISE error_serie.
        ENDIF.
    ENDCASE.
  ENDIF.

* Caso Notas de Crédito y Débito (buscamos con documento referenciado)
  IF gs_vbrk-fkart IN gr_fkart_not
*{  BEGIN OF INSERT WMR-030615
  AND gr_fkart_not[] IS NOT INITIAL.
*}  END OF INSERT WMR-030615
    IF gs_vbrk_ref IS NOT INITIAL.                            "I-WMR-270815
      SELECT SINGLE a~doccls
      FROM t003_i AS a INNER JOIN tvfk AS b ON a~blart = b~blart
      INTO lw_doccls
      WHERE b~fkart = gs_vbrk_ref-fkart
*{  BEGIN OF INSERT WMR-160615
        AND a~land1 EQ gc_peru.
*}  END OF INSERT WMR-160615

*{  BEGIN OF INSERT WMR-150716
      " Excepción por clase de factura
      CLEAR ls_excep.
      SELECT SINGLE *
        INTO ls_excep
        FROM zostb_t003_i
        WHERE land1 EQ gc_peru
          AND fkart EQ gs_vbrk_ref-fkart.
      IF sy-subrc EQ 0.
        lw_doccls = ls_excep-doccls.
      ENDIF.
*}  END OF INSERT WMR-150716

*      CASE pi_rgtno+1(1).                                               "E-WMR-190918-3000009765
      CASE pi_rgtno(1).                                                 "I-WMR-190918-3000009765
        WHEN gc_charf.
          IF lw_doccls <> gc_tipdoc_fa.
            RAISE error_serie.
          ENDIF.
        WHEN gc_charb.
          IF lw_doccls <> gc_tipdoc_bl.
            RAISE error_serie.
          ENDIF.
      ENDCASE.

*{  BEGIN OF INSERT WMR-270815
    ELSEIF  gs_vbak_solncnd IS NOT INITIAL.

      PERFORM valida_ncnd_sin_referencia USING    gs_vbrk               "I-WMR-261118-3000009765
                                                  ps_idcn_loma          "I-WMR-261118-3000009765
                                         CHANGING l_continue.           "I-WMR-261118-3000009765

      IF l_continue = abap_true.                                        "I-WMR-261118-3000009765
        CLEAR ls_sunat.
        SPLIT gs_vbak_solncnd-xblnr AT '-'
          INTO ls_sunat-tipo
               ls_sunat-serie
               ls_sunat-numro.

        " Tipo comprobante
        lw_length = strlen( ls_sunat-tipo ).
        IF  lw_length EQ 2
        AND ls_sunat-tipo CO '0123456789'.
        ELSE.
          RAISE error_serie.
        ENDIF.

        " Serie
        lw_length = strlen( ls_sunat-serie ).
        IF  ( lw_length EQ 4 OR lw_length EQ 5 ).
        ELSE.
          RAISE error_serie.
        ENDIF.

        " Número
        lw_length = strlen( ls_sunat-numro ).
        IF  ( lw_length EQ 7 OR lw_length EQ 8 )
        AND ls_sunat-numro CO '0123456789'.
        ELSE.
          RAISE error_serie.
        ENDIF.

        " Verificar que debe ser con referencia a Factura o Boleta
        CASE ls_sunat-tipo.
          WHEN gc_tipdoc_fa.
          WHEN gc_tipdoc_bl.
          WHEN OTHERS.
            RAISE error_serie.
        ENDCASE.
      ENDIF.                                                            "I-WMR-261118-3000009765
    ENDIF.
*}  END OF INSERT WMR-270815
  ENDIF.

ENDFORM.                    "chk_lotno

*&---------------------------------------------------------------------*
*&      Form  chk_correl
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM chk_correl.

  DATA: ls_idcn_boma_1 TYPE idcn_boma,
        ls_idcn_boma_2 TYPE idcn_boma.
  FIELD-SYMBOLS: <fs> TYPE any.

* Obtener correlativo que esta por usarse
  ASSIGN ('(IDPRCNINVOICE)IDCN_BOMA') TO <fs>.
  IF sy-subrc EQ 0.
    ls_idcn_boma_1 = <fs>.
  ENDIF.

  CHECK ls_idcn_boma_1 IS NOT INITIAL.

* Obtener el último correlativo usado
  SELECT SINGLE *
  FROM idcn_boma
  INTO ls_idcn_boma_2
  WHERE bukrs EQ ls_idcn_boma_1-bukrs
    AND lotno EQ ls_idcn_boma_1-lotno
    AND bokno EQ ls_idcn_boma_1-bokno.

* Validar
  IF ls_idcn_boma_1-liinv LE ls_idcn_boma_2-liinv.
    RAISE error_correla.
  ENDIF.

ENDFORM.                    "chk_correl

*&---------------------------------------------------------------------*
*&      Form  chk_fecfac
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PO_FECHA   text
*----------------------------------------------------------------------*
FORM chk_fecfac CHANGING po_fecha TYPE char10.

  DATA: lw_date TYPE datum.

* Fecha permitida
*{  BEGIN OF REPLACE WMR-231015
  ""  lw_date = sy-datum - gw_fecfac_d + 1. "gw_fecfac_d = 7
  lw_date = sy-datum - gw_fecfac_d.
*}  END OF REPLACE WMR-231015
  CONCATENATE lw_date+6(2)
              lw_date+4(2)
              lw_date+0(4)
              INTO po_fecha SEPARATED BY '.'.

* Validar
  IF gs_vbrk-fkdat LT lw_date.
    RAISE error_fecha_fac.
  ENDIF.

ENDFORM.                    " CHK_FECFAC

*&---------------------------------------------------------------------*
*&      Form  CHK_NOTAS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM chk_notas .

  DATA: ls_vbrk  TYPE vbrk,
        ls_felog TYPE zostb_felog,
        lw_aubel TYPE vbrp-aubel,
        lw_xblnr TYPE vbrk-xblnr,
        lw_vgbel TYPE vbap-vgbel,
        l_tipo   TYPE string,                                           "I-WMR-190918-3000009765
        l_numera TYPE zostb_felog-zzt_numeracion.                       "I-WMR-190918-3000009765

* Validar que se trate de una Nota de Crédito o Débito
  CHECK gs_vbrk-fkart IN gr_fkart_not
*{  BEGIN OF INSERT WMR-030615
        AND gr_fkart_not[] IS NOT INITIAL.
*}  END OF INSERT WMR-030615

* Validar que se haya encontrado comprobante referencia
  CHECK gs_vbrk_ref IS NOT INITIAL.

  SPLIT gs_vbrk_ref-xblnr AT '-' INTO l_tipo l_numera.                  "I-WMR-190918-3000009765
  SHIFT l_numera LEFT DELETING LEADING '0'.                             "I-WMR-190918-3000009765

* Obtener status SUNAT del comprobante de referencia y validar que esté aprobado
  SELECT SINGLE *
  FROM zostb_felog
  INTO ls_felog
  WHERE zzt_nrodocsap  EQ gs_vbrk_ref-vbeln
    AND zzt_numeracion EQ l_numera.                                     "I-WMR-190918-3000009765
*    AND zzt_numeracion EQ gs_vbrk_ref-xblnr+4.                          "E-WMR-190918-3000009765
  IF ( ls_felog-zzt_status_cdr <> 1 AND ls_felog-zzt_status_cdr <> 4 ).
    RAISE error_notas.
  ENDIF.

ENDFORM.                    " CHK_NOTAS

*&---------------------------------------------------------------------*
*&      Form  chk_fecnot
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PO_FECHA   text
*      -->PO_DIAS    text
*----------------------------------------------------------------------*
FORM chk_fecnot CHANGING po_fecha TYPE char10
                          po_dias TYPE char2.

  DATA: lt_constfkart TYPE STANDARD TABLE OF zostb_constfkart,
        ls_constfkart TYPE zostb_constfkart.

  DATA: lw_date  TYPE datum,
        lw_aubel TYPE vbeln_va,
        lw_augru TYPE augru.

  DATA: ltr_fkart TYPE RANGE OF vbrk-fkart,
        lsr_fkart LIKE LINE  OF ltr_fkart.

  CONSTANTS: lc_op1    TYPE zoesd_opcionselecc VALUE '9',
             lc_op2    TYPE zoesd_opcionselecc VALUE '2',
             lc_augru2 TYPE augru VALUE 'C02',
             lc_augru3 TYPE augru VALUE 'C03'.

* Validar que se trate de una Nota de Crédito o Débito
  CHECK gs_vbrk-fkart IN gr_fkart_not
*{  BEGIN OF INSERT WMR-030615
        AND gr_fkart_not[] IS NOT INITIAL.
*}  END OF INSERT WMR-030615

* Validar que se haya encontrado comprobante referencia
  CHECK gs_vbrk_ref IS NOT INITIAL.

* Definir constantes de días (15/10)
  SELECT SINGLE valor2 INTO po_dias
    FROM zostb_const_fe
    WHERE modulo      = gc_mod AND
          aplicacion  = gc_apl AND
          programa    = gc_prg AND
          campo       = gc_cam AND
          valor1      = gs_vbrk-fkart.

* Cargar constantes para NC
  SELECT * INTO TABLE lt_constfkart
    FROM zostb_constfkart
    WHERE zz_opcion01 = lc_op1 AND
          zz_opcion02 = lc_op2.

* Armar rango
  REFRESH ltr_fkart.
  LOOP AT lt_constfkart INTO ls_constfkart WHERE zz_opcion01 = lc_op1 AND zz_opcion02 = lc_op2.
    lsr_fkart-low    = ls_constfkart-fkart.
    lsr_fkart-sign   = 'I'.
    lsr_fkart-option = 'EQ'.
    APPEND lsr_fkart TO ltr_fkart.
  ENDLOOP.

* Ubicar Motivo de pedido (AUGRU)
  SELECT SINGLE aubel
  INTO lw_aubel
  FROM vbrp
  WHERE vbeln = gs_vbrk-vbeln.
  IF sy-subrc = 0.
    SELECT SINGLE augru
    INTO lw_augru
    FROM vbak
    WHERE vbeln = lw_aubel.
  ENDIF.

*{  BEGIN OF REPLACE WMR-030615
  ""  CHECK ( lw_augru = lc_augru2 OR lw_augru = lc_augru3 ).
  CHECK ( lw_augru IN gr_augru_mde AND gr_augru_mde[] IS NOT INITIAL ).
*}  END OF REPLACE WMR-030615
  CHECK ( gs_vbrk-fkart IN ltr_fkart ).

* Validar
  IF ( gs_vbrk-fkdat+6(2) GT po_dias ).
    CONCATENATE gs_vbrk-fkdat+0(4)
                gs_vbrk-fkdat+4(2)
                '01'
                INTO lw_date.
    CONCATENATE lw_date+6(2)
                lw_date+4(2)
                lw_date+0(4)
                INTO po_fecha SEPARATED BY '.'.
    IF gs_vbrk_ref-fkdat LT lw_date.
      RAISE error_fecha_not.
    ENDIF.
  ELSE.
    CALL FUNCTION 'HRAR_SUBTRACT_MONTH_TO_DATE'
      EXPORTING
        date                 = gs_vbrk-fkdat
      IMPORTING
        date_minus_one_month = lw_date.
    CONCATENATE lw_date+0(4)
                lw_date+4(2)
                '01'
                INTO lw_date.
    CONCATENATE lw_date+6(2)
                lw_date+4(2)
                lw_date+0(4)
                INTO po_fecha SEPARATED BY '.'.
    IF gs_vbrk_ref-fkdat LT lw_date.
      RAISE error_fecha_not.
    ENDIF.
  ENDIF.

ENDFORM.                    " CHK_FECNOT
*{  BEGIN OF INSERT WMR-140116
*&---------------------------------------------------------------------*
*&      Form  PRE_CHECKS_DELIVERY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pre_checks_delivery  USING     pi_vbeln TYPE likp-vbeln
                          CHANGING  po_fecha TYPE char10.

  DATA: lt_tlines    TYPE tline_tab,                                    "I-WMR-150119-3000011134
        ls_tvko      TYPE tvko,
        ls_idcn_loma TYPE idcn_loma,
        ls_lotno     TYPE zostb_lotno,
        ls_excep     TYPE zostb_t003_i,                     "I-WMR-020816-3000005346
        ls_t158      TYPE t158,
        ls_t003_i    TYPE t003_i,
        ls_thead     TYPE thead,                                        "I-WMR-150119-3000011134
        ls_vttk      TYPE vttk,                                         "I-WMR-150119-3000011134
        lw_error     TYPE xfeld,
        lw_date      TYPE datum.

  FIELD-SYMBOLS: <fs_value> TYPE any.

  " Limpiar datos globales
  CLEAR: gs_likp.

  " Verificar transacción
  IF sy-tcode NE 'IDCP'.
    lw_error = abap_true.
  ENDIF.

  CHECK lw_error EQ abap_false.

  " Verificamos si es entrega
  SELECT SINGLE *
    INTO gs_likp
    FROM likp
    WHERE vbeln EQ pi_vbeln.
  IF sy-subrc NE 0.
    lw_error = abap_true.
  ENDIF.

  CHECK lw_error EQ abap_false.

  " Validar Sociedad
  SELECT SINGLE vkorg bukrs
    INTO CORRESPONDING FIELDS OF ls_tvko
    FROM tvko
    WHERE vkorg EQ gs_likp-vkorg.
  IF sy-subrc NE 0.
    lw_error = abap_true.
  ENDIF.

  CHECK lw_error EQ abap_false.

  " Validar Serie permitida
  ASSIGN ('(IDPRCNINVOICE)LOTNO') TO <fs_value>.
  IF <fs_value> IS ASSIGNED.
  ELSE.
    lw_error = abap_true.
  ENDIF.

  CHECK lw_error EQ abap_false.

  SELECT SINGLE *
    INTO ls_idcn_loma
    FROM idcn_loma
    WHERE bukrs EQ ls_tvko-bukrs
      AND lotno EQ <fs_value>.

  IF sy-subrc EQ 0.
  ELSE.
    lw_error = abap_true.
  ENDIF.

  CHECK lw_error EQ abap_false.

  " Determinar Clase de documento FI
  SELECT SINGLE tcode blart
    INTO CORRESPONDING FIELDS OF ls_t158
    FROM t158
    WHERE tcode EQ gc_vl02n.

  IF sy-subrc EQ 0.
  ELSE.
    RAISE error_serie.
    lw_error = abap_true.
  ENDIF.

  CHECK lw_error EQ abap_false.

  " Determinar Clase de documento Oficial
  SELECT SINGLE land1 blart doccls
    INTO CORRESPONDING FIELDS OF ls_t003_i
    FROM t003_i
    WHERE land1 EQ gc_peru
      AND blart EQ ls_t158-blart.

  IF sy-subrc EQ 0.
  ELSE.
*{  BEGIN OF REPLACE WMR-020816-3000005346
    ""    RAISE error_serie.
    ""    lw_error = abap_true.

    " Excepción por clase de entrega
    CLEAR ls_excep.
    SELECT SINGLE *
      INTO ls_excep
      FROM zostb_t003_i
      WHERE land1 EQ gc_peru
        AND fkart EQ gs_likp-lfart.
    IF sy-subrc EQ 0.
      ls_t003_i-land1  = ls_excep-land1.
      ls_t003_i-doccls = ls_excep-doccls.
    ELSE.
      RAISE error_serie.
      lw_error = abap_true.
    ENDIF.
*}  END OF REPLACE WMR-020816-3000005346
  ENDIF.

  CHECK lw_error EQ abap_false.

  " Verificar Clase de documento oficial vs Tipo formulario
  IF ls_t003_i-doccls NE ls_idcn_loma-invtp.
    RAISE error_pila.
  ENDIF.

  " Verificar Serie autorizada por Sunat
  SHIFT ls_idcn_loma-rgtno LEFT DELETING LEADING '0'.                   "I-WMR-190918-3000009765
  SELECT SINGLE *
    INTO ls_lotno
    FROM zostb_lotno
    WHERE lotno EQ ls_idcn_loma-rgtno.                                  "I-WMR-190918-3000009765
*    WHERE lotno EQ ls_idcn_loma-rgtno+1.                                "E-WMR-190918-3000009765

  IF sy-subrc EQ 0.
  ELSE.
    lw_error = abap_true.
  ENDIF.

  CHECK lw_error EQ abap_false.

  " Verificar Serie seleccionada corresponda a Guía de Remisión
*  CASE ls_idcn_loma-rgtno+1(1).                                         "E-WMR-190918-3000009765
  CASE ls_idcn_loma-rgtno(1).                                           "I-WMR-190918-3000009765
    WHEN gc_chart.
      IF ls_t003_i-doccls NE gc_tipdoc_gr.
        lw_error = abap_true.
        RAISE error_pila.
      ENDIF.
    WHEN OTHERS.
      lw_error = abap_true.
      RAISE error_pila.
  ENDCASE.

  CHECK lw_error EQ abap_false.

  " Fecha permitida
  lw_date = sy-datum - gw_fecfac_d.
  CONCATENATE lw_date+6(2)
              lw_date+4(2)
              lw_date+0(4)
              INTO po_fecha SEPARATED BY '.'.

*{  BEGIN OF INSERT WMR-150119-3000011134
  CASE gw_license.
    WHEN '0021061097'.  " CMH
      " En caso que tenga texto Consignación, tomar Fecha de emisión = fecha fin de carga de transporte
      CLEAR ls_thead.
      ls_thead-tdobject = 'VBBK'.
      ls_thead-tdid     = 'ZE01'.
      ls_thead-tdname   = gs_likp-vbeln.
      SELECT SINGLE spras INTO ls_thead-tdspras FROM kna1 WHERE kunnr = gs_likp-kunag.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = ls_thead-tdid
          language                = ls_thead-tdspras
          name                    = ls_thead-tdname
          object                  = ls_thead-tdobject
        TABLES
          lines                   = lt_tlines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF lt_tlines[] IS INITIAL.
        ls_thead-tdspras = sy-langu.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id                      = ls_thead-tdid
            language                = ls_thead-tdspras
            name                    = ls_thead-tdname
            object                  = ls_thead-tdobject
          TABLES
            lines                   = lt_tlines
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
      ENDIF.
      IF lt_tlines[] IS NOT INITIAL.
        SELECT SINGLE p~tknum k~dalen INTO CORRESPONDING FIELDS OF ls_vttk
          FROM vttp AS p INNER JOIN vttk AS k
          ON p~tknum = k~tknum
          WHERE p~vbeln = gs_likp-vbeln.
        IF sy-subrc = 0 AND ls_vttk-dalen IS NOT INITIAL.
          gs_likp-wadat_ist = ls_vttk-dalen.
        ENDIF.
      ENDIF.
  ENDCASE.
*}  END OF INSERT WMR-150119-3000011134

  IF gs_likp-wadat_ist LT lw_date.
    lw_error = abap_true.
    RAISE error_fecha_fac.
  ENDIF.

  CHECK lw_error EQ abap_false.

ENDFORM.                    "pre_checks_delivery
*}  END OF INSERT WMR-140116
*{  BEGIN OF INSERT WMR-261118-3000009765
*&---------------------------------------------------------------------*
*& Form VALIDA_NCND_SIN_REFERENCIA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_VBRK
*&      --> PS_IDCN_LOMA
*&      <-- L_CONTINUE
*&---------------------------------------------------------------------*
FORM valida_ncnd_sin_referencia  USING    is_vbrk      TYPE vbrk
                                          is_idcn_loma TYPE idcn_loma
                                 CHANGING ep_continue  TYPE xfeld.

  DATA: ls_vbrp       TYPE vbrp,
        ls_catahomo10 TYPE zostb_catahomo10.

  ep_continue = abap_true.

  CASE is_idcn_loma-invtp.
    WHEN '08'.  " ND
      SELECT SINGLE vbeln posnr augru_auft
        INTO CORRESPONDING FIELDS OF ls_vbrp
        FROM vbrp
        WHERE vbeln = is_vbrk-vbeln.

      IF sy-subrc = 0 AND ls_vbrp-augru_auft IS NOT INITIAL.
        SELECT SINGLE augru zz_codigo_sunat
          INTO CORRESPONDING FIELDS OF ls_catahomo10
          FROM zostb_catahomo10
          WHERE augru = ls_vbrp-augru_auft.

        IF sy-subrc = 0.
          " Motivo ND sin referencia
          IF ls_catahomo10-zz_codigo_sunat IN gr_motsref AND gr_motsref[] IS NOT INITIAL.
            ep_continue = abap_false.
          ENDIF.
        ENDIF.
      ENDIF.
  ENDCASE.

ENDFORM.
*}  END OF INSERT WMR-261118-3000009765
