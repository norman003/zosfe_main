*&---------------------------------------------------------------------*
*& Report  ZOSFE_INT_PREVIEW_DOCUMENT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zosfe_int_preview_document.

PARAMETERS: p_vbeln TYPE vbrk-vbeln,
            p_dest  TYPE  lvs_ldest MEMORY ID pri MATCHCODE OBJECT h_tsp03.

START-OF-SELECTION.

  TYPES: BEGIN OF ty_t003i,
           blart  TYPE  t003_i-blart,
           doccls TYPE  t003_i-blart,
           fkart  TYPE  tvfk-fkart,
         END OF ty_t003i.

  DATA: ls_vbrk           TYPE vbrk,
        ls_t003i          TYPE ty_t003i,
        ls_excep          TYPE zostb_t003_i,
        ls_data           TYPE zosfees_data_nojson,
        ls_options        TYPE zosfees_extract_options VALUE 'XX',
        ls_control_param  TYPE  ssfctrlop,
        ls_output_options TYPE  ssfcompop,
        ls_nast           TYPE nast,
        ls_bil_invoice    TYPE lbbil_invoice,
        ls_header2        TYPE zostb_docexposc2,
        cl_extfac         TYPE REF TO zossdcl_pro_extrac_fe,

        lw_formname       TYPE tdsfname,
        lw_fm_name        TYPE rs38l_fnam,
        lw_repeat         TYPE c,

        lc_tip_op         TYPE string VALUE '02'. " Exportación

  SELECT SINGLE vbeln fkart
    INTO CORRESPONDING FIELDS OF ls_vbrk
    FROM vbrk
    WHERE vbeln EQ p_vbeln.
  CHECK sy-subrc EQ 0.

  " Determinar tipo de comprobante Sunat
  SELECT SINGLE a~blart a~doccls b~fkart
    INTO ls_t003i
    FROM t003_i AS a
    INNER JOIN tvfk AS b
    ON a~blart = b~blart
    WHERE b~fkart EQ ls_vbrk-fkart
      AND a~land1 EQ 'PE' ##warn_ok.

  SELECT SINGLE *
    INTO ls_excep
    FROM zostb_t003_i
    WHERE land1 EQ 'PE'
      AND fkart EQ ls_vbrk-fkart.
  IF sy-subrc EQ 0.
    CLEAR ls_t003i.
    ls_t003i-doccls = ls_excep-doccls.
    ls_t003i-fkart  = ls_excep-fkart.
  ENDIF.

  " Obtener datos
  CREATE OBJECT cl_extfac.

  CASE ls_t003i-doccls.
    WHEN '01'. "Facturas
      cl_extfac->extrae_data_fa(
        EXPORTING
          p_vbeln    = ls_vbrk-vbeln
          is_options = ls_options
        IMPORTING
          es_datanojson = ls_data
      ).
      READ TABLE ls_data-t_header2 INTO ls_header2 INDEX 1.
      IF sy-subrc EQ 0.
        CASE ls_header2-zz_tip_ope.
          WHEN lc_tip_op.
            lw_formname = 'ZOSSFFE_ELECTRONIC_DOCUMENT_EX'.
          WHEN OTHERS.
            lw_formname = 'ZOSSFFE_ELECTRONIC_DOCUMENT'.
        ENDCASE.
      ENDIF.

    WHEN '03'. "Boletas
      cl_extfac->extrae_data_bo(
        EXPORTING
          p_vbeln    = ls_vbrk-vbeln
          is_options = ls_options
        IMPORTING
          es_datanojson = ls_data
      ).
      lw_formname = 'ZOSSFFE_ELECTRONIC_DOCUMENT'.

    WHEN '07'. "Nota de credito
      cl_extfac->extrae_data_nc(
        EXPORTING
          p_vbeln    = ls_vbrk-vbeln
          is_options = ls_options
        IMPORTING
          es_datanojson = ls_data
      ).
      lw_formname = 'ZOSSFFE_ELECTRONIC_DOCUMENT'.

    WHEN '08'. "Nota de debito
      cl_extfac->extrae_data_nd(
        EXPORTING
          p_vbeln    = ls_vbrk-vbeln
          is_options = ls_options
        IMPORTING
          es_datanojson = ls_data
      ).
      lw_formname = 'ZOSSFFE_ELECTRONIC_DOCUMENT'.

  ENDCASE.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = lw_formname
    IMPORTING
      fm_name            = lw_fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc NE 0.
    EXIT.
  ENDIF.

  ls_control_param-preview    = 'X'.
  ls_output_options-tdnoprev  = space.
  ls_output_options-tddest    = p_dest.

  ls_control_param-device     = 'PRINTER'.
  ls_control_param-no_dialog  = space.
  ls_control_param-no_open   = 'X'.
  ls_control_param-no_close  = 'X'.

  PERFORM ssf_open CHANGING ls_output_options ls_control_param sy-subrc.
  IF sy-subrc NE 0. RETURN. ENDIF.

  CALL FUNCTION lw_fm_name
    EXPORTING
      control_parameters = ls_control_param
      output_options     = ls_output_options
      user_settings      = space
      is_bil_invoice     = ls_bil_invoice
      is_nast            = ls_nast
      is_repeat          = lw_repeat
      is_data            = ls_data
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.
  IF sy-subrc NE 0 AND sy-subrc NE 4.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  PERFORM ssf_close.

*&---------------------------------------------------------------------*
*&      Form  SSF_OPEN
*&---------------------------------------------------------------------*
FORM ssf_open  CHANGING pe_ssfcompop TYPE ssfcompop
                        pe_ssfctrlop LIKE ssfctrlop
                        pe_subrc     TYPE sysubrc.
  CALL FUNCTION 'SSF_OPEN'
    EXPORTING
      user_settings      = ' '
      output_options     = pe_ssfcompop
      control_parameters = pe_ssfctrlop
    EXCEPTIONS ##FM_SUBRC_OK
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.
  IF sy-subrc <> 0.    "#EC NEEDED
  ENDIF.
  pe_subrc = sy-subrc.
ENDFORM.                    " SSF_OPEN
*&---------------------------------------------------------------------*
*&      Form  SSF_CLOSE
*&---------------------------------------------------------------------*
FORM ssf_close .
  CALL FUNCTION 'SSF_CLOSE'
    EXCEPTIONS ##FM_SUBRC_OK
      formatting_error = 1
      internal_error   = 2
      send_error       = 3
      OTHERS           = 4.
  IF sy-subrc <> 0.   "#EC NEEDED
  ENDIF.
ENDFORM.                    " SSF_CLOSE
