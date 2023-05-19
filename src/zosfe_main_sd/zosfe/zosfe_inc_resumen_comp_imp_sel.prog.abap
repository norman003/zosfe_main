*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_RESUMEN_COMP_IMP_SEL
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&                   S E L E C T I O N - S C R E E N
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE text-b01.
PARAMETERS: p_bukrs TYPE vbrk-bukrs OBLIGATORY MEMORY ID buk.
PARAMETERS: p_fkdat TYPE vbrk-fkdat.
SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN BEGIN OF SCREEN 200 TITLE text-b02
                                     AS WINDOW.
PARAMETERS: p_path1 TYPE string.
SELECTION-SCREEN END OF SCREEN 200.


*&---------------------------------------------------------------------*
*&               A T   S E L E C T I O N - S C R E E N
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_path1.
  PERFORM f4_ruta USING p_path1.
