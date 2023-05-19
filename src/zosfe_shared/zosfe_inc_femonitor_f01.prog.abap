*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_FEMONITOR_F01
*&---------------------------------------------------------------------*

*{I-NTP130717-3000006468
*----------------------------------------------------------------------*
* Modificar screen
*----------------------------------------------------------------------*
FORM modifyscreen.
  DATA: l_active TYPE i.

  CASE abap_on.
    WHEN p_facpro. l_active = 1.
    WHEN p_facpor. l_active = 0.
    WHEN p_facsin. l_active = 0.
  ENDCASE.

  LOOP AT SCREEN.
    IF screen-group1 EQ 'R2'.
      screen-active = l_active.
      MODIFY SCREEN.
    ENDIF.

*{  BEGIN OF INSERT WMR-14092020-3000014557
    CASE screen-group1.
      WHEN 'TCP'.
        " Si GRE no está activa, eliminar sección 'Tipo de comprobante de pago'
        IF gs_process-active_gr = abap_off.
          screen-active = 0.
        ENDIF.
      WHEN 'GJ'.
        " Si Fact.Financiera no está activa, ocultar 'Ejercicio'
        IF gs_process-active_fi = abap_off.
          screen-active = 0.
        ENDIF.
        CASE abap_true.
          WHEN p_fbcd.
          WHEN p_gr.
            " Si selecciona 'GRE', ocultar 'Ejercicio'
            screen-active = 0.
        ENDCASE.
    ENDCASE.
    MODIFY SCREEN.
*}  END OF INSERT WMR-14092020-3000014557

  ENDLOOP.
ENDFORM.
*}I-NTP130717-3000006468

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

*{I-NTP040717-3000006468
  CASE abap_on.
    WHEN p_facpro.
      PERFORM get_docs_procesados.
    WHEN p_facpor.
      PERFORM get_docs_procesados.
      PERFORM get_docs_por_procesar.
      PERFORM get_docs_por_procesar_likp CHANGING gt_likp_procesar.

      DELETE gt_vbrk WHERE xblnr = gc_xblnr_cero.
      DELETE gt_likp_procesar WHERE xblnr <> gc_xblnr_cero. "I-3000013020-NTP-211119
    WHEN p_facsin.
      PERFORM get_docs_procesados.
      PERFORM get_docs_por_procesar.
      PERFORM get_docs_por_procesar_likp CHANGING gt_likp_procesar.

      DELETE gt_vbrk WHERE xblnr <> gc_xblnr_cero.
      DELETE gt_likp_procesar WHERE xblnr <> gc_xblnr_cero. "I-3000013020-NTP-211119
  ENDCASE.
*}I-NTP040717-3000006468

ENDFORM.                    " GET_DATA

*{I-NTP050717-3000006468
*----------------------------------------------------------------------*
* Obtener documentos procesados
*----------------------------------------------------------------------*
FORM get_docs_procesados.

  DATA: lt_felog TYPE TABLE OF zostb_felog. "I-NTP040717-3000006468

*{E-NTP040717-3000006468
** Obtener datos LOG
*  SELECT *
*  FROM zostb_felog
*  INTO TABLE gt_felog
*  WHERE zzt_nrodocsap IN s_vbeln
*    AND zzt_fcreacion IN s_fecha
*    AND bukrs         EQ p_bukrs.                                       "I-WMR-200715
*  IF sy-subrc NE 0.
*    MESSAGE s208(00) WITH TEXT-e01.
*    EXIT.
*  ENDIF.
*}E-NTP040717-3000006468

*}I-NTP040717-3000006468
* Obtener datos LOG

  CASE abap_true.                                                             "I-WMR-14092020-3000014557
    WHEN p_fbcd.                                                              "I-WMR-14092020-3000014557
      " Facturas
      SELECT a~mandt a~zzt_nrodocsap a~zzt_numeracion
             a~bukrs                      "I-3000012056-NTP-030719
        APPENDING CORRESPONDING FIELDS OF TABLE lt_felog ##TOO_MANY_ITAB_FIELDS
        FROM zostb_felog AS a INNER JOIN vbrk AS b ON a~zzt_nrodocsap = b~vbeln
                                                  AND a~bukrs = b~bukrs
        WHERE a~bukrs = p_bukrs
          AND a~zzt_nrodocsap IN s_vbeln
*          AND a~gjahr = space             "I-3000012056-NTP-030719
          AND a~zzt_fcreacion IN s_fecha
          AND b~fkdat IN s_fkdat.

      " Facturas Financieras                                                  "I-WMR-14092020-3000014557
      SELECT *                                                                "I-WMR-14092020-3000014557
      FROM zostb_felog                                                        "I-WMR-14092020-3000014557
      APPENDING TABLE lt_felog                                                "I-WMR-14092020-3000014557
      WHERE bukrs         EQ p_bukrs                                          "I-WMR-14092020-3000014557
        AND zzt_nrodocsap IN s_vbeln                                          "I-WMR-14092020-3000014557
*        AND gjahr         IN s_gjahr                                          "I-WMR-14092020-3000014557
        AND zzt_fcreacion IN s_fecha                                          "I-WMR-14092020-3000014557
        AND zzt_flag_fi   EQ abap_true.                                       "I-WMR-14092020-3000014557

    WHEN p_gr.                                                                "I-WMR-14092020-3000014557
      " Guías
*{  BEGIN OF DELETE WMR-22012020-3000013729
**  SELECT a~mandt a~zzt_nrodocsap a~zzt_numeracion,
**         a~bukrs                      "I-3000012056-NTP-030719
**    APPENDING CORRESPONDING FIELDS OF TABLE lt_felog   ##TOO_MANY_ITAB_FIELDS
**    FROM zostb_felog AS a INNER JOIN likp AS b ON a~zzt_nrodocsap = b~vbeln
**    WHERE a~bukrs = p_bukrs
**      AND a~zzt_nrodocsap IN s_vbeln
**      AND a~gjahr = space             "I-3000012056-NTP-030719
**      AND a~zzt_fcreacion IN s_fecha
**      AND b~tddat IN s_fkdat.
*}  END OF DELETE WMR-22012020-3000013729
*{  BEGIN OF INSERT WMR-22012020-3000013729
      SELECT a~mandt a~zzt_nrodocsap a~zzt_numeracion a~bukrs
        APPENDING CORRESPONDING FIELDS OF TABLE lt_felog
        FROM zostb_felog AS a INNER JOIN likp AS b ON a~zzt_nrodocsap = b~vbeln
        WHERE a~bukrs        = p_bukrs
          AND zzt_nrodocsap IN s_vbeln
*          AND gjahr         = space
          AND zzt_fcreacion IN s_fecha.
*}  END OF INSERT WMR-22012020-3000013729
*{+NTP010523-3000020188
      SELECT a~mandt a~zzt_nrodocsap a~zzt_numeracion a~bukrs
             a~gjahr
        APPENDING CORRESPONDING FIELDS OF TABLE lt_felog
        FROM zostb_felog AS a INNER JOIN zostb_fegrcab AS b ON a~zzt_nrodocsap = b~zznrosap
                                                           AND a~gjahr = b~zzgjahr
        WHERE a~bukrs        = p_bukrs
          AND zzt_nrodocsap IN s_vbeln
          AND zzt_fcreacion IN s_fecha.

      SORT lt_felog BY zzt_nrodocsap gjahr zzt_numeracion.
      DELETE ADJACENT DUPLICATES FROM lt_felog COMPARING zzt_nrodocsap gjahr zzt_numeracion.
*}+NTP010523-3000020188
  ENDCASE.                                                                    "I-WMR-14092020-3000014557

  CHECK lt_felog IS NOT INITIAL.

  SELECT * INTO TABLE gt_felog
    FROM zostb_felog
    FOR ALL ENTRIES IN lt_felog
    WHERE bukrs = lt_felog-bukrs                    "I-3000012056-NTP-030719
      AND zzt_nrodocsap = lt_felog-zzt_nrodocsap
      AND gjahr         = lt_felog-gjahr            "I-3000012056-NTP-030719
      AND zzt_numeracion = lt_felog-zzt_numeracion.
*}I-NTP040717-3000006468

* Obtener cabecera y detalle
  SELECT *
  FROM zostb_docexposca
  INTO TABLE gt_docexposca
  FOR ALL ENTRIES IN gt_felog
  WHERE bukrs         EQ p_bukrs                                        "I-WMR-200715
    AND zz_nrodocsap  EQ gt_felog-zzt_nrodocsap
    AND zz_gjahr      EQ gt_felog-gjahr                 "I-3000012056-NTP-020719
    AND zz_numeracion EQ gt_felog-zzt_numeracion.
*{  BEGIN OF DELETE WMR-14092020-3000014557
**  IF sy-subrc EQ 0.
**    SELECT *
**    FROM zostb_docexposde
**    INTO TABLE gt_docexposde
**    FOR ALL ENTRIES IN gt_docexposca
**    WHERE bukrs EQ  gt_docexposca-bukrs                 "I-3000012056-NTP-020719
**      AND zz_nrodocsap  EQ gt_docexposca-zz_nrodocsap
**      AND zz_gjahr      EQ gt_docexposca-zz_gjahr       "I-3000012056-NTP-020719
**      AND zz_numeracion EQ gt_docexposca-zz_numeracion.
**  ENDIF.
*}  END OF DELETE WMR-14092020-3000014557

  CASE abap_true.                                                             "I-WMR-14092020-3000014557
    WHEN p_gr.                                                                "I-WMR-14092020-3000014557
*{  BEGIN OF INSERT WMR-140116
      " Guía Remisión Cabecera
      SELECT *
        INTO TABLE gt_fegrcab
        FROM zostb_fegrcab
        FOR ALL ENTRIES IN gt_felog
        WHERE bukrs     EQ gt_felog-bukrs
          AND zznrosap  EQ gt_felog-zzt_nrodocsap
          AND zzgjahr   EQ gt_felog-gjahr
          AND zznrosun  EQ gt_felog-zzt_numeracion.
*}  END OF INSERT WMR-140116

*{  BEGIN OF INSERT WMR-051018-3000010624
      " Entregas
      lt_felog[] = gt_felog[].
      SORT lt_felog BY zzt_nrodocsap ASCENDING.
      DELETE ADJACENT DUPLICATES FROM lt_felog COMPARING zzt_nrodocsap.

      SELECT vbeln lfart tddat xblnr
        INTO CORRESPONDING FIELDS OF TABLE gt_likp
        FROM likp
        FOR ALL ENTRIES IN lt_felog
        WHERE vbeln = lt_felog-zzt_nrodocsap.
*}  END OF INSERT WMR-051018-3000010624
  ENDCASE.                                                                    "I-WMR-14092020-3000014557

ENDFORM.

*----------------------------------------------------------------------*
* Obtener documentos por procesar
*----------------------------------------------------------------------*
FORM get_docs_por_procesar.

  DATA: lt_bkpf  TYPE TABLE OF gty_bkpf,
        lt_vbfa  TYPE TABLE OF gty_vbfa,
        ls_vbrk  LIKE LINE OF gt_vbrk,
        ls_felog LIKE LINE OF gt_felog ##NEEDED.
  DATA: l_tabix TYPE i.


