*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_RBMONITOR_SEL
*&---------------------------------------------------------------------*

*&--------------------------------------------------------------------&*
*&            S E L E C T I O N - S C R E E N                         &*
*&--------------------------------------------------------------------&*
SELECTION-SCREEN : BEGIN OF BLOCK b01 WITH FRAME TITLE text-t01.
*{  BEGIN OF INSERT WMR-200715
PARAMETERS: p_bukrs  TYPE t001-bukrs OBLIGATORY MEMORY ID buk.
*}  END OF INSERT WMR-200715
SELECT-OPTIONS: s_idres FOR zostb_rbcab-zz_identifiresu,
                s_fecha FOR zostb_rbcab-zz_fecgenresume.
SELECTION-SCREEN : END OF BLOCK b01.
