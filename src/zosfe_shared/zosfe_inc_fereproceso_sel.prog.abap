*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_FEREPROCESO_SEL
*&---------------------------------------------------------------------*

*&--------------------------------------------------------------------&*
*&            S E L E C T I O N - S C R E E N                         &*
*&--------------------------------------------------------------------&*
SELECTION-SCREEN : BEGIN OF BLOCK b00 WITH FRAME TITLE text-t00.
PARAMETERS: p_opcfa RADIOBUTTON GROUP g1 DEFAULT 'X',
            p_opcbl RADIOBUTTON GROUP g1,
            p_opcnc RADIOBUTTON GROUP g1,
            p_opcnd RADIOBUTTON GROUP g1,
*{  BEGIN OF INSERT WMR-140116
            p_opcgr RADIOBUTTON GROUP g1.
*}  END OF INSERT WMR-140116
PARAMETERS: p_facpor TYPE xfeld NO-DISPLAY. "Facturas por procesar   "I-NTP110717-3000006468
PARAMETERS: p_synsta TYPE char01 NO-DISPLAY. "Sinc status sap a web   "I-NTP110717-3000006468
SELECTION-SCREEN : END OF BLOCK b00.

SELECTION-SCREEN : BEGIN OF BLOCK b01 WITH FRAME TITLE text-t01.
PARAMETERS: p_docsap TYPE zosed_nrodocsap OBLIGATORY,
            p_numera TYPE zosed_numeracion OBLIGATORY.
SELECTION-SCREEN : END OF BLOCK b01.
