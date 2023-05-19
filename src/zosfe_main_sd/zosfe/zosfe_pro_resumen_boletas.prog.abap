*************************************************************************
*                         INFORMACION GENERAL
*************************************************************************
* Programa...: ZOSFE_PRO_RESUMEN_BOLETAS
* Tipo.......: Proceso
* Módulo.....: SD
* Descripción: Resumen de Boletas - Facturación Electrónica
* Autor......: Omnia Solution
* Fecha......:
* Transacción: ZOSFE002
*************************************************************************
REPORT zosfe_pro_resumen_boletas.

DATA: gw_error TYPE char01.                                                   "I-WMR-130319-3000010823

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE text-b01.
PARAMETERS: p_bukrs  TYPE t001-bukrs OBLIGATORY MEMORY ID buk,
            p_fecgen TYPE datum,
            p_chkrep AS CHECKBOX DEFAULT ' '.
SELECTION-SCREEN END OF BLOCK b01.

START-OF-SELECTION.
*{  BEGIN OF INSERT WMR-130319-3000010823
  gw_error = abap_off.
  " Validar Autorización
  zosclpell_libros_legales=>_authority_check_f_bkpf_buk(
    EXPORTING  i_bukrs = p_bukrs
    EXCEPTIONS error   = 1
               OTHERS  = 2 ).
  IF sy-subrc <> 0.
    gw_error = abap_on.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  CHECK gw_error = abap_off.
*}  END OF INSERT WMR-130319-3000010823
  SUBMIT zosfe_pro_extrac_fe
    WITH p_bukrs  EQ p_bukrs
    WITH p_fecfac EQ p_fecgen
    WITH p_cladoc EQ 'R'
    WITH p_chkrep EQ p_chkrep
    AND RETURN. "#EC CI_SUBMIT
