*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_PRMONITOR_SEL
*&---------------------------------------------------------------------*

SELECTION-SCREEN : BEGIN OF BLOCK b01 WITH FRAME TITLE text-t01.
PARAMETERS: p_bukrs TYPE t001-bukrs OBLIGATORY MEMORY ID buk.
SELECT-OPTIONS: s_idres FOR zostb_rertcab-zzidres,
                s_fecha FOR zostb_rertcab-zzfecgen.
SELECTION-SCREEN : END OF BLOCK b01.
