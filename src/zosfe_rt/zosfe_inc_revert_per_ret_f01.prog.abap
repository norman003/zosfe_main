*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_RESUM_REVERS_PR_F01
*&---------------------------------------------------------------------*

FORM get_cons.

  DATA: lt_const TYPE TABLE OF zostb_const_fe,
        ls_const TYPE zostb_const_fe.

  SELECT * INTO TABLE lt_const
    FROM zostb_const_fe
    WHERE modulo = gc_modul
      AND aplicacion = gc_aplic.

  LOOP AT lt_const INTO ls_const.
    CASE ls_const-campo.
      WHEN 'FECREV'.
        zconst-fecrepr = ls_const-valor1.
        zconst-fecrert = ls_const-valor1.
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP.

ENDFORM.

FORM chk_date.

  DATA: l_fecmax TYPE i,  "date,
        l_fecgen TYPE i.  "date.

  CASE abap_on.
    WHEN p_perce. l_fecmax = zconst-fecrepr.
    WHEN p_reten. l_fecmax = zconst-fecrert.
    WHEN OTHERS.
  ENDCASE.

  l_fecgen = sy-datum - p_fecha.
  IF l_fecgen GT l_fecmax.
    g_subrc = 1.
    MESSAGE s000 WITH text-e01 l_fecmax text-e02.
  ENDIF.

ENDFORM.

FORM pro_data.

  DATA: "lo_perce TYPE REF TO zossdcl_pro_extrac_fe_pr,
        lo_reten TYPE REF TO zossdcl_pro_extrac_fe_rt.

  CASE abap_on.
      "Percepción
    WHEN p_perce.
*      CREATE OBJECT lo_perce.
*
*      lo_perce->extrae_data_percepcion_rev(
*        EXPORTING
*          i_bukrs    = p_bukrs
*          i_fecha    = p_fecha
*        IMPORTING
*          et_return  = gt_return
*        EXCEPTIONS
*          error      = 1
*      ).

      "Retención
    WHEN p_reten.
      CREATE OBJECT lo_reten.

      lo_reten->extrae_data_retencion_rev(
        EXPORTING
          i_bukrs    = p_bukrs
          i_fecha    = p_fecha
        IMPORTING
          et_return  = gt_return
        EXCEPTIONS
          error      = 1
      ).

    WHEN OTHERS.
  ENDCASE.

ENDFORM.

FORM sho_log.

  CALL FUNCTION 'C14ALD_BAPIRET2_SHOW'
    TABLES
      i_bapiret2_tab = gt_return.

ENDFORM.
