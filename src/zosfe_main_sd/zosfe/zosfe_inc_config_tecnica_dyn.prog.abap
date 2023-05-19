*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_CONFIG_TECNICA_DYN
*&---------------------------------------------------------------------*

MODULE status_0100 OUTPUT.

  SET PF-STATUS 'STAT_0100'.
  SET TITLEBAR  'TITU_0100'.

  CLEAR gw_okcode.

ENDMODULE.


MODULE user_command_0100 INPUT.

  PERFORM user_command_0100.

ENDMODULE.


MODULE exit INPUT.

  SET SCREEN 0.
  LEAVE SCREEN.

ENDMODULE.
