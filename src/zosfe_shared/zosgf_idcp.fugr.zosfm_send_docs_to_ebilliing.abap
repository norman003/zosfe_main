FUNCTION zosfm_send_docs_to_ebilliing.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     REFERENCE(IT_PRINTED_INVOICES) TYPE  ZOSTT_PRINTED_INVOICES
*"     REFERENCE(I_CHKBILL) TYPE  XFELD
*"     REFERENCE(I_CHKDELI) TYPE  XFELD
*"     REFERENCE(I_INTERFAZ) TYPE  XFELD DEFAULT ''
*"  EXPORTING
*"     REFERENCE(ET_MESSAGE) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA: cl_extfac TYPE REF TO zossdcl_pro_extrac_fe,
        lo_extgr  TYPE REF TO object,
        lo_obj    TYPE REF TO object.                         "+NTP010523-3000020188

  DATA: lwa_t003i   TYPE lty_t003i,
        ls_excep    TYPE zostb_t003_i,                          "I-WMR-150716
        ls_ceactsoc TYPE zostb_ceactsoc,                      "I-WMR-071116-3000005897
        lw_mandt    TYPE sy-mandt,
        l_errmsg    TYPE string,                              "I-WMR-231117-3000007633
        lt_message  TYPE STANDARD TABLE OF bapiret2.

  CONSTANTS: gc_classname_gr TYPE string VALUE 'ZOSSDCL_PRO_EXTRAC_FE_GR',  "I-3000011085-NTP190219
             gc_classname_fe TYPE string VALUE 'ZOSSDCL_PRO_EXTRAC_FE'.     "+NTP010523-3000020188

  FIELD-SYMBOLS:<fs_printed> LIKE LINE OF it_printed_invoices.


*{  BEGIN OF INSERT WMR-111116-3000005346
  " Nro. Instalación Sap
  CALL FUNCTION 'SLIC_GET_LICENCE_NUMBER'
    IMPORTING
      license_number = gw_license.
*}  END OF INSERT WMR-111116-3000005346

  IF ( ( sy-ucomm = 'RW'   OR
         sy-ucomm = 'BTCI' OR
         sy-ucomm = 'YES'  OR
         sy-ucomm = 'RENU' OR
         sy-ucomm EQ '&ASIG' ) "OFV 06.06.2016
       AND ( i_interfaz EQ abap_false ) )
  OR ( i_interfaz EQ abap_true ).

*   Creamos objeto
*    CREATE OBJECT cl_extfac.                                                                                       "-NTP010523-3000020188
    zossdcl_pro_extrac_fe=>get_badi_object( EXPORTING i_classname = gc_classname_fe CHANGING co_obj = cl_extfac ).  "+NTP010523-3000020188

    LOOP AT it_printed_invoices ASSIGNING <fs_printed>.

      CASE abap_true.
        WHEN i_chkbill.

*     Verificar que NO sea Guia de Remisión
          SELECT SINGLE *
          FROM vbrk
          WHERE vbeln = <fs_printed>-vbeln.

          CHECK sy-subrc = 0.

*{  BEGIN OF INSERT WMR-071116-3000005897
          " Verificar que Facturación Electrónica se encuentre activa para la Sociedad
          SELECT SINGLE *
            INTO ls_ceactsoc
            FROM zostb_ceactsoc
            WHERE bukrs EQ vbrk-bukrs.

          CHECK ls_ceactsoc-factele EQ abap_true.
*}  END OF INSERT WMR-071116-3000005897

*{  BEGIN OF INSERT WMR-111116-3000005346
          CASE gw_license.
            WHEN '0020673876'.  " Beta
*{  BEGIN OF INSERT WMR-231117-3000007633
              CLEAR l_errmsg.
              CALL FUNCTION 'ZOSSDFM_BEFORE_RELEASE_TO_ACC'
                EXPORTING
                  i_vbeln  = <fs_printed>-vbeln
                IMPORTING
                  e_errmsg = l_errmsg.
              IF l_errmsg IS INITIAL.
*               Verificar que esté contabilizado
                CLEAR lw_mandt.
                SELECT SINGLE mandt
                FROM bkpf
                INTO lw_mandt
                WHERE awkey = <fs_printed>-vbeln
                  AND awtyp = 'VBRK'.
                IF sy-subrc NE 0.
                  WAIT UP TO 2 SECONDS.
                  SELECT SINGLE mandt
                  FROM bkpf
                  INTO lw_mandt
                  WHERE awkey = <fs_printed>-vbeln
                    AND awtyp = 'VBRK'.
                ENDIF.

                CHECK lw_mandt IS NOT INITIAL.
              ENDIF.
*}  END OF INSERT WMR-231117-3000007633

            WHEN OTHERS.
*}  END OF INSERT WMR-111116-3000005346
*     Verificar que esté contabilizado
              CLEAR lw_mandt.
              SELECT SINGLE mandt
              FROM bkpf
              INTO lw_mandt
              WHERE awkey = <fs_printed>-vbeln
                AND awtyp = 'VBRK'.
              IF sy-subrc NE 0.
                WAIT UP TO 2 SECONDS.
                SELECT SINGLE mandt
                FROM bkpf
                INTO lw_mandt
                WHERE awkey = <fs_printed>-vbeln
                  AND awtyp = 'VBRK'.
              ENDIF.

              CHECK lw_mandt IS NOT INITIAL.
