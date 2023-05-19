*----------------------------------------------------------------------*
***INCLUDE LZOSFEGF_DOCUINACI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  SET_UPDATE_SECU  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_update_secu INPUT.

  DATA: l_count TYPE i,
        l_id    TYPE string.

  CASE zosfeva_docuinac-zzt_tipodoc.
    WHEN '01'
      OR '03'
      OR '07'
      OR '08'
      OR 'RC'   " Resumen de boletas
      OR 'RA'.  " Comunicado de Bajas

      CASE zosfeva_docuinac-zzt_tipodoc.
        WHEN '01'
          OR '03'
          OR '07'
          OR '08'.
          SELECT COUNT( * ) INTO l_count
            FROM zostb_docexposca
            WHERE bukrs         = zosfeva_docuinac-bukrs
              AND zz_numeracion = zosfeva_docuinac-zzt_numeracion
              AND zz_tipodoc    = zosfeva_docuinac-zzt_tipodoc.
          IF l_count > 0.
            MESSAGE text-e02 TYPE 'E'.
          ENDIF.

        WHEN 'RC'.  " Resumen de boletas
          CONCATENATE zosfeva_docuinac-zzt_tipodoc zosfeva_docuinac-zzt_numeracion
            INTO l_id SEPARATED BY '-'.
          SELECT COUNT( * ) INTO l_count
            FROM zostb_rbcab
            WHERE bukrs           = zosfeva_docuinac-bukrs
              AND zz_identifiresu = l_id.
          IF l_count > 0.
            MESSAGE text-e03 TYPE 'E'.
          ENDIF.

        WHEN 'RA'.  " Comunicado de Bajas
          CONCATENATE zosfeva_docuinac-zzt_tipodoc zosfeva_docuinac-zzt_numeracion
            INTO l_id SEPARATED BY '-'.
          SELECT COUNT( * ) INTO l_count
            FROM zostb_bacab
            WHERE bukrs           = zosfeva_docuinac-bukrs
              AND zz_identifibaja = l_id.
          IF l_count > 0.
            MESSAGE text-e04 TYPE 'E'.
          ENDIF.
      ENDCASE.
    WHEN OTHERS.
      MESSAGE text-e01 TYPE 'E'.
  ENDCASE.

  l_count = 0.
  SELECT COUNT( * ) INTO l_count FROM zosfetb_docuinac
    WHERE bukrs          = zosfeva_docuinac-bukrs
      AND zzt_numeracion = zosfeva_docuinac-zzt_numeracion
      AND zzt_tipodoc    = zosfeva_docuinac-zzt_tipodoc.

  IF l_count = 0.
    zosfeva_docuinac-updkz = 'I'.
  ENDIF.

ENDMODULE.
