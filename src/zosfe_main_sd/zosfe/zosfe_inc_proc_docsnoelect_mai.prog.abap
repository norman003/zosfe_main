*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_PROC_DOCSNOELECT_MAI
*&---------------------------------------------------------------------*
INITIALIZATION.
  PERFORM obtener_constantes.

START-OF-SELECTION.
  CLEAR gw_proc.
  PERFORM validacion.
  PERFORM obtener_facturas.
  PERFORM mostrar_facturas.
