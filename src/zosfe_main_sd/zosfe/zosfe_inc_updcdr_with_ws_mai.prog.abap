*&---------------------------------------------------------------------*
*&  Include           ZOSSD_INC_UPDCDR_WITH_WS_MAI
*&---------------------------------------------------------------------*
INITIALIZATION.
  PERFORM obtener_constantes.

START-OF-SELECTION.
  IF  p_single EQ abap_false
  AND p_resbol EQ abap_false
  AND p_combaj EQ abap_false
  AND p_resrev EQ abap_false.                                           "I-WMR-230419-3000010823
    MESSAGE text-e03 TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  CLEAR gw_error.
  PERFORM obtener_datos.

  CHECK gw_error NE gc_chare.

  CASE abap_true.
    WHEN p_previe.
      PERFORM mostrar_datos.

    WHEN p_submit.
      PERFORM pf_syncronize USING gt_felog.

    WHEN OTHERS.
      PERFORM pf_syncronize USING gt_felog.
      PERFORM mostrar_datos.
  ENDCASE.
