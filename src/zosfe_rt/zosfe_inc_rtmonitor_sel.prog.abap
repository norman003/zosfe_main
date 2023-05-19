*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_PRMONITOR_SEL
*&---------------------------------------------------------------------*

SELECTION-SCREEN : BEGIN OF BLOCK b01 WITH FRAME TITLE text-t01.
PARAMETERS: p_bukrs TYPE t001-bukrs OBLIGATORY MEMORY ID buk.
SELECT-OPTIONS: s_cnumb FOR zostb_cplog-zzt_nrodocsap,
                s_fecha FOR zostb_cplog-zzt_fcreacion.
SELECTION-SCREEN : END OF BLOCK b01.