*1: Obtener Facturas
  SELECT vbeln vbeln fkart vbtyp fkdat xblnr bukrs
    INTO TABLE gt_vbrk
    FROM vbrk
    WHERE vbeln IN s_vbeln
      AND fkdat IN s_fkdat
      AND bukrs EQ p_bukrs
      AND rfbsk = 'C'
      AND fksto = space
      AND sfakn = space.

  "Filtrar para obtener no procesados
  LOOP AT gt_vbrk INTO ls_vbrk.
    l_tabix = sy-tabix.

    LOOP AT gt_felog TRANSPORTING NO FIELDS WHERE zzt_nrodocsap = ls_vbrk-vbeln.
      DELETE gt_felog INDEX sy-tabix.
    ENDLOOP.
    IF sy-subrc = 0.
      DELETE gt_vbrk INDEX l_tabix.
    ENDIF.
  ENDLOOP.


*2: Obtener facturas fi activas
  IF gt_vbrk IS NOT INITIAL.
    SELECT bukrs belnr gjahr awkey
      INTO TABLE lt_bkpf
      FROM bkpf
      FOR ALL ENTRIES IN gt_vbrk
      WHERE bukrs = gt_vbrk-bukrs
        AND awkey = gt_vbrk-awkey
        AND awtyp = 'VBRK'
        AND stblg = space.

    SORT lt_bkpf BY awkey.
  ENDIF.

  "Filtrar para obtener no procesados - facturados fi
  LOOP AT gt_vbrk INTO ls_vbrk.
    l_tabix = sy-tabix.

    READ TABLE lt_bkpf WITH KEY awkey = ls_vbrk-awkey TRANSPORTING NO FIELDS BINARY SEARCH.
    IF sy-subrc <> 0.
      DELETE gt_vbrk INDEX l_tabix.
    ENDIF.
  ENDLOOP.


*3: No debe tener documentos subsiguientes
  IF gt_vbrk IS NOT INITIAL.
    SELECT vbelv posnv vbeln posnn vbtyp_n vbtyp_v
      INTO TABLE lt_vbfa
      FROM vbfa
      FOR ALL ENTRIES IN gt_vbrk
      WHERE vbelv = gt_vbrk-vbeln
        AND vbtyp_v = gt_vbrk-vbtyp.

    SORT lt_vbfa BY vbelv vbtyp_v.
  ENDIF.

  "Filtrar para obtener doc sin subsiguientes
  LOOP AT gt_vbrk INTO ls_vbrk.
    l_tabix = sy-tabix.

    READ TABLE lt_vbfa WITH KEY vbelv = ls_vbrk-vbeln
                                vbtyp_v = ls_vbrk-vbtyp TRANSPORTING NO FIELDS BINARY SEARCH.
    IF sy-subrc = 0.
      DELETE gt_vbrk INDEX l_tabix.
    ENDIF.
  ENDLOOP.


* Data Adicional de facturas
  "Clase de doc
  SELECT a~blart a~doccls b~fkart
    INTO TABLE gt_t003_i
    FROM t003_i AS a INNER JOIN tvfk AS b ON a~blart = b~blart
    WHERE a~land1 EQ gc_peru.                         "#EC CI_BUFFJOIN.

  SELECT * INTO TABLE gt_zt003_i
    FROM zostb_t003_i
    WHERE land1 = gc_peru.

  "Ordenar
  SORT gt_vbrk BY fkdat.
  SORT gt_t003_i BY fkart.
  SORT gt_zt003_i BY fkart.

ENDFORM.
*}I-NTP050717-3000006468

*{I-3000013020-NTP-211119
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
FORM get_docs_por_procesar_likp CHANGING et_likp TYPE gtt_likp.

  TYPES: BEGIN OF ty_tvko,
           vkorg TYPE tvko-vkorg,
           bukrs TYPE tvko-bukrs,
         END OF ty_tvko.

  DATA: lt_lotno  TYPE HASHED TABLE OF zostb_lotno WITH UNIQUE KEY lotno,
        lt_tvko   TYPE HASHED TABLE OF ty_tvko WITH UNIQUE KEY vkorg,
        lo_fegr   TYPE REF TO zossdcl_pro_extrac_fe_gr,
        ls_option TYPE zosfees_extract_options,
        ls_nojson TYPE zosfegres_data_nojson,
        ls_head   LIKE LINE OF ls_nojson-t_header.
  FIELD-SYMBOLS: <fs_tvko> LIKE LINE OF lt_tvko,
                 <fs_likp> LIKE LINE OF et_likp.

  CHECK p_gr = abap_true.   " Seleción: Guía de remisión                      "I-WMR-14092020-3000014557

* 0. Inicializa
  CREATE OBJECT lo_fegr.

* 1. Data
  "1.0 Lote
  SELECT * INTO TABLE lt_lotno FROM zostb_lotno.

  "1.1 OrgVta
  SELECT vkorg bukrs INTO TABLE lt_tvko
    FROM tvko
    WHERE bukrs = p_bukrs.

  CHECK lt_tvko IS NOT INITIAL.

  "1.2 Entregas
  SELECT * INTO CORRESPONDING FIELDS OF TABLE et_likp
    FROM likp
    FOR ALL ENTRIES IN lt_tvko
    WHERE vbeln IN s_vbeln
      AND erdat IN s_fecha
      AND tddat IN s_fkdat
      AND vkorg EQ lt_tvko-vkorg.

  CASE gw_license.
    WHEN '0020262397'. "Artesco
      IF s_fkdat IS NOT INITIAL.
        SELECT * APPENDING CORRESPONDING FIELDS OF TABLE et_likp
          FROM likp
          FOR ALL ENTRIES IN lt_tvko
          WHERE vbeln IN s_vbeln
            AND erdat IN s_fecha
            AND wadat_ist IN s_fkdat
            AND vkorg EQ lt_tvko-vkorg.

        SORT et_likp BY vbeln.
        DELETE ADJACENT DUPLICATES FROM et_likp COMPARING vbeln.
      ENDIF.
  ENDCASE.

************************************************************************
* 2 Filtro
************************************************************************
  LOOP AT et_likp ASSIGNING <fs_likp>.
    "Sociedad
    READ TABLE lt_tvko ASSIGNING <fs_tvko> WITH TABLE KEY vkorg = <fs_likp>-vkorg.
    IF sy-subrc = 0.
      <fs_likp>-bukrs = <fs_tvko>-bukrs.
    ENDIF.

    "No procesados
    LOOP AT gt_felog TRANSPORTING NO FIELDS WHERE zzt_nrodocsap = <fs_likp>-vbeln.
      DELETE gt_felog INDEX sy-tabix.
    ENDLOOP.
    IF sy-subrc = 0.
      <fs_likp>-del = abap_on. CONTINUE.
    ENDIF.

    "Lote
    IF <fs_likp>-xblnr IS NOT INITIAL.
      lo_fegr->split_xblnr( EXPORTING i_xblnr = <fs_likp>-xblnr IMPORTING e_serie = <fs_likp>-lotno e_sercor = <fs_likp>-zzt_numeracion ).
      READ TABLE lt_lotno WITH TABLE KEY lotno = <fs_likp>-lotno TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        <fs_likp>-del = abap_on. CONTINUE.
      ENDIF.
    ENDIF.

    "Construir fecha de emision
    CASE gw_license.
      WHEN '0020262397'. "Artesco
        IF <fs_likp>-vbtyp <> 'T'.
          <fs_likp>-zzt_femision = <fs_likp>-wadat_ist.
        ENDIF.
    ENDCASE.
  ENDLOOP.

  DELETE et_likp WHERE del IS NOT INITIAL.

************************************************************************
* 3. Completar
************************************************************************
  "3.1 Obtener datos del extractor
  LOOP AT et_likp ASSIGNING <fs_likp>.
    ls_option-noverif_xblnr = abap_on.
    ls_option-only_datanojs = abap_on.

    lo_fegr->extrae_data_guia_remision(
      EXPORTING
        i_entrega     = <fs_likp>-vbeln
        is_options    = ls_option
      IMPORTING
        es_datanojson = ls_nojson
      EXCEPTIONS
        error         = 1
    ).

    READ TABLE ls_nojson-t_header INTO ls_head INDEX 1.
    IF sy-subrc = 0.
      <fs_likp>-zzt_femision = ls_head-zzfecemi.
      <fs_likp>-zzt_nombreraz = ls_head-zzdstden.
    ENDIF.
  ENDLOOP.

  DELETE et_likp WHERE zzt_femision NOT IN s_fkdat.
  SORT et_likp BY zzt_femision.

ENDFORM.
*}I-3000013020-NTP-211119

*&---------------------------------------------------------------------*
*&      Form  SET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_data .

  CHECK gw_error = abap_off.                                                  "I-WMR-130319-3000010823

*{I-NTP040717-3000006468
  CASE abap_on.
    WHEN p_facpro.
      PERFORM set_docs_procesados.
    WHEN p_facpor.
      PERFORM set_docs_por_procesar.
    WHEN p_facsin.
      PERFORM set_docs_por_procesar.
  ENDCASE.
*}I-NTP040717-3000006468

ENDFORM.                    " SET_DATA

*----------------------------------------------------------------------*
* Asignar documentos procesados
*----------------------------------------------------------------------*
FORM set_docs_procesados.

  DATA: lo_fegr    TYPE REF TO zossdcl_pro_extrac_fe_gr,                 "+NTP010423-3000020188

        ls_reporte LIKE LINE OF gt_reporte,
*{  BEGIN OF INSERT WMR-140116
        ls_fegrcab TYPE zostb_fegrcab,
*}  END OF INSERT WMR-140116
        ls_likp    LIKE LINE OF gt_likp.                                "I-WMR-051018-3000010624
  REFRESH gt_reporte.


  CREATE OBJECT lo_fegr. "+NTP010423-3000020188

* Formar tabla final
  LOOP AT gt_felog ASSIGNING <fs_felog>.
    AT NEW zzt_numeracion.
      CLEAR: ls_reporte.
      REFRESH ls_reporte-zzt_errores.
    ENDAT.
    IF <fs_felog>-zzt_errorext IS NOT INITIAL.
      APPEND <fs_felog>-zzt_errorext TO ls_reporte-zzt_errores.
    ENDIF.
    AT END OF zzt_numeracion.
      MOVE-CORRESPONDING <fs_felog> TO ls_reporte ##ENH_OK.
