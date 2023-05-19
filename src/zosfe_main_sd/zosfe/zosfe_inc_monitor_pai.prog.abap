*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_MONITOR_PAI
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'BT_DOC'.
      SUBMIT zosfe_rpt_femonitor VIA SELECTION-SCREEN AND RETURN. "#EC CI_SUBMIT
    WHEN 'BT_RES'.
      SUBMIT zosfe_rpt_rbmonitor VIA SELECTION-SCREEN AND RETURN. "#EC CI_SUBMIT
    WHEN 'BT_BAJ'.
      SUBMIT zosfe_rpt_bamonitor VIA SELECTION-SCREEN AND RETURN. "#EC CI_SUBMIT
    WHEN 'BACK' OR 'CANC' OR 'EXIT'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.                 " USER_COMMAND_0100  INPUT
