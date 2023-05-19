*&---------------------------------------------------------------------*
*&  Include           ZOSSD_INC_IDCP_PRINT_TOP
*&---------------------------------------------------------------------*

DATA: BEGIN OF zamp,
        is_edicion      TYPE xfeld,
        is_sociedad     TYPE xfeld,
        is_ampl_active  TYPE xfeld,
      END OF zamp,
      BEGIN OF zconst,
        f_activ TYPE sy-datum,
      END OF zconst.
