*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_PRMONITOR_TOP
*&---------------------------------------------------------------------*
*&--------------------------------------------------------------------&*
*&         T A B L A S   T R A N S P A R E N T E S                    &*
*&--------------------------------------------------------------------&*

 TABLES: zostb_rertcab.
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
            gc_status_7 TYPE zosed_status_cdr VALUE '7'.

 CONSTANTS: gc_mod TYPE zosed_modulo     VALUE 'FE',
            gc_apl TYPE zosed_aplicacion VALUE 'EXTRACTOR'.

 CONSTANTS: gc_prefix_rr TYPE char02 VALUE 'RR'.

  DATA: BEGIN OF zconst,
          fecfac_d TYPE datum,
        END OF zconst.

*&--------------------------------------------------------------------&*
*&         T A B L A S   I N T E R N A S    G L O B A L E S           &*
*&--------------------------------------------------------------------&*

 DATA: gt_reporte    TYPE TABLE OF zoses_rertmonitor,
       gt_rertcab    TYPE HASHED TABLE OF zostb_rertcab WITH UNIQUE KEY zzidres,
       gt_log        TYPE TABLE OF zostb_rertlog.

*&--------------------------------------------------------------------&*
*&                F I E L D   -   S Y M B O L S                       &*
*&--------------------------------------------------------------------&*

 FIELD-SYMBOLS: <fs_reporte>  TYPE zoses_reprmonitor,
                <fs_log>      TYPE zostb_rertlog.
