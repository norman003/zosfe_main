*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_RBMONITOR_MAI
*&---------------------------------------------------------------------*
INITIALIZATION.
  PERFORM get_constantes.

*&--------------------------------------------------------------------&*
*&          S T A R T  -  O F  -  S E L E C T I O N                   &*
*&--------------------------------------------------------------------&*
START-OF-SELECTION.
  PERFORM checks.                                                             "I-WMR-130319-3000010823
  PERFORM get_data.
  PERFORM set_data.
  PERFORM sho_data.
