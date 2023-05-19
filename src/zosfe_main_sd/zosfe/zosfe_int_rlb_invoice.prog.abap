*----------------------------------------------------------------------*
*      Print of a invoice by SAPscript SMART FORMS               *
*----------------------------------------------------------------------*

REPORT zosfe_int_rlb_invoice.

* declaration of data
INCLUDE rlb_invoice_data_declare.
* definition of forms
INCLUDE rlb_invoice_form01.
INCLUDE rlb_print_forms.

*---------------------------------------------------------------------*
*       FORM ENTRY
*---------------------------------------------------------------------*
FORM entry USING return_code us_screen ##CALLED ##PERF_NO_TYPE.

  DATA: lf_retcode TYPE sy-subrc.
  CLEAR retcode.
  xscreen = us_screen.
  PERFORM processing USING us_screen
                     CHANGING lf_retcode.
  IF lf_retcode NE 0.
    return_code = 1.
  ELSE.
    return_code = 0.
  ENDIF.

ENDFORM.                    "ENTRY
*---------------------------------------------------------------------*
*       FORM PROCESSING                                               *
*---------------------------------------------------------------------*
FORM processing USING proc_screen  ##PERF_NO_TYPE   ##NEEDED
                CHANGING cf_retcode.

*{  BEGIN OF INSERT WMR-181016-3000005779
  TYPES: BEGIN OF ty_t003i,
           blart  TYPE  t003_i-blart,
           doccls TYPE  t003_i-blart,
           fkart  TYPE  tvfk-fkart,
         END OF ty_t003i.
*}  END OF INSERT WMR-181016-3000005779

  DATA: ls_print_data_to_read TYPE lbbil_print_data_to_read.
  DATA: ls_bil_invoice TYPE lbbil_invoice.
  DATA: lf_fm_name            TYPE rs38l_fnam.
  DATA: ls_control_param      TYPE ssfctrlop.
  DATA: ls_composer_param     TYPE ssfcompop.
  DATA: ls_recipient          TYPE swotobjid.
  DATA: ls_sender             TYPE swotobjid.
  DATA: lf_formname           TYPE tdsfname.
  DATA: ls_addr_key           LIKE addr_key.
  DATA: ls_dlv_land           LIKE vbrk-land1   ##FIELD_HYPHEN.
  DATA: ls_job_info           TYPE ssfcrescl.

*{  BEGIN OF INSERT WMR-181016-3000005779
  DATA: ls_t003i   TYPE ty_t003i,
        ls_excep   TYPE zostb_t003_i,
        ls_data    TYPE zosfees_data_nojson,
        ls_options TYPE zosfees_extract_options VALUE 'XX',
        ls_header2 TYPE zostb_docexposc2,
        cl_extfac  TYPE REF TO zossdcl_pro_extrac_fe,
        lc_tip_op  TYPE string VALUE '02', " Exportación
        gw_license TYPE string.                             "I-NTP190417-3000007094
*}  END OF INSERT WMR-181016-3000005779


  CALL FUNCTION 'SLIC_GET_LICENCE_NUMBER'                   "I-NTP190417-3000007094
    IMPORTING
      license_number = gw_license.


* SmartForm from customizing table TNAPR
  lf_formname = tnapr-sform.

* determine print data
  PERFORM set_print_data_to_read USING    lf_formname
                                 CHANGING ls_print_data_to_read
                                 cf_retcode.

  IF cf_retcode = 0.
* select print data
    PERFORM get_data USING    ls_print_data_to_read
                     CHANGING ls_addr_key
                              ls_dlv_land
                              ls_bil_invoice
                              cf_retcode.

*{  BEGIN OF INSERT WMR-181016-3000005779
    " Determinar tipo de comprobante Sunat
    SELECT SINGLE a~blart a~doccls b~fkart
      INTO ls_t003i
      FROM t003_i AS a INNER JOIN tvfk AS b ON a~blart = b~blart
      WHERE b~fkart EQ ls_bil_invoice-hd_gen-bil_type
        AND a~land1 EQ 'PE'.                           "#EC CI_BUFFJOIN

    SELECT SINGLE *
      INTO ls_excep
      FROM zostb_t003_i
      WHERE land1 EQ 'PE'
        AND fkart EQ ls_bil_invoice-hd_gen-bil_type.
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
            p_vbeln    = ls_bil_invoice-hd_gen-bil_number
            is_options = ls_options
          IMPORTING
            es_datanojson = ls_data
        ).
        READ TABLE ls_data-t_header2 INTO ls_header2 INDEX 1.
        IF sy-subrc EQ 0 AND ls_header2-zz_tip_ope IS NOT INITIAL."I-WMR-290319-3000011466
