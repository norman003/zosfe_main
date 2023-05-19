*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_RBMONITOR_TOP
*&---------------------------------------------------------------------*

*&--------------------------------------------------------------------&*
*&         T A B L A S   T R A N S P A R E N T E S                    &*
*&--------------------------------------------------------------------&*

 TABLES: zostb_rbcab.
 TYPE-POOLS: abap, slis.
*&--------------------------------------------------------------------&*
*&                 C O N S T A N T E S                                &*
*&--------------------------------------------------------------------&*

 CONSTANTS: gc_semaf_rojo(4) TYPE c VALUE '@0A@',
            gc_semaf_verd(4) TYPE c VALUE '@08@',
            gc_semaf_amar(4) TYPE c VALUE '@09@',
            gc_semaf_gris(4) TYPE c VALUE '@EB@' ##NEEDED.

 CONSTANTS: gc_tabname TYPE tabname VALUE 'ZOSES_RBMONITOR'.

 CONSTANTS: gc_mod TYPE zostb_const_fe-modulo     VALUE 'FE',
            gc_apl TYPE zostb_const_fe-aplicacion VALUE 'EXTRACTOR',
            gc_prefix_rb TYPE char02     VALUE 'RB',                    "I-WMR-080118-3000008865
            gc_version_1 TYPE char02     VALUE '01',                    "I-WMR-080118-3000008865
            gc_version_2 TYPE char02     VALUE '02'.                    "I-WMR-080118-3000008865

*&--------------------------------------------------------------------&*
*&         T A B L A S   I N T E R N A S    G L O B A L E S           &*
*&--------------------------------------------------------------------&*

 DATA: gt_reporte TYPE TABLE OF zoses_rbmonitor,
       gt_rblog   TYPE TABLE OF zostb_rblog,
       gt_rbcab   TYPE TABLE OF zostb_rbcab,
       gt_rbdet   TYPE TABLE OF zostb_rbdet ##NEEDED.

 DATA: gt_const TYPE TABLE OF zostb_const_fe,
       gs_const LIKE LINE OF  gt_const.
*&--------------------------------------------------------------------&*
*&                F I E L D   -   S Y M B O L S                       &*
*&--------------------------------------------------------------------&*

 FIELD-SYMBOLS: <fs_reporte> TYPE zoses_rbmonitor,
                <fs_rblog>   TYPE zostb_rblog,
                <fs_rbcab>   TYPE zostb_rbcab,
                <fs_rbdet>   TYPE zostb_rbdet ##NEEDED.

*&--------------------------------------------------------------------&*
*&                V A R I A B L E S  -  G L O B A L E S               &*
*&--------------------------------------------------------------------&*
 DATA: gw_fecfac_d TYPE n LENGTH 2,
       gw_error    TYPE char01.                                               "I-WMR-130319-3000010823
