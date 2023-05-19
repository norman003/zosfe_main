*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_FEMONITOR_TOP
*&---------------------------------------------------------------------*

*&--------------------------------------------------------------------&*
*&         T A B L A S   T R A N S P A R E N T E S                    &*
*&--------------------------------------------------------------------&*

* TABLES: zostb_felog. "-NTP010423-3000020188
 TYPE-POOLS: abap, slis.

*&--------------------------------------------------------------------&*
*&                 T I P O S                                          &*
*&--------------------------------------------------------------------&*
*{I-NTP040717-3000006468
 TYPES: BEGIN OF gty_vbrk,
          vbeln TYPE vbrk-vbeln,
          awkey TYPE bkpf-awkey,
          fkart TYPE vbrk-fkart,
          vbtyp TYPE vbrk-vbtyp,
          fkdat TYPE vbrk-fkdat,
          xblnr TYPE vbrk-xblnr,
          bukrs TYPE vbrk-bukrs,

          zzt_tipodoc    TYPE zoses_femonitor-zzt_tipodoc,  "I-3000012593-NTP-031219
          zzt_nombreraz  TYPE zoses_femonitor-zzt_nombreraz,  "I-3000012593-NTP-031219
        END OF gty_vbrk,

        BEGIN OF gty_bkpf,
          bukrs TYPE bkpf-bukrs,
          belnr TYPE bkpf-belnr,
          gjahr TYPE bkpf-gjahr,
          awkey TYPE bkpf-awkey,
        END OF gty_bkpf,

        BEGIN OF gty_vbfa,
          vbelv   TYPE vbfa-vbelv,
          posnv   TYPE vbfa-posnv,
          vbeln   TYPE vbfa-vbeln,
          posnn   TYPE vbfa-posnn,
          vbtyp_n TYPE vbfa-vbtyp_n,
          vbtyp_v TYPE vbfa-vbtyp_v,
        END OF gty_vbfa,

        BEGIN OF gty_t003_i,
          blart  TYPE t003_i-blart,
          doccls TYPE t003_i-doccls,
          fkart  TYPE tvfk-fkart,
        END OF gty_t003_i.
*}I-NTP040717-3000006468
*{I-3000013020-NTP-211119
 TYPES: BEGIN OF gty_likp,
          vbeln          TYPE likp-vbeln,
          vkorg          TYPE likp-vkorg,
          tddat          TYPE likp-tddat,
          vbtyp          TYPE likp-vbtyp,
          wadat_ist      TYPE likp-wadat_ist,
          xblnr          TYPE likp-xblnr,

          bukrs          TYPE bkpf-bukrs,
          lotno          TYPE string,
          del            TYPE xfeld,

          zzt_femision   TYPE zoses_femonitor-zzt_femision,
          zzt_nombreraz  TYPE zoses_femonitor-zzt_nombreraz,
          zzt_numeracion TYPE zostb_felog-zzt_numeracion,
        END OF gty_likp,
        gtt_likp TYPE TABLE OF gty_likp WITH DEFAULT KEY.
*}I-3000013020-NTP-211119

*&--------------------------------------------------------------------&*
*&                 C O N S T A N T E S                                &*
*&--------------------------------------------------------------------&*

 CONSTANTS: gc_semaf_rojo(4) TYPE c VALUE '@0A@',
            gc_semaf_verd(4) TYPE c VALUE '@08@',
            gc_semaf_amar(4) TYPE c VALUE '@09@',
            gc_semaf_gris(4) TYPE c VALUE '@EB@'.

 CONSTANTS: gc_status_0 TYPE zosed_status_cdr VALUE '0',
            gc_status_1 TYPE zosed_status_cdr VALUE '1',
            gc_status_2 TYPE zosed_status_cdr VALUE '2',                "+@001
            gc_status_3 TYPE zosed_status_cdr VALUE '3',
            gc_status_4 TYPE zosed_status_cdr VALUE '4',
            gc_status_5 TYPE zosed_status_cdr VALUE '5',
            gc_status_6 TYPE zosed_status_cdr VALUE '6',
            gc_status_7 TYPE zosed_status_cdr VALUE '7',
            gc_status_8 TYPE zosed_status_cdr VALUE '8',
            gc_status_9 TYPE zosed_status_cdr VALUE '9'.                "I-WMR-040717-3000006468

 CONSTANTS: gc_tabname TYPE tabname VALUE 'ZOSES_FEMONITOR'.

