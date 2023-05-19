*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_RESUM_REVERS_PR_MAI
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM get_cons.
  PERFORM chk_date.
  CHECK   g_subrc = 0.
  PERFORM pro_data.
  PERFORM sho_log.