*{  BEGIN OF REPLACE WMR-140116
      ""      READ TABLE gt_docexposca ASSIGNING <fs_docexposca>
      ""                 WITH KEY zz_nrodocsap = <fs_felog>-zzt_nrodocsap.
      ""      IF sy-subrc EQ 0.
      ""*{  BEGIN OF INSERT WMR-200715
      ""        ls_reporte-bukrs         = <fs_docexposca>-bukrs.
      ""*}  END OF INSERT WMR-200715
      ""        ls_reporte-zzt_femision  = <fs_docexposca>-zz_femision.
      ""        ls_reporte-zzt_nombreraz = <fs_docexposca>-zz_nombreraz.
      ""      ENDIF.
      CASE <fs_felog>-zzt_tipodoc.
        WHEN gc_tipdoc_fa   " Factura
          OR gc_tipdoc_bl   " Boleta
          OR gc_tipdoc_nc   " Nota de Crédito
          OR gc_tipdoc_nd.  " Nota de Débito
          READ TABLE gt_docexposca ASSIGNING <fs_docexposca>
                     WITH KEY zz_nrodocsap = <fs_felog>-zzt_nrodocsap.
          IF sy-subrc EQ 0.
            ls_reporte-bukrs         = <fs_docexposca>-bukrs.
            ls_reporte-gjahr         = <fs_docexposca>-zz_gjahr.       "I-3000012056-NTP-050719
            ls_reporte-zzt_femision  = <fs_docexposca>-zz_femision.
            ls_reporte-zzt_nombreraz = <fs_docexposca>-zz_nombreraz.
          ENDIF.

        WHEN gc_tipdoc_gr.  " Guía de Remisión
          READ TABLE gt_fegrcab INTO ls_fegrcab
               WITH TABLE KEY zznrosap = <fs_felog>-zzt_nrodocsap       "+NTP010423-3000020188
                              zzgjahr  = <fs_felog>-gjahr               "+NTP010423-3000020188
                              zznrosun = <fs_felog>-zzt_numeracion.
          IF sy-subrc EQ 0.
            ls_reporte-bukrs         = ls_fegrcab-bukrs.
            ls_reporte-zzt_femision  = ls_fegrcab-zzfecemi.
**            ls_reporte-zzt_nombreraz = ls_fegrcab-zzremden.             "E-WMR-180919-3000010823
            ls_reporte-zzt_nombreraz = ls_fegrcab-zzdstden.             "I-WMR-180919-3000010823

          ELSE.                                                         "I-WMR-051018-3000010624
            READ TABLE gt_likp INTO ls_likp                             "I-WMR-051018-3000010624
                 WITH TABLE KEY vbeln = <fs_felog>-zzt_nrodocsap.       "I-WMR-051018-3000010624
            IF sy-subrc = 0.                                            "I-WMR-051018-3000010624
              ls_reporte-zzt_femision  = ls_likp-tddat.                 "I-WMR-051018-3000010624
            ENDIF.                                                      "I-WMR-051018-3000010624
          ENDIF.

          SPLIT <fs_felog>-log AT '|' INTO TABLE ls_reporte-zzt_errores. "+NTP010423-3000020188

        WHEN OTHERS.
      ENDCASE.
*}  END OF REPLACE WMR-140116
      CASE <fs_felog>-zzt_status_cdr.
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
        WHEN '9'. "Cancelado                                            "I-WMR-030717-3000006468
          ls_reporte-semaforo = gc_semaf_gris.                          "I-WMR-030717-3000006468
      ENDCASE.
      APPEND ls_reporte TO gt_reporte.
    ENDAT.
  ENDLOOP.

* Ordenar los mas recientes al comienzo
  SORT gt_reporte BY zzt_fcreacion DESCENDING
                     zzt_hcreacion DESCENDING.

ENDFORM.

*{I-NTP040717-3000006468
*----------------------------------------------------------------------*
* Asignar documentos por procesar
*----------------------------------------------------------------------*
FORM set_docs_por_procesar.

  DATA: ls_vbrk    LIKE LINE OF gt_vbrk,
*        ls_t003_i  LIKE LINE OF gt_t003_i,                             "E-3000012593-NTP-031219
*        ls_zt003_i LIKE LINE OF gt_zt003_i,                            "E-3000012593-NTP-031219
        ls_reporte LIKE LINE OF gt_reporte,
        l_tipo     TYPE string.                                         "I-WMR-190918-3000009765
  DATA: ls_likp LIKE LINE OF gt_likp_procesar.                          "I-3000013020-NTP-211119


  REFRESH gt_reporte.

  CASE abap_true.                                                             "I-WMR-14092020-3000014557
    WHEN p_fbcd.                                                              "I-WMR-14092020-3000014557
      " Facturas/ Boletas/ NC/ ND                                             "I-WMR-14092020-3000014557
      LOOP AT gt_vbrk INTO ls_vbrk.
        ls_reporte-bukrs = ls_vbrk-bukrs.
        ls_reporte-zzt_nrodocsap  = ls_vbrk-vbeln.
        ls_reporte-zzt_nombreraz  = ls_vbrk-zzt_nombreraz.                  "I-3000012593-NTP-031219
        ls_reporte-zzt_tipodoc    = ls_vbrk-zzt_tipodoc.                    "I-3000012593-NTP-031219
        ls_reporte-gjahr  = space.                                          "I-3000012056-NTP-050719
*    ls_reporte-zzt_numeracion = ls_vbrk-xblnr+4.                        "E-WMR-190918-3000009765
        SPLIT ls_vbrk-xblnr AT '-' INTO l_tipo ls_reporte-zzt_numeracion.   "I-WMR-190918-3000009765
        ls_reporte-zzt_tipodoc = l_tipo.                                            "I-WMR-20112020-3000014557
        SHIFT ls_reporte-zzt_numeracion LEFT DELETING LEADING '0'.          "I-WMR-190918-3000009765
        ls_reporte-zzt_femision = ls_vbrk-fkdat.

*{E-3000012593-NTP-031219
*        READ TABLE gt_t003_i INTO ls_t003_i WITH KEY fkart = ls_vbrk-fkart BINARY SEARCH.
*        IF sy-subrc = 0.
*          ls_reporte-zzt_tipodoc = ls_t003_i-doccls.
*        ENDIF.
*
*        READ TABLE gt_zt003_i INTO ls_zt003_i WITH KEY fkart = ls_vbrk-fkart BINARY SEARCH.
*        IF sy-subrc = 0.
*          ls_reporte-zzt_tipodoc = ls_zt003_i-doccls.
*        ENDIF.
*}E-3000012593-NTP-031219

        ls_reporte-zzt_status_cdr = 0. "Por procesar
        ls_reporte-semaforo = gc_semaf_rojo.

        APPEND ls_reporte TO gt_reporte.
      ENDLOOP.

    WHEN p_gr.                                                                "I-WMR-14092020-3000014557
      " Guía de remisión                                                      "I-WMR-14092020-3000014557

*{I-3000013020-NTP-211119
      LOOP AT gt_likp_procesar INTO ls_likp.
        ls_reporte-bukrs = ls_likp-bukrs.
        ls_reporte-zzt_nrodocsap  = ls_likp-vbeln.
        ls_reporte-zzt_nombreraz  = ls_likp-zzt_nombreraz.
        ls_reporte-zzt_numeracion  = ls_likp-zzt_numeracion.
        SHIFT ls_reporte-zzt_numeracion LEFT DELETING LEADING '0'.
        ls_reporte-zzt_femision = ls_likp-zzt_femision.
        ls_reporte-zzt_tipodoc = '09'.
        ls_reporte-zzt_status_cdr = 0. "Por procesar
        ls_reporte-semaforo = gc_semaf_rojo.

        APPEND ls_reporte TO gt_reporte.
      ENDLOOP.
*}I-3000013020-NTP-211119

  ENDCASE.                                                                    "I-WMR-14092020-3000014557

ENDFORM.
*}I-NTP040717-3000006468

*&---------------------------------------------------------------------*
*&      Form  SHO_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sho_data .

  DATA: lt_fieldcat   TYPE lvc_t_fcat,
        ls_layout     TYPE lvc_s_layo,
        ls_t001       TYPE t001,                                                "I-WMR-12122020-3000014829
        l_gjahr_exist TYPE xfeld.                                             "+NTP030523-3000018994
  FIELD-SYMBOLS: <fs_fieldcat> LIKE LINE OF lt_fieldcat.

  CHECK gw_error = abap_off.                                                  "I-WMR-130319-3000010823

* Catálogo
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = gc_tabname
    CHANGING
      ct_fieldcat      = lt_fieldcat.

  CASE gs_t001-land1.                                                         "I-WMR-12122020-3000014829
    WHEN gc_peru.                                                             "I-WMR-12122020-3000014829
      DELETE lt_fieldcat WHERE fieldname = 'ZZT_BO_NROAUT'.                   "I-WMR-12122020-3000014829
  ENDCASE.                                                                    "I-WMR-12122020-3000014829

*{+NTP030523-3000018994
  LOOP AT gt_reporte TRANSPORTING NO FIELDS WHERE gjahr IS NOT INITIAL.
    l_gjahr_exist = abap_on.
    EXIT.
  ENDLOOP.
*}+NTP030523-3000018994

  LOOP AT lt_fieldcat ASSIGNING <fs_fieldcat>.
    CASE <fs_fieldcat>-fieldname.
*{  BEGIN OF INSERT WMR-200715
      WHEN 'BUKRS'.
        <fs_fieldcat>-key = abap_true.
*}  END OF INSERT WMR-200715
      WHEN 'ZZT_NRODOCSAP'.
        <fs_fieldcat>-key = abap_true.
        <fs_fieldcat>-hotspot = abap_true.
*{  BEGIN OF INSERT WMR-170915
      WHEN 'GJAHR'.                                                             "I-3000010823-JPS-100519
**        IF p_facfin = abap_true.                                                "I-3000010823-JPS-100519  "E-WMR-14092020-3000014557
        IF gs_process-active_fi = abap_true OR                                  "I-WMR-14092020-3000014557
           l_gjahr_exist = abap_on.                                             "+NTP030523-3000018994
          <fs_fieldcat>-key = abap_true.                                        "I-3000010823-JPS-100519
        ELSE.                                                                   "I-3000010823-JPS-100519
          <fs_fieldcat>-no_out = abap_true.                                     "I-3000010823-JPS-100519
        ENDIF.                                                                  "I-3000010823-JPS-100519
      WHEN 'ZZT_TIPODOC'.
        <fs_fieldcat>-key = abap_true.
      WHEN 'ZZT_BO_NROAUT'.                                                   "I-WMR-14122020-3000014829
        <fs_fieldcat>-key = abap_true.                                        "I-WMR-14122020-3000014829
*}  END OF INSERT WMR-170915
      WHEN 'ZZT_NUMERACION'.
        <fs_fieldcat>-key = abap_true.
        CASE gs_t001-land1.                                                   "I-WMR-12122020-3000014829
          WHEN gc_bolivia.                                                    "I-WMR-12122020-3000014829
            <fs_fieldcat>-scrtext_s = TEXT-c01.                               "I-WMR-12122020-3000014829
            <fs_fieldcat>-scrtext_m = TEXT-c01.                               "I-WMR-12122020-3000014829
            <fs_fieldcat>-scrtext_l = TEXT-c01.                               "I-WMR-12122020-3000014829
            <fs_fieldcat>-seltext   = TEXT-c01.                               "I-WMR-12122020-3000014829
            <fs_fieldcat>-coltext   = TEXT-c01.                               "I-WMR-12122020-3000014829
            <fs_fieldcat>-coltext   = TEXT-c01.                               "I-WMR-12122020-3000014829
        ENDCASE.                                                              "I-WMR-12122020-3000014829
      WHEN 'ZZT_STATUS_CDR'.
        <fs_fieldcat>-key = abap_true.
      WHEN 'ZZT_ERRORES'.
        <fs_fieldcat>-no_out = abap_true.
      WHEN 'SELEC'.
        <fs_fieldcat>-no_out = abap_true.
      WHEN 'SEMAFORO'.
        <fs_fieldcat>-just = 'C'.
        <fs_fieldcat>-reptext = TEXT-001.
        <fs_fieldcat>-coltext = TEXT-001.
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
  ls_layout-box_fname  = 'SELEC'.