*{  BEGIN OF INSERT WMR-111116-3000005346
          ENDCASE.
*}  END OF INSERT WMR-111116-3000005346

*     Verificar Tipo de Documento
          CLEAR lwa_t003i.
          SELECT SINGLE a~blart a~doccls b~fkart
          INTO lwa_t003i
          FROM t003_i AS a INNER JOIN tvfk AS b ON a~blart = b~blart
          WHERE b~fkart = vbrk-fkart
*{  BEGIN OF INSERT WMR-160615
            AND a~land1 EQ gc_peru.
*}  END OF INSERT WMR-160615

*{  BEGIN OF REPLACE WMR-150716
          ""        IF sy-subrc NE 0.

          " Verificar excepción de Tipo de documento
          CLEAR ls_excep.
          SELECT SINGLE *
            INTO ls_excep
            FROM zostb_t003_i
            WHERE land1 EQ gc_peru
              AND fkart EQ vbrk-fkart.
          IF sy-subrc EQ 0.
            CLEAR lwa_t003i.
            lwa_t003i-doccls = ls_excep-doccls.
            lwa_t003i-fkart  = ls_excep-fkart.
          ENDIF.

          IF lwa_t003i IS INITIAL.
*}  END OF REPLACE WMR-150716
            MESSAGE 'Tipo de Documento no existe en clase de Documentos, extractor no se ejecuta' TYPE 'W'.
            EXIT.
          ENDIF.

*BI-NTP-200416
          CASE lwa_t003i-doccls.
            WHEN '01'. "Facturas
              cl_extfac->extrae_data_fa(
                EXPORTING
                  p_vbeln   = vbrk-vbeln
                IMPORTING
                  p_message = lt_message
              ).

            WHEN '03'. "Boletas
              cl_extfac->extrae_data_bo(
                EXPORTING
                  p_vbeln   = vbrk-vbeln
                IMPORTING
                  p_message = lt_message
              ).

            WHEN '07'. "Nota de credito
              cl_extfac->extrae_data_nc(
                EXPORTING
                  p_vbeln   = vbrk-vbeln
                IMPORTING
                  p_message = lt_message
              ).

            WHEN '08'. "Nota de debito
              cl_extfac->extrae_data_nd(
                EXPORTING
                  p_vbeln   = vbrk-vbeln
                IMPORTING
                  p_message = lt_message
              ).

          ENDCASE.

        WHEN i_chkdeli.

          SELECT SINGLE * FROM likp WHERE vbeln = <fs_printed>-vbeln.
          IF sy-subrc = 0.

*{  BEGIN OF INSERT WMR-071116-3000005897
            " Verificar que Guía Remisión Electrónica se encuentre activa para la Sociedad
            CLEAR vbrk.
            SELECT SINGLE l~vbeln t~bukrs
              INTO CORRESPONDING FIELDS OF vbrk
              FROM likp AS l INNER JOIN tvko AS t
              ON l~vkorg EQ t~vkorg
              WHERE l~vbeln EQ <fs_printed>-vbeln.

            CHECK sy-subrc EQ 0.

            SELECT SINGLE *
              INTO ls_ceactsoc
              FROM zostb_ceactsoc
              WHERE bukrs EQ vbrk-bukrs.

            CHECK ls_ceactsoc-guiaele EQ abap_true.
*}  END OF INSERT WMR-071116-3000005897

            IF lo_extgr IS NOT BOUND.
*              CREATE OBJECT lo_extgr TYPE (gc_classname_gr).                                                               "+NTP010523-3000020188
              zossdcl_pro_extrac_fe=>get_badi_object( EXPORTING i_classname = gc_classname_gr CHANGING co_obj = lo_extgr ). "+NTP010523-3000020188
            ENDIF.

            CALL METHOD lo_extgr->('EXTRAE_DATA_GUIA_REMISION')
              EXPORTING
                i_entrega = <fs_printed>-vbeln
              IMPORTING
                et_return = lt_message
              EXCEPTIONS
                error     = 1.
          ENDIF.

      ENDCASE.
    ENDLOOP.
*EI-NTP-200416

    IF i_interfaz EQ abap_false AND sy-calld IS INITIAL.
*     Mostrar mensaje final
      CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
        EXPORTING
          it_message = lt_message.
    ELSE.
      et_message[] = lt_message[].
    ENDIF.

  ENDIF.
ENDFUNCTION.
