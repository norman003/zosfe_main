*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_RESUMEN_COMP_IMP_PBO
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STAT_0100'.
  SET TITLEBAR  'TITU_0100'.

  PERFORM alv_display.

ENDMODULE.