* Titulo
  CASE abap_on.                                                                     "I-WMR-20112020-3000014557
    WHEN p_fbcd.                                                                    "I-WMR-20112020-3000014557
*{I-NTP040717-3000006468
      CASE abap_on.
        WHEN p_facpro.
          sy-title = TEXT-t03.
        WHEN p_facpor.
          sy-title = TEXT-t04.
        WHEN p_facsin.
          sy-title = TEXT-t05.
**    WHEN p_facfin.                                                "I-3000010823-JPS-100519  "E-WMR-14092020-3000014557
**      sy-title = text-t06.                                        "I-3000010823-JPS-100519  "E-WMR-14092020-3000014557
      ENDCASE.
*}I-NTP040717-3000006468
    WHEN p_gr.                                                                      "I-WMR-20112020-3000014557
      CASE abap_on.                                                                 "I-WMR-20112020-3000014557
        WHEN p_facpro.  sy-title = TEXT-t07.                                        "I-WMR-20112020-3000014557
        WHEN p_facpor.  sy-title = TEXT-t08.                                        "I-WMR-20112020-3000014557
        WHEN p_facsin.  sy-title = TEXT-t09.                                        "I-WMR-20112020-3000014557
      ENDCASE.                                                                      "I-WMR-20112020-3000014557
  ENDCASE.                                                                          "I-WMR-20112020-3000014557

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

  DATA: lw_error TYPE char1,
        l_subrc  TYPE sy-subrc.                                           "+010922-NTP-3000018956

  CASE ucomm.
    WHEN '&IC1'.
      CASE selfield-fieldname.
        WHEN 'SEMAFORO'.
          PERFORM show_mensa USING selfield.
        WHEN 'ZZT_NRODOCSAP'.
          PERFORM call_vf03 USING selfield.
        WHEN 'ZZT_NUMERACION'.
          PERFORM call_json USING selfield.  "I-NTP111218-3000011059
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
      "BEGIN OF OFV 23.03.2016
    WHEN '&SYNC'.
      selfield-refresh = abap_true.
      PERFORM pf_sincronizar.
      PERFORM get_data.
      PERFORM set_data.
      "END OF OFV 23.03.2016
    WHEN '&CANCELAR'.                                                   "I-WMR-030717-3000006468
      CLEAR lw_error.                                                   "I-WMR-030717-3000006468
      selfield-refresh = abap_true.                                     "I-WMR-030717-3000006468
      PERFORM cancelar_documento CHANGING lw_error.                     "I-WMR-030717-3000006468
      IF lw_error IS INITIAL.                                           "I-WMR-030717-3000006468
        PERFORM get_data.                                               "I-WMR-030717-3000006468
        PERFORM set_data.                                               "I-WMR-030717-3000006468
      ENDIF.                                                            "I-WMR-030717-3000006468
*{I-PBM260619-3000012056
    WHEN '&PDF'.
*}I-PBM260619-3000012056
*{+010922-NTP-3000018956
    WHEN 'REENU'.
      selfield-refresh = abap_true.
      PERFORM reenumerar_btn CHANGING l_subrc.
      IF l_subrc = 0.
        PERFORM get_data.
        PERFORM set_data.
      ENDIF.
    WHEN 'REFAC'.
      selfield-refresh = abap_true.
      PERFORM reefacturar_btn CHANGING l_subrc.
      IF l_subrc = 0.
        PERFORM get_data.
        PERFORM set_data.
      ENDIF.
*}+010922-NTP-3000018956
  ENDCASE.

ENDFORM.                    "user_command

*&---------------------------------------------------------------------*
*&      Form  alv_form_status
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PT_EXTAB   text
*----------------------------------------------------------------------*
FORM alv_form_status USING pt_extab TYPE slis_t_extab ##CALLED.

*{I-NTP040717-3000006468
  CASE abap_on.
    WHEN p_facpro.
      IF p_gr IS NOT INITIAL.                                                       "+NTP010523-3000020188
        APPEND '&CANCELAR' TO pt_extab.                                             "+NTP010523-3000020188
      ENDIF.                                                                        "+NTP010523-3000020188
    WHEN p_facpor.
      APPEND '&SYNC' TO pt_extab.
      APPEND '&CANCELAR' TO pt_extab.
    WHEN p_facsin.
      APPEND '&REPROC' TO pt_extab.
      APPEND '&SYNC' TO pt_extab.
      APPEND '&CANCELAR' TO pt_extab.
  ENDCASE.
*}I-NTP040717-3000006468

  " Mostrar botón 'Visualizar PDF' sólo en documentos procesados                    "I-WMR-20112020-3000014557
  CASE abap_on.                                                                     "I-WMR-20112020-3000014557
    WHEN p_facpro.                                                                  "I-WMR-20112020-3000014557
    WHEN OTHERS.                                                                    "I-WMR-20112020-3000014557
      APPEND '&PDF' TO pt_extab.                                                    "I-WMR-20112020-3000014557
  ENDCASE.                                                                          "I-WMR-20112020-3000014557

*{+011222-NTP-3000019824
  APPEND '&ALL' TO pt_extab.
  APPEND '&RNT_PREV' TO pt_extab.
  APPEND '&AQW' TO pt_extab.
  APPEND '%PC' TO pt_extab.
  APPEND '%SL' TO pt_extab.
  APPEND '&ABC' TO pt_extab.
  APPEND '&GRAPH' TO pt_extab.
  APPEND '&INFO' TO pt_extab.
*}+011222-NTP-3000019824

*{+010922-NTP-3000018956
  "Excluir funciones de test de prd
  READ TABLE gt_const WITH KEY valor1 = sy-host valor2 = 'PRD' TRANSPORTING NO FIELDS.
  IF sy-subrc = 0.
    APPEND 'REENU' TO pt_extab.
    APPEND 'REFAC' TO pt_extab.
  ENDIF.
*}+010922-NTP-3000018956

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
*&      Form  call_vf03
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PI_SELFIELD  text
*----------------------------------------------------------------------*
FORM call_vf03 USING pi_selfield TYPE slis_selfield.

  READ TABLE gt_reporte ASSIGNING <fs_reporte> INDEX pi_selfield-tabindex.
  CHECK sy-subrc EQ 0.
*{  BEGIN OF DELETE WMR-20112020-3000014557
***{  BEGIN OF REPLACE WMR-140116
**  ""  SET PARAMETER ID 'VF' FIELD <fs_reporte>-zzt_nrodocsap.
**  ""  CALL TRANSACTION 'VF03' AND SKIP FIRST SCREEN.
**
**  CASE <fs_reporte>-zzt_tipodoc.
**    WHEN gc_tipdoc_fa   " Factura
**      OR gc_tipdoc_bl   " Boleta
**      OR gc_tipdoc_nc   " Nota de Crédito
**      OR gc_tipdoc_nd.  " Nota de Débito
**      SET PARAMETER ID 'VF' FIELD <fs_reporte>-zzt_nrodocsap.
**      CALL TRANSACTION 'VF03' AND SKIP FIRST SCREEN.    "#EC CI_CALLTA.
**
**    WHEN gc_tipdoc_gr.  " Guía de Remisión
**      SET PARAMETER ID 'VL' FIELD <fs_reporte>-zzt_nrodocsap.
**      CALL TRANSACTION 'VL03N' AND SKIP FIRST SCREEN.   "#EC CI_CALLTA.
**
**    WHEN OTHERS.
**  ENDCASE.
***}  END OF REPLACE WMR-140116
*}  END OF DELETE WMR-20112020-3000014557

  CASE abap_on.                                                                     "I-WMR-20112020-3000014557
    WHEN p_fbcd.                                                                    "I-WMR-20112020-3000014557
      SET PARAMETER ID 'VF' FIELD <fs_reporte>-zzt_nrodocsap.                       "I-WMR-20112020-3000014557
      CALL TRANSACTION 'VF03' AND SKIP FIRST SCREEN.                                "I-WMR-20112020-3000014557
    WHEN p_gr.                                                                      "I-WMR-20112020-3000014557
*{+NTP010523-3000020188
      SELECT COUNT(*) FROM likp WHERE vbeln = <fs_reporte>-zzt_nrodocsap.
      IF sy-subrc = 0.
        SET PARAMETER ID 'VL' FIELD <fs_reporte>-zzt_nrodocsap.                       "I-WMR-20112020-3000014557
        CALL TRANSACTION 'VL03N' AND SKIP FIRST SCREEN.                               "I-WMR-20112020-3000014557
      ELSE.
        SUBMIT zosfegr_int_guia_z
          WITH p_gr_nro = <fs_reporte>-zzt_nrodocsap
          WITH p_gr_gja = <fs_reporte>-gjahr
          AND RETURN.
      ENDIF.
*}+NTP010523-3000020188
  ENDCASE.                                                                          "I-WMR-20112020-3000014557

ENDFORM.                    "call_vf03

*&---------------------------------------------------------------------*
*&      Form  reprocesa
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PO_ERROR   text
*----------------------------------------------------------------------*
FORM reprocesa CHANGING po_error TYPE char1.

  DATA: lw_tipodoc TYPE char02 ##NEEDED,
        lw_fac     TYPE char01,
        lw_bol     TYPE char01,
        lw_nc      TYPE char01,
        lw_nd      TYPE char01,
*{  BEGIN OF INSERT WMR-140116
        lw_gr      TYPE char01,
*}  END OF INSERT WMR-140116
        lw_text1   TYPE char50,
        lw_answer  TYPE char01,
        lw_date    TYPE datum,                                        "I-WMR-140617-3000007486
        lw_days    TYPE n LENGTH 2,                                   "I-WMR-140617-3000007486
        l_facpor   TYPE xfeld,                                        "I-NTP110717-3000006468
        ls_reporte LIKE LINE OF gt_reporte,
        ls_repro   TYPE zosfetb_repro.                                "I-PBM200219-3000011108

  DATA: lv_status TYPE zostb_felog-zzt_status_cdr.                    "I-PBM200219-3000011108

*{ BEGIN OF INSERT WMR-06012021-3000014829
  CASE gs_t001-land1.
    WHEN gc_peru.
    WHEN OTHERS.
      po_error = abap_true.
      MESSAGE s208(00) WITH TEXT-e06.
      EXIT.
  ENDCASE.
*} END OF INSERT WMR-06012021-3000014829

* Leer línea marcada
  READ TABLE gt_reporte INTO ls_reporte WITH KEY selec = abap_true.

  CHECK sy-subrc EQ 0.

* Validar status
  CASE ls_reporte-zzt_status_cdr.
    WHEN gc_status_0 OR gc_status_2 OR gc_status_5 OR gc_status_6 OR gc_status_7. "+@001

*{I-NTP110717-3000006468
      "Factura por procesar no existe en zostb_felog
      CASE abap_on.
        WHEN p_facpor. l_facpor = p_facpor.
      ENDCASE.
*}I-NTP110717-3000006468

    WHEN OTHERS.
      po_error = abap_true.
      MESSAGE s208(00) WITH TEXT-e02.
      EXIT.
  ENDCASE.

