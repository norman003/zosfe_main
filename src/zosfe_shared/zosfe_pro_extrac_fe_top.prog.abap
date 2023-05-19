*&---------------------------------------------------------------------*
*&  Include           ZOSFE_PRO_EXTRAC_FE_TOP
*&---------------------------------------------------------------------*

*&--------------------------------------------------------------------&*
*&         T A B L A S   T R A N S P A R E N T E S                    &*
*&--------------------------------------------------------------------&*

TABLES: vbrk ##NEEDED,
        vbpa ##NEEDED.

*&--------------------------------------------------------------------&*
*&                  T Y P E - P O O L S                               &*
*&--------------------------------------------------------------------&*

TYPE-POOLS: truxs.

*&--------------------------------------------------------------------&*
*&                 T I P O S   G L O B A L E S                        &*
*&--------------------------------------------------------------------&*

TYPES: BEGIN OF gty_fecfac,
         sign(1),
         option(2),
         low  TYPE vbrk-fkdat,
         high TYPE vbrk-fkdat,
       END OF gty_fecfac,

       BEGIN OF gty_vbeln ##NEEDED,
         sign(1),
         option(2),
         low  TYPE vbrk-vbeln,
         high TYPE vbrk-vbeln,
       END OF gty_vbeln,

       BEGIN OF gty_numeracion ##NEEDED,
         sign(1),
         option(2),
         low  TYPE c LENGTH 13,
         high TYPE c LENGTH 13,
       END OF gty_numeracion,

*{  BEGIN OF INSERT WMR-011215
       BEGIN OF ty_constants,
         fecres   TYPE int4,
         fecbaj   TYPE int4,
       END OF ty_constants.
*}  END OF INSERT WMR-011215

*&--------------------------------------------------------------------&*
*&         T A B L A S   I N T E R N A S    G L O B A L E S           &*
*&--------------------------------------------------------------------&*

DATA: gt_fecfac       TYPE TABLE OF gty_fecfac ##NEEDED,
      gt_message      TYPE bapiret2tab.

*&--------------------------------------------------------------------&*
*&             V A R I A B L E S   G L O B A L E S                    &*
*&--------------------------------------------------------------------&*

DATA: gv_error        TYPE char01,
      gv_clasdoc      TYPE char01,
      gv_repro        TYPE char01,
*{  BEGIN OF INSERT WMR-011215
      gs_constants    TYPE ty_constants.
*}  END OF INSERT WMR-011215

*&--------------------------------------------------------------------&*
*&               O B J E T O S   G L O B A L E S                      &*
*&--------------------------------------------------------------------&*

DATA: cl_extfac       TYPE REF TO zossdcl_pro_extrac_fe.

*&--------------------------------------------------------------------&*
*&                 C O N S T A N T E S                                &*
*&--------------------------------------------------------------------&*

CONSTANTS: gc_tran_r       TYPE sy-tcode VALUE 'ZSDOS031' ##NEEDED,
           gc_tran_b       TYPE sy-tcode VALUE 'ZSDOS032' ##NEEDED,
           gc_status_cdr_0 TYPE zosed_status_cdr VALUE '0',
           gc_status_cdr_5 TYPE zosed_status_cdr VALUE '5',
           gc_status_cdr_6 TYPE zosed_status_cdr VALUE '6',
           gc_status_cdr_7 TYPE zosed_status_cdr VALUE '7',
*{  BEGIN OF INSERT WMR-011215
           gc_modul        TYPE zostb_const_fe-modulo     VALUE 'FE',
           gc_aplic        TYPE zostb_const_fe-aplicacion VALUE 'EXTRACTOR',
           gc_classname_fe TYPE string VALUE 'ZOSSDCL_PRO_EXTRAC_FE',         "+NTP010523-3000020188
           gc_classname_gr TYPE string VALUE 'ZOSSDCL_PRO_EXTRAC_FE_GR'.      "+NTP010523-3000020188
*}  END OF INSERT WMR-011215

*&--------------------------------------------------------------------&*
*&                            R A N G O S                             &*
*&--------------------------------------------------------------------&*

DATA: gr_status TYPE RANGE OF zosed_status_cdr,
      rs_status LIKE LINE OF gr_status.
