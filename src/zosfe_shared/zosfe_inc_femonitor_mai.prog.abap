*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_FEMONITOR_MAI
*&---------------------------------------------------------------------*

*&--------------------------------------------------------------------&*
*&                E V E N T O S  S C R E E N                          &*
*&--------------------------------------------------------------------&*
AT SELECTION-SCREEN OUTPUT.
  PERFORM modifyscreen.   "I-NTP130717-3000006468

*&--------------------------------------------------------------------&*
*&                I N I T I A L I Z A T I O N                         &*
*&--------------------------------------------------------------------&*
INITIALIZATION.
  PERFORM get_const.

*&--------------------------------------------------------------------&*
*&          S T A R T  -  O F  -  S E L E C T I O N                   &*
*&--------------------------------------------------------------------&*
START-OF-SELECTION.
  PERFORM checks.                                                             "I-WMR-130319-3000010823
  PERFORM get_data.
  PERFORM set_data.
  PERFORM sho_data.
