class ZOSSDCL_PRO_EXTRAC_FE_RT definition
  public
  final
  create public .

public section.

  types:
    gtt_cnumber TYPE TABLE OF zostb_cnumber .
  types:
    gtt_fertcab TYPE TABLE OF zostb_fertcab .
  types:
    gtt_fertdet TYPE TABLE OF zostb_fertdet .
  types:
    gtt_fertcab_json TYPE TABLE OF zoses_fertcab_json .
  types:
    gtt_fertdet_json TYPE TABLE OF zoses_fertdet_json .
  types:
    gtt_rertcab TYPE TABLE OF zostb_rertcab .
  types:
    gtt_rertdet TYPE TABLE OF zostb_rertdet .
  types:
    gtt_rertcab_json TYPE TABLE OF zoses_rertcab_json .
  types:
    gtt_rertdet_json TYPE TABLE OF zoses_rertdet_json .

  methods EXTRAE_DATA_RETENCION
    importing
      !I_BUKRS type BUKRS
      !I_CRNUMBER type ZOSED_NUMBER
      !IS_OPTIONS type ZOSFEES_EXTRACT_OPTIONS optional
    exporting
      !ET_RETURN type BAPIRETTAB
    exceptions
      ERROR .
  methods EXTRAE_DATA_RETENCION_REV
    importing
      !I_BUKRS type BUKRS
      !I_FECHA type DATUM
    exporting
      !ET_RETURN type BAPIRETTAB
    exceptions
      ERROR .
  methods SET_JSON_RET
    importing
      !IT_CAB type GTT_FERTCAB
      !IT_DET type GTT_FERTDET
    exporting
      !ET_CAB_JSON type GTT_FERTCAB_JSON
      !ET_DET_JSON type GTT_FERTDET_JSON .
  methods SET_JSON_RET_REV
    importing
      !IT_CAB type GTT_RERTCAB
      !IT_DET type GTT_RERTDET
    exporting
      !ET_CAB_JSON type GTT_RERTCAB_JSON
      !ET_DET_JSON type GTT_RERTDET_JSON .
  PROTECTED SECTION.
*--------------------------------------------------------------------*
*	TIPOS GLOBAL
*--------------------------------------------------------------------*
    TYPES:
      BEGIN OF gty_likp,
        "key
        vbeln TYPE likp-vbeln,
        "---
        xblnr TYPE likp-xblnr,
        bzirk TYPE likp-bzirk,
        vkorg TYPE likp-vkorg,
        kunnr TYPE likp-kunnr,
        kunag TYPE likp-kunag,
        lfart TYPE likp-lfart,
        vstel TYPE likp-vstel,
        tddat TYPE likp-tddat,
        btgew TYPE likp-btgew,
        anzpk TYPE likp-anzpk,
        gewei TYPE likp-gewei,
        ntgew TYPE likp-ntgew,
        "Campos homologación
      END OF gty_likp .

    TYPES:
      BEGIN OF gty_direccion,
        "key
        adrnr      TYPE  adrnr,
        "---
        name       TYPE  string,
        name1      TYPE  adrc-name1,
        name2      TYPE  adrc-name2,
        name3      TYPE  adrc-name3,
        name4      TYPE  adrc-name4,
        pais       TYPE  adrc-country,
        depart     TYPE  t005u-bezei,  "Departamento (Pais-Region T005U)
        provin     TYPE  adrc-city1,   "Provincia
        distri     TYPE  adrc-city2,   "Distrito
        street     TYPE  adrc-street,  "Dirección
        stnumb     TYPE  adrc-house_num1,    "Número
        str_suppl1 TYPE adrc-str_suppl1,  "Dirección
        str_suppl2 TYPE adrc-str_suppl2,  "Dirección
        str_suppl3 TYPE adrc-str_suppl3,  "Dirección
*        ubigeo     TYPE adrc-cityp_code,  "Ubigeo  "E-NTP-270416
        ubigeo     TYPE numc06,           "Ubigeo   "R-NTP-270416
        smtp_addr  TYPE string,           "Correos
        tel_number TYPE adrc-tel_number,  "Teléfono
        fax_number TYPE adrc-fax_number,  "Fax
      END OF gty_direccion .

    TYPES:
      BEGIN OF gty_kna1,
        "key
        kunnr TYPE lfa1-kunnr,
        "---
        stcd1 TYPE lfa1-stcd1,
        stcdt TYPE lfa1-stcdt,
        xcpdk TYPE lfa1-xcpdk,
        adrnr TYPE lfa1-adrnr,
        name1 TYPE lfa1-name1,
        name2 TYPE lfa1-name2,
        name3 TYPE lfa1-name3,
        name4 TYPE lfa1-name4,
        stkzn TYPE lfa1-stkzn,
      END OF gty_kna1 .


    TYPES: BEGIN OF gty_with_item,
             bukrs     TYPE  with_item-bukrs,
             belnr     TYPE  with_item-belnr,
             gjahr     TYPE  with_item-gjahr,
             buzei     TYPE  with_item-buzei,
             witht     TYPE  with_item-witht,
             wt_withcd TYPE  with_item-wt_withcd,
             wt_qsshb  TYPE  with_item-wt_qsshb,
             wt_qsshh  TYPE  with_item-wt_qsshh,
             qsatz     TYPE  with_item-qsatz,
           END OF gty_with_item.


    TYPES: BEGIN OF gty_bkpf,
             bukrs TYPE bkpf-bukrs,
             belnr TYPE bkpf-belnr,
             gjahr TYPE bkpf-gjahr,
             kursf TYPE bkpf-kursf,
             wwert TYPE bkpf-wwert,
           END OF gty_bkpf.


    TYPES: BEGIN OF gty_bkpf_anul,
             bukrs TYPE bkpf-bukrs,
             belnr TYPE bkpf-belnr,
             gjahr TYPE bkpf-gjahr,
             stblg TYPE bkpf-stblg,
             stjah TYPE bkpf-stjah,
             stgrd TYPE bkpf-stgrd,
           END OF gty_bkpf_anul.


    TYPES: BEGIN OF gty_refsunat,
             tipo  TYPE string,
             serie TYPE string,
             numro TYPE string,
           END OF gty_refsunat.


    TYPES: BEGIN OF gty_lineas,
             linea TYPE char1024,
           END OF gty_lineas .

*--------------------------------------------------------------------*
*	TIPOS DE TABLAS GLOBAL
*--------------------------------------------------------------------*
    TYPES: gtt_registro_retencion TYPE TABLE OF zoses_retigv_printdoc,

           gtt_fecli              TYPE TABLE OF zostb_fecli,

           gtth_bkpf_anul         TYPE HASHED TABLE OF gty_bkpf_anul WITH UNIQUE KEY bukrs belnr gjahr,

           gtth_direccion         TYPE HASHED TABLE OF gty_direccion WITH UNIQUE KEY adrnr.

*--------------------------------------------------------------------*
*	TIPOS DE RANGOS GLOBAL
*--------------------------------------------------------------------*
    TYPES: gtr_adrnr TYPE RANGE OF adrnr .

    TYPES: gtr_crnumber TYPE RANGE OF zosed_number .
private section.
*"* private components of class ZOSSDCL_PRO_EXTRAC_FE_RT
*"* do not include other source files here!!!

  constants GC_APLIC type ZOSED_APLICACION value 'EXTRACTOR' ##NO_TEXT.
  constants GC_CAMPO_HOST type STRING value 'HOSTNAME' ##NO_TEXT.
  constants GC_CAMPO_MANDT_PRD type STRING value 'MANDTPRD' ##NO_TEXT.
  constants GC_CAMPO_TEST_ACT type STRING value 'TEST_ACT' ##NO_TEXT.
  constants GC_PARTY type T001Z-PARTY value 'TAXNR' ##NO_TEXT.
  constants GC_PREFIX_RR type CHAR02 value 'RR' ##NO_TEXT.
  constants GC_PREFIX_RT type CHAR02 value 'RT' ##NO_TEXT.
  constants GC_PROG type PROGRAMM value 'ZOSSD_PRO_EXTRAC' ##NO_TEXT.
  constants GC_PROGNAME type PROGNAME value 'ZOSFI_RPT_COMPROB_RETENCIONNEW' ##NO_TEXT.
  constants GC_STATUSCDR_0 type ZOSED_STATUS_CDR value '0' ##NO_TEXT.
  constants GC_STATUSCDR_1 type ZOSED_STATUS_CDR value '1' ##NO_TEXT.
  constants GC_STATUSCDR_2 type ZOSED_STATUS_CDR value '2' ##NO_TEXT.
  constants GC_STATUSCDR_4 type ZOSED_STATUS_CDR value '4' ##NO_TEXT.
  constants GC_STATUSCDR_7 type ZOSED_STATUS_CDR value '7' ##NO_TEXT.
  constants GC_SYSTEM_PRD type SYST-HOST value 'PRD' ##NO_TEXT.
  constants GC_SYSTEM_QAS type SYST-HOST value 'QAS' ##NO_TEXT.
  constants GC_SYSTEM_SUNAT_HOMO type STRING value 'HOM' ##NO_TEXT.
  constants GC_SYSTEM_SUNAT_PROD type STRING value 'PRD' ##NO_TEXT.
  constants GC_SYSTEM_SUNAT_TEST type STRING value 'TES' ##NO_TEXT.
  constants GC_TIPDOC_RT type CHAR02 value '20' ##NO_TEXT.
  constants GC_TP_ELECTRO type ZOSED_TIPSER value 'E' ##NO_TEXT.
  constants GC_VERSION_1 type ZOSED_VERSIVIGEN value '01' ##NO_TEXT.
  constants GC_VERSION_2 type ZOSED_VERSIVIGEN value '02' ##NO_TEXT.
  data GS_CONSEXTSUN type ZOSTB_CONSEXTSUN .
  data:
    gth_dire TYPE HASHED TABLE OF gty_direccion WITH UNIQUE KEY adrnr .
  data:
    gth_hom06 TYPE HASHED TABLE OF zostb_catahomo06 WITH UNIQUE KEY stcdt .
  data:
    gth_hom23 TYPE HASHED TABLE OF zostb_catahomo23 WITH UNIQUE KEY witht wt_withcd .
  data:
    gth_kna1 TYPE HASHED TABLE OF gty_kna1 WITH UNIQUE KEY kunnr .
  data:
    gth_t001 TYPE HASHED TABLE OF t001 WITH UNIQUE KEY bukrs .
  data:
    gth_t001z TYPE HASHED TABLE OF t001z WITH UNIQUE KEY bukrs .
  data:
    gt_const TYPE TABLE OF zostb_const_fe .
  data:
    gt_proxy TYPE TABLE OF zostb_envwsfe .
  data:
    gt_vigen TYPE TABLE OF zostb_constvigen .
  data:
    gt_tcurt TYPE STANDARD TABLE OF zostb_tcurt .
  data G_BUKRS type BUKRS .
  data:
    BEGIN OF ZCONST,
          reten_per TYPE with_item-qsatz,
          r_witht TYPE RANGE OF witht,
          r_withcd TYPE RANGE OF wt_withcd,
        END OF zconst .
  data GW_LICENSE type STRING .

  methods CALL_WS_MAIN
    importing
      !PI_BUKRS type BUKRS
      !PI_TIPDOC type CHAR02
      !PI_FECFAC type BLDAT
      !PI_INPUT type ANY
      !PI_CNUMBER type ZOSED_NUMBER optional
      !PI_ID type CLIKE
      !IS_OPTIONS type ZOSFEES_EXTRACT_OPTIONS optional
    exporting
      !PE_OUTPUT type ANY
      !PE_MESSAGE type BAPIRETTAB .
  methods CALL_WS_RET
    importing
      !IT_CAB type GTT_FERTCAB_JSON
      !IT_DET type GTT_FERTDET_JSON
      !IT_CLI type GTT_FECLI
      !IS_OPTIONS type ZOSFEES_EXTRACT_OPTIONS
    exporting
      !ET_RETURN type BAPIRETTAB
    exceptions
      ERROR .
  methods CALL_WS_RET_REV
    importing
      !IT_CAB type GTT_RERTCAB_JSON
      !IT_DET type GTT_RERTDET_JSON
    exporting
      !ET_RETURN type BAPIRETTAB
    exceptions
      ERROR .
  methods CHECK_HOMO_RET
    importing
      !IT_CAB type GTT_FERTCAB
      !IT_DET type GTT_FERTDET
    exporting
      !ET_RETURN type BAPIRETTAB
    exceptions
      ERROR .
  methods CHECK_HOMO_RET_REV
    importing
      !IT_CAB type GTT_RERTCAB
      !IT_DET type GTT_RERTDET
    exporting
      !ET_RETURN type BAPIRETTAB
    exceptions
      ERROR .
  methods FREE_DATA .
  methods GET_CONSTANTES .
  methods GET_DATA_RET
    importing
      !I_BUKRS type BUKRS
      !I_CRNUMBER type ZOSED_NUMBER
      !IR_CRNUMBER type GTR_CRNUMBER optional
    exporting
      !ET_RCAB type GTT_REGISTRO_RETENCION
      !ET_RDET type GTT_REGISTRO_RETENCION
    exceptions
      ERROR .
  methods GET_DATA_RET_REV
    importing
      !I_BUKRS type BUKRS
      !I_FECHA type DATUM
    exporting
      !ET_RCAB type GTT_CNUMBER
      !ET_RDET type GTT_CNUMBER
    exceptions
      ERROR .
  methods GET_DIRECCIONES
    importing
      !IR_ADRNR type GTR_ADRNR
    exporting
      !ETH_DIRECCION type GTTH_DIRECCION .
  methods GET_TEXT_MONTO
    importing
      !I_WAERS type WAERS
      !I_BLDAT type BLDAT
      !I_MONTO type ZOSED_PERITR
    exporting
      !E_TEXT type STRING .
  methods SET_DATA_RET
    importing
      !IT_RCAB type GTT_REGISTRO_RETENCION
      !IT_RDET type GTT_REGISTRO_RETENCION
    exporting
      !ET_CAB type GTT_FERTCAB
      !ET_DET type GTT_FERTDET
    exceptions
      ERROR .
  methods SET_DATA_RET_REV
    importing
      !IT_RCAB type GTT_CNUMBER
      !IT_RDET type GTT_CNUMBER
    exporting
      !ET_CAB type GTT_RERTCAB
      !ET_DET type GTT_RERTDET
    exceptions
      ERROR .
  methods SET_HOMO_CLI
    importing
      !PI_CAB type GTT_FERTCAB
    exporting
      !PE_CLI type GTT_FECLI .
  methods SET_HOMO_RET
    changing
      !CT_CAB type GTT_FERTCAB .
  methods SET_HOMO_RET_REV
    changing
      !CT_CAB type GTT_RERTCAB .
  methods SET_JSON_CLI
    importing
      !PI_CLI type GTT_FECLI
    exporting
      !PE_CLI_JSON type GTT_FECLI .
  methods SY_TO_RET
    importing
      !I_ROW type BAPIRET2-ROW optional
    returning
      value(RS_RETURN) type BAPIRET2 .
  methods UPD_TABLA_RET
    importing
      !IT_CAB type GTT_FERTCAB
      !IT_DET type GTT_FERTDET
      !IT_CLI type GTT_FECLI .
  methods UPD_TABLA_RET_REV
    importing
      !IT_CAB type GTT_RERTCAB
      !IT_DET type GTT_RERTDET .
  methods GET_SUNAT_RESOLUTION
    importing
      !I_BUKRS type BUKRS
    returning
      value(R_RESOL) type STRING .
  methods UPD_IDENTI_RET_REV
    importing
      !IT_RCAB type GTT_CNUMBER
      !IT_CAB type GTT_RERTCAB .
  methods GET_LAST_RET_REV
    importing
      !I_BUKRS type BUKRS
    returning
      value(R_IDRES) type ZOSED_IDENTIFIRESU .
