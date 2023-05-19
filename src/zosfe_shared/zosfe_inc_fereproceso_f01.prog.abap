*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_FEREPROCESO_F01
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

  SELECT SINGLE *
  INTO gs_constantes
  FROM zostb_consextsun ##WARN_OK.

*   Constantes Ubica usuario para Homologación
  SELECT * INTO TABLE gt_cosnt
    FROM zostb_const_fe
    WHERE modulo      = gc_modul AND
          aplicacion  = gc_aplic AND
          programa    = gc_progr.

*{BEGIN OF EXCLUDE NTP-060616
*  IF sy-subrc = 0.
*    LOOP AT gt_cosnt INTO gs_const.
*      CASE gs_const-campo.
*        WHEN 'USER'.
*          rs_user-sign   = 'I'.
*          rs_user-option = 'EQ'.
*          rs_user-low    = gs_const-valor1.
*          APPEND rs_user TO gr_user.
*        WHEN 'INICIO'.
*          gw_inicio = gs_const-valor1.
**{  BEGIN OF INSERT WMR-030615
*        WHEN zossdcl_pro_extrac_fe=>gc_campo_test_act.
*          " Indicador Sistema Test activo
*          gw_test_act    = gs_const-valor1.
**}  END OF INSERT WMR-030615
**{  BEGIN OF INSERT WMR-270715
*        WHEN zossdcl_pro_extrac_fe=>gc_campo_mandt_prd.
*          " Mandante Productivo Real
*          gw_mandt_prd   = gs_const-valor1.
**}  END OF INSERT WMR-270715
*      ENDCASE.
*    ENDLOOP.
*
**{  BEGIN OF INSERT WMR-030615
*    " Determinar Nombre de Sistema
*    READ TABLE gt_cosnt INTO gs_const
*         WITH KEY campo  = zossdcl_pro_extrac_fe=>gc_campo_host
*                  valor1 = sy-host.
*    IF sy-subrc EQ 0.
*      gw_system = gs_const-valor2.
*    ENDIF.
**}  END OF INSERT WMR-030615
*  ENDIF.
*}END OF EXCLUDE NTP-060616

ENDFORM.                    " GET_CONST

*&---------------------------------------------------------------------*
*&      Form  create_objects
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM create_objects.

*  CREATE OBJECT cl_extfac.                                                                                       "-NTP010523-3000020188
  zossdcl_pro_extrac_fe=>get_badi_object( EXPORTING i_classname = gc_classname_fe CHANGING co_obj = cl_extfac ).  "+NTP010523-3000020188

ENDFORM.                    "create_objects

