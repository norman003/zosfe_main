*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_FEREPROCESO_TOP
*&---------------------------------------------------------------------*

*&--------------------------------------------------------------------&*
*&         T A B L A S   I N T E R N A S    G L O B A L E S           &*
*&--------------------------------------------------------------------&*

DATA: gt_fecab    TYPE                   zostt_fecab ##NEEDED,
      gt_fecab2   TYPE                   zostt_fecab2 ##NEEDED,
      gt_fedet    TYPE                   zostt_fedet ##NEEDED,
      gt_fecli    TYPE                   zostt_fecli ##NEEDED,
      gt_headtext TYPE                  zostt_docexpostc ##NEEDED,         "I-WMR-230615
      gt_message  TYPE TABLE OF          bapiret2,
      gt_cosnt    TYPE STANDARD TABLE OF zostb_const_fe.

DATA: gs_const LIKE LINE OF gt_cosnt.

*** Definiciones para el proceso de servicio web PRD
**DATA: inputfc TYPE zosws_wsosfc_documentos_reque2,
**      inputbl TYPE zosws_wsosbl_documentos_reque2,
**      inputnc TYPE zosws_wsosnc_documentos_reque2,
**      inputnd TYPE zosws_wsosnd_documentos_reque2.
**
*** Definiciones para el proceso de servicio web TEST
**DATA: inputfc_1 TYPE zosws_wsosfc_documentos_reques,
**      inputbl_1 TYPE zosws_wsosbl_documentos_reques,
**      inputnc_1 TYPE zosws_wsosnc_documentos_reques,
**      inputnd_1 TYPE zosws_wsosnd_documentos_reques.
**
*** Definiciones para el proceso de servicio web HOMOLOGACION
**DATA: inputfc_2 TYPE zosws_wsosfc_documentos_reque1,
**      inputbl_2 TYPE zosws_wsosbl_documentos_reque1,
**      inputnc_2 TYPE zosws_wsosnc_documentos_reque1,
**      inputnd_2 TYPE zosws_wsosnd_documentos_reque1.

*{BEGIN OF EXCLUDE NTP-060616
** Definiciones para el proceso de servicio web PRD
*DATA: inputfc TYPE zosfe_wsosfc_documentos_reques,
*      inputbl TYPE zosfe_wsosbl_documentos_reques,
*      inputnc TYPE zosfe_wsosnc_documentos_reques,
*      inputnd TYPE zosfe_wsosnd_documentos_reques.
*
** Definiciones para el proceso de servicio web TEST
*DATA: inputfc_1 TYPE zosfe_wsosfc_documentos_reques,
*      inputbl_1 TYPE zosfe_wsosbl_documentos_reques,
*      inputnc_1 TYPE zosfe_wsosnc_documentos_reques,
*      inputnd_1 TYPE zosfe_wsosnd_documentos_reques.
*
** Definiciones para el proceso de servicio web HOMOLOGACION
*DATA: inputfc_2 TYPE zosfe_wsosfc_documentos_reques,
*      inputbl_2 TYPE zosfe_wsosbl_documentos_reques,
*      inputnc_2 TYPE zosfe_wsosnc_documentos_reques,
*      inputnd_2 TYPE zosfe_wsosnd_documentos_reques.
*}END OF EXCLUDE NTP-060616

*&--------------------------------------------------------------------&*
*&                F I E L D   -   S Y M B O L S                       &*
*&--------------------------------------------------------------------&*

FIELD-SYMBOLS: <fs_fecab> TYPE zostb_fecab ##NEEDED,
               <fs_fedet> TYPE zostb_fedet ##NEEDED,
               <fs_fecli> TYPE zostb_fecli ##NEEDED.

*&--------------------------------------------------------------------&*
*&               O B J E T O S   G L O B A L E S                      &*
*&--------------------------------------------------------------------&*

DATA: cl_extfac TYPE REF TO zossdcl_pro_extrac_fe,
      go_gr     TYPE REF TO object.                                             "I-3000011085-NTP190219

*&--------------------------------------------------------------------&*
*&                 C O N S T A N T E S                                &*
*&--------------------------------------------------------------------&*

CONSTANTS: gc_tipdoc_fa TYPE char2 VALUE '01',
           gc_tipdoc_bl TYPE char2 VALUE '03',
           gc_tipdoc_nc TYPE char2 VALUE '07',
           gc_tipdoc_nd TYPE char2 VALUE '08'.

CONSTANTS: gc_status_0 TYPE zosed_status_cdr VALUE '0',
           gc_status_2 TYPE zosed_status_cdr VALUE '2',                 "+@001
           gc_status_5 TYPE zosed_status_cdr VALUE '5',
           gc_status_6 TYPE zosed_status_cdr VALUE '6',
           gc_status_7 TYPE zosed_status_cdr VALUE '7',
           gc_mandt    TYPE sy-mandt         VALUE '400' ##NEEDED,
           gc_modul    TYPE zostb_const_fe-modulo     VALUE 'FE',
           gc_aplic    TYPE zostb_const_fe-aplicacion VALUE 'EXTRACTOR',
           gc_progr    TYPE zostb_const_fe-programa   VALUE 'ZOSSD_PRO_EXTRAC',
           gc_classname_gr TYPE string VALUE 'ZOSSDCL_PRO_EXTRAC_FE_GR',          "I-3000011085-NTP190219
           gc_classname_fe TYPE string VALUE 'ZOSSDCL_PRO_EXTRAC_FE'.             "+NTP010523-3000020188

*&--------------------------------------------------------------------&*
*&             V A R I A B L E S   G L O B A L E S                    &*
*&--------------------------------------------------------------------&*

DATA: gw_numeraci   TYPE char12 ##NEEDED,
      gs_constantes TYPE zostb_consextsun ##NEEDED,
      gw_error      TYPE char1 ##NEEDED,
      gw_nrodocsap  TYPE zostb_felog-zzt_nrodocsap ##NEEDED,
      gw_inicio     TYPE c ##NEEDED.
*{  BEGIN OF INSERT WMR-030615
DATA: gw_system    TYPE syst-host ##NEEDED,
      gw_test_act  TYPE xfeld ##NEEDED, " Indicador Sistema Test activo
*}  END OF INSERT WMR-030615
*{  BEGIN OF INSERT WMR-270715
      gw_mandt_prd TYPE symandt ##NEEDED. " Mandante Productivo Real
*}  END OF INSERT WMR-270715

DATA: gw_vbeln TYPE zosed_nrodocsap ##NEEDED,
      gw_xblnr TYPE zosed_numeracion ##NEEDED.

DATA: gr_user TYPE RANGE OF sy-uname,
      rs_user LIKE LINE OF  gr_user ##NEEDED.

DATA: p_error     TYPE char01.