*{  BEGIN OF INSERT WMR-140617-3000007486
  " Validar Días para Envío a Sunat
  READ TABLE gt_const INTO gs_const WITH KEY campo = 'FECFAC'.
  IF sy-subrc EQ 0.
    lw_days = gs_const-valor1.
    lw_date = sy-datum - lw_days.

    IF ls_reporte-zzt_femision LT lw_date.
      po_error = abap_true.
      WRITE lw_date TO lw_text1.
      MESSAGE i398(00) WITH TEXT-e03 lw_text1 ##MG_MISSING.
      EXIT.
    ENDIF.
  ENDIF.
*}  END OF INSERT WMR-140617-3000007486

* Popup de confirmación
*{  BEGIN OF REPLACE WMR-140116
  ""  CONCATENATE 'La Factura'
  ""              ls_reporte-zzt_nrodocsap
  ""              'será enviada a SUNAT' INTO lw_text1 SEPARATED BY space.
  CONCATENATE TEXT-i13
              ls_reporte-zzt_nrodocsap
              TEXT-i14 INTO lw_text1 SEPARATED BY space.
*}  END OF REPLACE WMR-140116
  CALL FUNCTION 'POPUP_TO_CONFIRM_WITH_MESSAGE' ##FM_OLDED
    EXPORTING
      diagnosetext1 = lw_text1
      textline1     = TEXT-i15
      titel         = TEXT-i16
    IMPORTING
      answer        = lw_answer.
  IF lw_answer NE 'J'.
    po_error = abap_true.
    EXIT.
  ENDIF.

* Verificar tipo de documento
*{  BEGIN OF REPLACE WMR-140116
  ""  SELECT SINGLE zzt_tipodoc
  ""  INTO lw_tipodoc
  ""  FROM zostb_fecab
  ""  WHERE zzt_nrodocsap   = ls_reporte-zzt_nrodocsap
  ""    AND zzt_numeracion  = ls_reporte-zzt_numeracion.
  ""  IF sy-subrc = 0.
  ""    CASE lw_tipodoc.
  ""      WHEN '01'.
  ""        lw_fac = abap_true.
  ""      WHEN '03'.
  ""        lw_bol = abap_true.
  ""      WHEN '07'.
  ""        lw_nc  = abap_true.
  ""      WHEN '08'.
  ""        lw_nd  = abap_true.
  ""    ENDCASE.
  ""  ENDIF.

  CASE ls_reporte-zzt_tipodoc.
    WHEN gc_tipdoc_fa.  lw_fac = abap_true.
    WHEN gc_tipdoc_bl.  lw_bol = abap_true.
    WHEN gc_tipdoc_nc.  lw_nc  = abap_true.
    WHEN gc_tipdoc_nd.  lw_nd  = abap_true.
    WHEN gc_tipdoc_gr.  lw_gr  = abap_true.
  ENDCASE.
*}  END OF REPLACE WMR-140116

* Llamar programa para reproceso
  SUBMIT zosfe_pro_fereproceso AND RETURN
      WITH p_opcfa  = lw_fac
      WITH p_opcbl  = lw_bol
      WITH p_opcnc  = lw_nc
      WITH p_opcnd  = lw_nd
      WITH p_opcgr  = lw_gr                                     "I-WMR-060318-3000009350
      WITH p_docsap = ls_reporte-zzt_nrodocsap
      WITH p_numera = ls_reporte-zzt_numeracion
      WITH p_facpor = l_facpor. "#EC CI_SUBMIT     "Factura por procesar  "I-NTP110717-3000006468

*{I-PBM200219-3000011108
  CASE gw_license.
    WHEN '0020316164'. "Modasa
      "obtener última actualización
      SELECT SINGLE zzt_status_cdr INTO lv_status
      FROM zostb_felog
       WHERE zzt_nrodocsap EQ ls_reporte-zzt_nrodocsap
         AND zzt_numeracion EQ ls_reporte-zzt_numeracion.

      "obtener reproceso
      SELECT SINGLE * INTO ls_repro
      FROM zosfetb_repro
       WHERE bukrs EQ ls_reporte-bukrs
         AND zzt_nrodocsap EQ ls_reporte-zzt_nrodocsap
         AND zzt_numeracion EQ ls_reporte-zzt_numeracion
         AND zzt_status_cdr EQ lv_status.

      IF sy-subrc <> 0.
        CLEAR: ls_repro.
        ls_repro-bukrs          = ls_reporte-bukrs.
        ls_repro-zzt_nrodocsap  = ls_reporte-zzt_nrodocsap.
        ls_repro-zzt_numeracion = ls_reporte-zzt_numeracion.
        ls_repro-zzt_status_cdr = lv_status.
        ls_repro-zzt_femision   = ls_reporte-zzt_femision.
        ls_repro-zzt_tipodoc    = ls_reporte-zzt_tipodoc.
        ADD 1 TO ls_repro-zzt_cant_rep.
        INSERT zosfetb_repro FROM ls_repro.
      ELSE.
        ADD 1 TO ls_repro-zzt_cant_rep.
        UPDATE zosfetb_repro SET zzt_cant_rep = ls_repro-zzt_cant_rep
                       WHERE bukrs          = ls_repro-bukrs
                         AND zzt_nrodocsap  = ls_repro-zzt_nrodocsap
                         AND zzt_numeracion = ls_repro-zzt_numeracion
                         AND zzt_status_cdr = lv_status.
      ENDIF.
    WHEN OTHERS.
  ENDCASE.
*}I-PBM200219-3000011108

ENDFORM.                    " REPROCESA

FORM call_json USING is_selfield TYPE slis_selfield ##CALLED.

  DATA: l_answer TYPE c,
        l_folder TYPE string,
        l_char   TYPE et_ws_path. "+010922-NTP-3000018956
  DATA: lo_fe    TYPE REF TO zossdcl_pro_extrac_fe.

  "{I-PBM240419-3000011085
  DATA: lo_obj TYPE REF TO object,
        lo_cx  TYPE REF TO cx_root.

  DATA: lv_classname TYPE string,
        lv_method    TYPE string VALUE 'BUILD_XML'.
  "}I-PBM240419-3000011085

  READ TABLE gt_reporte ASSIGNING <fs_reporte> INDEX is_selfield-tabindex.
  CHECK sy-subrc = 0.

  CALL FUNCTION 'POPUP_TO_DECIDE'
    EXPORTING
      textline1    = 'Opciones de XML'
      text_option1 = 'Visualizar'
      text_option2 = 'Download'
      titel        = 'Elegir'
    IMPORTING
      answer       = l_answer.

*{R-PBM240419-3000011085
*  CREATE OBJECT lo_fe.
  IF <fs_reporte>-zzt_tipodoc EQ gc_tipdoc_gr.
    lv_classname = 'ZOSSDCL_PRO_EXTRAC_FE_GR'.
  ELSE.
    lv_classname = 'ZOSSDCL_PRO_EXTRAC_FE'.
  ENDIF.
*}R-PBM240419-3000011085

  CASE l_answer.
    WHEN '1'. "Visualizar

*{R-PBM240419-3000011085
      TRY.
          CREATE OBJECT lo_obj TYPE (lv_classname).
          TRY.
              CALL METHOD lo_obj->(lv_method)
                EXPORTING
                  i_nrodocsap  = <fs_reporte>-zzt_nrodocsap
                  i_numeracion = <fs_reporte>-zzt_numeracion
                  i_show       = abap_on
                EXCEPTIONS
                  error        = 1.
              IF sy-subrc <> 0.
                MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                           WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
              ENDIF.
            CATCH cx_ai_system_fault      INTO lo_cx.
            CATCH cx_ai_application_fault INTO lo_cx.
          ENDTRY.
        CATCH cx_ai_system_fault INTO lo_cx.
      ENDTRY.
*}R-PBM240419-3000011085

    WHEN '2'. "Download
*{+010922-NTP-3000018956
      GET PARAMETER ID 'ECATT_FILENAME' FIELD l_char.
      l_folder = l_char.
      IF l_folder IS INITIAL.
        SELECT SINGLE valor1 INTO l_folder FROM zostb_const_fe WHERE campo = 'DWP_FRT'.
      ENDIF.

      "Obtener folder
      cl_gui_frontend_services=>directory_browse(
        EXPORTING
          initial_folder       = l_folder
        CHANGING
          selected_folder      = l_folder
        EXCEPTIONS
          cntl_error           = 1
          error_no_gui         = 2
          not_supported_by_gui = 3
      ).
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        EXIT.
      ELSE.
        IF l_char <> l_folder.
          l_char = l_folder.
          SET PARAMETER ID 'ECATT_FILENAME' FIELD l_char.
        ENDIF.
      ENDIF.
*}+010922-NTP-3000018956

      "Downlad
*{R-PBM240419-3000011085
      TRY.
          CREATE OBJECT lo_obj TYPE (lv_classname).
          TRY.
              CALL METHOD lo_obj->(lv_method)
                EXPORTING
                  i_nrodocsap  = <fs_reporte>-zzt_nrodocsap
                  i_numeracion = <fs_reporte>-zzt_numeracion
                  i_down       = abap_on
                  i_folder     = l_folder
                EXCEPTIONS
                  error        = 1.
              IF sy-subrc <> 0.
                MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                           WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
              ENDIF.
            CATCH cx_ai_system_fault      INTO lo_cx.
            CATCH cx_ai_application_fault INTO lo_cx.
          ENDTRY.
        CATCH cx_ai_system_fault INTO lo_cx.
      ENDTRY.
*}R-PBM240419-3000011085

      MESSAGE s000 WITH 'Documento(s) descargados'.
    WHEN OTHERS.

      MESSAGE e000 WITH 'Acción cancelada'.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PF_SINCRONIZAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pf_sincronizar .

  DATA: ls_reporte TYPE          zoses_femonitor,
        l_answer   TYPE          char01,
        lr_numero  TYPE RANGE OF zoses_femonitor-zzt_numeracion,
        lr_tipdoc  TYPE RANGE OF zoses_femonitor-zzt_tipodoc,         "I-3000012035-NTP-110619
        lr_fecha   TYPE RANGE OF sy-datum,
        lr_status  TYPE RANGE OF zosed_status_cdr,
        l_string   TYPE          string.

*{ BEGIN OF INSERT WMR-06012021-3000014829
  CASE gs_t001-land1.
    WHEN gc_peru.
    WHEN OTHERS.
      MESSAGE s208(00) WITH TEXT-e06.
      EXIT.
  ENDCASE.
*} END OF INSERT WMR-06012021-3000014829

* Valida seleccion
  READ TABLE gt_reporte INTO ls_reporte WITH KEY selec = abap_true.
  IF sy-subrc <> 0.
    MESSAGE s000 WITH TEXT-s01 DISPLAY LIKE 'E'. EXIT.                 "M LJG-21.05.2018
  ENDIF.

* Confirmación
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = TEXT-i01
      text_question         = TEXT-i02
      display_cancel_button = space
    IMPORTING
      answer                = l_answer
    EXCEPTIONS ##FM_SUBRC_OK
      text_not_found        = 1
      OTHERS                = 2.
  IF l_answer <> '1'.
    MESSAGE s000 WITH TEXT-s02. EXIT.
  ENDIF.

