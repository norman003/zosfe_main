FUNCTION zosfm_checks_print_and_release.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     REFERENCE(I_VBELN) TYPE  VBELN_VF
*"     REFERENCE(I_CHKBILL) TYPE  XFELD
*"     REFERENCE(I_CHKDELI) TYPE  XFELD
*"  EXPORTING
*"     REFERENCE(E_FECHA) TYPE  CHAR10
*"     REFERENCE(E_DIAS) TYPE  CHAR2
*"  EXCEPTIONS
*"      ERROR_SERIE
*"      ERROR_CORRELA
*"      ERROR_FECHA_FAC
*"      ERROR_NOTAS
*"      ERROR_FECHA_NOT
*"      ERROR_PILA
*"----------------------------------------------------------------------

  DATA: lw_error     TYPE char1,
        lw_rgtno     TYPE idcn_loma-rgtno,
        ls_idcn_loma TYPE idcn_loma,                           "I-WMR-290915
        ls_vbrk      TYPE vbrk,                                "I-WMR-071116-3000005897
        ls_ceactsoc  TYPE zostb_ceactsoc.                      "I-WMR-071116-3000005897

  " Obtener constantes
  PERFORM get_const.

  CASE abap_true.                                              "I-WMR-290915
    WHEN i_chkbill. " Factura                                  "I-WMR-290915

*{  BEGIN OF INSERT WMR-071116-3000005897
      " Verificar que Facturación Electrónica se encuentre activa para la Sociedad
      SELECT SINGLE vbeln bukrs
        INTO CORRESPONDING FIELDS OF ls_vbrk
        FROM vbrk
        WHERE vbeln EQ i_vbeln.

      CHECK sy-subrc EQ 0.

      SELECT SINGLE *
        INTO ls_ceactsoc
        FROM zostb_ceactsoc
        WHERE bukrs EQ ls_vbrk-bukrs.

      CHECK ls_ceactsoc-factele EQ abap_true.
*}  END OF INSERT WMR-071116-3000005897

      " Verificar cumple requisitos antes de empezar a validar
      PERFORM chk_values USING i_vbeln
                      CHANGING lw_error
                               lw_rgtno
                               ls_idcn_loma.                      "I-WMR-290915

      CHECK lw_error IS INITIAL.

      " Validar serie
      PERFORM chk_lotno USING lw_rgtno
                              ls_idcn_loma.                       "I-WMR-290915

** Validar correlativo
*  PERFORM chk_correl.

      " Verificar fecha de factura (7 días)
      PERFORM chk_fecfac CHANGING e_fecha.

      " Validar NC y ND referencian a Comprobante aprobado
      PERFORM chk_notas.

      " Validar fechas de notas
      PERFORM chk_fecnot CHANGING e_fecha
                                  e_dias.

    WHEN i_chkdeli. " Entrega                                  "I-WMR-290915

*{  BEGIN OF INSERT WMR-071116-3000005897
      " Verificar que Guía Remisión Electrónica se encuentre activa para la Sociedad
      SELECT SINGLE l~vbeln t~bukrs
        INTO CORRESPONDING FIELDS OF ls_vbrk
        FROM likp AS l INNER JOIN tvko AS t
        ON l~vkorg EQ t~vkorg
        WHERE l~vbeln EQ i_vbeln.

      CHECK sy-subrc EQ 0.

      SELECT SINGLE *
        INTO ls_ceactsoc
        FROM zostb_ceactsoc
        WHERE bukrs EQ ls_vbrk-bukrs.

      CHECK ls_ceactsoc-guiaele EQ abap_true.
*}  END OF INSERT WMR-071116-3000005897

      PERFORM pre_checks_delivery USING     i_vbeln            "I-WMR-290915
                                  CHANGING  e_fecha.           "I-WMR-290915

  ENDCASE.                                                     "I-WMR-290915

ENDFUNCTION.