ENDCLASS.



CLASS ZOSSDCL_PRO_EXTRAC_FE_RT IMPLEMENTATION.


  METHOD call_ws_main.

*   Llamada dinamica de webservices
    DATA: l_system    TYPE syst-host,
          l_test_act  TYPE xfeld,       "Indicador Sistema Test activo
          l_mandt_prd TYPE symandt,     "Mandante Productivo Real.
          l_envsun    TYPE zostb_envwsfe-envsun,
          l_clase     TYPE string,
          l_metho     TYPE string,

          lv_prefix   TYPE string,

          "WS
          lo_obj      TYPE REF TO object,
          lo_sys      TYPE REF TO cx_ai_system_fault,
          lo_app      TYPE REF TO cx_ai_application_fault,
          l_cx_system TYPE string,
          l_sunat     TYPE string,

          "Const
          ls_const    LIKE LINE OF gt_const,
          ls_proxy    LIKE LINE OF gt_proxy,
          ls_vigen    LIKE LINE OF gt_vigen.

*   Lectura de resultado
    DATA: l_registrado TYPE char1,
          lt_sunat     TYPE TABLE OF char256,
          ls_sunat     TYPE char256,

          lt_lineas    TYPE TABLE OF gty_lineas,
          ls_lineas    LIKE LINE OF lt_lineas,
          ls_message   LIKE LINE OF pe_message,
          ls_cplog     TYPE zostb_cplog,
          ls_relog     TYPE zostb_rertlog.

    FIELD-SYMBOLS: <input>  TYPE any,
                   <output> TYPE any,
                   <fs>     TYPE any.

*BI-NTP-210416
    CASE pi_tipdoc.
      WHEN gc_tipdoc_rt. lv_prefix = gc_prefix_rt.
      WHEN gc_prefix_rr. lv_prefix = gc_prefix_rr.
    ENDCASE.
*EI-NTP-210416

*   Lectura de constantes
    LOOP AT gt_const INTO ls_const.
      CASE ls_const-campo.
          "Test
        WHEN gc_campo_test_act.
          l_test_act = ls_const-valor1.

          "PRD
        WHEN gc_campo_mandt_prd.
          l_mandt_prd = ls_const-valor1.

          "Determinar nombre del sistema
        WHEN gc_campo_host.
          TRANSLATE sy-host TO UPPER CASE.        "I-NTP-300616
          IF ls_const-valor1 = sy-host.
            l_system = ls_const-valor2.
          ENDIF.
      ENDCASE.
    ENDLOOP.


*   Segun Sistema - Identificar Modo TEST HOMO PRD
    CASE l_system.
        "QAS
      WHEN gc_system_qas.
        IF l_test_act EQ abap_on.
          l_envsun = gc_system_sunat_test.
        ELSE.
          l_envsun = gc_system_sunat_homo.
        ENDIF.
        "PRD
      WHEN gc_system_prd.
        IF sy-mandt EQ l_mandt_prd.
          l_envsun = gc_system_sunat_prod.
        ELSE.
          l_envsun = gc_system_sunat_test.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.

*   Asignar input y output
    ASSIGN pi_input  TO <input>.
    ASSIGN pe_output TO <output>.


*   Determinar Clase y Metodo WS
    READ TABLE gt_proxy INTO ls_proxy WITH KEY bukrs   = pi_bukrs
                                               envsun  = l_envsun
                                               tpproc  = lv_prefix.
    IF sy-subrc EQ 0.

*     Determina Versión de FE Activa
      LOOP AT gt_vigen INTO ls_vigen WHERE begda <= pi_fecfac
                                       AND endda >= pi_fecfac
                                       AND tpproc = lv_prefix.
      ENDLOOP.
      IF sy-subrc = 0.
        CASE ls_vigen-zz_versivigen.
          WHEN gc_version_1.
            l_clase = ls_proxy-class.
            l_metho = ls_proxy-method.
          WHEN gc_version_2.
            l_clase = ls_proxy-class2.
            l_metho = ls_proxy-method2.
        ENDCASE.
      ELSE.
        l_clase = ls_proxy-class.
        l_metho = ls_proxy-method.
      ENDIF.

*     Llamar Web Service
      TRY.
          CREATE OBJECT lo_obj TYPE (l_clase)
            EXPORTING
              logical_port_name = gs_consextsun-zz_proxy_name. "ZP01

          TRY.
              CALL METHOD lo_obj->(l_metho)
                EXPORTING
                  input  = <input>
                IMPORTING
                  output = <output>.
            CATCH cx_ai_system_fault      INTO lo_sys.
            CATCH cx_ai_application_fault INTO lo_app.
          ENDTRY.

        CATCH cx_ai_system_fault INTO lo_sys.
      ENDTRY.

      "Exception
      IF lo_sys IS BOUND.
        l_cx_system = lo_sys->get_text( ).
      ENDIF.

      "Resultado
      ASSIGN COMPONENT 'RESULTADO' OF STRUCTURE <output> TO <fs>.
      IF <fs> IS ASSIGNED.
        l_sunat = <fs>.
      ENDIF.
    ELSE.
      CONCATENATE 'No tiene clase-metodo configurado en ZOSTB_ENVWSFE'
                  'la FE de'
                  lv_prefix
             INTO l_cx_system SEPARATED BY space.
    ENDIF.


**********************************************************************
*   Resultado
**********************************************************************
*   Excepción (error de conexión)
    IF l_cx_system IS NOT INITIAL.
      ls_message-type       = 'E'.
      ls_message-id         = '00'.
      ls_message-number     = '398'.
      ls_message-message_v1 = 'Error de Conexión con el Servicio Web.'.
      ls_message-message_v2 = ' Verificar log en transacción SRT_UTIL'.
      CONCATENATE ls_message-message_v1
                  ls_message-message_v2
                  INTO ls_message-message SEPARATED BY space.
      APPEND ls_message TO pe_message.
    ELSE.

*   Leer resultado sunat
      CASE lv_prefix.
        WHEN gc_prefix_rt OR
             gc_prefix_rr.

          SHIFT l_sunat BY 3 PLACES.                "Borrar los 3 primeros
          SPLIT l_sunat AT ';' INTO TABLE lt_sunat. "Mensajes separados
          LOOP AT lt_sunat INTO ls_sunat.
            ls_lineas-linea = ls_sunat+4.
            IF ls_sunat(3) = '007'.
              l_registrado = abap_true.
              CONCATENATE pi_id ls_lineas-linea INTO ls_lineas-linea SEPARATED BY space.
            ENDIF.
            APPEND ls_lineas TO lt_lineas.
          ENDLOOP.

          LOOP AT lt_lineas INTO ls_lineas.
            CASE l_registrado.
              WHEN abap_true.  ls_message-type = 'S'.
              WHEN abap_false. ls_message-type = 'E'.
            ENDCASE.

            ls_message-id       = '00'.
            ls_message-number   = '398'.
            ls_message-message  = ls_lineas-linea.
            CALL FUNCTION 'CRM_MESSAGE_TEXT_SPLIT'
              EXPORTING
                iv_text    = ls_lineas-linea
              IMPORTING
                ev_msgvar1 = ls_message-message_v1
                ev_msgvar2 = ls_message-message_v2
                ev_msgvar3 = ls_message-message_v3
                ev_msgvar4 = ls_message-message_v4.
            APPEND ls_message TO pe_message.
          ENDLOOP.
      ENDCASE.
    ENDIF.

    "Sincronizando documentos de sap a web
    CHECK is_options-only_syncstat = space. "+291222-NTP-3000020441

*   Actualiza Log
    CASE lv_prefix.
      WHEN gc_prefix_rt.
*       Log de Factura Electrónica
        ls_cplog-zzt_nrodocsap    = pi_cnumber.
        ls_cplog-zzt_numeracion   = pi_id.
        ls_cplog-zzt_correlativ   = 1.
        ls_cplog-zzt_fcreacion    = sy-datum.
        ls_cplog-zzt_hcreacion    = sy-uzeit.
        ls_cplog-zzt_ucreacion    = sy-uname.
        ls_cplog-bukrs            = pi_bukrs.
        ls_cplog-zzt_tipodoc      = pi_tipdoc.
        IF l_cx_system IS NOT INITIAL.
          ls_cplog-zzt_status_cdr = gc_statuscdr_7.
          ls_cplog-zzt_errorext   = ls_message-message.
        ELSE.
          ls_cplog-zzt_status_cdr = gc_statuscdr_2.
          IF l_registrado = abap_off.
            ls_cplog-zzt_errorext = ls_message-message.
          ENDIF.
        ENDIF.
        MODIFY zostb_cplog FROM ls_cplog.

      WHEN gc_prefix_rr.
*   Log de reversion
        DELETE FROM zostb_rertlog WHERE bukrs   = pi_bukrs
                                    AND zzidres = pi_id.
        ls_relog-bukrs            = pi_bukrs.
        ls_relog-zzidres          = pi_id.
        ls_relog-zzt_fcreacion    = sy-datum.
        ls_relog-zzt_hcreacion    = sy-uzeit.
        ls_relog-zzt_ucreacion    = sy-uname.
        ls_relog-zzt_femision     = pi_fecfac.
        IF l_cx_system IS NOT INITIAL.
          ls_relog-zzt_status_cdr = gc_statuscdr_7.
          ls_relog-zzt_errorext   = ls_message-message_v1.
        ELSE.
          ls_relog-zzt_status_cdr = gc_statuscdr_2.
        ENDIF.
        MODIFY zostb_rertlog FROM ls_relog.

    ENDCASE.

  ENDMETHOD.                    "call_ws_rev


  METHOD call_ws_ret.

    DATA: input      TYPE zosfe_wsoscrt_documentos_reque, "Test,Homo,Prd
          output     TYPE zosfe_wsoscrt_documentos_respo, "Test,Homo,Prd
          ls_item    LIKE LINE OF input-d_retencion_array-d_retencion.

    DATA: ls_cab LIKE LINE OF it_cab,
          ls_det LIKE LINE OF it_det,
          ls_cli LIKE LINE OF it_cli.

    CHECK lines( it_cab ) > 0.

* Cabecera
    LOOP AT it_cab INTO ls_cab.
      input-user = gs_consextsun-zz_usuario_web.
      input-pass = gs_consextsun-zz_pass_web.
      input-bukrs = gs_consextsun-bukrs.                "I-NTP-240616

      input-c_retencion-ser_num_crt = ls_cab-zznrosun.
      input-c_retencion-fec_emi_crt = ls_cab-zzfecemi.