*{BEGIN OF REPLACE NTP-060616
**&---------------------------------------------------------------------*
**&      Form  get_data
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**      -->PO_ERROR   text
**----------------------------------------------------------------------*
*FORM get_data CHANGING po_error TYPE char1.
*
*  DATA: lw_status TYPE zostb_felog-zzt_status_cdr.
*  DATA: ls_vbrk TYPE vbrk,                                                    "I-WMR-220915
*        ls_likp TYPE likp.                                                    "I-WMR-140116
*
**{  BEGIN OF INSERT WMR-220915
*  " Validar si es FAC/ BOL/ NC/ ND                                            "I-WMR-140116
*  SELECT SINGLE *
*    INTO ls_vbrk
*    FROM vbrk
*    WHERE vbeln EQ p_docsap.
*
*  " Validar si es G/R                                                         "I-WMR-140116
*  IF sy-subrc NE 0.                                                           "I-WMR-140116
*    SELECT SINGLE *                                                           "I-WMR-140116
*      INTO ls_likp                                                            "I-WMR-140116
*      FROM likp                                                               "I-WMR-140116
*      WHERE vbeln EQ p_docsap.                                                "I-WMR-140116
*  ENDIF.                                                                      "I-WMR-140116
*
*  " Validar existencia de documento Sap
*  IF sy-subrc NE 0.
*    po_error = abap_true.
*    MESSAGE s208(00) WITH text-e03.
*    EXIT.
*  ENDIF.
*
*  " Validar Tipo de comprobante con opción seleccionada
*  IF ls_vbrk IS NOT INITIAL.                                                  "I-WMR-140116
*    CASE ls_vbrk-xblnr(2).
*      WHEN gc_tipdoc_fa.
*        IF p_opcfa EQ abap_false.
*          po_error = abap_true.
*          MESSAGE s208(00) WITH text-e04.
*          EXIT.
*        ENDIF.
*      WHEN gc_tipdoc_bl.
*        IF p_opcbl EQ abap_false.
*          po_error = abap_true.
*          MESSAGE s208(00) WITH text-e04.
*          EXIT.
*        ENDIF.
*      WHEN gc_tipdoc_nc.
*        IF p_opcnc EQ abap_false.
*          po_error = abap_true.
*          MESSAGE s208(00) WITH text-e04.
*          EXIT.
*        ENDIF.
*      WHEN gc_tipdoc_nd.
*        IF p_opcnd EQ abap_false.
*          po_error = abap_true.
*          MESSAGE s208(00) WITH text-e04.
*          EXIT.
*        ENDIF.
*    ENDCASE.
*  ENDIF.                                                                      "I-WMR-140116
*
*  IF ls_likp IS NOT INITIAL.                                                  "I-WMR-140116
*    IF p_opcgr EQ abap_false.                                                 "I-WMR-140116
*      po_error = abap_true.                                                   "I-WMR-140116
*      MESSAGE s208(00) WITH text-e04.                                         "I-WMR-140116
*      EXIT.                                                                   "I-WMR-140116
*    ENDIF.                                                                    "I-WMR-140116
*  ENDIF.
**}  END OF INSERT WMR-220915
*
** Obtener Status
*  SELECT SINGLE zzt_status_cdr zzt_nrodocsap
*  FROM zostb_felog
*  INTO (lw_status,gw_nrodocsap )
*  WHERE zzt_nrodocsap  EQ p_docsap
*    AND zzt_numeracion EQ p_numera.
*
** Evaluar Status
*  IF p_opcgr EQ abap_true.                                                    "I-WMR-140116
*    CASE lw_status.                                                           "I-WMR-140116
*      WHEN gc_status_0 OR gc_status_5 OR gc_status_6  " Excepción o error XSD "I-WMR-140116
*        OR gc_status_7.                               " Error Conexión WS     "I-WMR-140116
*
*      WHEN OTHERS.                                                            "I-WMR-140116
*        po_error = abap_true.                                                 "I-WMR-140116
*        MESSAGE s208(00) WITH text-e02.                                       "I-WMR-140116
*    ENDCASE.                                                                  "I-WMR-140116
*
*  ELSE.                                                                       "I-WMR-140116
*
*    CASE lw_status.
*      WHEN gc_status_7.                           " Error Conexión WS
*        PERFORM get_data_store CHANGING po_error.
*      WHEN gc_status_0 OR gc_status_5 OR gc_status_6.
*        PERFORM get_data_again CHANGING po_error. " Excepción o error XSD
*      WHEN OTHERS.
*        po_error = abap_true.
*        MESSAGE s208(00) WITH text-e02.
*    ENDCASE.
*  ENDIF.                                                                      "I-WMR-140116
*
*ENDFORM.                    " GET_DATA
*
**&---------------------------------------------------------------------*
**&      Form  get_data_store
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**      -->PO_ERROR   text
**----------------------------------------------------------------------*
*FORM get_data_store CHANGING po_error TYPE char1.
*
** Cabecera
*  SELECT *
*  INTO TABLE gt_fecab
*  FROM zostb_fecab
*  WHERE zzt_nrodocsap  EQ p_docsap
*    AND zzt_numeracion EQ p_numera.
*  IF sy-subrc NE 0.
*    po_error = abap_true.
*    MESSAGE s208(00) WITH text-e01.
*    EXIT.
*  ENDIF.
*
** Detalle
*  SELECT *
*  INTO TABLE gt_fedet
*  FROM zostb_fedet
*  WHERE zzt_nrodocsap  EQ p_docsap
*    AND zzt_numeracion EQ p_numera.
*
** Cliente
*  SELECT *
*  INTO TABLE gt_fecli
*  FROM zostb_fecli
*  WHERE zzt_nrodocsap  EQ p_docsap
*    AND zzt_numeracion EQ p_numera.
*
**{  BEGIN OF INSERT WMR-230615
*  " Textos de cabecera
*  SELECT *
*    INTO TABLE gt_headtext
*    FROM zostb_docexpostc
*    WHERE zz_nrodocsap  EQ p_docsap
*      AND zz_numeracion EQ p_numera.
**}  END OF INSERT WMR-230615
*
** Borrar datos de Log antiguos
*  DELETE FROM zostb_felog WHERE zzt_nrodocsap  EQ p_docsap
*                            AND zzt_numeracion EQ p_numera.
*
*ENDFORM.                    "get_data_store
*
**&---------------------------------------------------------------------*
**&      Form  get_data_again
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**      -->PO_ERROR   text
**----------------------------------------------------------------------*
*FORM get_data_again CHANGING po_error TYPE char1.
*
** Borrar datos de Log antiguos
*  DELETE FROM zostb_felog WHERE zzt_nrodocsap  EQ p_docsap
*                            AND zzt_numeracion EQ p_numera.
*
** Factura
*  IF p_opcfa = abap_true.
*    CALL METHOD cl_extfac->extrae_data_facturas
*      EXPORTING
*        p_vbeln    = p_docsap
*      IMPORTING
*        p_fecab    = gt_fecab
*        p_fecab2   = gt_fecab2
*        p_fedet    = gt_fedet
*        p_fecli    = gt_fecli
*        p_headtext = gt_headtext                                  "I-WMR-230615
*        p_error    = po_error
*        p_message  = gt_message.
*  ENDIF.
*
** Boleta
*  IF p_opcbl = abap_true.
*    CALL METHOD cl_extfac->extrae_data_boletas
*      EXPORTING
*        p_vbeln    = p_docsap
*      IMPORTING
*        p_fecab    = gt_fecab
*        p_fecab2   = gt_fecab2
*        p_fedet    = gt_fedet
*        p_fecli    = gt_fecli
*        p_headtext = gt_headtext                                  "I-WMR-230615
*        p_error    = po_error
*        p_message  = gt_message.
*  ENDIF.
*
** NC
*  IF p_opcnc = abap_true.
*    CALL METHOD cl_extfac->extrae_data_nc
*      EXPORTING
*        p_vbeln    = p_docsap
*      IMPORTING
*        p_fecab    = gt_fecab
*        p_fecab2   = gt_fecab2
*        p_fedet    = gt_fedet
*        p_fecli    = gt_fecli
*        p_headtext = gt_headtext                                  "I-WMR-230615
*        p_error    = po_error
*        p_message  = gt_message.
*  ENDIF.
*
** ND
*  IF p_opcnd = abap_true.
*    CALL METHOD cl_extfac->extrae_data_nd
*      EXPORTING
*        p_vbeln    = p_docsap
*      IMPORTING
*        p_fecab    = gt_fecab
*        p_fecab2   = gt_fecab2
*        p_fedet    = gt_fedet
*        p_fecli    = gt_fecli
*        p_headtext = gt_headtext                                  "I-WMR-230615
*        p_error    = po_error
*        p_message  = gt_message.
*  ENDIF.
*
** En caso de error, mostrar log
*  IF po_error = abap_true.
*    CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
*      EXPORTING
*        it_message = gt_message.
*  ENDIF.
*
*ENDFORM.                    "get_data_again
*
**&---------------------------------------------------------------------*
**&      Form  REP_DATA
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**  -->  p1        text
**  <--  p2        text
**----------------------------------------------------------------------*
*FORM rep_data .
*
** Factura
*  IF p_opcfa = abap_true.
*    PERFORM rep_fact.
*  ENDIF.
*
** Boleta
*  IF p_opcbl = abap_true.
*    PERFORM rep_bole.
*  ENDIF.
*
** NC
*  IF p_opcnc = abap_true.
*    PERFORM rep_nocr.
*  ENDIF.
*
** ND
*  IF p_opcnd = abap_true.
*    PERFORM rep_nodb.
*  ENDIF.
*
**{  BEGIN OF INSERT WMR-140116
*  " GR
*  IF p_opcgr = abap_true.
*    PERFORM rep_guiarem.
*  ENDIF.
**}  END OF INSERT WMR-140116
*
*ENDFORM.                    " REP_DATA
*
**&---------------------------------------------------------------------*
**&      Form  rep_fact
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
*FORM rep_fact.
*
** Llenar datos WS
*  CALL METHOD cl_extfac->set_ws_fa
*    EXPORTING
*      pi_user     = gs_constantes-zz_usuario_web
*      pi_pass     = gs_constantes-zz_pass_web
*      pi_fecab    = gt_fecab
*      pi_fecab2   = gt_fecab2
*      pi_fedet    = gt_fedet
*      pi_fecli    = gt_fecli
*      pi_headtext = gt_headtext                                  "I-WMR-230615
*    IMPORTING
*      pe_datosws  = inputfc
*      pe_numeraci = gw_numeraci.
*
**Llamar Web Service
**{  BEGIN OF REPLACE WMR-030615
*  ""  IF ( sy-mandt <> gc_mandt ) AND ( sy-uname NOT IN gr_user ) AND ( gr_user[] IS NOT INITIAL ). "TEST  QAS
*
*  ""    inputfc_1 = inputfc.
*  ""    CALL METHOD cl_extfac->call_ws_1
*  ""      EXPORTING
*  ""        pi_tipdoc   = gc_tipdoc_fa
*  ""        pi_proxy    = gs_constantes-zz_proxy_name
*  ""        pi_input    = inputfc_1
*  ""        pi_numeraci = gw_numeraci
*  ""        pi_vbeln    = p_docsap
*  ""      IMPORTING
*  ""        pe_message  = gt_message.
*
*  ""  ELSEIF sy-mandt = gc_mandt.                                                               "PRD
*  ""    CALL METHOD cl_extfac->call_ws
*  ""      EXPORTING
*  ""        pi_tipdoc   = gc_tipdoc_fa
*  ""        pi_proxy    = gs_constantes-zz_proxy_name
*  ""        pi_input    = inputfc
*  ""        pi_numeraci = gw_numeraci
*  ""        pi_vbeln    = p_docsap
*  ""      IMPORTING
*  ""        pe_message  = gt_message.
*  ""  ELSEIF ( sy-mandt <> gc_mandt ) AND ( sy-uname IN gr_user ) AND ( gr_user[] IS NOT INITIAL ). "HOMO  QAS
*  ""    inputfc_2 = inputfc.
*  ""    CALL METHOD cl_extfac->call_ws_2
*  ""      EXPORTING
*  ""        pi_tipdoc   = gc_tipdoc_fa
*  ""        pi_proxy    = gs_constantes-zz_proxy_name
*  ""        pi_input    = inputfc_2
*  ""        pi_numeraci = gw_numeraci
*  ""        pi_vbeln    = p_docsap
*  ""      IMPORTING
*  ""        pe_message  = gt_message.
*  ""  ENDIF.
*
*  CASE gw_system.
*    WHEN zossdcl_pro_extrac_fe=>gc_system_qas.  " QAS
*      IF gw_test_act EQ abap_true.
*        " Sistema Test está activo
*        inputfc_1 = inputfc.
*        CALL METHOD cl_extfac->call_ws_1
*          EXPORTING
*            pi_tipdoc   = gc_tipdoc_fa
*            pi_proxy    = gs_constantes-zz_proxy_name
*            pi_input    = inputfc_1
*            pi_numeraci = gw_numeraci
*            pi_vbeln    = p_docsap
*          IMPORTING
*            pe_message  = gt_message.
*      ELSE.
*        " Sistema Test está inactivo; por lo tanto, direccionar a Homologación
*        inputfc_2 = inputfc.
*        CALL METHOD cl_extfac->call_ws_2
*          EXPORTING
*            pi_tipdoc   = gc_tipdoc_fa
*            pi_proxy    = gs_constantes-zz_proxy_name
*            pi_input    = inputfc_2
*            pi_numeraci = gw_numeraci
*            pi_vbeln    = p_docsap
*          IMPORTING
*            pe_message  = gt_message.
*      ENDIF.
*    WHEN zossdcl_pro_extrac_fe=>gc_system_prd.  " PRD
*      IF sy-mandt EQ gw_mandt_prd.
*        CALL METHOD cl_extfac->call_ws
*          EXPORTING
*            pi_tipdoc   = gc_tipdoc_fa
*            pi_proxy    = gs_constantes-zz_proxy_name
*            pi_input    = inputfc
*            pi_numeraci = gw_numeraci
*            pi_vbeln    = p_docsap
*          IMPORTING
*            pe_message  = gt_message.
*      ELSE.
*        " Si No es el mandante productivo real direccionar a Test Sunat
*        inputfc_1 = inputfc.
*        CALL METHOD cl_extfac->call_ws_1
*          EXPORTING
*            pi_tipdoc   = gc_tipdoc_fa
*            pi_proxy    = gs_constantes-zz_proxy_name
*            pi_input    = inputfc_1
*            pi_numeraci = gw_numeraci
*            pi_vbeln    = p_docsap
*          IMPORTING
*            pe_message  = gt_message.
*      ENDIF.
*  ENDCASE.
**}  END OF REPLACE WMR-030615
*
*ENDFORM.                    "rep_fact
*
**&---------------------------------------------------------------------*
**&      Form  rep_bole
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
*FORM rep_bole.
*
** Llenar datos WS
*  CALL METHOD cl_extfac->set_ws_bl
*    EXPORTING
*      pi_user     = gs_constantes-zz_usuario_web
*      pi_pass     = gs_constantes-zz_pass_web
*      pi_fecab    = gt_fecab
*      pi_fecab2   = gt_fecab2
*      pi_fedet    = gt_fedet
*      pi_fecli    = gt_fecli
*      pi_headtext = gt_headtext                                  "I-WMR-230615
*    IMPORTING
*      pe_datosws  = inputbl
*      pe_numeraci = gw_numeraci.
*
** Llamar Web Service
**{  BEGIN OF REPLACE WMR-030615
*  ""  IF ( sy-mandt <> gc_mandt ) AND ( sy-uname NOT IN gr_user ) AND ( gr_user[] IS NOT INITIAL )."TEST
*  ""    inputbl_1 = inputbl.
*  ""    CALL METHOD cl_extfac->call_ws_1
*  ""      EXPORTING
*  ""        pi_tipdoc   = gc_tipdoc_bl
*  ""        pi_proxy    = gs_constantes-zz_proxy_name
*  ""        pi_input    = inputbl_1
*  ""        pi_numeraci = gw_numeraci
*  ""        pi_vbeln    = p_docsap
*  ""      IMPORTING
*  ""        pe_message  = gt_message.
*  ""  ELSEIF sy-mandt = gc_mandt.                       "PRD
*  ""    CALL METHOD cl_extfac->call_ws
*  ""      EXPORTING
*  ""        pi_tipdoc   = gc_tipdoc_bl
*  ""        pi_proxy    = gs_constantes-zz_proxy_name
*  ""        pi_input    = inputbl
*  ""        pi_numeraci = gw_numeraci
*  ""        pi_vbeln    = p_docsap
*  ""      IMPORTING
*  ""        pe_message  = gt_message.
*  ""  ELSEIF ( sy-mandt <> gc_mandt )  AND ( sy-uname IN gr_user ) AND ( gr_user[] IS NOT INITIAL ). "HOMO  QAS
*  ""    inputbl_2 = inputbl.
*  ""    CALL METHOD cl_extfac->call_ws_2
*  ""      EXPORTING
*  ""        pi_tipdoc   = gc_tipdoc_bl
*  ""        pi_proxy    = gs_constantes-zz_proxy_name
*  ""        pi_input    = inputbl_2
*  ""        pi_numeraci = gw_numeraci
*  ""        pi_vbeln    = p_docsap
*  ""      IMPORTING
*  ""        pe_message  = gt_message.
*  ""  ENDIF.
*
*  CASE gw_system.
*    WHEN zossdcl_pro_extrac_fe=>gc_system_qas.  " QAS
*      IF gw_test_act EQ abap_true.
*        " Sistema Test está activo
*        inputbl_1 = inputbl.
*        CALL METHOD cl_extfac->call_ws_1
*          EXPORTING
*            pi_tipdoc   = gc_tipdoc_bl
*            pi_proxy    = gs_constantes-zz_proxy_name
*            pi_input    = inputbl_1
*            pi_numeraci = gw_numeraci
*            pi_vbeln    = p_docsap
*          IMPORTING
*            pe_message  = gt_message.
*      ELSE.
*        " Sistema Test está inactivo; por lo tanto, direccionar a Homologación
*        inputbl_2 = inputbl.
*        CALL METHOD cl_extfac->call_ws_2
*          EXPORTING
*            pi_tipdoc   = gc_tipdoc_bl
*            pi_proxy    = gs_constantes-zz_proxy_name
*            pi_input    = inputbl_2
*            pi_numeraci = gw_numeraci
*            pi_vbeln    = p_docsap
*          IMPORTING
*            pe_message  = gt_message.
*      ENDIF.
*    WHEN zossdcl_pro_extrac_fe=>gc_system_prd.  " PRD
*      IF sy-mandt EQ gw_mandt_prd.
*        CALL METHOD cl_extfac->call_ws
*          EXPORTING
*            pi_tipdoc   = gc_tipdoc_bl
*            pi_proxy    = gs_constantes-zz_proxy_name
*            pi_input    = inputbl
*            pi_numeraci = gw_numeraci
*            pi_vbeln    = p_docsap
*          IMPORTING
*            pe_message  = gt_message.
*      ELSE.
*        " Si No es el mandante productivo real direccionar a Test Sunat
*        inputbl_1 = inputbl.
*        CALL METHOD cl_extfac->call_ws_1
*          EXPORTING
*            pi_tipdoc   = gc_tipdoc_bl
*            pi_proxy    = gs_constantes-zz_proxy_name
*            pi_input    = inputbl_1
*            pi_numeraci = gw_numeraci
*            pi_vbeln    = p_docsap
*          IMPORTING
*            pe_message  = gt_message.
*      ENDIF.
*  ENDCASE.
**}  END OF REPLACE WMR-030615
*ENDFORM.                    "rep_bole
*
**&---------------------------------------------------------------------*
**&      Form  rep_nocr
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
*FORM rep_nocr.
*
** Llenar datos WS
*  CALL METHOD cl_extfac->set_ws_nc
*    EXPORTING
*      pi_user     = gs_constantes-zz_usuario_web
*      pi_pass     = gs_constantes-zz_pass_web
*      pi_fecab    = gt_fecab
*      pi_fecab2   = gt_fecab2
*      pi_fedet    = gt_fedet
*      pi_fecli    = gt_fecli
*      pi_headtext = gt_headtext                                  "I-WMR-230615
*    IMPORTING
*      pe_datosws  = inputnc
*      pe_numeraci = gw_numeraci.
*
** Llamar Web Service
**{  BEGIN OF REPLACE WMR-030615
*  ""  IF ( sy-mandt <> gc_mandt ) AND ( sy-uname NOT IN gr_user ) AND ( gr_user[] IS NOT INITIAL ). "TEST
*  ""    inputnc_1 = inputnc.
*  ""    CALL METHOD cl_extfac->call_ws_1
*  ""      EXPORTING
*  ""        pi_tipdoc   = gc_tipdoc_nc
*  ""        pi_proxy    = gs_constantes-zz_proxy_name
*  ""        pi_input    = inputnc_1
*  ""        pi_numeraci = gw_numeraci
*  ""        pi_vbeln    = p_docsap
*  ""      IMPORTING
*  ""        pe_message  = gt_message.
*  ""  ELSEIF sy-mandt = gc_mandt.                       "PRD
*  ""    CALL METHOD cl_extfac->call_ws
*  ""      EXPORTING
*  ""        pi_tipdoc   = gc_tipdoc_nc
*  ""        pi_proxy    = gs_constantes-zz_proxy_name
*  ""        pi_input    = inputnc
*  ""        pi_numeraci = gw_numeraci
*  ""        pi_vbeln    = p_docsap
*  ""      IMPORTING
*  ""        pe_message  = gt_message.
*  ""  ELSEIF ( sy-mandt <> gc_mandt )  AND ( sy-uname IN gr_user ) AND ( gr_user[] IS NOT INITIAL ). "HOMO  QAS
*  ""    inputnc_2 = inputnc.
*  ""    CALL METHOD cl_extfac->call_ws_2
*  ""      EXPORTING
*  ""        pi_tipdoc   = gc_tipdoc_nc
*  ""        pi_proxy    = gs_constantes-zz_proxy_name
*  ""        pi_input    = inputnc_2
*  ""        pi_numeraci = gw_numeraci
*  ""        pi_vbeln    = p_docsap
*  ""      IMPORTING
*  ""        pe_message  = gt_message.
*  ""  ENDIF.
*
*  CASE gw_system.
*    WHEN zossdcl_pro_extrac_fe=>gc_system_qas.  " QAS
*      IF gw_test_act EQ abap_true.
*        " Sistema Test está activo
*        inputnc_1 = inputnc.
*        CALL METHOD cl_extfac->call_ws_1
*          EXPORTING
*            pi_tipdoc   = gc_tipdoc_nc
*            pi_proxy    = gs_constantes-zz_proxy_name
*            pi_input    = inputnc_1
*            pi_numeraci = gw_numeraci
*            pi_vbeln    = p_docsap
*          IMPORTING
*            pe_message  = gt_message.
*      ELSE.
*        " Sistema Test está inactivo; por lo tanto, direccionar a Homologación
*        inputnc_2 = inputnc.
*        CALL METHOD cl_extfac->call_ws_2
*          EXPORTING
*            pi_tipdoc   = gc_tipdoc_nc
*            pi_proxy    = gs_constantes-zz_proxy_name
*            pi_input    = inputnc_2
*            pi_numeraci = gw_numeraci
*            pi_vbeln    = p_docsap
*          IMPORTING
*            pe_message  = gt_message.
*      ENDIF.
*    WHEN zossdcl_pro_extrac_fe=>gc_system_prd.  " PRD
*      IF sy-mandt EQ gw_mandt_prd.
*        CALL METHOD cl_extfac->call_ws
*          EXPORTING
*            pi_tipdoc   = gc_tipdoc_nc
*            pi_proxy    = gs_constantes-zz_proxy_name
*            pi_input    = inputnc
*            pi_numeraci = gw_numeraci
*            pi_vbeln    = p_docsap
*          IMPORTING
*            pe_message  = gt_message.
*      ELSE.
*        " Si No es el mandante productivo real direccionar a Test Sunat
*        inputnc_1 = inputnc.
*        CALL METHOD cl_extfac->call_ws_1
*          EXPORTING
*            pi_tipdoc   = gc_tipdoc_nc
*            pi_proxy    = gs_constantes-zz_proxy_name
*            pi_input    = inputnc_1
*            pi_numeraci = gw_numeraci
*            pi_vbeln    = p_docsap
*          IMPORTING
*            pe_message  = gt_message.
*      ENDIF.
*  ENDCASE.
**}  END OF REPLACE WMR-030615
*ENDFORM.                    "rep_nocr
*
**&---------------------------------------------------------------------*
**&      Form  rep_nodb
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
*FORM rep_nodb.
*
** Llenar datos WS
*  CALL METHOD cl_extfac->set_ws_nd
*    EXPORTING
*      pi_user     = gs_constantes-zz_usuario_web
*      pi_pass     = gs_constantes-zz_pass_web
*      pi_fecab    = gt_fecab
*      pi_fecab2   = gt_fecab2
*      pi_fedet    = gt_fedet
*      pi_fecli    = gt_fecli
*      pi_headtext = gt_headtext                                  "I-WMR-230615
*    IMPORTING
*      pe_datosws  = inputnd
*      pe_numeraci = gw_numeraci.
*
** Llamar Web Service
**{  BEGIN OF REPLACE WMR-030615
*  ""  IF ( sy-mandt <> gc_mandt ) AND ( sy-uname NOT IN gr_user ) AND ( gr_user[] IS NOT INITIAL ). "TEST
*  ""    inputnd_1 = inputnd.
*  ""    CALL METHOD cl_extfac->call_ws_1
*  ""      EXPORTING
*  ""        pi_tipdoc   = gc_tipdoc_nd
*  ""        pi_proxy    = gs_constantes-zz_proxy_name
*  ""        pi_input    = inputnd_1
*  ""        pi_numeraci = gw_numeraci
*  ""        pi_vbeln    = p_docsap
*  ""      IMPORTING
*  ""        pe_message  = gt_message.
*  ""  ELSEIF  sy-mandt = gc_mandt.                                                                  "PRD
*  ""    CALL METHOD cl_extfac->call_ws
*  ""      EXPORTING
*  ""        pi_tipdoc   = gc_tipdoc_nd
*  ""        pi_proxy    = gs_constantes-zz_proxy_name
*  ""        pi_input    = inputnd
*  ""        pi_numeraci = gw_numeraci
*  ""        pi_vbeln    = p_docsap
*  ""      IMPORTING
*  ""        pe_message  = gt_message.
*  ""  ELSEIF ( sy-mandt <> gc_mandt )  AND ( sy-uname IN gr_user ) AND ( gr_user[] IS NOT INITIAL ). "HOMO  QAS
*  ""    inputnd_2 = inputnd.
*  ""    CALL METHOD cl_extfac->call_ws_2
*  ""      EXPORTING
*  ""        pi_tipdoc   = gc_tipdoc_nd
*  ""        pi_proxy    = gs_constantes-zz_proxy_name
*  ""        pi_input    = inputnd_2
*  ""        pi_numeraci = gw_numeraci
*  ""        pi_vbeln    = p_docsap
*  ""      IMPORTING
*  ""        pe_message  = gt_message.
*  ""  ENDIF.
*
*  CASE gw_system.
*    WHEN zossdcl_pro_extrac_fe=>gc_system_qas.  " QAS
*      IF gw_test_act EQ abap_true.
*        " Sistema Test está activo
*        inputnd_1 = inputnd.
*        CALL METHOD cl_extfac->call_ws_1
*          EXPORTING
*            pi_tipdoc   = gc_tipdoc_nd
*            pi_proxy    = gs_constantes-zz_proxy_name
*            pi_input    = inputnd_1
*            pi_numeraci = gw_numeraci
*            pi_vbeln    = p_docsap
*          IMPORTING
*            pe_message  = gt_message.
*      ELSE.
*        " Sistema Test está inactivo; por lo tanto, direccionar a Homologación
*        inputnd_2 = inputnd.
*        CALL METHOD cl_extfac->call_ws_2
*          EXPORTING
*            pi_tipdoc   = gc_tipdoc_nd
*            pi_proxy    = gs_constantes-zz_proxy_name
*            pi_input    = inputnd_2
*            pi_numeraci = gw_numeraci
*            pi_vbeln    = p_docsap
*          IMPORTING
*            pe_message  = gt_message.
*      ENDIF.
*    WHEN zossdcl_pro_extrac_fe=>gc_system_prd.  " PRD
*      IF sy-mandt EQ gw_mandt_prd.
*        CALL METHOD cl_extfac->call_ws
*          EXPORTING
*            pi_tipdoc   = gc_tipdoc_nd
*            pi_proxy    = gs_constantes-zz_proxy_name
*            pi_input    = inputnd
*            pi_numeraci = gw_numeraci
*            pi_vbeln    = p_docsap
*          IMPORTING
*            pe_message  = gt_message.
*      ELSE.
*        " Si No es el mandante productivo real direccionar a Test Sunat
*        inputnd_1 = inputnd.
*        CALL METHOD cl_extfac->call_ws_1
*          EXPORTING
*            pi_tipdoc   = gc_tipdoc_nd
*            pi_proxy    = gs_constantes-zz_proxy_name
*            pi_input    = inputnd_1
*            pi_numeraci = gw_numeraci
*            pi_vbeln    = p_docsap
*          IMPORTING
*            pe_message  = gt_message.
*      ENDIF.
*  ENDCASE.
**}  END OF REPLACE WMR-030615
*ENDFORM.                    "rep_nodb
*
**&---------------------------------------------------------------------*
**&      Form  SHOW_LOG
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**  -->  p1        text
**  <--  p2        text
**----------------------------------------------------------------------*
*FORM show_log .
*
*  CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
*    EXPORTING
*      it_message = gt_message.
*
*ENDFORM.                    " SHOW_LOG
**{  BEGIN OF INSERT WMR-140116
**&---------------------------------------------------------------------*
**&      Form  REP_GUIAREM
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**  -->  p1        text
**  <--  p2        text
**----------------------------------------------------------------------*
*FORM rep_guiarem .
*
*  DATA: cl_extract TYPE REF TO zossdcl_pro_extrac_fe_gr.
*
** Borrar datos de Log antiguos
*  DELETE FROM zostb_felog WHERE zzt_nrodocsap  EQ p_docsap
*                            AND zzt_numeracion EQ p_numera.
*
*  CREATE OBJECT cl_extract.
*
*  cl_extract->extrae_data_guia_remision(
*    EXPORTING
*      i_entrega = p_docsap
*    IMPORTING
*      et_return = gt_message
*    EXCEPTIONS
*      error      = 1 ).
*
*ENDFORM.
**}  END OF INSERT WMR-140116
*}END OF REPLACE NTP-060616

