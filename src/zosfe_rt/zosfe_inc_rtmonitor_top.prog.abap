*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_PRMONITOR_TOP
*&---------------------------------------------------------------------*
*&--------------------------------------------------------------------&*
*&         T A B L A S   T R A N S P A R E N T E S                    &*
*&--------------------------------------------------------------------&*

 TABLES: zostb_cplog.
 TYPE-POOLS: abap, slis.
*&--------------------------------------------------------------------&*
*&                 C O N S T A N T E S                                &*
*&--------------------------------------------------------------------&*

 CONSTANTS: gc_semaf_rojo(4) TYPE c VALUE '@0A@',
            gc_semaf_verd(4) TYPE c VALUE '@08@',
            gc_semaf_amar(4) TYPE c VALUE '@09@',
            gc_semaf_gris(4) TYPE c VALUE '@EB@'.

 CONSTANTS: gc_status_0 TYPE zosed_status_cdr VALUE '0',
            gc_status_5 TYPE zosed_status_cdr VALUE '5',
            gc_status_6 TYPE zosed_status_cdr VALUE '6',
            gc_status_7 TYPE zosed_status_cdr VALUE '7',
            gc_status_8 TYPE zosed_status_cdr VALUE '8',
            gc_status_9 TYPE zosed_status_cdr VALUE '9'.                "I-WMR-040717-3000006468

 CONSTANTS: gc_prefix_rt TYPE char02 VALUE 'RT'.

*&--------------------------------------------------------------------&*
*&         T A B L A S   I N T E R N A S    G L O B A L E S           &*
*&--------------------------------------------------------------------&*

 DATA: gt_reporte    TYPE TABLE OF zoses_cpmonitor,
       gt_cplog      TYPE TABLE OF zostb_cplog,
       gt_fertcab    TYPE HASHED TABLE OF zostb_fertcab WITH UNIQUE KEY crnumber zznrosun.

*&--------------------------------------------------------------------&*
*&                F I E L D   -   S Y M B O L S                       &*
*&--------------------------------------------------------------------&*

 FIELD-SYMBOLS: <fs_reporte>    LIKE LINE OF gt_reporte,
                <fs_cplog>      TYPE zostb_cplog.
