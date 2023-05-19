*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_JSON_MAI
*&---------------------------------------------------------------------*

START-OF-SELECTION.

  CASE p_prefix.
    WHEN 'GR'.
      PERFORM build_guia_remision.
    WHEN 'PR'.
      PERFORM build_percepcion.
    WHEN 'RT'.
      PERFORM build_retencion.
    WHEN 'RP'.
      PERFORM build_rev_percepcion.
    WHEN 'RR'.
      PERFORM build_rev_retencion.
  ENDCASE.

  CALL SCREEN 100.