*      input-c_retencion-fir_dig_crt = ."Web
      input-c_retencion-tip_doc_crt = ls_cab-zztipdoc.
      input-c_retencion-nmc_emi_crt = ls_cab-zzemiden.
      input-c_retencion-tni_emi_crt = ls_cab-zzeminro.
      input-c_retencion-dof_emi_crt = ls_cab-zzemidir.
*      input-c_retencion-tfx_emi_crt = ls_cab-zzemitel. "No existe aun
      input-c_retencion-nom_emi_crt = ls_cab-zzemiden.
      input-c_retencion-nmc_prv_crt = ls_cab-zzprvden.
      input-c_retencion-tni_prv_crt = ls_cab-zzprvnro.
      input-c_retencion-dof_prv_crt = ls_cab-zzprvdir.
      input-c_retencion-nom_prv_crt = ls_cab-zzprvden.
      input-c_retencion-reg_tas_crt = ls_cab-zzretreg.
      input-c_retencion-obs_rtn_crt = ls_cab-zzretitr_t.
      input-c_retencion-ito_rtn_crt = ls_cab-zzretitr.
      input-c_retencion-ito_pag_crt = ls_cab-zzretitp.
      input-c_retencion-ver_ubl_crt = ls_cab-zzverubl.
      input-c_retencion-ver_est_crt = ls_cab-zzverstr.
*      input-c_retencion-vlr_rsm_crt = ."Web
      input-c_retencion-ley_rep_crt = text-w01.
      input-c_retencion-ley_res_crt = get_sunat_resolution( ls_cab-bukrs ).
      input-c_retencion-tip_mon_crt = ls_cab-zzretmnd.
*      input-c_retencion-fec_reg_crt = ."Web
      input-c_retencion-est_reg_crt = is_options-only_syncstat. "+291222-NTP-3000020441
    ENDLOOP.

    LOOP AT it_det INTO ls_det.
      ls_item-ser_num_crt = ls_det-zznrosun.
      ls_item-num_itm_crt = ls_det-posnr.
      ls_item-tnd_rel_crt = ls_det-zzcrlnro.
      ls_item-fem_rel_crt = ls_det-zzcrlfec.
      ls_item-ito_rel_crt = ls_det-zzcrlitd.
      ls_item-fec_pag_crt = ls_det-zzpagfec.
      ls_item-num_pag_crt = ls_det-zzpagcor.
      ls_item-imp_pag_crt = ls_det-zzpagisr.
      ls_item-imp_ret_crt = ls_det-zzretire.
      ls_item-fec_ret_crt = ls_det-zzretfer.
      ls_item-mto_pag_crt = ls_det-zzretitp.
      ls_item-mro_tcm_crt = ls_det-zztpcmnd.
      ls_item-fac_tcm_crt = ls_det-zztpcapl.
      ls_item-fec_tcm_crt = ls_det-zztpcfec.
      APPEND ls_item TO input-d_retencion_array-d_retencion.
    ENDLOOP.

* Cliente
    LOOP AT it_cli INTO ls_cli.
      input-d_empresa-ruc_emp     = ls_cli-ruc.
      input-d_empresa-raz_soc_emp = ls_cli-razon_social.
      input-d_empresa-dir_emp     = ls_cli-direccion.
      input-d_empresa-tel_emp     = ls_cli-telefono.
      input-d_empresa-con_emp     = ls_cli-email.
    ENDLOOP.

    call_ws_main(
      EXPORTING
        pi_bukrs      = g_bukrs
        pi_tipdoc     = gc_tipdoc_rt
        pi_fecfac     = sy-datum
        pi_input      = input
        pi_cnumber    = ls_cab-crnumber
        pi_id         = ls_cab-zznrosun
        is_options    = is_options      "+291222-NTP-3000020441
      IMPORTING
        pe_output     = output
        pe_message    = et_return
    ).

  ENDMETHOD.


  METHOD call_ws_ret_rev.

    DATA: input   TYPE zosfe_wsosrrt_documentos_reque,  "Test,Homo,Prd
          output  TYPE zosfe_wsosrrt_documentos_respo,  "Test,Homo,Prd
          ls_item LIKE LINE OF input-d_rev_retencion_array-d_rev_retencion.

    DATA: ls_cab LIKE LINE OF it_cab,
          ls_det LIKE LINE OF it_det.

    CHECK lines( it_cab ) > 0.

* Cabecera
    LOOP AT it_cab INTO ls_cab.
      input-user = gs_consextsun-zz_usuario_web.
      input-pass = gs_consextsun-zz_pass_web.
      input-bukrs = gs_consextsun-bukrs.                  "I-NTP-010716

      input-c_rev_retencion-ide_rsm_rrt = ls_cab-zzidres.
      input-c_rev_retencion-nom_raz_rrt = ls_cab-zzemiden.
      input-c_rev_retencion-num_ruc_rrt = ls_cab-zzeminro.
      input-c_rev_retencion-fec_emi_rrt = ls_cab-zzfecemi.
      input-c_rev_retencion-fec_gen_rrt = ls_cab-zzfecgen.
*      input-c_rev_retencion-fir_dig_rrt = ."Web
      input-c_rev_retencion-ver_ubl_rrt = ls_cab-zzverubl.
      input-c_rev_retencion-ver_est_rrt = ls_cab-zzverstr.
*      input-c_rev_retencion-vlr_rsm_rrt = ."Web
      input-c_rev_retencion-ley_rep_rrt = text-w03.
      input-c_rev_retencion-ley_res_rrt = get_sunat_resolution( ls_cab-bukrs ).
*      input-c_rev_retencion-fec_reg_rrt = ."Web
*      input-c_rev_retencion-est_reg_rrt = ."Web
    ENDLOOP.

    LOOP AT it_det INTO ls_det.
      ls_item-ide_rsm_rrt = ls_det-zzidres.
      ls_item-num_itm_rrt = ls_det-zznfila.
      ls_item-tdc_rev_rrt = ls_det-zztipdoc.
      ls_item-sdc_rev_rrt = ls_det-zzcrlser.
      ls_item-cdc_rev_rrt = ls_det-zzcrlnro.
      ls_item-mot_rev_rrt = ls_det-zzmotanu.
      APPEND ls_item TO input-d_rev_retencion_array-d_rev_retencion.
    ENDLOOP.

    call_ws_main(
      EXPORTING
        pi_bukrs      = g_bukrs
        pi_tipdoc     = gc_prefix_rr
        pi_fecfac     = sy-datum
        pi_input      = input
        pi_id         = ls_cab-zzidres
      IMPORTING
        pe_output     = output
        pe_message    = et_return
    ).

  ENDMETHOD.


  METHOD check_homo_ret.

    DATA: ls_cab    LIKE LINE OF it_cab,
          ls_det    LIKE LINE OF it_det,
          ls_return LIKE LINE OF et_return,
          lt_log    TYPE TABLE OF zostb_cplog,
          ls_log    LIKE LINE OF lt_log,

          l_pos     TYPE posnr_d,
          l_corr    TYPE zosed_correlativ.



* Errores de cabecera
    LOOP AT it_cab INTO ls_cab.
      CLEAR ls_log.
      ls_log-bukrs          = ls_cab-bukrs.
      ls_log-zzt_nrodocsap  = ls_cab-crnumber.
      ls_log-zzt_numeracion = ls_cab-zznrosun.
      ls_log-zzt_status_cdr = gc_statuscdr_0.
      ls_log-zzt_fcreacion  = sy-datum.
      ls_log-zzt_hcreacion  = sy-uzeit.
      ls_log-zzt_ucreacion  = sy-uname.
      ls_log-zzt_tipodoc    = ls_cab-zztipdoc.

      IF ls_cab-zzeminro IS NOT INITIAL AND
         ls_cab-zzemitpd_h IS INITIAL.
        ADD 1 TO l_corr.
        ls_log-zzt_correlativ = l_corr.
        ls_log-zzt_errorext = 'Error Homologación RUC emisor'.
        APPEND ls_log TO lt_log.
      ENDIF.

      IF ls_cab-zzprvnro IS NOT INITIAL AND
        ls_cab-zzprvtpd_h IS INITIAL.
        ADD 1 TO l_corr.
        ls_log-zzt_correlativ = l_corr.
        ls_log-zzt_errorext = 'Error Homologación RUC cliente'.
        APPEND ls_log TO lt_log.
      ENDIF.

      IF ls_cab-zzretreg IS INITIAL OR
        ls_cab-zzrettas IS INITIAL.
        ADD 1 TO l_corr.
        ls_log-zzt_correlativ = l_corr.
        ls_log-zzt_errorext = 'Error Homologación Tasa de Retención'.
        APPEND ls_log TO lt_log.
      ENDIF.

*    IF ls_cab-zzretitr IS INITIAL OR
*      ls_cab-zzcrlmnd IS INITIAL.
*      ADD 1 to l_corr.
*      ls_log-zzt_correlativ = l_corr.
*      ls_log-zzt_errorext = 'Error Homologación Importe total retenido'.
*      APPEND ls_log TO lt_log.
*    ENDIF.
    ENDLOOP.

* Errores de detalle
    LOOP AT it_det INTO ls_det.
      CLEAR ls_log.
      CONCATENATE 'Pos.' ls_det-posnr ':' INTO l_pos SEPARATED BY space.
      ls_log-zzt_nrodocsap  = ls_det-crnumber.
*    ls_log-zzt_numeracion =
      ls_log-zzt_status_cdr = gc_statuscdr_0.
      ls_log-zzt_fcreacion = sy-datum.
      ls_log-zzt_hcreacion = sy-uzeit.
      ls_log-zzt_ucreacion = sy-uname.
      READ TABLE it_cab INTO ls_cab WITH KEY crnumber = ls_det-crnumber.
      IF sy-subrc = 0.
        ls_log-bukrs       = ls_cab-bukrs.
        ls_log-zzt_tipodoc = ls_cab-zztipdoc.
      ENDIF.

      IF ls_det-zzcrltip IS INITIAL OR
        ls_det-zzcrlser IS INITIAL.
        ADD 1 TO l_corr.
        ls_log-zzt_correlativ = l_corr.
        CONCATENATE l_pos 'Error Homologación Tipo Doc Relacionado'
               INTO ls_log-zzt_errorext SEPARATED BY space.
        APPEND ls_log TO lt_log.
      ENDIF.
    ENDLOOP.

* Actualizar tabla de log
    IF lt_log[] IS NOT INITIAL.
      MODIFY zostb_cplog FROM TABLE lt_log.
    ENDIF.

* Pasar error a parámetro de retorno
    IF lt_log[] IS NOT INITIAL.
      CLEAR ls_return.
      ls_return-type = 'E'.
      ls_return-id   = '00'.
      ls_return-number = '368'.
      ls_return-message_v1 = 'Error de Homologación en el Extractor.'.
      ls_return-message_v2 = 'Verificar error en el Monitor'.
      APPEND ls_return TO et_return.
      RAISE error.
    ENDIF.
  ENDMETHOD.


  METHOD check_homo_ret_rev.