*          CASE ls_header2-zz_tip_ope.                             "E-WMR-290319-3000011466
          CASE ls_header2-zz_tip_ope(2).                          "I-WMR-290319-3000011466
            WHEN lc_tip_op. " Exportación
              CASE gw_license.
                WHEN '0020311006'   " AIB                         "I-WMR-290319-3000011466
                  OR '0020863116'.  " AIB CLOUD
                  lf_formname = 'ZOSSFFE_ELECDOC_EXP_0020311006'. "I-WMR-290319-3000011466
                WHEN '0020974592'. "Danper                        "I-NTP190417-3000007094
                  lf_formname = 'ZOSSFFE_ELECDOC_EXP_0020974592'. "I-NTP190417-3000007094
                WHEN OTHERS.
                  lf_formname = 'ZOSSFFE_ELECTRONIC_DOCUMENT_EX'.
              ENDCASE.
            WHEN OTHERS.    " Nacional                            "I-WMR-040517-3000007140
              CASE gw_license.                                    "I-WMR-040517-3000007140
                WHEN '0020974592'.  " Danper                      "I-WMR-040517-3000007140
                  lf_formname = 'ZOSSFFE_FACT_BOLET_0020974592'.  "I-WMR-040517-3000007140
              ENDCASE.                                            "I-WMR-040517-3000007140
          ENDCASE.
        ENDIF.

      WHEN '03'. "Boletas
        cl_extfac->extrae_data_bo(
          EXPORTING
            p_vbeln    = ls_bil_invoice-hd_gen-bil_number
            is_options = ls_options
          IMPORTING
            es_datanojson = ls_data
        ).
        CASE gw_license.                                          "I-WMR-040517-3000007140
          WHEN '0020974592'.  " Danper                            "I-WMR-040517-3000007140
            lf_formname = 'ZOSSFFE_FACT_BOLET_0020974592'.        "I-WMR-040517-3000007140
        ENDCASE.                                                  "I-WMR-040517-3000007140

      WHEN '07'. "Nota de credito
        cl_extfac->extrae_data_nc(
          EXPORTING
            p_vbeln    = ls_bil_invoice-hd_gen-bil_number
            is_options = ls_options
          IMPORTING
            es_datanojson = ls_data
        ).
        CASE gw_license.                                          "I-WMR-040517-3000007448
          WHEN '0020974592'.  " Danper                            "I-WMR-040517-3000007448
            READ TABLE ls_data-t_header2 INTO ls_header2 INDEX 1. "I-WMR-040517-3000007448
            IF sy-subrc EQ 0 AND ls_header2-zz_tip_ope IS NOT INITIAL."I-WMR-290319-3000011466
*              CASE ls_header2-zz_tip_ope.                         "E-WMR-290319-3000011466
              CASE ls_header2-zz_tip_ope(2).                      "I-WMR-290319-3000011466
                WHEN lc_tip_op. " Exportación                     "I-WMR-040517-3000007448
                  lf_formname = 'ZOSSFFE_NC_ND_EXP_0020974592'.   "I-WMR-040517-3000007448
                WHEN OTHERS.                                      "I-WMR-040517-3000007448
                  lf_formname = 'ZOSSFFE_NC_ND_0020974592'.       "I-WMR-040517-3000007448
              ENDCASE.                                            "I-WMR-040517-3000007448
            ENDIF.                                                "I-WMR-040517-3000007448
*{I-221021-NTP-3000017871
          WHEN '0020311006'  " AIB
            OR '0020863116'. " AIB CLOUD
            READ TABLE ls_data-t_header2 INTO ls_header2 INDEX 1.
            IF sy-subrc = 0 AND ls_header2-zz_tip_ope IS NOT INITIAL.
              IF ls_header2-zz_tip_ope(2) = lc_tip_op.
                lf_formname = 'ZOSSFFE_NC_EXP_0020311006'.
              ENDIF.
            ENDIF.
*}I-221021-NTP-3000017871
        ENDCASE.                                                  "I-WMR-040517-3000007448

      WHEN '08'. "Nota de debito
        cl_extfac->extrae_data_nd(
          EXPORTING
            p_vbeln    = ls_bil_invoice-hd_gen-bil_number
            is_options = ls_options
          IMPORTING
            es_datanojson = ls_data
        ).
        CASE gw_license.                                          "I-WMR-040517-3000007448
          WHEN '0020974592'.  " Danper                            "I-WMR-040517-3000007448
            READ TABLE ls_data-t_header2 INTO ls_header2 INDEX 1. "I-WMR-040517-3000007448
            IF sy-subrc EQ 0 AND ls_header2-zz_tip_ope IS NOT INITIAL."I-WMR-290319-3000011466
