*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_PROC_DOCSNOELECT_SEL
*&---------------------------------------------------------------------*
DATA  ls_parsel   TYPE  ty_parsel.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE text-b01.
PARAMETER:
                p_bukrs   TYPE t001-bukrs MEMORY ID buk.
SELECT-OPTIONS:
                s_vbeln   FOR  ls_parsel-vbeln,
                s_fkdat   FOR  ls_parsel-fkdat.
SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE text-b02.
PARAMETERS:
  p_chkfac AS CHECKBOX DEFAULT 'X',
  p_chkbol AS CHECKBOX,
  p_chknc  AS CHECKBOX,
  p_chknd  AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK b02.
