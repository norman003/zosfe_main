*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_FEREPROCESO_MAI
*&---------------------------------------------------------------------*

*&--------------------------------------------------------------------&*
*&                I N I T I A L I Z A T I O N                         &*
*&--------------------------------------------------------------------&*
INITIALIZATION.
  PERFORM get_const.
  PERFORM create_objects.

*&--------------------------------------------------------------------&*
*&          S T A R T  -  O F  -  S E L E C T I O N                   &*
*&--------------------------------------------------------------------&*
START-OF-SELECTION.

*  PERFORM get_data CHANGING gw_error.
*  CHECK gw_error IS INITIAL.
*  PERFORM rep_data.
*  PERFORM show_log.
  gw_error = abap_off.                                                        "I-WMR-130319-3000010823
  PERFORM reproceso.