*              CASE ls_header2-zz_tip_ope.                         "E-WMR-290319-3000011466
              CASE ls_header2-zz_tip_ope(2).                      "I-WMR-290319-3000011466
                WHEN lc_tip_op. " Exportación                     "I-WMR-040517-3000007448
                  lf_formname = 'ZOSSFFE_NC_ND_EXP_0020974592'.   "I-WMR-040517-3000007448
                WHEN OTHERS.                                      "I-WMR-040517-3000007448
                  lf_formname = 'ZOSSFFE_NC_ND_0020974592'.       "I-WMR-040517-3000007448
              ENDCASE.                                            "I-WMR-040517-3000007448
            ENDIF.                                                "I-WMR-040517-3000007448
*{I-WMR-15122021-3000018127
          WHEN '0020311006'  " AIB
            OR '0020863116'. " AIB CLOUD
            READ TABLE ls_data-t_header2 INTO ls_header2 INDEX 1.
            IF sy-subrc = 0 AND ls_header2-zz_tip_ope IS NOT INITIAL.
              IF ls_header2-zz_tip_ope(2) = lc_tip_op.
                lf_formname = 'ZOSSFFE_ND_EXP_0020311006'.
              ENDIF.
            ENDIF.
*}I-WMR-15122021-3000018127
        ENDCASE.                                                  "I-WMR-040517-3000007448

    ENDCASE.
*}  END OF INSERT WMR-181016-3000005779

  ENDIF.

  IF cf_retcode = 0.
    PERFORM set_print_param USING    ls_addr_key
                                     ls_dlv_land
                            CHANGING ls_control_param
                                     ls_composer_param
                                     ls_recipient
                                     ls_sender
                                     cf_retcode.
  ENDIF.

  IF cf_retcode = 0.
* determine smartform function module for invoice
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = lf_formname
*       variant            = ' '
*       direct_call        = ' '
      IMPORTING
        fm_name            = lf_fm_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.
    IF sy-subrc <> 0.
*   error handling
      cf_retcode = sy-subrc.
      PERFORM protocol_update.
    ENDIF.
  ENDIF.

  IF cf_retcode = 0.
    PERFORM check_repeat.
    IF ls_composer_param-tdcopies EQ 0.
      nast_anzal = 1.
    ELSE.
      nast_anzal = ls_composer_param-tdcopies.
    ENDIF.
    ls_composer_param-tdcopies = 1.
    DO nast_anzal TIMES.
* In case of repetition only one time archiving
      IF sy-index > 1 AND nast-tdarmod = 3.
        nast_tdarmod = nast-tdarmod.
        nast-tdarmod = 1.
        ls_composer_param-tdarmod = 1.
      ENDIF.
      IF sy-index NE 1 AND repeat IS INITIAL.
        repeat = 'X'.
      ENDIF.
* call smartform invoice
      CALL FUNCTION lf_fm_name
        EXPORTING
          archive_index      = toa_dara
          archive_parameters = arc_params
          control_parameters = ls_control_param
*         mail_appl_obj      =
          mail_recipient     = ls_recipient
          mail_sender        = ls_sender
          output_options     = ls_composer_param
          user_settings      = space
          is_bil_invoice     = ls_bil_invoice
          is_nast            = nast
          is_repeat          = repeat
*{  BEGIN OF INSERT WMR-181016-3000005779
          is_data            = ls_data
*}  END OF INSERT WMR-181016-3000005779
        IMPORTING
          job_output_info    = ls_job_info
*         document_output_info =
*         job_output_options =
        EXCEPTIONS
          formatting_error   = 1
          internal_error     = 2
          send_error         = 3
          user_canceled      = 4
          OTHERS             = 5.
      IF sy-subrc <> 0.
*   error handling
        cf_retcode = sy-subrc.
        PERFORM protocol_update.
* get SmartForm protocoll and store it in the NAST protocoll
        PERFORM add_smfrm_prot.
      ENDIF.
    ENDDO.
* get SmartForm spoolid and store it in the NAST protocoll
    DATA ls_spoolid LIKE LINE OF ls_job_info-spoolids.
    LOOP AT ls_job_info-spoolids INTO ls_spoolid.
      IF ls_spoolid NE space.
        PERFORM protocol_update_spool USING '342' ls_spoolid
                                            space space space.
      ENDIF.
    ENDLOOP.
    ls_composer_param-tdcopies = nast_anzal.
    IF NOT nast_tdarmod IS INITIAL.
      nast-tdarmod = nast_tdarmod.
      CLEAR nast_tdarmod.
    ENDIF.

  ENDIF.

* get SmartForm protocoll and store it in the NAST protocoll
* PERFORM ADD_SMFRM_PROT.

ENDFORM.                    "PROCESSING
