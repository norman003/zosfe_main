*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_RESUM_REVERS_PR_SEL
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE text-t01.
PARAMETERS: p_bukrs TYPE bukrs MEMORY ID buk OBLIGATORY,
            p_fecha TYPE datum.
PARAMETERS: p_reten RADIOBUTTON GROUP r1,
            p_perce RADIOBUTTON GROUP r1.
SELECTION-SCREEN END OF BLOCK b01.
