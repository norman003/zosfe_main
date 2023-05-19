FUNCTION-POOL ZOSGF_IDCP.                   "MESSAGE-ID ..

* INCLUDE LZOSGF_IDCPD...                    " Local class definition

TABLES: vbrk,
        likp.                                                  "I-WMR-071116-3000005897

*&--------------------------------------------------------------------&*
*&          T I P O S    T A B L A S   G L O B A L E S                &*
*&--------------------------------------------------------------------&*

TYPES: BEGIN OF gty_vbeln,
         sign(1),
         option(2),
         low       TYPE vbrk-vbeln,
         high      TYPE vbrk-vbeln,
       END OF gty_vbeln,

       BEGIN OF lty_docexposca.
        INCLUDE TYPE zoses_docexposca.

TYPES: END OF lty_docexposca,
BEGIN OF lty_docexposde.
        INCLUDE TYPE zoses_docexposde.

TYPES: END OF lty_docexposde,
BEGIN OF lty_docexposcl.
        INCLUDE TYPE zoses_docexposcl.

TYPES: END OF lty_docexposcl,
BEGIN OF lty_constantes.
        INCLUDE TYPE zostb_consextsun.
TYPES: END OF lty_constantes.

TYPES: BEGIN OF lty_lineas,
         linea TYPE string,
       END OF lty_lineas,

       BEGIN OF lty_t003i,
         blart  TYPE  t003_i-blart,
         doccls TYPE  t003_i-blart,
         fkart  TYPE  tvfk-fkart,
       END OF lty_t003i.

TYPES: BEGIN OF ty_sunat,                                     "I-WMR-270815
         tipo  TYPE string,                                   "I-WMR-270815
         serie TYPE string,                                   "I-WMR-270815
         numro TYPE string,                                   "I-WMR-270815
       END OF ty_sunat.                                       "I-WMR-270815

*&--------------------------------------------------------------------&*
*&                 C O N S T A N T E S                                &*
*&--------------------------------------------------------------------&*

CONSTANTS: gc_tipdoc_fa TYPE doccls VALUE '01',
           gc_tipdoc_bl TYPE doccls VALUE '03',
*{  BEGIN OF INSERT WMR-130416
           gc_tipdoc_gr TYPE doccls VALUE '09',
           gc_vl02n     TYPE tcode  VALUE 'VL02N',
*}  END OF INSERT WMR-130416
*{  BEGIN OF INSERT WMR-160615
           gc_peru      TYPE t005-land1 VALUE 'PE'.
*}  END OF INSERT WMR-160615

CONSTANTS: gc_charf TYPE char1  VALUE 'F',
           gc_charb TYPE char1  VALUE 'B',
*{  BEGIN OF INSERT WMR-130416
           gc_chart TYPE char1  VALUE 'T'.
*}  END OF INSERT WMR-130416

CONSTANTS: gc_mod  TYPE zostb_const_fe-modulo     VALUE 'FE',
           gc_apl  TYPE zostb_const_fe-aplicacion VALUE 'EXTRACTOR',
           gc_prg  TYPE zostb_const_fe-programa   VALUE 'ZOSSD_EXPORTA_FACT_SUNAT',
           gc_cam  TYPE zostb_const_fe-campo      VALUE 'FKART',
           gc_cama TYPE zostb_const_fe-campo      VALUE 'FKART_A'.

*&--------------------------------------------------------------------&*
*&                         R A N G O S                                &*
*&--------------------------------------------------------------------&*

DATA: gr_fkart_anu TYPE RANGE OF vbrk-fkart,
      gr_fkart_not TYPE RANGE OF vbrk-fkart,
*{  BEGIN OF INSERT WMR-030615
      gr_augru_mde TYPE RANGE OF vbak-augru,
*}  END OF INSERT WMR-030615
      gr_motsref   TYPE RANGE OF zostb_catahomo10-zz_codigo_sunat.      "I-WMR-261118-3000009765

*&--------------------------------------------------------------------&*
*&             V A R I A B L E S   G L O B A L E S                    &*
*&--------------------------------------------------------------------&*

DATA: gs_vbrk         TYPE vbrk,
      gs_vbrk_ref     TYPE vbrk,
      gs_vbak_solncnd TYPE vbak,                              "I-WMR-270815
      gs_likp         TYPE likp.                              "I-WMR-140116

DATA: gw_fecfac_d TYPE n LENGTH 2.
*{  BEGIN OF INSERT WMR-030615
DATA: gw_system    TYPE syst-host,
      gw_test_act  TYPE xfeld, " Indicador Sistema Test activo
*}  END OF INSERT WMR-030615
*{  BEGIN OF INSERT WMR-270715
      gw_mandt_prd TYPE symandt, " Mandante Productivo Real
*}  END OF INSERT WMR-270715
*{  BEGIN OF INSERT WMR-111116-3000005346
      gw_license   TYPE string.  "  Nro. Instalación Sap
*}  END OF INSERT WMR-111116-3000005346
