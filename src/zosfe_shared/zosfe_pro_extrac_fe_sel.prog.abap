*&---------------------------------------------------------------------*
*&  Include           ZOSFE_PRO_EXTRAC_FE_SEL
*&---------------------------------------------------------------------*

*&--------------------------------------------------------------------&*
*&            S E L E C T I O N - S C R E E N                         &*
*&--------------------------------------------------------------------&*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
*{  BEGIN OF INSERT WMR-200715
PARAMETERS: p_bukrs  TYPE t001-bukrs OBLIGATORY.
*}  END OF INSERT WMR-200715
PARAMETERS: p_fecfac TYPE datum OBLIGATORY.  "Fecha de Factura
*{  BEGIN OF INSERT WMR-150715
PARAMETERS: p_cladoc TYPE char01,                   " Clase documento
            p_chkrep AS CHECKBOX,                   " Reproceso
*}  END OF INSERT WMR-150715
*{  BEGIN OF INSERT WMR-281016-3000005971
            p_getfdo AS CHECKBOX DEFAULT ' ',                           "I-WMR-070417-3000007034
            p_getffo AS CHECKBOX DEFAULT ' '.                           "I-WMR-070417-3000007034
*}  END OF INSERT WMR-281016-3000005971
SELECTION-SCREEN END OF BLOCK b1.

*&--------------------------------------------------------------------&*
*&   A T   S E L E C T I O N  -  S C R E E N   O U T   P U T          &*
*&--------------------------------------------------------------------&*
AT SELECTION-SCREEN OUTPUT.
  PERFORM set_textparam.
