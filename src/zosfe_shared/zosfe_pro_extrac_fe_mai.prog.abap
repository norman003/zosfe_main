*&---------------------------------------------------------------------*
*&  Include           ZOSFE_PRO_EXTRAC_FE_MAI
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&                    I N I T I A L I Z A T I O N
*&---------------------------------------------------------------------*
INITIALIZATION.
  PERFORM carga_constantes.
  PERFORM create_objects.

*&---------------------------------------------------------------------*
*&                S T A R T - O F - S E L E C T I O N
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM check_authority CHANGING gv_error.                                  "I-WMR-130319-3000010823
  CHECK gv_error IS INITIAL.                                                  "I-WMR-130319-3000010823
*{  BEGIN OF INSERT WMR-071116-3000005897
  PERFORM check_proc CHANGING gv_error. " Verificar que Facturación Electrónica se encuentre activa para la Sociedad
  CHECK gv_error IS INITIAL.
*}  END OF INSERT WMR-071116-3000005897
*  PERFORM check_date CHANGING gv_error."Valida que la fecha este entre los 7 dia "E-3000011744-NTP300419
  CHECK gv_error IS INITIAL.
  PERFORM reproceso CHANGING gv_error. "Reproceso Bajas y Resumen
  CHECK gv_error IS INITIAL.
  PERFORM get_data CHANGING gv_error.  "Ejecuta extractores
  CHECK gv_error IS INITIAL.
  PERFORM show_log.                    "Muestra log
