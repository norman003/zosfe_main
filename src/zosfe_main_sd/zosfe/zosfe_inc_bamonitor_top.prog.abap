*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_BAMONITOR_TOP
*&---------------------------------------------------------------------*

*&--------------------------------------------------------------------&*
*&         T A B L A S   T R A N S P A R E N T E S                    &*
*&--------------------------------------------------------------------&*
 TABLES: zostb_bacab.

 TYPE-POOLS: abap, slis.        "I-NTP-130716
*&--------------------------------------------------------------------&*
*&                 C O N S T A N T E S                                &*
*&--------------------------------------------------------------------&*

 CONSTANTS: gc_semaf_rojo(4) TYPE c VALUE '@0A@',
            gc_semaf_verd(4) TYPE c VALUE '@08@',
            gc_semaf_amar(4) TYPE c VALUE '@09@',
            gc_semaf_gris(4) TYPE c VALUE '@EB@' ##NEEDED.

 CONSTANTS: gc_tabname TYPE tabname VALUE 'ZOSES_BAMONITOR'.

 CONSTANTS: gc_mod TYPE zostb_const_fe-modulo     VALUE 'FE',
            gc_apl TYPE zostb_const_fe-aplicacion VALUE 'EXTRACTOR'.

*&--------------------------------------------------------------------&*
*&         T A B L A S   I N T E R N A S    G L O B A L E S           &*
*&--------------------------------------------------------------------&*

 DATA: gt_reporte TYPE TABLE OF zoses_bamonitor,
       gt_balog   TYPE TABLE OF zostb_balog,
       gt_bacab   TYPE TABLE OF zostb_bacab,
       gt_badet   TYPE TABLE OF zostb_badet ##NEEDED.

 DATA: gt_const TYPE TABLE OF zostb_const_fe,
       gs_const LIKE LINE OF  gt_const.
*&--------------------------------------------------------------------&*
*&                F I E L D   -   S Y M B O L S                       &*
*&--------------------------------------------------------------------&*

 FIELD-SYMBOLS: <fs_reporte> TYPE zoses_bamonitor,
                <fs_balog>   TYPE zostb_balog,
                <fs_bacab>   TYPE zostb_bacab,
                <fs_badet>   TYPE zostb_badet ##NEEDED.


*&--------------------------------------------------------------------&*
*&                V A R I A B L E S  -  G L O B A L E S               &*
*&--------------------------------------------------------------------&*
 DATA: gw_fecfac_d TYPE n LENGTH 2,
       gw_error    TYPE char01.                                               "I-WMR-130319-3000010823