*  DATA: ls_cab LIKE LINE OF it_cab,
*        ls_det LIKE LINE OF it_det,
*        ls_return LIKE LINE OF et_return,
*        lt_log    TYPE TABLE OF zostb_cplog,
*        ls_log    LIKE LINE OF lt_log,
*
*        l_pos     TYPE posnr_d,
*        l_corr    TYPE zosed_correlativ.
*
*
*
** Errores de cabecera
*  LOOP AT it_cab INTO ls_cab.
*    CLEAR ls_log.
*    ls_log-bukrs          = ls_cab-bukrs.
*    ls_log-zzt_nrodocsap  = ls_cab-crnumber.
*    ls_log-zzt_numeracion = ls_cab-zznrosun.
*    ls_log-zzt_status_cdr = gc_statuscdr_0.
*    ls_log-zzt_fcreacion  = sy-datum.
*    ls_log-zzt_hcreacion  = sy-uzeit.
*    ls_log-zzt_ucreacion  = sy-uname.
*    ls_log-zzt_tipodoc    = ls_cab-zztipdoc.
*
*    IF ls_cab-zzeminro IS NOT INITIAL AND
*       ls_cab-zzemitpd_h IS INITIAL.
*      ADD 1 TO l_corr.
*      ls_log-zzt_correlativ = l_corr.
*      ls_log-zzt_errorext = 'Error Homologación RUC emisor'.
*      APPEND ls_log TO lt_log.
*    ENDIF.
*
*    IF ls_cab-zzprvnro IS NOT INITIAL AND
*      ls_cab-zzprvtpd_h IS INITIAL.
*      ADD 1 TO l_corr.
*      ls_log-zzt_correlativ = l_corr.
*      ls_log-zzt_errorext = 'Error Homologación RUC cliente'.
*      APPEND ls_log TO lt_log.
*    ENDIF.
*
*    IF ls_cab-zzretreg IS INITIAL OR
*      ls_cab-zzrettas IS INITIAL.
*      ADD 1 TO l_corr.
*      ls_log-zzt_correlativ = l_corr.
*      ls_log-zzt_errorext = 'Error Homologación Tasa de percepción'.
*      APPEND ls_log TO lt_log.
*    ENDIF.
*
**    IF ls_cab-zzretitr IS INITIAL OR
**      ls_cab-zzcrlmnd IS INITIAL.
**      ADD 1 to l_corr.
**      ls_log-zzt_correlativ = l_corr.
**      ls_log-zzt_errorext = 'Error Homologación Importe total percibido'.
**      APPEND ls_log TO lt_log.
**    ENDIF.
*  ENDLOOP.
*
** Errores de detalle
*  LOOP AT it_det INTO ls_det.
*    CLEAR ls_log.
*    CONCATENATE 'Pos.' ls_det-posnr ':' INTO l_pos SEPARATED BY space.
*    ls_log-zzt_nrodocsap  = ls_det-crnumber.
**    ls_log-zzt_numeracion =
*    ls_log-zzt_status_cdr = gc_statuscdr_0.
*    ls_log-zzt_fcreacion = sy-datum.
*    ls_log-zzt_hcreacion = sy-uzeit.
*    ls_log-zzt_ucreacion = sy-uname.
*    READ TABLE it_cab INTO ls_cab WITH KEY crnumber = ls_det-crnumber.
*    IF sy-subrc = 0.
*      ls_log-bukrs       = ls_cab-bukrs.
*      ls_log-zzt_tipodoc = ls_cab-zztipdoc.
*    ENDIF.
*
*    IF ls_det-zzcrltip IS INITIAL OR
*      ls_det-zzcrlser IS INITIAL.
*      ADD 1 TO l_corr.
*      ls_log-zzt_correlativ = l_corr.
*      CONCATENATE l_pos 'Error Homologación Tipo Doc Relacionado'
*             INTO ls_log-zzt_errorext SEPARATED BY space.
*      APPEND ls_log TO lt_log.
*    ENDIF.
*  ENDLOOP.
*
** Actualizar tabla de log
*  IF lt_log[] IS NOT INITIAL.
*    MODIFY zostb_cplog FROM TABLE lt_log.
*  ENDIF.
*
** Pasar error a parámetro de retorno
*  IF lt_log[] IS NOT INITIAL.
*    CLEAR ls_return.
*    ls_return-type = 'E'.
*    ls_return-id   = '00'.
*    ls_return-number = '368'.
*    ls_return-message_v1 = 'Error de Homologación en el Extractor.'.
*    ls_return-message_v2 = 'Verificar error en el Monitor'.
*    APPEND ls_return TO et_return.
*    RAISE error.
*  ENDIF.
  ENDMETHOD.


  METHOD extrae_data_retencion.

    DATA: lt_rcab     TYPE gtt_registro_retencion, "Cabecera certificados
          lt_rdet     TYPE gtt_registro_retencion, "Detalle certificados
          lt_cab      TYPE gtt_fertcab,
          lt_det      TYPE gtt_fertdet,
          lt_cli      TYPE gtt_fecli,

          lt_cab_json TYPE gtt_fertcab_json,
          lt_det_json TYPE gtt_fertdet_json,
          ls_return   TYPE bapiret2.                "I-NTP-130716


* Free
    free_data( ).

* Obtener constantes y catálogos
    g_bukrs = i_bukrs.
    get_constantes( ).

* Obtener data de sap
    get_data_ret( EXPORTING i_bukrs  = i_bukrs
                            i_crnumber = i_crnumber
                  IMPORTING et_rcab = lt_rcab
                            et_rdet = lt_rdet
                  EXCEPTIONS error    = 1 ).
    IF sy-subrc <> 0.
*      El mensaje esta inplementado en ZOSFI_RPT_COMPROB_RETENCIONNEW "I-NTP250917-3000008236
*      ls_return = sy_to_ret( ).                       "I-NTP-130716  "E-NTP250917-3000008236
*      APPEND ls_return TO et_return.                  "I-NTP-130716  "E-NTP250917-3000008236
*      APPEND sy_to_ret( ) TO et_return. RAISE error. "E-NTP-130716   "E-NTP250917-3000008236
      RAISE error.                                    "I-NTP-130716
    ENDIF.

* Formar Datos Cabecera
    set_data_ret( EXPORTING it_rcab = lt_rcab
                            it_rdet = lt_rdet
                  IMPORTING et_cab   = lt_cab
                            et_det   = lt_det
                  EXCEPTIONS error   = 1 ).
    IF sy-subrc <> 0.
      ls_return = sy_to_ret( ).                       "I-NTP-130716
      APPEND ls_return TO et_return.                  "I-NTP-130716
      RAISE error.                                    "I-NTP-130716
*      APPEND sy_to_ret( ) TO et_return. RAISE error. "E-NTP-130716
    ENDIF.

* Homologar Percepción
    set_homo_ret( CHANGING ct_cab = lt_cab ).

* Homologar Cliente
    set_homo_cli( EXPORTING pi_cab = lt_cab
                  IMPORTING pe_cli = lt_cli ).

