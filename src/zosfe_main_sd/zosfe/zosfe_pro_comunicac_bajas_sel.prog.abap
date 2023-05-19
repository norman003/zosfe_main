*&---------------------------------------------------------------------*
*&  Include           ZOSFE_PRO_COMUNICAC_BAJAS_SEL
*&---------------------------------------------------------------------*
**********************************************************************
* PANTALLA PRINCIPAL
**********************************************************************
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE text-b01.
PARAMETERS: p_bukrs  TYPE t001-bukrs OBLIGATORY MEMORY ID buk,
            p_fecem  TYPE datum OBLIGATORY,
            p_chkrep AS CHECKBOX DEFAULT ' ',
            p_getffo AS CHECKBOX DEFAULT ' ',                           "I-WMR-070417-3000007034
            p_baj_gr AS CHECKBOX DEFAULT ' '.                           "+NTP010523-3000020188
SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN:FUNCTION KEY 1.              "I-WMR-281016-3000005971

**********************************************************************
* AT SELECTION-SCREEN OUTPUT
**********************************************************************
AT SELECTION-SCREEN OUTPUT.
  PERFORM ocultar_campos.

**********************************************************************
* AT SELECTION-SCREEN
**********************************************************************
AT SELECTION-SCREEN.
  PERFORM sscrfields_ucomm.
