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
    WHEN 'BT_PR'.
      SUBMIT zosfe_rpt_prmonitor VIA SELECTION-SCREEN AND RETURN.
    WHEN 'BT_RT'.
      SUBMIT zosfe_rpt_rtmonitor VIA SELECTION-SCREEN AND RETURN.
    WHEN 'BT_PR_REV'.
      SUBMIT zosfe_rpt_prmonitor_rev VIA SELECTION-SCREEN AND RETURN.
    WHEN 'BT_RT_REV'.
      SUBMIT zosfe_rpt_rtmonitor_rev VIA SELECTION-SCREEN AND RETURN.
    WHEN 'BACK' OR 'CANC' OR 'EXIT'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.                 " USER_COMMAND_0100  INPUT
