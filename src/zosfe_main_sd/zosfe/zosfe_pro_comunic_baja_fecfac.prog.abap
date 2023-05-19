*************************************************************************
*                         INFORMACION GENERAL
*************************************************************************
* Programa...: ZOSFE_PRO_COMUNICACION_BAJAS
* Tipo.......: Proceso
* Módulo.....: SD
* Descripción: Comunicación de Bajas - Facturación Electrónica
* Autor......: Omnia Solution
* Fecha......:
* Transacción: ZOSFE003
*************************************************************************
REPORT zosfe_pro_comunic_baja_fecfac.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE text-b01.
PARAMETERS: p_bukrs  TYPE t001-bukrs OBLIGATORY MEMORY ID buk,
            p_fecem  TYPE datum,
            p_chkrep TYPE c DEFAULT '' NO-DISPLAY.
SELECTION-SCREEN END OF BLOCK b01.

START-OF-SELECTION.
  SUBMIT zosfe_pro_extrac_fe
    WITH p_bukrs  EQ p_bukrs
    WITH p_fecfac EQ p_fecem
    WITH p_cladoc EQ 'J'
    WITH p_chkrep EQ p_chkrep
*{  BEGIN OF INSERT WMR-281016-3000005971
    WITH p_getfdo EQ abap_true
*}  END OF INSERT WMR-281016-3000005971
    AND RETURN.