*{  BEGIN OF REPLACE WMR-140617-3000007486
 "" CONSTANTS: gc_mod TYPE zosed_modulo     VALUE 'SD',
 ""            gc_apl TYPE zosed_aplicacion VALUE 'EXTRACTOR'.

 CONSTANTS: gc_modul TYPE zostb_const_fe-modulo     VALUE 'FE',
            gc_aplic TYPE zostb_const_fe-aplicacion VALUE 'EXTRACTOR',
            gc_progr TYPE zostb_const_fe-programa   VALUE 'ZOSSD_PRO_EXTRAC'.
*}  END OF REPLACE WMR-140617-3000007486

*{  BEGIN OF INSERT WMR-140116
 CONSTANTS: gc_tipdoc_fa TYPE doccls   VALUE '01',
            gc_tipdoc_bl TYPE doccls   VALUE '03',
            gc_tipdoc_nc TYPE doccls   VALUE '07',
            gc_tipdoc_nd TYPE doccls   VALUE '08',
            gc_tipdoc_gr TYPE doccls   VALUE '09'.
*}  END OF INSERT WMR-140116

 CONSTANTS: gc_prefix_gr TYPE char02 VALUE 'GR',
            gc_extrac_fi TYPE string VALUE 'ZOSFICL_PRO_EXTRAC_FE',     "I-WMR-190619-3000012056
            gc_extrac_gr TYPE string VALUE 'ZOSSDCL_PRO_EXTRAC_FE_GR'.  "I-WMR-14092020-3000014557

 CONSTANTS: gc_peru       TYPE t003_i-land1 VALUE 'PE',                  "I-NTP050717-3000006468
            gc_bolivia    TYPE t001-land1   VALUE 'BO',                  "I-WMR-12122020-3000014829
            gc_xblnr_cero TYPE xblnr VALUE '0000000000000000'.          "I-NTP050717-3000006468

*----------------------------------------------------------------------*
*	Tipos de tablas
*----------------------------------------------------------------------*
 TYPES: gtt_reporte TYPE TABLE OF zoses_femonitor.        "I-NTP131218-3000009651

*&--------------------------------------------------------------------&*
*&         T A B L A S   I N T E R N A S    G L O B A L E S           &*
*&--------------------------------------------------------------------&*

 DATA: gt_reporte       TYPE gtt_reporte,
       gt_felog         TYPE TABLE OF zostb_felog,
       gt_vbrk          TYPE TABLE OF gty_vbrk,            "I-NTP040717-3000006468
       gt_likp_procesar TYPE TABLE OF gty_likp,            "I-3000013020-NTP-211119
       gt_t003_i        TYPE TABLE OF gty_t003_i,          "I-NTP050717-3000006468
       gt_zt003_i       TYPE TABLE OF zostb_t003_i,        "I-NTP050717-3000006468
       gt_docexposca    TYPE TABLE OF zostb_docexposca,
       gt_docexposde    TYPE TABLE OF zostb_docexposde ##NEEDED,
*{  BEGIN OF INSERT WMR-140116
       gt_fegrcab       TYPE HASHED TABLE OF zostb_fegrcab WITH UNIQUE KEY zznrosap zzgjahr zznrosun,
*}  END OF INSERT WMR-140116
       gt_likp          TYPE HASHED TABLE OF likp                          "I-WMR-051018-3000010624
                     WITH UNIQUE KEY vbeln.                             "I-WMR-051018-3000010624

 DATA: gt_const TYPE TABLE OF zostb_const_fe,
       gs_const LIKE LINE OF  gt_const,
       gs_t001  TYPE t001.                                                    "I-WMR-12122020-3000014829

 DATA: BEGIN OF gs_process,                                                   "I-WMR-14092020-3000014557
        active_gr     TYPE xfeld,                                             "I-WMR-14092020-3000014557
        active_fi     TYPE xfeld,                                             "I-WMR-14092020-3000014557
        active_grz    TYPE xfeld,                                             "+NTP010523-3000020188
       END OF gs_process.                                                     "I-WMR-14092020-3000014557

*&--------------------------------------------------------------------&*
*&                F I E L D   -   S Y M B O L S                       &*
*&--------------------------------------------------------------------&*

 FIELD-SYMBOLS: <fs_reporte>    TYPE zoses_femonitor,
                <fs_felog>      TYPE zostb_felog,
                <fs_docexposca> TYPE zostb_docexposca,
                <fs_docexposde> TYPE zostb_docexposde ##NEEDED.


*&--------------------------------------------------------------------&*
*&                V A R I A B L E S  -  G L O B A L E S               &*
*&--------------------------------------------------------------------&*
 DATA: gw_fecfac_d TYPE n LENGTH 2 ##NEEDED,
       gw_license  TYPE string,
       gw_error    TYPE char01.                                               "I-WMR-130319-3000010823
