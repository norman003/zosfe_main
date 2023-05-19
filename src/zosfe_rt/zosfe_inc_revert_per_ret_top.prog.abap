*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_RESUM_REVERS_PR_TOP
*&---------------------------------------------------------------------*

TYPE-POOLS: abap, slis.
*--------------------------------------------------------------------*
*	CONSTANTES
*--------------------------------------------------------------------*
CONSTANTS:
  gc_modul TYPE zosge_modulo     VALUE 'FE',
  gc_aplic TYPE zosge_aplicacion VALUE 'EXTRACTOR'.

DATA: BEGIN OF zconst,
        fecrepr TYPE i, "date,
        fecrert TYPE i, "date,
      END OF zconst.

*--------------------------------------------------------------------*
*	TABLAS GLOBAL
*--------------------------------------------------------------------*
DATA: gt_return TYPE bapirettab.

*--------------------------------------------------------------------*
*	VARIABLES
*--------------------------------------------------------------------*
DATA: g_subrc TYPE sy-subrc.