*{BEGIN OF INSERT NTP-060616
FORM reproceso.

  DATA: lw_status     TYPE zostb_felog-zzt_status_cdr.
  DATA: ls_vbrk TYPE vbrk,                                                    "I-WMR-220915
        ls_likp TYPE likp,                                                    "I-WMR-140116
        ls_tvko TYPE tvko.                                                    "I-WMR-130319-3000010823

  DATA: lw_date    TYPE datum,                                                "I-WMR-140617-3000007486
        lw_days    TYPE n LENGTH 2,                                           "I-WMR-140617-3000007486
        lw_message TYPE c LENGTH 100.                                         "I-WMR-140617-3000007486

*{  BEGIN OF INSERT WMR-220915
  " Validar si es FAC/ BOL/ NC/ ND                                            "I-WMR-140116
  SELECT SINGLE *
    INTO ls_vbrk
    FROM vbrk
    WHERE vbeln EQ p_docsap.

  " Validar si es G/R                                                         "I-WMR-140116
  IF sy-subrc NE 0.                                                           "I-WMR-140116
    SELECT SINGLE *                                                           "I-WMR-140116
      INTO ls_likp                                                            "I-WMR-140116
      FROM likp                                                               "I-WMR-140116
      WHERE vbeln EQ p_docsap.                                                "I-WMR-140116
  ENDIF.                                                                      "I-WMR-140116

  " Validar existencia de documento Sap
  IF sy-subrc NE 0.
    MESSAGE s208(00) WITH TEXT-e03.
    EXIT.
  ENDIF.

*{  BEGIN OF INSERT WMR-130319-3000010823
  " Validar Autorización
  IF ls_vbrk IS NOT INITIAL.
    zosclpell_libros_legales=>_authority_check_f_bkpf_buk(
      EXPORTING  i_bukrs = ls_vbrk-bukrs
      EXCEPTIONS error   = 1
                 OTHERS  = 2 ).
  ELSEIF ls_likp IS NOT INITIAL.
    SELECT SINGLE vkorg bukrs INTO CORRESPONDING FIELDS OF ls_tvko
      FROM tvko WHERE vkorg = ls_likp-vkorg.
    zosclpell_libros_legales=>_authority_check_f_bkpf_buk(
      EXPORTING  i_bukrs = ls_tvko-bukrs
      EXCEPTIONS error   = 1
                 OTHERS  = 2 ).
  ENDIF.
  IF sy-subrc <> 0.
    gw_error = abap_on.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  CHECK gw_error = abap_off.
*}  END OF INSERT WMR-130319-3000010823

  " Validar Tipo de comprobante con opción seleccionada
  IF ls_vbrk IS NOT INITIAL.                                                  "I-WMR-140116
    CASE ls_vbrk-xblnr(2).
      WHEN gc_tipdoc_fa.
        IF p_opcfa EQ abap_false.
          MESSAGE s208(00) WITH TEXT-e04.
          EXIT.
        ENDIF.
      WHEN gc_tipdoc_bl.
        IF p_opcbl EQ abap_false.
          MESSAGE s208(00) WITH TEXT-e04.
          EXIT.
        ENDIF.
      WHEN gc_tipdoc_nc.
        IF p_opcnc EQ abap_false.
          MESSAGE s208(00) WITH TEXT-e04.
          EXIT.
        ENDIF.
      WHEN gc_tipdoc_nd.
        IF p_opcnd EQ abap_false.
          MESSAGE s208(00) WITH TEXT-e04.
          EXIT.
        ENDIF.
    ENDCASE.
  ENDIF.                                                                      "I-WMR-140116

  IF ls_likp IS NOT INITIAL.                                                  "I-WMR-140116
    IF p_opcgr EQ abap_false.                                                 "I-WMR-140116
      MESSAGE s208(00) WITH TEXT-e04.                                         "I-WMR-140116
      EXIT.                                                                   "I-WMR-140116
    ENDIF.                                                                    "I-WMR-140116
  ENDIF.
*}  END OF INSERT WMR-220915

*{  BEGIN OF INSERT WMR-140617-3000007486
  " Validar Días para Envío a Sunat
  READ TABLE gt_cosnt INTO gs_const WITH KEY campo = 'FECFAC'.
  IF sy-subrc EQ 0.
    lw_days = gs_const-valor1.
    lw_date = sy-datum - lw_days.
  ENDIF.
*}  END OF INSERT WMR-140617-3000007486

* Obtener Status
  SELECT SINGLE zzt_status_cdr zzt_nrodocsap
  FROM zostb_felog
  INTO (lw_status,gw_nrodocsap )
  WHERE zzt_nrodocsap  EQ p_docsap
    AND zzt_numeracion EQ p_numera ##WARN_OK.

*{I-NTP110717-3000006468
  IF sy-subrc <> 0.
    "Factura por procesar
    IF p_facpor IS NOT INITIAL.
      lw_status = gc_status_0.
    ENDIF.
  ENDIF.
*}I-NTP110717-3000006468


* Evaluar Status
  IF p_opcgr EQ abap_true.                                                    "I-WMR-140116
    CASE lw_status.                                                           "I-WMR-140116
      WHEN gc_status_0 OR gc_status_5 OR gc_status_6  " Excepción o error XSD "I-WMR-140116
        OR gc_status_7                                " Error Conexión WS     "I-WMR-140116
        OR gc_status_2.

*{  BEGIN OF INSERT WMR-140617-3000007486
        " Validar Días para Envío a Sunat
        IF ls_likp-wadat_ist LT lw_date.
          WRITE lw_date TO lw_message.
          MESSAGE i398(00) WITH TEXT-e05 lw_message   ##MG_MISSING.
          RETURN.
        ENDIF.
*}  END OF INSERT WMR-140617-3000007486

        PERFORM set_reproceso_sap.                                            "I-WMR-070318-3000009350

      WHEN OTHERS.                                                            "I-WMR-140116
        MESSAGE s208(00) WITH TEXT-e02.                                       "I-WMR-140116
    ENDCASE.                                                                  "I-WMR-140116

  ELSE.                                                                       "I-WMR-140116
    CASE lw_status.
*    WHEN gc_status_7.                           " Error Conexión WS
*      PERFORM set_reproceso_db.
      WHEN gc_status_0 OR gc_status_2 OR gc_status_5 OR gc_status_6 OR  "+@001
           gc_status_7.                                                 "I002-281116

*{  BEGIN OF INSERT WMR-140617-3000007486
        IF p_synsta IS INITIAL.                                         "I-NTP260717-3000006468
          " Validar Días para Envío a Sunat
          IF ls_vbrk-fkdat LT lw_date.
            WRITE lw_date TO lw_message.
            MESSAGE i398(00) WITH TEXT-e05 lw_message ##MG_MISSING.
            RETURN.
          ENDIF.
        ENDIF.
*}  END OF INSERT WMR-140617-3000007486

        PERFORM set_reproceso_sap.
      WHEN OTHERS.
        MESSAGE s208(00) WITH TEXT-e02.
    ENDCASE.
  ENDIF.                                                                      "I-WMR-140116

ENDFORM.

*{E-NTP260717-3000006468
*FORM set_reproceso_db.
*
*  DATA: ls_nojson_data  TYPE zosfees_data_nojson,
*        ls_json_data    TYPE zosfees_json_data.
*
** Cabecera
*  SELECT *
*  INTO TABLE gt_fecab
*  FROM zostb_fecab
*  WHERE zzt_nrodocsap  EQ p_docsap
*    AND zzt_numeracion EQ p_numera.
*  IF sy-subrc NE 0.
*    MESSAGE s208(00) WITH text-e01.
*    EXIT.
*  ENDIF.
*
**BI-NTP-210416
*  SELECT *
*  INTO TABLE gt_fecab2
*  FROM zostb_fecab2
*    WHERE zzt_nrodocsap  EQ p_docsap
*    AND zzt_numeracion EQ p_numera.
**EI-NTP-210416
*
** Detalle
*  SELECT *
*  INTO TABLE gt_fedet
*  FROM zostb_fedet
*  WHERE zzt_nrodocsap  EQ p_docsap
*    AND zzt_numeracion EQ p_numera.
*
** Cliente
*  SELECT *
*  INTO TABLE gt_fecli
*  FROM zostb_fecli
*  WHERE zzt_nrodocsap  EQ p_docsap
*    AND zzt_numeracion EQ p_numera.
*
*  SELECT *
*  INTO TABLE gt_headtext
*  FROM zostb_docexpostc
*  WHERE zz_nrodocsap  EQ p_docsap
*    AND zz_numeracion EQ p_numera.
*
*  ls_json_data-t_fecab[]          = gt_fecab[].
*  ls_json_data-t_fecab2[]         = gt_fecab2[].
*  ls_json_data-t_fedet[]          = gt_fedet[].
*  ls_json_data-t_fecli[]          = gt_fecli[].
*  ls_nojson_data-t_text_header[]  = gt_headtext[].
*
** Borrar datos de Log antiguos
*  DELETE FROM zostb_felog WHERE zzt_nrodocsap  EQ p_docsap
*                            AND zzt_numeracion EQ p_numera.
*
** Obtener constantes
*  cl_extfac->get_constants( i_vbeln = p_docsap ).
*
** Lanzamiento WebServices
*  CASE abap_true.
*    WHEN p_opcfa. "Factura
*      cl_extfac->call_ws_fa(
*        EXPORTING
*          is_nojson_data  = ls_nojson_data
*          is_json_data    = ls_json_data
*        IMPORTING
*          pe_message      = gt_message
*      ).
*
*    WHEN p_opcbl. "Boleta
*      cl_extfac->call_ws_bl(
*        EXPORTING
*          is_nojson_data  = ls_nojson_data
*          is_json_data    = ls_json_data
*        IMPORTING
*          pe_message      = gt_message
*      ).
*
*    WHEN p_opcnc. "Nota credito
*      cl_extfac->call_ws_nc(
*        EXPORTING
*          is_nojson_data  = ls_nojson_data
*          is_json_data    = ls_json_data
*        IMPORTING
*          pe_message      = gt_message
*      ).
*
*    WHEN p_opcnd. "Nota debito
*      cl_extfac->call_ws_nd(
*        EXPORTING
*          is_nojson_data  = ls_nojson_data
*          is_json_data    = ls_json_data
*        IMPORTING
*          pe_message      = gt_message
*      ).
*
*    WHEN p_opcgr. "Guia Remisión
*      go_gr->extrae_data_guia_remision(
*        EXPORTING
*          i_entrega = p_docsap
*        IMPORTING
*          et_return = gt_message
*        EXCEPTIONS
*          error     = 1
*          OTHERS    = 2
*      ).
*
*  ENDCASE.
*
** En caso de error, mostrar log
*  IF gt_message IS NOT INITIAL.
*    CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
*      EXPORTING
*        it_message = gt_message.
*  ENDIF.
*ENDFORM.
*}E-NTP260717-3000006468

FORM set_reproceso_sap.

  DATA: po_error       TYPE char01 ##NEEDED,
        ls_felog_repro TYPE zostb_felog,                                  "I-WMR-040417-3000007000
        ls_options     TYPE zosfees_extract_options.                          "I-NTP260717-3000006468

  " Obtener datos que deben mantenerse del original                       "I-WMR-040417-3000007000
  SELECT SINGLE * INTO ls_felog_repro                                     "I-WMR-040417-3000007000
    FROM zostb_felog                                                      "I-WMR-040417-3000007000
    WHERE zzt_nrodocsap  EQ p_docsap                                      "I-WMR-040417-3000007000
      AND zzt_numeracion EQ p_numera ##WARN_OK.                           "I-WMR-040417-3000007000

  " Se usa en método CALL_WS_MAIN de la clase ZOSSDCL_PRO_EXTRAC_FE       "I-WMR-040417-3000007000
  EXPORT felog_reproc = ls_felog_repro TO MEMORY ID 'REPROCESO_FE'.       "I-WMR-040417-3000007000

* Borrar datos de Log antiguos
  DELETE FROM zostb_felog WHERE zzt_nrodocsap  EQ p_docsap
                            AND zzt_numeracion EQ p_numera
                            AND zzt_correlativ NE 01.                     "I-3000011101-NTP200319

  ls_options-only_syncstat = p_synsta.                                    "I-NTP260717-3000006468
  ls_options-zzt_numeracion = p_numera.                                   "I-3000011995-NTP200519

  CASE abap_true.
    WHEN p_opcfa. "Factura
      cl_extfac->extrae_data_fa(
        EXPORTING
          p_vbeln   = p_docsap
          is_options = ls_options "I-NTP260717-3000006468
        IMPORTING
          p_error   = po_error
          p_message = gt_message
      ).
    WHEN p_opcbl. "Boleta
      cl_extfac->extrae_data_bo(
        EXPORTING
          p_vbeln   = p_docsap
          is_options = ls_options "I-NTP260717-3000006468
        IMPORTING
          p_error   = po_error
          p_message = gt_message
      ).

    WHEN p_opcnc. "Nota credito
      cl_extfac->extrae_data_nc(
        EXPORTING
          p_vbeln   = p_docsap
          is_options = ls_options "I-NTP260717-3000006468
        IMPORTING
          p_error   = po_error
          p_message = gt_message
      ).

    WHEN p_opcnd. "Nota debito
      cl_extfac->extrae_data_nd(
        EXPORTING
          p_vbeln   = p_docsap
          is_options = ls_options "I-NTP260717-3000006468
        IMPORTING
          p_error   = po_error
          p_message = gt_message
      ).

    WHEN p_opcgr. "Guia Remisión

*      CREATE OBJECT go_gr TYPE (gc_classname_gr).                                                                "-NTP010523-3000020188
      zossdcl_pro_extrac_fe=>get_badi_object( EXPORTING i_classname = gc_classname_gr CHANGING co_obj = go_gr ).  "+NTP010523-3000020188

      CALL METHOD go_gr->('EXTRAE_DATA_GUIA_REMISION')
        EXPORTING
          i_entrega  = p_docsap
          is_options = ls_options "I-NTP260717-3000006468
        IMPORTING
          et_return  = gt_message
        EXCEPTIONS
          error      = 1.
      IF sy-subrc <> 0.
        p_error = abap_true.
      ENDIF.
  ENDCASE.

  FREE MEMORY ID 'REPROCESO_FE'.                                          "I-WMR-040417-3000007000

* En caso de error, mostrar log
  IF p_error IS NOT INITIAL.
    CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
      EXPORTING
        it_message = gt_message.
  ENDIF.
ENDFORM.
*}END OF INSERT NTP-060616