* Verificar Homologación
    check_homo_ret( EXPORTING it_cab    = lt_cab
                              it_det    = lt_det
                    IMPORTING et_return = et_return
                    EXCEPTIONS error = 1 ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.

* Actualizar tabla z
    upd_tabla_ret( it_cab = lt_cab
                   it_det = lt_det
                   it_cli = lt_cli ).

* Setear valores Json
    set_json_ret( EXPORTING it_cab = lt_cab
                            it_det = lt_det
                  IMPORTING et_cab_json = lt_cab_json
                            et_det_json = lt_det_json ).

* Enviar via WS
    call_ws_ret( EXPORTING it_cab = lt_cab_json
                           it_det = lt_det_json
                           it_cli = lt_cli
                           is_options = is_options "+291222-NTP-3000020441
                 IMPORTING et_return = et_return
                 EXCEPTIONS error = 1 ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.

  ENDMETHOD.


  METHOD extrae_data_retencion_rev.

    DATA: lt_rcab     TYPE gtt_cnumber, "Cabecera certificados
          lt_rdet     TYPE gtt_cnumber, "Detalle certificados
          lt_cab      TYPE gtt_rertcab,
          lt_det      TYPE gtt_rertdet,

          lt_cab_json TYPE gtt_rertcab_json,
          lt_det_json TYPE gtt_rertdet_json,
          ls_return   TYPE bapiret2.            "I-NTP-130716


* Free
    free_data( ).

* Obtener constantes y catálogos
    g_bukrs = i_bukrs.
    get_constantes( ).

* Obtener data de sap
    get_data_ret_rev( EXPORTING i_bukrs  = i_bukrs
                                i_fecha = i_fecha
                      IMPORTING et_rcab = lt_rcab
                                et_rdet = lt_rdet
                      EXCEPTIONS error    = 1 ).
    IF sy-subrc <> 0.
      ls_return = sy_to_ret( ).                       "I-NTP-130716
      APPEND ls_return TO et_return.                  "I-NTP-130716
      RAISE error.                                    "I-NTP-130716
*      APPEND sy_to_ret( ) TO et_return. RAISE error. "E-NTP-130716
    ENDIF.

* Formar Datos Cabecera
    set_data_ret_rev( EXPORTING it_rcab = lt_rcab
                                it_rdet = lt_rdet
                      IMPORTING et_cab   = lt_cab
                                et_det   = lt_det
                      EXCEPTIONS error   = 1 ).
    IF sy-subrc <> 0.
      ls_return = sy_to_ret( ).                       "I-NTP-130716
      APPEND ls_return TO et_return.                  "I-NTP-130716
      RAISE error.                                    "I-NTP-130716
*      APPEND sy_to_ret( ) TO et_return. RAISE error. "E-NTP-130716
    ENDIF.

** Homologar Percepción
*  set_homo_ret_rev( CHANGING ct_cab = lt_cab ).
*
** Verificar Homologación
*  check_homo_ret_rev( EXPORTING it_cab    = lt_cab
*                                it_det    = lt_det
*                      IMPORTING et_return = et_return
*                      EXCEPTIONS error = 1 ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.

* Actualizar tabla z
    upd_tabla_ret_rev( it_cab = lt_cab
                       it_det = lt_det ).

* Setear valores Json
    set_json_ret_rev( EXPORTING it_cab = lt_cab
                                it_det = lt_det
                      IMPORTING et_cab_json = lt_cab_json
                                et_det_json = lt_det_json ).

* Enviar via WS
    call_ws_ret_rev( EXPORTING it_cab = lt_cab_json
                               it_det = lt_det_json
                     IMPORTING et_return = et_return
                     EXCEPTIONS error = 1 ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.

*  Actualiza identificador
    upd_identi_ret_rev( it_rcab = lt_rcab
                        it_cab  = lt_cab ).

  ENDMETHOD.


  METHOD free_data.

    REFRESH: gth_hom06,
             gth_hom23,
             gt_const,
             gt_proxy,
             gt_vigen.

  ENDMETHOD.


  METHOD get_constantes.

    DATA: lt_const TYPE TABLE OF zostb_constantes,
          ls_const LIKE LINE OF lt_const,
          l_string TYPE string.

    SELECT SINGLE * INTO gs_consextsun FROM zostb_consextsun WHERE bukrs = g_bukrs.

*{  BEGIN OF REPLACE WMR-080816-3000005361
    ""    SELECT * INTO TABLE gth_t001z FROM t001z WHERE bukrs = g_bukrs AND party = gc_party.
    SELECT * INTO TABLE gth_t001z FROM t001z WHERE bukrs = g_bukrs
                                               AND party = gs_consextsun-zz_paramruc.
    IF sy-subrc NE 0.
      SELECT * INTO TABLE gth_t001z FROM t001z WHERE bukrs = g_bukrs
                                                 AND party = gc_party.
    ENDIF.
*}  END OF REPLACE WMR-080816-3000005361

    SELECT * INTO TABLE gth_t001  FROM t001 WHERE bukrs = g_bukrs.

    SELECT * INTO TABLE gt_proxy FROM zostb_envwsfe WHERE bukrs = g_bukrs.

    SELECT * INTO TABLE gt_vigen  FROM zostb_constvigen.

    SELECT * INTO TABLE gth_hom06 FROM zostb_catahomo06.

    SELECT * INTO TABLE gth_hom23 FROM zostb_catahomo23.

    SELECT * INTO TABLE gt_const  FROM zostb_const_fe
      WHERE aplicacion = gc_aplic
        AND programa   = gc_prog.

    SELECT * INTO TABLE gt_tcurt FROM zostb_tcurt.

*{BEGIN OF INSERT NTP-200616
    zosclpell_libros_legales=>get_constants_ll(
      EXPORTING
        i_progname        = gc_progname
      IMPORTING
        et_constants      = lt_const ).

    LOOP AT lt_const INTO ls_const.
      CONCATENATE ls_const-signo ls_const-opcion ls_const-valor1 INTO l_string.
      CASE ls_const-campo.
        WHEN 'RETEN_%'. zconst-reten_per = ls_const-valor1 * 100.
        WHEN 'WITHT'.  APPEND l_string TO zconst-r_witht.
        WHEN 'WITHCD'. APPEND l_string TO zconst-r_withcd.
      ENDCASE.
    ENDLOOP.
*}END OF INSERT NTP-200616

    " Nro. Instalación Sap
    CALL FUNCTION 'SLIC_GET_LICENCE_NUMBER'
      IMPORTING
        license_number = gw_license.

  ENDMETHOD.


  METHOD get_data_ret.

    DATA: ls_rdet   LIKE LINE OF et_rdet.
    DATA: ls_kna1     TYPE gty_kna1,
          ls_t001     TYPE t001,
          lr_adrnr    TYPE gtr_adrnr,
          ls_adrnr    LIKE LINE OF lr_adrnr VALUE 'IEQ',
          lr_crnumber TYPE gtr_crnumber,
          ls_crnumber LIKE LINE OF lr_crnumber VALUE 'IEQ',
          lr_gjahr    TYPE RANGE OF gjahr,
          ls_gjahr    LIKE LINE OF lr_gjahr.

    DATA: lt_memory  TYPE gtt_registro_retencion,
          lo_error   TYPE REF TO cx_root,
          lw_message TYPE string,
          l_aplic_nc_fac TYPE xfeld.                                      "I-WMR-240919-3000012845


    IF gw_license EQ '0021061097' OR  "CMH              "I-SVM011019-3000012421
       gw_license EQ '0020311006' OR  "AIB              "I-SVM011019-3000012421
       gw_license EQ '0020863116' .   "AIB CLOUD
      l_aplic_nc_fac = abap_on.                         "I-SVM011019-3000012421
    ENDIF.                                              "I-SVM011019-3000012421

    "Retenciones
    lr_crnumber = ir_crnumber.
    IF i_crnumber IS NOT INITIAL.
      ls_crnumber-low = i_crnumber.
      APPEND ls_crnumber TO lr_crnumber.
    ENDIF.

    "Get
    SUBMIT zosfi_rpt_registro_retenc_igv "zosfi_rpt_reg_retenciones_igv
      WITH p_bukrs  EQ i_bukrs
*    WITH p_gjahr  EQ i_gjahr
      WITH s_crnumb IN lr_crnumber
      WITH p_memory EQ 'X'
      WITH p_apncfa EQ l_aplic_nc_fac                 "I-SVM011019-3000012421
       AND RETURN.

    TRY .
        IMPORT gt_rimpre = lt_memory FROM MEMORY ID 'RESUMRET'.
        FREE MEMORY ID 'RESUMRET'.

      CATCH cx_root INTO lo_error.
        lw_message = lo_error->get_text( ).
        MESSAGE e000 WITH lw_message RAISING error.
    ENDTRY.

    et_rdet[] = lt_memory[].

* Limpia Detalle
    DELETE et_rdet WHERE crnumber IS INITIAL.
    DELETE et_rdet WHERE crnumber NOT IN lr_crnumber. "Puede venir varios
    IF et_rdet[] IS INITIAL.
      MESSAGE e000 WITH 'No existen datos de selección...' RAISING error.
    ENDIF.

* Adicionar sociedad
    ls_rdet-bukrs = i_bukrs.
    MODIFY et_rdet FROM ls_rdet TRANSPORTING bukrs WHERE bukrs IS INITIAL.

* Cabecera
    SORT et_rdet BY bukrs crnumber.
    et_rcab = et_rdet.
    DELETE ADJACENT DUPLICATES FROM et_rcab COMPARING bukrs crnumber.

* Clientes
    SELECT lifnr AS kunnr stcd1 stcdt xcpdk adrnr name1 name2 name3 name4 stkzn
      INTO TABLE gth_kna1
      FROM lfa1
      FOR ALL ENTRIES IN et_rdet
      WHERE lifnr = et_rdet-lifnr.

* Direcciones
    LOOP AT gth_kna1 INTO ls_kna1.
      ls_adrnr-low = ls_kna1-adrnr.
      APPEND ls_adrnr TO lr_adrnr.
    ENDLOOP.
    LOOP AT gth_t001 INTO ls_t001.
      ls_adrnr-low = ls_t001-adrnr.
      APPEND ls_adrnr TO lr_adrnr.
    ENDLOOP.
    IF lr_adrnr[] IS NOT INITIAL.
      get_direcciones( EXPORTING ir_adrnr      = lr_adrnr
                       IMPORTING eth_direccion = gth_dire ).
    ENDIF.

  ENDMETHOD.


  METHOD get_data_ret_rev.

    DATA: lt_cplog TYPE TABLE OF zostb_cplog,
          ls_rcab  LIKE LINE OF et_rcab,
          l_tabix  TYPE i.

*{  BEGIN OF INSERT WMR-040816-3000005346
    DATA: lr_adrnr TYPE gtr_adrnr,
          ls_t001  TYPE t001,
          ls_adrnr LIKE LINE OF lr_adrnr VALUE 'IEQ'.
*}  END OF INSERT WMR-040816-3000005346

    "Certificados Anulados
    SELECT *
      INTO TABLE et_rcab
      FROM zostb_cnumber
      WHERE bukrs EQ i_bukrs
        AND feanu EQ i_fecha
        AND anula = abap_on
        AND tipse = gc_tp_electro.  "E
    IF sy-subrc <> 0.
      MESSAGE s000 WITH 'No existe datos para procesar' RAISING error.
    ENDIF.

    "Verificar que Estado Aceptado
    SELECT *
      INTO TABLE lt_cplog
      FROM zostb_cplog
      FOR ALL ENTRIES IN et_rcab
      WHERE bukrs = et_rcab-bukrs
        AND zzt_nrodocsap = et_rcab-crnumber
        AND ( zzt_status_cdr = gc_statuscdr_1 OR
              zzt_status_cdr = gc_statuscdr_4 ).
    IF sy-subrc <> 0.
      MESSAGE s000 WITH 'No existe datos para procesar' RAISING error.
    ENDIF.


    "Actualiza
    LOOP AT et_rcab INTO ls_rcab.
      l_tabix = sy-tabix.

      READ TABLE lt_cplog WITH KEY zzt_nrodocsap = ls_rcab-crnumber TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        DELETE et_rcab INDEX l_tabix.
      ENDIF.
    ENDLOOP.
    IF et_rcab[] IS INITIAL.
      MESSAGE s000 WITH 'No existe datos para procesar' RAISING error.
    ENDIF.


    "Posicion
    et_rdet = et_rcab.

*{  BEGIN OF INSERT WMR-040816-3000005346
* Direcciones
    LOOP AT gth_t001 INTO ls_t001.
      ls_adrnr-low = ls_t001-adrnr.
      APPEND ls_adrnr TO lr_adrnr.
    ENDLOOP.
    IF lr_adrnr[] IS NOT INITIAL.
      get_direcciones( EXPORTING ir_adrnr      = lr_adrnr
                       IMPORTING eth_direccion = gth_dire ).
    ENDIF.
*}  END OF INSERT WMR-040816-3000005346

  ENDMETHOD.


  METHOD get_direcciones.

    TYPES: BEGIN OF ty_adrc,
             adrnr      TYPE  adrc-addrnumber,   "Nro
             country    TYPE  adrc-country,      "Pais
             region     TYPE  adrc-region,       "Departamento
             street     TYPE  adrc-street,       "Dirección
             house_num1 TYPE  adrc-house_num1,   "Dirección
             str_suppl1 TYPE  adrc-str_suppl1,   "Dirección "Urbanización
             str_suppl2 TYPE  adrc-str_suppl2,   "Dirección
             str_suppl3 TYPE  adrc-str_suppl3,   "Dirección
             city1      TYPE  adrc-city1,        "Provincia
             city2      TYPE  adrc-city2,        "Distrito
             location   TYPE  adrc-location,
             cityp_code TYPE  adrc-cityp_code,   "Ubigeo
             name1      TYPE  adrc-name1,
             name2      TYPE  adrc-name2,
             name3      TYPE  adrc-name3,
             name4      TYPE  adrc-name4,
             tel_number TYPE  ad_tlnmbr1,
             fax_number TYPE  ad_fxnmbr1,
*{  BEGIN OF INSERT WMR-010716
             city_code  TYPE  adrc-city_code,   " Codificación de Provincia
*}  END OF INSERT WMR-010716
           END OF ty_adrc,

           BEGIN OF ty_t005u,
             land1 TYPE  t005u-land1,      " Clave de país
             bland TYPE  t005u-bland,      " Departamento
             bezei TYPE  t005u-bezei,      " Denominación
           END OF ty_t005u,

           BEGIN OF ty_adr6,
             adrnr     TYPE adrnr,
             persnum   TYPE adr6-persnumber,
             datefrom  TYPE adr6-date_from,
             consnumb  TYPE adr6-consnumber,
             smtp_addr TYPE adr6-smtp_addr,
           END OF ty_adr6 .

    DATA: lt_adrc      TYPE TABLE OF ty_adrc,
          lt_adrc1     TYPE TABLE OF ty_adrc,
          lt_t005u     TYPE HASHED TABLE OF ty_t005u WITH UNIQUE KEY land1 bland,
          lt_adr6      TYPE TABLE OF ty_adr6,
          lt_direccion TYPE TABLE OF gty_direccion,
*{  BEGIN OF INSERT WMR-010716
          lr_city_code TYPE RANGE OF adrcityt-city_code,
          lt_split     TYPE TABLE OF string,
*}  END OF INSERT WMR-010716

          "WA
          ls_adrc      TYPE ty_adrc,
          ls_t005u     TYPE ty_t005u,
          ls_adr6      TYPE ty_adr6,
          ls_direccion TYPE gty_direccion,
*{  BEGIN OF INSERT WMR-010716
          ls_city_code LIKE LINE OF lr_city_code,
          ls_split     LIKE LINE OF lt_split.
*}  END OF INSERT WMR-010716

    CHECK ir_adrnr[] IS NOT INITIAL.

    SELECT addrnumber country region street house_num1
           str_suppl1 str_suppl2 str_suppl3
           city1 city2 location cityp_code
           name1 name2 name3 name4 tel_number fax_number
*{  BEGIN OF INSERT WMR-010716
           city_code
*}  END OF INSERT WMR-010716
      FROM adrc
      INTO TABLE lt_adrc
        WHERE addrnumber IN ir_adrnr
          AND date_from  EQ '00010101'
          AND nation     IS NOT NULL.

    IF lt_adrc[] IS NOT INITIAL.
      SORT lt_adrc BY adrnr ASCENDING.

      lt_adrc1[] = lt_adrc[].
      SORT lt_adrc1 BY country ASCENDING region ASCENDING.
      DELETE ADJACENT DUPLICATES FROM lt_adrc1 COMPARING country region.
      IF lt_adrc1[] IS NOT INITIAL.
        SELECT land1 bland bezei
          INTO TABLE lt_t005u
          FROM t005u
          FOR ALL ENTRIES IN lt_adrc1
          WHERE spras EQ sy-langu
            AND land1 EQ lt_adrc1-country
            AND bland EQ lt_adrc1-region.
      ENDIF.

      SELECT addrnumber persnumber date_from consnumber smtp_addr
        INTO TABLE lt_adr6
        FROM adr6
        FOR ALL ENTRIES IN lt_adrc
        WHERE addrnumber EQ lt_adrc-adrnr
*{  BEGIN OF INSERT WMR-090816-3000005457
          AND flgdefault EQ abap_true.
*}  END OF INSERT WMR-090816-3000005457
      SORT lt_adr6 BY adrnr.

      LOOP AT lt_adrc INTO ls_adrc.
*{  BEGIN OF INSERT WMR-010716
        CLEAR: lr_city_code, lt_split.
*}  END OF INSERT WMR-010716

        ls_direccion-adrnr  = ls_adrc-adrnr.

        " Nombre
        CONCATENATE ls_adrc-name1 ls_adrc-name2 ls_adrc-name3 ls_adrc-name4 INTO ls_direccion-name SEPARATED BY space.
        " Nombre 1
        ls_direccion-name1  = ls_adrc-name1.
        " Nombre 2
        ls_direccion-name2  = ls_adrc-name2.
        " Nombre 3
        ls_direccion-name3  = ls_adrc-name3.
        " Nombre 4
        ls_direccion-name4  = ls_adrc-name4.
        " Teléfono
        ls_direccion-tel_number = ls_adrc-tel_number.
        " Fax
        ls_direccion-fax_number = ls_adrc-fax_number.
        " Nombre de Avenida/ Calle/ Jirón
        ls_direccion-street = ls_adrc-street.
        " Número
        ls_direccion-stnumb = ls_adrc-house_num1.
        " Urbanización
        ls_direccion-str_suppl1 = ls_adrc-str_suppl1.
        ls_direccion-str_suppl2 = ls_adrc-str_suppl2.
        ls_direccion-str_suppl3 = ls_adrc-str_suppl3.
        " País
        ls_direccion-pais   = ls_adrc-country.
        " Departamento
        READ TABLE lt_t005u INTO ls_t005u
                   WITH TABLE KEY land1 = ls_adrc-country
                                  bland = ls_adrc-region.
        IF sy-subrc EQ 0.
          ls_direccion-depart = ls_t005u-bezei.
        ENDIF.
        " Provincia
        ls_direccion-provin = ls_adrc-city1.
        " Distrito
        ls_direccion-distri = ls_adrc-city2.
        " Ubigeo
*{  BEGIN OF INSERT WMR-010716
        IF ls_adrc-cityp_code IS INITIAL.
          IF ls_adrc-city_code IS INITIAL.
            CASE gw_license.
              WHEN '0020241712' OR '0020673876'.  " Beta
                SPLIT ls_adrc-city1 AT ' - ' INTO TABLE lt_split.
                IF lines( lt_split ) EQ 3.
                  " Leer Departamento
                  READ TABLE lt_split INTO ls_split INDEX 2.
                  IF sy-subrc EQ 0.
                    TRANSLATE ls_split TO UPPER CASE.
                    SELECT city_code AS low
                      INTO CORRESPONDING FIELDS OF TABLE lr_city_code
                      FROM adrcityt
                      WHERE langu     EQ sy-langu
                        AND country   EQ ls_adrc-country
                        AND city_name EQ ls_split.
                    IF lr_city_code[] IS NOT INITIAL.
                      LOOP AT lt_split INTO ls_split.
                        TRANSLATE ls_split TO UPPER CASE.
                        CASE sy-tabix.
                          WHEN 2.
                            " Provincia
                            ls_direccion-provin = ls_adrc-city1 = ls_split.
                          WHEN 3.
                            " Distrito
                            ls_direccion-distri = ls_adrc-city2 = ls_split.
                        ENDCASE.
                      ENDLOOP.
                    ENDIF.
                  ENDIF.
                ELSE.

                  " Obtener Códigos de Provincia
                  TRANSLATE ls_adrc-city1 TO UPPER CASE.
                  SELECT city_code AS low
                    INTO CORRESPONDING FIELDS OF TABLE lr_city_code
                    FROM adrcityt
                    WHERE langu     EQ sy-langu
                      AND country   EQ ls_adrc-country
                      AND city_name EQ ls_adrc-city1.
                ENDIF.

              WHEN OTHERS.
                " Obtener Códigos de Provincia
                TRANSLATE ls_adrc-city1 TO UPPER CASE.
                SELECT city_code AS low
                  INTO CORRESPONDING FIELDS OF TABLE lr_city_code
                  FROM adrcityt
                  WHERE langu     EQ sy-langu
                    AND country   EQ ls_adrc-country
                    AND city_name EQ ls_adrc-city1.
            ENDCASE.

            LOOP AT lr_city_code INTO ls_city_code.
              ls_city_code-sign = 'I'. ls_city_code-option = 'EQ'.
              MODIFY lr_city_code FROM ls_city_code INDEX sy-tabix.
            ENDLOOP.
          ELSE.
            CONCATENATE 'IEQ' ls_adrc-city_code INTO ls_city_code.
            APPEND ls_city_code TO lr_city_code.
          ENDIF.
          IF lr_city_code[] IS NOT INITIAL.
            " Buscar en código postales de Distritos
            TRANSLATE ls_adrc-city2 TO UPPER CASE.
            SELECT SINGLE cityp_code
              INTO ls_adrc-cityp_code
              FROM adrcityprt
              WHERE country   EQ ls_adrc-country
                AND city_code IN lr_city_code
                AND city_part EQ ls_adrc-city2.
          ENDIF.
        ENDIF.
*}  END OF INSERT WMR-010716
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = ls_adrc-cityp_code
          IMPORTING
            output = ls_adrc-cityp_code.
        ls_direccion-ubigeo = ls_adrc-cityp_code.
        " Correo
        LOOP AT lt_adr6 INTO ls_adr6 WHERE adrnr = ls_adrc-adrnr.
          IF ls_direccion-smtp_addr IS INITIAL.
            ls_direccion-smtp_addr = ls_adr6-smtp_addr.
          ELSE.
            CONCATENATE ls_direccion-smtp_addr ls_adr6-smtp_addr INTO ls_direccion-smtp_addr SEPARATED BY ';'.
          ENDIF.
        ENDLOOP.

        APPEND ls_direccion TO lt_direccion.
        CLEAR ls_direccion.
      ENDLOOP.

      eth_direccion = lt_direccion.
    ENDIF.

  ENDMETHOD.


  method GET_LAST_RET_REV.

    TYPES: BEGIN OF ty_numeracion,
             bukrs   TYPE bukrs,
             zzidres TYPE zosed_identifiresu,
             correl  TYPE numc06,
           END OF ty_numeracion .

    DATA: lt_rcab   TYPE TABLE OF ty_numeracion,
          l_correl  TYPE char6,
          l_numero  TYPE i,
          l_lastnum TYPE char03,
          l_string  TYPE string,
          lr_idres  TYPE RANGE OF zosed_identifiresu.

    FIELD-SYMBOLS: <fs_rcab> LIKE LINE OF lt_rcab.


    "Identificador de Reversión
    CONCATENATE 'ICP' 'RR-' sy-datum '*' INTO l_string.
    APPEND l_string TO lr_idres.

    SELECT bukrs zzidres
      INTO TABLE lt_rcab
      FROM zostb_rertcab
      WHERE bukrs   EQ i_bukrs
        AND zzidres IN lr_idres.


    "Calcula el ultimo
    IF lt_rcab IS NOT INITIAL.
      LOOP AT lt_rcab ASSIGNING <fs_rcab>.
        l_correl = <fs_rcab>-zzidres+12.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = l_correl
          IMPORTING
            output = l_correl.
        l_numero = l_correl.
        <fs_rcab>-correl = l_numero.
      ENDLOOP.

      SORT lt_rcab BY correl DESCENDING.
      READ TABLE lt_rcab ASSIGNING <fs_rcab> INDEX 1.
      l_correl = <fs_rcab>-correl.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = l_correl
        IMPORTING
          output = l_lastnum.

      ADD 1 TO l_lastnum.
      CONDENSE l_lastnum.
    ELSE.
      l_lastnum = '1'.
    ENDIF.


    "Retorno
    CONCATENATE 'RR-' sy-datum '-' l_lastnum INTO r_idres.

  endmethod.


  method GET_SUNAT_RESOLUTION.

    r_resol = text-w02.
    REPLACE '&1' WITH gs_consextsun-zz_resol INTO r_resol.

  endmethod.


  METHOD get_text_monto.

    DATA: ls_spell TYPE spell,
          ls_tcurt TYPE zostb_tcurt.

    LOOP AT gt_tcurt INTO ls_tcurt WHERE waers EQ i_waers
                                     AND begda LE i_bldat
                                     AND endda GE i_bldat.
      EXIT.
    ENDLOOP.
    CHECK sy-subrc EQ 0.

    CALL FUNCTION 'SPELL_AMOUNT'
      EXPORTING
        amount    = i_monto
        currency  = i_waers
        language  = sy-langu
      IMPORTING
        in_words  = ls_spell
      EXCEPTIONS
        not_found = 1
        too_large = 2
        OTHERS    = 3.
    IF sy-subrc NE 0.
*      MESSAGE 'Error en importe total de ve, no se puede mostrar en texto' TYPE 'E'.
    ENDIF.

    IF ls_tcurt IS NOT INITIAL.
      CONCATENATE ls_spell-decimal(2) '/100' e_text INTO e_text.
      IF i_monto LE 1.
        CONCATENATE ls_spell-word 'y' e_text ls_tcurt-nomsun INTO e_text SEPARATED BY space.
      ELSE.
        CONCATENATE ls_spell-word 'y' e_text ls_tcurt-nommon2 INTO e_text SEPARATED BY space.
      ENDIF.
      TRANSLATE e_text TO UPPER CASE.
    ENDIF.

  ENDMETHOD.


METHOD set_data_ret.

  DATA: lt_rdet      TYPE gtt_registro_retencion,
        lt_rtot      TYPE gtt_registro_retencion,
        lt_witem_pa  TYPE TABLE OF gty_with_item,
        lts_witem_pa TYPE SORTED TABLE OF gty_with_item WITH UNIQUE KEY bukrs belnr gjahr buzei,
        lth_bkpf     TYPE SORTED TABLE OF gty_bkpf      WITH UNIQUE KEY bukrs belnr gjahr,

        ls_rcab      LIKE LINE OF it_rdet,
        ls_rdet      LIKE LINE OF it_rcab,
        ls_rtot      LIKE LINE OF lt_rtot,
        ls_refsunat  TYPE gty_refsunat,
        ls_witem_pa  TYPE gty_with_item,
        ls_bkpf      TYPE gty_bkpf,
        ls_cab       LIKE LINE OF et_cab,
        ls_det       LIKE LINE OF et_det,

        ls_hom23     TYPE zostb_catahomo23,
        ls_t001z     TYPE t001z,
        ls_t001      TYPE t001,
        ls_kna1      TYPE gty_kna1,

        l_importe    TYPE wertv8,
        l_posnr      TYPE i,
        l_length     TYPE i.

  "Pago
  SELECT bukrs belnr gjahr kursf wwert
    INTO TABLE lth_bkpf
    FROM bkpf
    FOR ALL ENTRIES IN it_rdet
    WHERE bukrs EQ it_rdet-bukrs
      AND belnr EQ it_rdet-belnr
      AND gjahr EQ it_rdet-gjahr
      AND bstat EQ space.

  "Impuesto Pago
  SELECT bukrs belnr gjahr buzei witht wt_withcd wt_qsshb wt_qsshh qsatz
    INTO TABLE lt_witem_pa
    FROM with_item
    FOR ALL ENTRIES IN it_rdet
    WHERE bukrs EQ it_rdet-bukrs
      AND belnr EQ it_rdet-belnr
      AND gjahr EQ it_rdet-gjahr
      AND witht IN zconst-r_witht.                                                          "I-NTP-200616

*    DELETE lt_witem_pa WHERE wt_withcd IS INITIAL. "Indicador                                "E-NTP-200616
  DELETE lt_witem_pa WHERE wt_withcd NOT IN zconst-r_withcd. "Indicador                     "R-NTP-200616
*    DELETE lt_witem_pa WHERE wt_qsshb EQ 0.        "Mon.Doc
  lts_witem_pa[] = lt_witem_pa[].

  "Totalización Impuesto pago
  LOOP AT it_rdet INTO ls_rdet.
    ls_rtot-bukrs    = ls_rdet-bukrs.
    ls_rtot-crnumber = ls_rdet-crnumber.
*      ls_rtot-wt_qsshh = ls_rdet-wt_qsshh.  "Base Imponible ML                               "E-NTP-200516
*      ls_rtot-dmbtr    = ls_rdet-dmbtr.     "Retención ML                                    "E-NTP-200516
*      ls_rtot-dif_imp  = ls_rdet-dif_imp.   "Base - Retención ML                             "E-NTP-200516
    ls_rtot-wt_qbshh2 = ls_rdet-wt_qbshh2.                            "Retención ML         "I-NTP-200516
    ls_rtot-dif_imp   = abs( ls_rdet-wt_qsshh2 - ls_rdet-wt_qbshh2 ). "Base - Retención ML  "I-NTP-200516
    COLLECT ls_rtot INTO lt_rtot.
  ENDLOOP.


  LOOP AT it_rcab INTO ls_rcab.

    CLEAR ls_t001z.
    READ TABLE gth_t001z INTO ls_t001z WITH TABLE KEY bukrs = ls_rcab-bukrs.

    CLEAR ls_t001.
    READ TABLE gth_t001 INTO ls_t001 WITH TABLE KEY bukrs = ls_rcab-bukrs.

    CLEAR ls_kna1.
    READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_rcab-lifnr.

    CLEAR ls_rtot.
    READ TABLE lt_rtot INTO ls_rtot WITH KEY bukrs = ls_rcab-bukrs
                                             crnumber = ls_rcab-crnumber.

    CLEAR ls_witem_pa.
    READ TABLE lts_witem_pa INTO ls_witem_pa INDEX 1.
    IF ls_witem_pa-qsatz IS INITIAL.                                                    "I-NTP-300616
      ls_witem_pa-qsatz = zconst-reten_per.                                             "I-NTP-300616
    ENDIF.                                                                              "I-NTP-300616

    CLEAR ls_hom23.
    READ TABLE gth_hom23 INTO ls_hom23 WITH TABLE KEY witht = ls_witem_pa-witht
                                                      wt_withcd = ls_witem_pa-wt_withcd.

    ls_cab-zztipdoc = '20'.
    ls_cab-bukrs    = ls_rcab-bukrs.
    ls_cab-lifnr    = ls_rcab-lifnr.

    ls_cab-zzeminro = ls_t001z-paval.
    ls_cab-zzemitpd_h = '6'.

    ls_cab-zzverubl = gs_consextsun-zz_verubl.      "Version del UBL
    ls_cab-zzverstr = gs_consextsun-zz_verestrdoc.  "Versión de la estructura del documento
    ls_cab-zzmotctg = ls_rcab-motctg.       "01: Motivo de Contigencia
    ls_cab-zzfecemi = ls_rcab-budat.        "04: Fecha de emisión del comprobante
    ls_cab-zzprvnro = ls_rcab-stcd1.        "05: Número de documento de identidad
    ls_cab-zzprvtpd_h = ls_kna1-stcdt.      "06: Tipo de docuento de identidad
    ls_cab-zzprvden = ls_rcab-name1.        "07: Apellidos y nombres y/o Razón social
*      CASE ls_witem_pa-wt_withcd.            "08: Régimen de Percepción
*        WHEN 'R8'.  ls_cab-zzretreg = '01'.
*      ENDCASE.
    ls_cab-zzretreg = ls_hom23-codsun.      "08: Régimen de Percepción
    ls_cab-zzrettas = ls_witem_pa-qsatz.    "09: Tasa de Retención
*      ls_cab-zzretitr = abs( ls_rtot-dmbtr ). "10: Importe Total Retenido
    ls_cab-zzretitr = abs( ls_rtot-wt_qbshh2 ). "10: Importe Total Retenido
*      ls_cab-zzretitp = abs( ls_rtot-wt_qsshh ). "11: Importe Total Cobrado
    ls_cab-zzretitp = abs( ls_rtot-dif_imp ).   "11: Importe Total Cobrado "Base - Retención ML
    ls_cab-zzretmnd = ls_t001-waers.        "17: Moneda de la retencion

    ls_cab-zzcreser = ls_rcab-crnumber(4).  "02: Serie del comprobante                    "crnumber = R0010000001
    ls_cab-zzcrecor = ls_rcab-crnumber+4.   "03: Número del comprobante
    CONCATENATE ls_cab-zzcreser ls_cab-zzcrecor INTO ls_cab-crnumber.                     "Nro Certificado
    CONCATENATE ls_cab-zzcreser abap_undefined ls_cab-zzcrecor INTO ls_cab-zznrosun.      "Nro Sunat R001-0000001

    APPEND ls_cab TO et_cab.

    CLEAR l_posnr.
    LOOP AT it_rdet INTO ls_rdet WHERE bukrs = ls_rcab-bukrs
                                   AND crnumber = ls_rcab-crnumber.

      ADD 1 TO l_posnr.

*        ls_refsunat-tipo  = ls_rdet-xblnr+0(2).   "E-NTP-010716
*        ls_refsunat-serie = ls_rdet-xblnr+4(4).   "E-NTP-010716
*        ls_refsunat-numro = ls_rdet-xblnr+9.      "E-NTP-010716
      SPLIT ls_rdet-xblnr AT abap_undefined     "I-NTP-010716
          INTO ls_refsunat-tipo                 "I-NTP-010716
               ls_refsunat-serie                "I-NTP-010716
               ls_refsunat-numro.               "I-NTP-010716
      SHIFT ls_refsunat-serie LEFT DELETING LEADING '0'.

      " Completar a 4 caracteres la Serie Sunat si es necesario
      l_length = STRLEN( ls_refsunat-serie ).
      IF l_length LT 4.
        DO.
          CONCATENATE '0' ls_refsunat-serie INTO ls_refsunat-serie.
          l_length = STRLEN( ls_refsunat-serie ).
          IF l_length EQ 4.
            EXIT.
          ENDIF.
        ENDDO.
      ENDIF.

      IF ls_rdet-waers <> ls_t001-waers.
*          l_importe = abs( ls_rdet-wt_qsshb ).
        l_importe = abs( ls_rdet-wt_qsshb2 ).
      ELSE.
*        l_importe = abs( ls_rdet-wt_qsshh ).
        l_importe = abs( ls_rdet-wt_qsshh2 ).
        ls_rdet-wt_qsshb = ls_rdet-wt_qsshh.      "MD no viene asignado
      ENDIF.

      ls_det-bukrs    = ls_rcab-bukrs.
      ls_det-crnumber = ls_cab-crnumber.
      ls_det-zznrosun = ls_cab-zznrosun.
      ls_det-posnr    = l_posnr.
      ls_det-zzcrltip = ls_refsunat-tipo.         "12: Tipo de doc relacionado
      ls_det-zzcrlser = ls_refsunat-serie.        "13: Serie de doc relacionado
      ls_det-zzcrlnro = ls_refsunat-numro.        "14: Número de doc relacionado
      ls_det-zzcrlfec = ls_rdet-bldat.            "15: Fecha de emisión del Doc relacionado
*      ls_det-zzcrlitd = abs( l_importe ).         "16: Importe Doc relacionado MD
      ls_det-zzcrlitd = abs( ls_rdet-wt_qsshb ).  "16: Importe Doc relacionado MD
      ls_det-zzcrlitl = abs( ls_rdet-wt_qsshh ).  "16: Importe Doc relacionado ML
      ls_det-zzcrlmnd = ls_rdet-waers.            "17: Moneda Doc relacionado
      ls_det-zzpagfec = ls_rdet-budat.            "18: Fecha de Pago
      ls_det-zzpagcor = l_posnr.                  "19: Número de Pago
*      ls_det-zzpagisr = abs( l_importe ).         "20: Importe de Pago MD - Nota de Credito
      ls_det-zzpagisr = abs( l_importe ).         "20: Importe de Pago MD - Nota de Credito
      ls_det-zzpagmnd = ls_rdet-waers.            "21: Moneda del Importe de Pago
*      ls_det-zzretire = abs( ls_rdet-dmbtr ).    "22: Importe Percibido "Retencion ML
      ls_det-zzretire = abs( ls_rdet-wt_qbshh2 ). "22: Importe Percibido "Retencion ML
      ls_det-zzretfer = ls_rdet-budat.            "23: Fecha de Pago
*      ls_det-zzretitp = abs( ls_rdet-dif_imp ).                      "24: Monto Neto a Pagar "Base - Retención ML
      ls_det-zzretitp = abs( ls_rdet-wt_qsshh2 - ls_rdet-wt_qbshh2 ). "24: Monto Neto a Pagar "Base - Retención ML
      ls_det-zzretmnd = ls_t001-waers.            "25: Moneda retencion ML

      "Notas de credito
      IF ls_det-zzcrltip = '07'.
        MULTIPLY ls_det-zzpagisr BY -1.
        MULTIPLY ls_det-zzretire BY -1.
        MULTIPLY ls_det-zzretitp BY -1.
      ENDIF.

      IF ls_rdet-waers NE ls_t001-waers.
        READ TABLE lth_bkpf INTO ls_bkpf WITH TABLE KEY bukrs = ls_rdet-bukrs
                                                        belnr = ls_rdet-belnr
                                                        gjahr = ls_rdet-gjahr.
        IF sy-subrc = 0.
          ls_det-zztpcmnd = ls_rdet-waers.    "25: Moneda extranjera de la referencia
*          ls_det-zztpcapl = ls_bkpf-kursf.   "26: Tipo de cambio aplicado
          ls_det-zztpcapl = ls_rdet-kursf.    "26: Tipo de cambio aplicado
          ls_det-zztpcfec = ls_bkpf-wwert.    "27: Fecha Tipo de cambio
        ENDIF.
      ELSE.
        ls_det-zztpcmnd = ls_t001-waers.      "25: Moneda local de la referencia
        ls_det-zztpcapl = '1.00000'.          "26: Tipo de cambio aplicado
        ls_det-zztpcfec = '00010101'.         "27: Fecha Tipo de cambio
      ENDIF.

      APPEND ls_det TO et_det.
      CLEAR ls_det.
    ENDLOOP.
  ENDLOOP.

  ENDMETHOD.


  METHOD set_data_ret_rev.

    DATA: ls_rdet   LIKE LINE OF it_rdet,
          ls_cab    LIKE LINE OF et_cab,
          ls_det    LIKE LINE OF et_det,

          lt_fecab  TYPE gtt_fertcab,
          ls_fecab  LIKE LINE OF lt_fecab,

          lth_bkpf1 TYPE gtth_bkpf_anul,
          lth_bkpf  TYPE gtth_bkpf_anul,
          ls_bkpf   LIKE LINE OF lth_bkpf,
          ls_bkpf1  LIKE LINE OF lth_bkpf1.

    DATA: l_fila    TYPE i,
          l_posnr   TYPE posnr_d.

* Obtener comprobante enviada a sunat
    SELECT *
      INTO TABLE lt_fecab
      FROM zostb_fertcab
      FOR ALL ENTRIES IN it_rcab
      WHERE crnumber = it_rcab-crnumber.

* Motivos de anulacion
    "Documentos anulados
    SELECT bukrs belnr gjahr stblg stjah stgrd
      INTO TABLE lth_bkpf
      FROM bkpf
      FOR ALL ENTRIES IN it_rdet
      WHERE bukrs = it_rdet-bukrs
        AND belnr = it_rdet-belnr
        AND gjahr = it_rdet-gjahr.
    IF sy-subrc = 0.

      "Documentos anulación
      SELECT bukrs belnr gjahr stblg stjah stgrd
        INTO TABLE lth_bkpf1
        FROM bkpf
        FOR ALL ENTRIES IN lth_bkpf
        WHERE bukrs = lth_bkpf-bukrs
          AND belnr = lth_bkpf-stblg
          AND gjahr = lth_bkpf-stjah.
    ENDIF.

* Construir Resumen de Reversión de Retención
* Cabecera
    READ TABLE lt_fecab INTO ls_fecab INDEX 1.
    IF sy-subrc = 0.
      ls_cab-bukrs    = ls_fecab-bukrs.
      ls_cab-zzidres  = get_last_ret_rev( ls_fecab-bukrs ).  "Identificador de Reversión
      ""      ls_cab-zzfecgen = sy-datum.
      ""      ls_cab-zzfecemi = ls_fecab-zzfecemi.
      ls_cab-zzfecgen = ls_fecab-zzfecemi.
      ls_cab-zzfecemi = sy-datum.
      ls_cab-zzeminro = ls_fecab-zzeminro.
      ls_cab-zzemitpd_h = ls_fecab-zzemitpd_h.
      ls_cab-zzverubl = ls_fecab-zzverubl.
      ls_cab-zzverstr = ls_fecab-zzverstr.
      APPEND ls_cab TO et_cab.
    ENDIF.


* Detalle
    LOOP AT lt_fecab INTO ls_fecab.
      ls_det-bukrs    = ls_cab-bukrs.
      ls_det-zzidres  = ls_cab-zzidres.
      ls_det-zztipdoc = ls_fecab-zztipdoc.

      "nro sunat
      SPLIT ls_fecab-zznrosun AT abap_undefined
        INTO ls_det-zzcrlser
             ls_det-zzcrlnro.

      "Detalle
      CLEAR l_posnr.
      LOOP AT it_rdet INTO ls_rdet WHERE crnumber = ls_fecab-crnumber.
        ADD 1 TO l_fila.
        ADD 1 TO l_posnr.
        ls_det-zznfila  = l_fila.  "Fila reversion del dia
        ls_det-posnr    = l_posnr.  "Posición del detalle


        "Motivo de anulacion
        "Documento anulado
        READ TABLE lth_bkpf INTO ls_bkpf
          WITH TABLE KEY bukrs = ls_rdet-bukrs
                         belnr = ls_rdet-belnr
                         gjahr = ls_rdet-gjahr.
        IF sy-subrc = 0.
          "Documento anulación
          READ TABLE lth_bkpf1 INTO ls_bkpf1
            WITH TABLE KEY bukrs = ls_bkpf-bukrs
                           belnr = ls_bkpf-stblg
                           gjahr = ls_bkpf-stjah.
          IF sy-subrc = 0.
            SELECT SINGLE txt40 INTO ls_det-zzmotanu
              FROM t041ct
              WHERE spras = sy-langu
                AND stgrd = ls_bkpf1-stgrd.
          ENDIF.
        ENDIF.

        APPEND ls_det TO et_det.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.


  METHOD set_homo_cli.

    DATA: ls_cab     LIKE LINE OF pi_cab,
          ls_kna1    TYPE gty_kna1,
          ls_dire    TYPE gty_direccion,
          ls_cliente LIKE LINE OF pe_cli.

*   Lectura de la Tabla lt_vbrk y creacion de Clientes
    LOOP AT pi_cab INTO ls_cab.

      ls_cliente-zzt_nrodocsap  = ls_cab-crnumber.
      ls_cliente-zzt_numeracion = ls_cab-crnumber.

      READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_cab-lifnr.
      IF sy-subrc = 0.
        "RUC
        ls_cliente-ruc = ls_cab-zzprvnro.

        READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_kna1-adrnr.
        IF sy-subrc = 0.
          "Telefono
          ls_cliente-telefono = ls_dire-tel_number.
          "Razon Social
          ls_cliente-razon_social = ls_dire-name.
          "Dirección
          CONCATENATE ls_dire-street
                      ls_dire-stnumb
                      ls_dire-str_suppl1
                      ls_dire-str_suppl2
                      ls_dire-str_suppl3
                      ls_dire-distri
                      ls_dire-provin
                      ls_dire-depart
                      INTO ls_cliente-direccion SEPARATED BY space.
          CONDENSE ls_cliente-direccion.
          TRANSLATE ls_cliente-direccion TO UPPER CASE.
          "Email
          SPLIT ls_dire-smtp_addr AT ';' INTO ls_cliente-email ls_dire-smtp_addr.
        ENDIF.
      ENDIF.

*     Adicionar registro
      APPEND ls_cliente TO pe_cli.
      CLEAR ls_cliente.
    ENDLOOP.

  ENDMETHOD.                    "set_cli


  METHOD set_homo_ret.

    DATA: ls_hom06 TYPE zostb_catahomo06.

    FIELD-SYMBOLS: <fs_cab> LIKE LINE OF ct_cab.

    "Procesamiento
    LOOP AT ct_cab ASSIGNING <fs_cab>.

      "Cliente - Tipo de documento de identidad
      READ TABLE gth_hom06 INTO ls_hom06 WITH TABLE KEY stcdt = <fs_cab>-zzprvtpd_h.
      IF sy-subrc = 0.
        <fs_cab>-zzprvtpd_h = ls_hom06-zz_codigo_sunat.
      ELSE.
        CLEAR <fs_cab>-zzprvtpd_h.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD set_homo_ret_rev.

*  DATA: ls_cat06 TYPE zostb_catalogo06,
*
*        ls_hom06 TYPE zostb_catahomo06.
*
*  FIELD-SYMBOLS: <fs_cab> like LINE OF ct_cab.
*
*  "Procesamiento
*  LOOP AT ct_cab ASSIGNING <fs_cab>.
*
*    "Cliente - Tipo de documento de identidad
*    READ TABLE gth_hom06 INTO ls_hom06 WITH TABLE KEY stcdt = <fs_cab>-zzprvtpd_h.
*    IF sy-subrc = 0.
*      READ TABLE gth_cat06 INTO ls_cat06 WITH TABLE KEY zz_codigo_sunat = ls_hom06-zz_codigo_sunat.
*      IF sy-subrc = 0.
*        <fs_cab>-zzprvtpd_h = ls_cat06-zz_codigo_sunat.
*      ENDIF.
*    ELSE.
*      CLEAR <fs_cab>-zzprvtpd_h.
*    ENDIF.
*
*  ENDLOOP.

  ENDMETHOD.


  METHOD set_json_cli.

    DATA: ls_cliente LIKE LINE OF pi_cli,
          ls_fecli   LIKE LINE OF pe_cli_json.

    LOOP AT pi_cli INTO ls_cliente.
      CLEAR ls_fecli.
      ls_fecli-zzt_nrodocsap  = ls_cliente-zzt_nrodocsap.
      ls_fecli-zzt_numeracion = ls_cliente-zzt_numeracion.
      ls_fecli-ruc            = ls_cliente-ruc.
      ls_fecli-razon_social   = ls_cliente-razon_social.
      ls_fecli-direccion      = ls_cliente-direccion.
      ls_fecli-telefono       = ls_cliente-telefono.
      ls_fecli-email          = ls_cliente-email.
      APPEND ls_fecli TO pe_cli_json.
    ENDLOOP.

  ENDMETHOD.


METHOD set_json_ret.

  DATA: ls_cab      LIKE LINE OF it_cab,
        ls_det      LIKE LINE OF it_det,
        ls_cab_json LIKE LINE OF et_cab_json,
        ls_det_json LIKE LINE OF et_det_json,

        ls_t001     TYPE t001,
        ls_kna1     TYPE gty_kna1,
        ls_dire     TYPE gty_direccion,
        ls_dire_buk TYPE gty_direccion,
        ls_tcurt    TYPE zostb_tcurt.

  DATA: l_zzretitr TYPE string, "char20,                                            "+020123-NTP-3000020724
        l_zzretitp TYPE string, "char20,                                            "+020123-NTP-3000020724
        l_zzrettas TYPE string, "char20,                                            "+020123-NTP-3000020724
        l_zzcrlitd TYPE string, "char20,                                            "+020123-NTP-3000020724
        l_zzcrlitl TYPE string, "char20,                                            "+020123-NTP-3000020724
        l_zzpagisr TYPE string, "char20,                                            "+020123-NTP-3000020724
        l_zzretire TYPE string. "char20.                                            "+020123-NTP-3000020724


  LOOP AT it_cab INTO ls_cab.

    MOVE-CORRESPONDING ls_cab TO ls_cab_json.

*   Preparar montos
    l_zzretitr = abs( ls_cab-zzretitr ). CONDENSE l_zzretitr.
    l_zzretitp = abs( ls_cab-zzretitp ). CONDENSE l_zzretitp.
    l_zzrettas = abs( ls_cab-zzrettas ). CONDENSE l_zzrettas.

    IF ls_cab-zzretitr IS INITIAL. CLEAR l_zzretitr. ENDIF.  "IF l_zzretitr = '0.0' "+020123-NTP-3000020724
    IF ls_cab-zzretitp IS INITIAL. CLEAR l_zzretitp. ENDIF.  "IF l_zzretitp = '0.0' "+020123-NTP-3000020724

    "Monto en letras
    get_text_monto( EXPORTING i_waers = ls_cab-zzretmnd
                              i_bldat = ls_cab-zzfecemi
                              i_monto = ls_cab-zzretitr
                    IMPORTING e_text  = ls_cab_json-zzretitr_t ).


*   Descripción de catalogos SUNAT
*   Armar Json
    "Emisor - Sociedad
    CLEAR ls_dire_buk.
    READ TABLE gth_t001 INTO ls_t001 WITH TABLE KEY bukrs = ls_cab-bukrs.
    IF sy-subrc = 0.
      READ TABLE gth_dire INTO ls_dire_buk WITH TABLE KEY adrnr = ls_t001-adrnr.
    ENDIF.
    CONCATENATE '{"0":"' ls_cab-zzeminro '",' '"1":"' ls_cab-zzemitpd_h '"}' INTO ls_cab_json-zzeminro.
    CONCATENATE '{"0":"' gs_consextsun-zz_ubigeo '",'
                 '"1":"' gs_consextsun-zz_direccion '",'
                 '"2":"' gs_consextsun-zz_urbanizacion '",'
                 '"3":"' gs_consextsun-zz_distrito '",'
                 '"4":"' gs_consextsun-zz_provincia '",'
                 '"5":"' gs_consextsun-zz_departamento '",'
                 '"6":"' gs_consextsun-zz_pais '"}' INTO ls_cab_json-zzemidir.
    CONCATENATE '{"0":"' ls_dire_buk-tel_number '",' '"1":"' ls_dire_buk-fax_number '"}' INTO ls_cab_json-zzemitel.
*{  BEGIN OF REPLACE WMR-040816-3000005346
    ""      ls_cab_json-zzemiden = gs_consextsun-zz_ncomercial.
    CONCATENATE ls_dire_buk-name1 ls_dire_buk-name2 INTO ls_cab_json-zzemiden SEPARATED BY space.
*}  END OF REPLACE WMR-040816-3000005346

    "Cliente
    CLEAR ls_dire.
    READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_cab-lifnr.
    IF sy-subrc = 0.
      READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_kna1-adrnr.
    ENDIF.
    CONCATENATE '{"0":"' ls_cab-zzprvnro '",' '"1":"' ls_cab-zzprvtpd_h '"}' INTO ls_cab_json-zzprvnro.
    CONCATENATE '{"0":"' ls_dire-ubigeo '",'
                 '"1":"' ls_dire-street '",'
*                   '"2":"' ls_dire-str_suppl1 '",'       "E-NTP-080616
*                   '"2":"''",'                           "I-NTP-080616           "E-NTP161117-3000008613
                 '"2":"' ls_dire-str_suppl1 '",'        "I-NTP161117-3000008613
                 '"3":"' ls_dire-distri '",'
                 '"4":"' ls_dire-provin '",'
                 '"5":"' ls_dire-depart '",'
                 '"6":"' ls_dire-pais '"}' INTO ls_cab_json-zzprvdir.

    "Montos
    CONCATENATE '{"0":"' ls_cab-zzretreg '",' '"1":"' l_zzrettas '"}' INTO ls_cab_json-zzretreg. "Percepción Regimen y Tasa
    CONCATENATE '{"0":"' l_zzretitr '",' '"1":"' ls_cab-zzretmnd '"}' INTO ls_cab_json-zzretitr. "Importe total retenido
    CONCATENATE '{"0":"' l_zzretitr '",' '"1":"' ls_cab_json-zzretitr_t '"}' INTO ls_cab_json-zzretitr_t. "Importe total retenido en letras
    CONCATENATE '{"0":"' l_zzretitp '",' '"1":"' ls_cab-zzretmnd '"}' INTO ls_cab_json-zzretitp. "Importe total cobrado

    " Tipo de Moneda
    CLEAR ls_tcurt.
    LOOP AT gt_tcurt INTO ls_tcurt WHERE waers EQ ls_cab-zzretmnd
                                     AND begda LE ls_cab-zzfecemi
                                     AND endda GE ls_cab-zzfecemi.
      EXIT.
    ENDLOOP.
    CONCATENATE '{"0":"' ls_tcurt-waers '","1":"' ls_tcurt-nomsun '","2":"' ls_tcurt-sigmon '"}' INTO ls_cab_json-zzretmnd.

    APPEND ls_cab_json TO et_cab_json.
    CLEAR ls_cab_json.
  ENDLOOP.



  LOOP AT it_det INTO ls_det.
    MOVE-CORRESPONDING ls_det TO ls_det_json.

*   Preparar montos
    l_zzcrlitd = abs( ls_det-zzcrlitd ). CONDENSE l_zzcrlitd.
    l_zzcrlitl = abs( ls_det-zzcrlitl ). CONDENSE l_zzcrlitl.
    l_zzpagisr = abs( ls_det-zzpagisr ). CONDENSE l_zzpagisr.
    l_zzretire = abs( ls_det-zzretire ). CONDENSE l_zzretire.
    l_zzretitp = abs( ls_det-zzretitp ). CONDENSE l_zzretitp.

    IF ls_det-zzcrlitd IS INITIAL. CLEAR l_zzcrlitd. ENDIF.  "IF l_zzcrlitd = '0.0' "+020123-NTP-3000020724
    IF ls_det-zzcrlitl IS INITIAL. CLEAR l_zzcrlitl. ENDIF.  "IF l_zzcrlitl = '0.0' "+020123-NTP-3000020724
    IF ls_det-zzpagisr IS INITIAL. CLEAR l_zzpagisr. ENDIF.  "IF l_zzpagisr = '0.0' "+020123-NTP-3000020724
    IF ls_det-zzretire IS INITIAL. CLEAR l_zzretire. ENDIF.  "IF l_zzretire = '0.0' "+020123-NTP-3000020724
    IF ls_det-zzretitp IS INITIAL. CLEAR l_zzretitp. ENDIF.  "IF l_zzretitp = '0.0' "+020123-NTP-3000020724


    CONCATENATE '{"0":"' ls_det-zzcrltip '",' '"1":"' ls_det-zzcrlser '-' ls_det-zzcrlnro '"}' INTO ls_det_json-zzcrlnro. "Tipo y Serie y Numero
    CONCATENATE '{"0":"' l_zzcrlitd '",' '"1":"' ls_det-zzcrlmnd '",' '"2":"' l_zzcrlitl '"}'  INTO ls_det_json-zzcrlitd. "Relacionado Importe Y Moneda
    CONCATENATE '{"0":"' l_zzpagisr '",' '"1":"' ls_det-zzpagmnd '"}' INTO ls_det_json-zzpagisr. "Cobro Importe Y Moneda
    CONCATENATE '{"0":"' l_zzretire '",' '"1":"' ls_det-zzretmnd '"}' INTO ls_det_json-zzretire. "Cobro Importe Y Moneda
    CONCATENATE '{"0":"' l_zzretitp '",' '"1":"' ls_det-zzretmnd '"}' INTO ls_det_json-zzretitp. "Cobro Importe Y Moneda
    CONCATENATE '{"0":"' ls_det-zztpcmnd '",' '"1":"' ls_det-zzretmnd '"}' INTO ls_det_json-zztpcmnd. "Moneda Tipo de cambio

    APPEND ls_det_json TO et_det_json.
    CLEAR ls_det_json.
  ENDLOOP.

ENDMETHOD.


  METHOD set_json_ret_rev.

    DATA: ls_cab      LIKE LINE OF it_cab,
          ls_det      LIKE LINE OF it_det,
          ls_cab_json LIKE LINE OF et_cab_json,
          ls_det_json LIKE LINE OF et_det_json,
*{  BEGIN OF INSERT WMR-040816-3000005346
          ls_t001     TYPE t001,
          ls_dire     TYPE gty_direccion.
*}  END OF INSERT WMR-040816-3000005346


    LOOP AT it_cab INTO ls_cab.
      MOVE-CORRESPONDING ls_cab TO ls_cab_json.

      CONCATENATE '{"0":"' ls_cab_json-zzeminro   '",'
                  '"1":"'  ls_cab_json-zzemitpd_h '"}' INTO ls_cab_json-zzeminro.
*{  BEGIN OF REPLACE WMR-040816-3000005346
      ""      ls_cab_json-zzemiden = gs_consextsun-zz_ncomercial.
      READ TABLE gth_t001 INTO ls_t001 WITH TABLE KEY bukrs = ls_cab-bukrs.
      IF sy-subrc = 0.
        READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_t001-adrnr.
        IF sy-subrc EQ 0.
          CONCATENATE ls_dire-name1 ls_dire-name2 INTO ls_cab_json-zzemiden SEPARATED BY space.
        ENDIF.
      ENDIF.
*}  END OF REPLACE WMR-040816-3000005346

      APPEND ls_cab_json TO et_cab_json.
      CLEAR ls_cab_json.
    ENDLOOP.


    LOOP AT it_det INTO ls_det.
      MOVE-CORRESPONDING ls_det TO ls_det_json.

      APPEND ls_det_json TO et_det_json.
      CLEAR ls_det_json.
    ENDLOOP.

  ENDMETHOD.


  METHOD sy_to_ret.

    MOVE: sy-msgv1 TO rs_return-message_v1,
          sy-msgv2 TO rs_return-message_v2,
          sy-msgv3 TO rs_return-message_v3,
          sy-msgv4 TO rs_return-message_v4,
          sy-msgid TO rs_return-id,
          sy-msgno TO rs_return-number,
          sy-msgty TO rs_return-type,
          i_row    TO rs_return-row.

  ENDMETHOD.


  method UPD_IDENTI_RET_REV.

    DATA: lt_log TYPE TABLE OF zostb_cplog,
          ls_cab LIKE LINE OF it_cab.

    FIELD-SYMBOLS: <fs_log> LIKE LINE OF lt_log.

*   Obtener Percepciones registrados
    SELECT *
      FROM zostb_cplog
      INTO TABLE lt_log
      FOR ALL ENTRIES IN it_rcab
      WHERE bukrs = it_rcab-bukrs
        AND zzt_nrodocsap = it_rcab-crnumber.

    CHECK sy-subrc = 0.


*   Actualizar identificador
    READ TABLE it_cab INTO ls_cab INDEX 1.

    LOOP AT lt_log ASSIGNING <fs_log>.
      <fs_log>-zzt_identifibaja = ls_cab-zzidres.
    ENDLOOP.


*   Actualizar DB
    MODIFY zostb_cplog FROM TABLE lt_log.

  endmethod.


  METHOD upd_tabla_ret.

*{  BEGIN OF INSERT WMR-160816-3000005346
    DATA: ls_cab LIKE LINE OF it_cab.

    READ TABLE it_cab INTO ls_cab INDEX 1.
    IF sy-subrc EQ 0.
      DELETE FROM zostb_fertcab WHERE bukrs    EQ ls_cab-bukrs
                                  AND crnumber EQ ls_cab-crnumber
                                  AND zznrosun EQ ls_cab-zznrosun.

      DELETE FROM zostb_fertdet WHERE bukrs    EQ ls_cab-bukrs
                                  AND crnumber EQ ls_cab-crnumber
                                  AND zznrosun EQ ls_cab-zznrosun.
    ENDIF.
*}  END OF INSERT WMR-160816-3000005346

    MODIFY zostb_fertcab FROM TABLE it_cab.
    MODIFY zostb_fertdet FROM TABLE it_det.
    MODIFY zostb_fecli FROM TABLE it_cli.

  ENDMETHOD.


  METHOD upd_tabla_ret_rev.

    MODIFY zostb_rertcab FROM TABLE it_cab.
    MODIFY zostb_rertdet FROM TABLE it_det.

  ENDMETHOD.
ENDCLASS.