* Proceso
  LOOP AT gt_reporte INTO ls_reporte WHERE selec = abap_true.
    CONCATENATE 'IEQ' ls_reporte-zzt_numeracion INTO l_string.
    APPEND l_string TO lr_numero.

    CONCATENATE 'IEQ' ls_reporte-zzt_tipodoc INTO l_string.   "I-3000012035-NTP-110619
    APPEND l_string TO lr_tipdoc.                             "I-3000012035-NTP-110619
  ENDLOOP.

  SUBMIT zosfe_int_updcdr_with_ws AND RETURN
    WITH p_bukrs = ls_reporte-bukrs
    WITH s_tipdoc IN lr_tipdoc                                "I-3000012035-NTP-110619
    WITH s_numero IN lr_numero
    WITH s_fecha  IN lr_fecha
    WITH s_status IN lr_status
    WITH p_previe = space
    WITH p_submit = abap_true
    WITH p_single = abap_true
    WITH p_resbol = space
    WITH p_combaj = space.                               "#EC CI_SUBMIT

ENDFORM.
*{  BEGIN OF INSERT WMR-140617-3000007486
*&---------------------------------------------------------------------*
*&      Form  GET_CONST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_const .

  DATA: ls_ceactsoc TYPE zostb_ceactsoc,                                      "I-WMR-14092020-3000014557
        lo_extract  TYPE REF TO object.                                       "I-WMR-14092020-3000014557

  SELECT * INTO TABLE gt_const
    FROM zostb_const_fe
    WHERE modulo      = gc_modul AND
          aplicacion  = gc_aplic AND
          programa    = gc_progr.

  " Nro. Instalación Sap
  CALL FUNCTION 'SLIC_GET_LICENCE_NUMBER'
    IMPORTING
      license_number = gw_license.

*{  BEGIN OF INSERT WMR-14092020-3000014557
* Procesos activos
  CLEAR gs_process.

  " ¿GRE está activo?
  CLEAR lo_extract.
  TRY .
      SELECT SINGLE bukrs INTO ls_ceactsoc-bukrs
        FROM zostb_ceactsoc WHERE guiaele = abap_true.
      CREATE OBJECT lo_extract TYPE (gc_extrac_gr).

      IF  ls_ceactsoc-bukrs IS NOT INITIAL      " ¿ Existe al menos una sociedad con GRE activa?
      AND lo_extract IS BOUND.                  " ¿ Está implementada la clase extractora de GRE?
        gs_process-active_gr = abap_true.
      ENDIF.
    CATCH cx_root.
  ENDTRY.

  " ¿Factura Financiera está activo?
  CLEAR lo_extract.
  TRY .
      CREATE OBJECT lo_extract TYPE (gc_extrac_fi).
      IF lo_extract IS BOUND.                   " ¿ Está implementada la clase extractora de GRE?
        gs_process-active_fi = abap_true.
      ENDIF.
    CATCH cx_root.
  ENDTRY.
*}  END OF INSERT WMR-14092020-3000014557

ENDFORM.
*}  END OF INSERT WMR-140617-3000007486
*{  BEGIN OF INSERT WMR-030717-3000006468
*&---------------------------------------------------------------------*
*&      Form  CANCELAR_DOCUMENTO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LW_ERROR  text
*----------------------------------------------------------------------*
FORM cancelar_documento  CHANGING po_error TYPE char1.

  DATA: lo_grid      TYPE REF TO cl_gui_alv_grid,
        lt_rows      TYPE lvc_t_roid,

        ls_rows      TYPE lvc_s_roid,
        ls_reporte   LIKE LINE OF gt_reporte,
        ls_usrautreg TYPE zostb_usrautreg,

        l_lines      TYPE i,
        l_text       TYPE string.

  po_error = abap_false.

*{ BEGIN OF INSERT WMR-06012021-3000014829
  CASE gs_t001-land1.
    WHEN gc_peru.
    WHEN OTHERS.
      po_error = abap_true.
      MESSAGE s208(00) WITH TEXT-e06.
      EXIT.
  ENDCASE.
*} END OF INSERT WMR-06012021-3000014829

*1. Verificar Autorización a Cancelar
  SELECT SINGLE * INTO ls_usrautreg
    FROM zostb_usrautreg
    WHERE bukrs EQ p_bukrs
      AND uname EQ sy-uname
      AND cafaele EQ abap_true.

  IF ls_usrautreg IS INITIAL.
    SELECT SINGLE * INTO ls_usrautreg
      FROM zostb_usrautreg
      WHERE bukrs EQ space
        AND uname EQ sy-uname
        AND cafaele EQ abap_true.
  ENDIF.

  IF ls_usrautreg IS INITIAL.
    MESSAGE i208(00) WITH TEXT-i03.                  "M LJG-21.05.2018
    po_error = abap_true. RETURN.
  ENDIF.


*2. Obtener selección
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
    MESSAGE i208(00) WITH TEXT-i04.                     "M LJG-21.05.2018
    po_error = abap_true. RETURN.
  ENDIF.

  READ TABLE lt_rows INTO ls_rows INDEX 1.
  CHECK sy-subrc EQ 0.

  READ TABLE gt_reporte INTO ls_reporte INDEX ls_rows-row_id.
  CHECK sy-subrc EQ 0.

  CASE ls_reporte-zzt_numeracion(1).
    WHEN 'F'
      OR 'B'.
    WHEN OTHERS.
      MESSAGE i208(00) WITH TEXT-i05.                   "M LJG-21.05.2018
      po_error = abap_true. RETURN.
  ENDCASE.

*3. Validación
  PERFORM pro_cancelar_documento USING ls_reporte abap_on CHANGING po_error.
  IF po_error IS INITIAL.

*4. Confirmación
    CONCATENATE ls_reporte-zzt_tipodoc ls_reporte-zzt_numeracion
                INTO l_text SEPARATED BY abap_undefined.
    CONCATENATE TEXT-i06
                l_text
                TEXT-i07 INTO l_text SEPARATED BY space.

    PERFORM _getconfirm USING l_text CHANGING po_error.
    IF po_error IS INITIAL.

*5. Procesar
      PERFORM pro_cancelar_documento USING ls_reporte abap_off CHANGING po_error.
    ENDIF.
  ENDIF.

ENDFORM.

*{I-NTP180717-3000006468
*----------------------------------------------------------------------*
* Cancelar documento
*----------------------------------------------------------------------*
FORM pro_cancelar_documento USING ls_reporte TYPE zoses_femonitor
                                  i_test TYPE char01
                            CHANGING po_error TYPE clike.

  DATA: lt_return   TYPE bapirettab,
        ls_vbrk_ori TYPE vbrk,
        ls_vbrk     TYPE vbrk,
        l_monat     TYPE t001b-frpe1.

  CASE ls_reporte-zzt_status_cdr.
    WHEN gc_status_0  " Inactivo
      OR gc_status_5  " Error XSD
      OR gc_status_6  " Error Excepción SUNAT
      OR gc_status_7. " Error Conexión Servicio Web

      " Obtener estado Anulado/ No anulado de documento
      SELECT SINGLE vbeln fksto
        INTO CORRESPONDING FIELDS OF ls_vbrk_ori
        FROM vbrk
        WHERE vbeln EQ ls_reporte-zzt_nrodocsap.

      IF ( ls_vbrk_ori-vbeln NE space AND ls_vbrk_ori-fksto EQ abap_false ).

* 1.- Verificación de Periodo Contable abierto
        l_monat = ls_reporte-zzt_femision+4(2).
        CALL FUNCTION 'FI_PERIOD_CHECK'
          EXPORTING
            i_bukrs          = ls_reporte-bukrs
            i_gjahr          = ls_reporte-zzt_femision(4)
            i_koart          = 'D'
            i_monat          = l_monat
          EXCEPTIONS
            error_period     = 1
            error_period_acc = 2
            invalid_input    = 3
            OTHERS           = 4.
        IF sy-subrc <> 0.
          MESSAGE i201(f5) WITH ls_reporte-zzt_femision+4(2) ls_reporte-zzt_femision(4) ##MG_MISSING.
          po_error = abap_true.
          RETURN.
        ENDIF.
      ENDIF.

* 2.- Validación de Estado en Portal y Sunat
      "Sunat acepta 01,07,08 hasta el momento
*      PERFORM consultar_status_sunat USING ls_reporte CHANGING po_error lt_return.
      IF po_error EQ abap_on.
        CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
          EXPORTING
            it_message = lt_return.
        RETURN.
      ENDIF.

      PERFORM consultar_documento USING ls_reporte CHANGING po_error lt_return.
      IF po_error EQ abap_true.
        CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
          EXPORTING
            it_message = lt_return.
        RETURN.
      ENDIF.

      "Modo real
      IF i_test = space.
        IF ( ls_vbrk_ori-vbeln NE space AND ls_vbrk_ori-fksto EQ abap_false ).

* 3.- Anulación de Documento
          PERFORM anular_documento USING ls_reporte CHANGING po_error ls_vbrk lt_return.
          IF po_error EQ abap_true.
            CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
              EXPORTING
                it_message = lt_return.
            RETURN.
          ENDIF.
        ENDIF.

* 4.- Enviar a web excepto status 0
        CASE ls_reporte-zzt_status_cdr.
          WHEN gc_status_0 OR gc_status_7.
            "Actualizar status solo en sap
            PERFORM actualizar_status_documento USING ls_reporte CHANGING po_error lt_return.

            CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
              EXPORTING
                it_message = lt_return.

          WHEN OTHERS.
            "Actualizar status a la web y sap
            PERFORM send_to_update_web USING ls_reporte.
            "Maneja su propio mensaje
        ENDCASE.
      ENDIF.

*{I-NTP180717-3000006468
    WHEN gc_status_1.
      MESSAGE s000 WITH TEXT-i08
                        TEXT-i09 DISPLAY LIKE 'E'.
      po_error = abap_on.

    WHEN gc_status_2.
      MESSAGE s000 WITH TEXT-i08
                        TEXT-i10 DISPLAY LIKE 'E'.
      po_error = abap_on.

    WHEN gc_status_3.
      MESSAGE s000 WITH TEXT-i08
                        TEXT-i09 DISPLAY LIKE 'E'.
      po_error = abap_on.

    WHEN gc_status_4.
      MESSAGE s000 WITH TEXT-i08
                        TEXT-i09 DISPLAY LIKE 'E'.
      po_error = abap_on.

    WHEN gc_status_8.
      MESSAGE s000 WITH TEXT-i08
                        TEXT-i11 DISPLAY LIKE 'E'.
      po_error = abap_on.

    WHEN gc_status_9.
      MESSAGE s000 WITH TEXT-i08
                        TEXT-i12 DISPLAY LIKE 'E'.
      po_error = abap_on.
*}I-NTP180717-3000006468
  ENDCASE.

ENDFORM.

*----------------------------------------------------------------------*
* Mensaje de confirmación
*----------------------------------------------------------------------*
FORM _getconfirm USING l_text TYPE string
                 CHANGING po_error TYPE char01.

  DATA: l_answer TYPE char01.

  CALL FUNCTION 'POPUP_TO_CONFIRM_WITH_MESSAGE'
    EXPORTING
      diagnosetext1 = l_text
      textline1     = TEXT-i15
      titel         = TEXT-i17
    IMPORTING
      answer        = l_answer.

  IF l_answer NE 'J'.
    po_error = abap_true.
  ENDIF.

ENDFORM.
*}I-NTP200717-3000006468

*&---------------------------------------------------------------------*
*&      Form  ANULAR_DOCUMENTO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_REPORTE  text
*      <--P_PO_ERROR  text
*      <--P_LS_VBRK  text
*      <--P_LT_RETURN  text
*----------------------------------------------------------------------*
FORM anular_documento  USING    is_reporte  TYPE zoses_femonitor
                       CHANGING ep_error    TYPE char1
                                es_vbrk     TYPE vbrk
                                et_return   TYPE bapirettab.

  DATA: lt_return1 TYPE STANDARD TABLE OF bapireturn1,
        lt_success TYPE STANDARD TABLE OF bapivbrksuccess,
        lt_lines   TYPE STANDARD TABLE OF tline,

        ls_return1 TYPE bapireturn1,
        ls_return  TYPE bapiret2,
        ls_success TYPE bapivbrksuccess,
        ls_lines   TYPE tline,
        ls_thead   TYPE thead.

  DATA: l_session TYPE char32,
        l_modno   TYPE string,
        l_id      TYPE indx-srtfd.

  CALL FUNCTION 'TH_GET_SESSION_ID'
    IMPORTING
      session_id = l_session.

  l_modno = sy-modno. CONDENSE l_modno.
  CONCATENATE l_modno l_session INTO l_id.

  " Se usa en Método UE_RV60AFZZ_NUMBER_RANGE de la clase ZOSSDCL_AMPLIACIONES_FE
  EXPORT reporte = is_reporte TO SHARED MEMORY indx(fe) CLIENT sy-mandt ID l_id.

  CALL FUNCTION 'BAPI_BILLINGDOC_CANCEL1'
    EXPORTING
      billingdocument = is_reporte-zzt_nrodocsap
      billingdate     = is_reporte-zzt_femision
    TABLES
      return          = lt_return1
      success         = lt_success.

  LOOP AT lt_return1 INTO ls_return1.
    CLEAR ls_return.
    MOVE-CORRESPONDING ls_return1 TO ls_return.
    APPEND ls_return TO et_return.
  ENDLOOP.

  READ TABLE et_return INTO ls_return WITH KEY id     = 'VF'
                                               number = '311'.
  IF sy-subrc NE 0.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ep_error = abap_true.

  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.

    CALL FUNCTION 'RZL_SLEEP'
      EXPORTING
        seconds = 1.

    READ TABLE lt_success INTO ls_success INDEX 1.
    IF sy-subrc EQ 0.
      es_vbrk-vbeln = ls_success-bill_doc.


      CLEAR ls_lines.
      ls_lines-tdformat = '*'.
      ls_lines-tdline   = TEXT-i18.
      APPEND ls_lines TO lt_lines.

      CLEAR: ls_thead.
      ls_thead-tdobject   = 'VBBK'.
      ls_thead-tdname     = es_vbrk-vbeln.
      SELECT SINGLE zz_tdidbaj INTO ls_thead-tdid
        FROM zostb_consextsun WHERE bukrs EQ is_reporte-bukrs.
      ls_thead-tdspras    = sy-langu.
      ls_thead-tdform     = 'SYSTEM'.
      ls_thead-tdversion  = '00001'.
      ls_thead-tdfuser    = sy-uname.

      CALL FUNCTION 'SAVE_TEXT'
        EXPORTING
          header          = ls_thead
          savemode_direct = abap_true
        IMPORTING
          newheader       = ls_thead
        TABLES
          lines           = lt_lines
        EXCEPTIONS
          id              = 1
          language        = 2
          name            = 3
          object          = 4
          OTHERS          = 5.

      IF sy-subrc EQ 0.
        CALL FUNCTION 'COMMIT_TEXT'.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.

*{I-NTP200717-3000006468
*----------------------------------------------------------------------*
* Consultar status sunat
*----------------------------------------------------------------------*
FORM consultar_status_sunat USING    is_reporte  TYPE zoses_femonitor ##NEEDED
                          CHANGING ep_error    TYPE char1 ##NEEDED
                                   et_return   TYPE bapirettab ##NEEDED ##CALLED.

  DATA: BEGIN OF zprocess ##NEEDED,
          ws_tpproc TYPE string VALUE 'CS', " Consulta Status Sunat
          ws_clase  TYPE string,
          ws_metodo TYPE string,
        END OF zprocess.

  DATA: ls_input   TYPE zosfe_ws_getstatussunatrequest,
        ls_output  TYPE zosfe_ws_getstatussunatrespons,
        lt_const   TYPE TABLE OF zostb_const_fe,
        ls_const   TYPE zostb_const_fe,
        ls_consext TYPE zostb_consextsun,
        ls_return  TYPE bapiret2,

        lr_tipdoc  TYPE RANGE OF zoses_femonitor-zzt_tipodoc,
        lr_stat_ok TYPE RANGE OF string,
        lr_stat_er TYPE RANGE OF string,

        ls_stat    LIKE LINE OF lr_stat_ok,
        ls_tipdoc  LIKE LINE OF lr_tipdoc,

        lo_obj     TYPE REF TO object,
        lo_cx      TYPE REF TO cx_root,
        l_message  TYPE string,
        l_envsun   TYPE zostb_envwsfe-envsun.

*1. Get constantes
  SELECT * INTO TABLE lt_const
    FROM zostb_const_fe
    WHERE aplicacion = 'WS_STAT_SUNAT'
      AND programa   = 'ZOSFE_INT_UPDCDR_WITH_WS'.

  LOOP AT lt_const INTO ls_const.
    CASE ls_const-campo.
        "Lee clase de syncronización segun HOST
      WHEN 'CLASSPROXY'.
        IF ls_const-valor1 = sy-host.
          SPLIT ls_const-valor2 AT '/' INTO zprocess-ws_clase zprocess-ws_metodo.
        ENDIF.
      WHEN 'STAT_OK'.
        ls_stat-sign = ls_const-signo.
        ls_stat-option = ls_const-opcion.
        ls_stat-low = ls_const-valor1.
        ls_stat-high = ls_const-valor2.
        APPEND ls_stat TO lr_stat_ok.
      WHEN 'STAT_ER'.
        ls_stat-sign = ls_const-signo.
        ls_stat-option = ls_const-opcion.
        ls_stat-low = ls_const-valor1.
        ls_stat-high = ls_const-valor2.
        APPEND ls_stat TO lr_stat_er.
      WHEN 'TIPDOC'.
        ls_tipdoc-sign = ls_const-signo.
        ls_tipdoc-option = ls_const-opcion.
        ls_tipdoc-low = ls_const-valor1.
        ls_tipdoc-high = ls_const-valor2.
        APPEND ls_tipdoc TO lr_tipdoc.
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP.

*2. Validar tipo documento que permite sunat para la consulta de status
  CHECK is_reporte-zzt_tipodoc IN lr_tipdoc.

*3. Leer datos de sociedad
  SELECT SINGLE * INTO ls_consext
    FROM zostb_consextsun
    WHERE bukrs EQ  is_reporte-bukrs.

  CLEAR: ls_input.
  ls_input-user     = ls_consext-zz_usuario_web.
  ls_input-pass     = ls_consext-zz_pass_web.
  ls_input-bukrs    = is_reporte-bukrs.
  ls_input-numera   = is_reporte-zzt_numeracion.
  ls_input-tipo_doc = is_reporte-zzt_tipodoc.

  " Determinar Ambiente Sunat
  PERFORM determinar_ambiente_sunat CHANGING l_envsun l_message.

  IF l_message IS NOT INITIAL.
    CLEAR ls_return.
    ls_return-type       = 'E'.
    ls_return-id         = 'ZOSFE'.
    ls_return-number     = '000'.
    ls_return-message_v1 = l_message.
    APPEND ls_return TO et_return.

    RETURN.
  ENDIF.

  " Determinar Proxy y Método
  SELECT SINGLE class method
    INTO (zprocess-ws_clase, zprocess-ws_metodo)
    FROM zostb_envwsfe
    WHERE bukrs  EQ is_reporte-bukrs
      AND envsun EQ l_envsun
      AND tpproc EQ zprocess-ws_tpproc.

  IF sy-subrc <> 0.
    CLEAR ls_return.
    ls_return-type       = 'E'.
    ls_return-id         = 'ZOSFE'.
    ls_return-number     = '000'.
    ls_return-message_v1 = 'No se pudo determinar Proxy'.
    APPEND ls_return TO et_return.

    RETURN.
  ENDIF.

*4. Consumir WS
  TRY.
      CREATE OBJECT lo_obj
        TYPE
          (zprocess-ws_clase)
        EXPORTING
          logical_port_name = ls_consext-zz_proxy_name.
      TRY.
          CALL METHOD lo_obj->(zprocess-ws_metodo)
            EXPORTING
              input  = ls_input
            IMPORTING
              output = ls_output.

        CATCH cx_ai_system_fault      INTO lo_cx.
        CATCH cx_ai_application_fault INTO lo_cx.
      ENDTRY.
    CATCH cx_ai_system_fault INTO lo_cx.
  ENDTRY.

  "Error
  IF lo_cx IS BOUND.
    ep_error = abap_true.

    l_message = lo_cx->get_text( ).
    CLEAR ls_return.
    ls_return-type       = 'E'.
    ls_return-id         = 'ZOSFE'.
    ls_return-number     = '000'.
    ls_return-message_v1 = l_message.
    APPEND ls_return TO et_return.

    RETURN.
  ENDIF.

  "Resultado
  IF ls_output-c_status-status_code IN lr_stat_ok.
    ep_error = abap_true.

    CLEAR ls_return.
    ls_return-type       = 'E'.
    ls_return-id         = 'ZOSFE'.
    ls_return-number     = '000'.
    ls_return-message_v1 = 'No es posible realizar esta acción,'.
    ls_return-message_v2 = 'el documento se encuentra en Sunat.'.
    ls_return-message_v3 = 'Mensaje Sunat:'.
    ls_return-message_v4 = ls_output-c_status-status_message.
    APPEND ls_return TO et_return.
  ELSEIF ls_output-c_status-status_code IN lr_stat_er.
    "Documento puede seguir procesando
  ELSE.
    "Status no registrado en las constantes
    ep_error = abap_true.

    CLEAR ls_return.
    ls_return-type       = 'E'.
    ls_return-id         = 'ZOSFE'.
    ls_return-number     = '000'.
    ls_return-message_v1 = 'No es posible realizar esta acción,'.
    ls_return-message_v2 = 'Servicio de sunat no disponible,'.
    ls_return-message_v3 = 'Mensaje Sunat:'.
    ls_return-message_v4 = ls_output-c_status-status_message.
    APPEND ls_return TO et_return.
  ENDIF.

ENDFORM.
*}I-NTP200717-3000006468

*&---------------------------------------------------------------------*
*&      Form  CONSULTAR_DOCUMENTO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_REPORTE  text
*      <--P_PO_ERROR  text
*      <--P_LT_RETURN  text
*----------------------------------------------------------------------*
FORM consultar_documento  USING    is_reporte  TYPE zoses_femonitor ##NEEDED
                          CHANGING ep_error    TYPE char1  ##NEEDED
                                   et_return   TYPE bapirettab ##NEEDED.

  DATA: BEGIN OF zprocess ##NEEDED,
          ws_tpproc TYPE string VALUE 'CP', " Consulta Status Portal Web
          ws_clase  TYPE string,
          ws_metodo TYPE string,
        END OF zprocess.

  DATA: ls_input   TYPE zosfe_ws_updcrdsaprequest,
        ls_output  TYPE zosfe_ws_updcrdsapresponse,
        ls_const   TYPE zostb_const_fe,
        ls_consext TYPE zostb_consextsun,
        ls_return  TYPE bapiret2,

        lo_obj     TYPE REF TO object,
        lo_cx      TYPE REF TO cx_root,
        l_message  TYPE string,
        l_envsun   TYPE zostb_envwsfe-envsun.

  "Lee clase de syncronización segun HOST
  SELECT SINGLE * INTO ls_const
    FROM zostb_const_fe
    WHERE aplicacion = 'WS_SYNC_FE'
      AND campo      = 'CLASSPROXY'
      AND valor1     = sy-host.
  IF sy-subrc = 0.
    SPLIT ls_const-valor2 AT '/'
      INTO zprocess-ws_clase zprocess-ws_metodo.
  ENDIF.

  "Leer datos de sociedad
  SELECT SINGLE * INTO ls_consext
    FROM zostb_consextsun
    WHERE bukrs EQ  is_reporte-bukrs.

  CLEAR: ls_input.
  ls_input-user     = ls_consext-zz_usuario_web.
  ls_input-pass     = ls_consext-zz_pass_web.
  ls_input-bukrs    = is_reporte-bukrs.
  ls_input-numera   = is_reporte-zzt_numeracion.
  ls_input-tipo_doc = is_reporte-zzt_tipodoc.

  " Determinar Ambiente Sunat
  PERFORM determinar_ambiente_sunat CHANGING l_envsun l_message.

  IF l_message IS NOT INITIAL.
    CLEAR ls_return.
    ls_return-type       = 'E'.
    ls_return-id         = 'ZOSFE'.
    ls_return-number     = '000'.
    ls_return-message_v1 = l_message.
    APPEND ls_return TO et_return.

    RETURN.
  ENDIF.

  " Determinar Proxy y Método
  SELECT SINGLE class method
    INTO (zprocess-ws_clase, zprocess-ws_metodo)
    FROM zostb_envwsfe
    WHERE bukrs  EQ is_reporte-bukrs
      AND envsun EQ l_envsun
      AND tpproc EQ zprocess-ws_tpproc.

  IF sy-subrc <> 0.
    CLEAR ls_return.
    ls_return-type       = 'E'.
    ls_return-id         = 'ZOSFE'.
    ls_return-number     = '000'.
    ls_return-message_v1 = 'No se pudo determinar Proxy'.
    APPEND ls_return TO et_return.

    RETURN.
  ENDIF.

  "Consumir WS
  TRY.
      CREATE OBJECT lo_obj
        TYPE
          (zprocess-ws_clase)
        EXPORTING
          logical_port_name = ls_consext-zz_proxy_name.
      TRY.
          CALL METHOD lo_obj->(zprocess-ws_metodo)
            EXPORTING
              input  = ls_input
            IMPORTING
              output = ls_output.

        CATCH cx_ai_system_fault      INTO lo_cx.
        CATCH cx_ai_application_fault INTO lo_cx.
      ENDTRY.
    CATCH cx_ai_system_fault INTO lo_cx.
  ENDTRY.

  IF lo_cx IS BOUND.
    ep_error = abap_true.

    l_message = lo_cx->get_text( ).
    CLEAR ls_return.
    ls_return-type       = 'E'.
    ls_return-id         = 'ZOSFE'.
    ls_return-number     = '000'.
    ls_return-message_v1 = l_message.
    APPEND ls_return TO et_return.

    RETURN.
  ENDIF.

  CASE is_reporte-zzt_status_cdr.
    WHEN gc_status_0. " Inactivo
      IF ls_output-c_cdr-numera = is_reporte-zzt_numeracion.
        ep_error = abap_true.

        CLEAR ls_return.
        ls_return-type       = 'E'.
        ls_return-id         = 'ZOSFE'.
        ls_return-number     = '000'.
        ls_return-message_v1 = 'No es posible realizar esta acción,'.
        ls_return-message_v2 = 'el documento se encuentra en Sunat'.
        APPEND ls_return TO et_return.

        RETURN.
      ENDIF.

    WHEN gc_status_5. " Error XSD
      CASE ls_output-c_cdr-status.
        WHEN '1'  " Aceptado
          OR '4'  " Aceptado con Observaciones
          OR '3'. " Rechazado
          ep_error = abap_true.

          CLEAR ls_return.
          ls_return-type       = 'E'.
          ls_return-id         = 'ZOSFE'.
          ls_return-number     = '000'.
          ls_return-message_v1 = 'No es posible realizar esta acción,'.
          ls_return-message_v2 = 'el documento se encuentra en Sunat'.
          APPEND ls_return TO et_return.

          RETURN.
        WHEN OTHERS.

      ENDCASE.

    WHEN gc_status_6. " Error Excepción SUNAT
      CASE ls_output-c_cdr-status.
        WHEN '1'  " Aceptado
          OR '4'  " Aceptado con Observaciones
          OR '3'. " Rechazado
          ep_error = abap_true.

          CLEAR ls_return.
          ls_return-type       = 'E'.
          ls_return-id         = 'ZOSFE'.
          ls_return-number     = '000'.
          ls_return-message_v1 = 'No es posible realizar esta acción,'.
          ls_return-message_v2 = 'el documento se encuentra en Sunat'.
          APPEND ls_return TO et_return.

          RETURN.
        WHEN OTHERS.

      ENDCASE.

    WHEN gc_status_7. " Error Conexión Servicio Web
      IF ls_output-c_cdr-numera = is_reporte-zzt_numeracion.
        ep_error = abap_true.

        CLEAR ls_return.
        ls_return-type       = 'E'.
        ls_return-id         = 'ZOSFE'.
        ls_return-number     = '000'.
        ls_return-message_v1 = 'No es posible realizar esta acción,'.
        ls_return-message_v2 = 'el documento se encuentra en Sunat'.
        APPEND ls_return TO et_return.

        RETURN.
      ENDIF.

  ENDCASE.

ENDFORM.

*{I-NTP260717-3000006468
*----------------------------------------------------------------------*
* Enviar a la web para actualizar
*----------------------------------------------------------------------*
FORM send_to_update_web USING ls_reporte TYPE zoses_femonitor.

  DATA: lw_tipodoc TYPE char02 ##NEEDED,
        lw_fac     TYPE char01,
        lw_bol     TYPE char01,
        lw_nc      TYPE char01,
        lw_nd      TYPE char01,
        lw_gr      TYPE char01.

  CASE ls_reporte-zzt_tipodoc.
    WHEN gc_tipdoc_fa.  lw_fac = abap_true.
    WHEN gc_tipdoc_bl.  lw_bol = abap_true.
    WHEN gc_tipdoc_nc.  lw_nc  = abap_true.
    WHEN gc_tipdoc_nd.  lw_nd  = abap_true.
    WHEN gc_tipdoc_gr.  lw_gr  = abap_true.
  ENDCASE.

* Enviar documento anulado a la web
  SUBMIT zosfe_pro_fereproceso AND RETURN
      WITH p_opcfa  = lw_fac
      WITH p_opcbl  = lw_bol
      WITH p_opcnc  = lw_nc
      WITH p_opcnd  = lw_nd
      WITH p_opcgr  = lw_gr                                     "I-WMR-060318-3000009350
      WITH p_docsap = ls_reporte-zzt_nrodocsap
      WITH p_numera = ls_reporte-zzt_numeracion
      WITH p_facpor = abap_on
      WITH p_synsta = gc_status_9.                       "#EC CI_SUBMIT

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  ACTUALIZAR_STATUS_DOCUMENTO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_REPORTE  text
*      <--P_PO_ERROR  text
*      <--P_LT_RETURN  text
*----------------------------------------------------------------------*
FORM actualizar_status_documento  USING    is_reporte  TYPE zoses_femonitor
                                  CHANGING ep_error    TYPE char1
                                           et_return   TYPE bapirettab.
  DATA: ls_return TYPE bapiret2.

  UPDATE zostb_felog SET: zzt_status_cdr = gc_status_9
                          usuregu        = sy-uname
                          fecregu        = sy-datum
                          horregu        = sy-uzeit
                     WHERE zzt_nrodocsap  = is_reporte-zzt_nrodocsap
                       AND zzt_numeracion = is_reporte-zzt_numeracion.
  IF sy-subrc EQ 0.
    COMMIT WORK.

    ls_return-type       = 'S'.
    ls_return-id         = 'ZOSFE'.
    ls_return-number     = '000'.
    ls_return-message_v1 = TEXT-s03.

  ELSE.
    ROLLBACK WORK.                                     "#EC CI_ROLLBACK

    ep_error = abap_true.

    ls_return-type       = 'E'.
    ls_return-id         = 'ZOSFE'.
    ls_return-number     = '000'.
    ls_return-message_v1 = TEXT-e05.
  ENDIF.

  APPEND ls_return TO et_return.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DETERMINAR_AMBIENTE_SUNAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_L_ENVSUN  text
*      <--P_L_MESSAGE  text
*----------------------------------------------------------------------*
FORM determinar_ambiente_sunat  CHANGING ep_envsun  TYPE zostb_envwsfe-envsun
                                         ep_message TYPE string ##CALLED.

  DATA: l_system  TYPE string.

  SELECT SINGLE valor2 INTO l_system ##WARN_OK
    FROM zostb_const_fe
    WHERE modulo     EQ gc_modul
      AND aplicacion EQ gc_aplic
      AND programa   EQ gc_progr
      AND valor1     EQ sy-host.

  IF sy-subrc <> 0.
    ep_message = TEXT-002.
    EXIT.
  ENDIF.

  CASE l_system.
    WHEN zossdcl_pro_extrac_fe=>gc_system_qas.
      ep_envsun = 'TES'.
    WHEN zossdcl_pro_extrac_fe=>gc_system_prd.
      ep_envsun = 'PRD'.
    WHEN OTHERS.
      ep_message = TEXT-i19.
      EXIT.
  ENDCASE.

ENDFORM.
*}I-NTP260717-3000006468
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
    EXPORTING
      i_bukrs = p_bukrs
    EXCEPTIONS
      error   = 1
      OTHERS  = 2 ).
  IF sy-subrc <> 0.
    gw_error = abap_on.
    MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 DISPLAY LIKE 'E'.
  ENDIF.

  CHECK gw_error = abap_off.

  SELECT SINGLE * INTO gs_t001 FROM t001 WHERE bukrs = p_bukrs.               "I-WMR-12122020-3000014829

ENDFORM.
*}  END OF INSERT WMR-130319-3000010823
