*----------------------------------------------------------------------*
*      Print of a delivery note by SAPscript SMART FORMS               *
*----------------------------------------------------------------------*
REPORT zosfe_int_rle_delnote.

* declaration of data
INCLUDE rle_delnote_data_declare.
* definition of forms
INCLUDE rle_delnote_forms.
INCLUDE rle_print_forms.

*---------------------------------------------------------------------*
*       FORM ENTRY
*---------------------------------------------------------------------*
FORM entry USING return_code us_screen.

  DATA: lf_retcode TYPE sy-subrc.
  xscreen = us_screen.
  PERFORM processing USING    us_screen
                     CHANGING lf_retcode.
  IF lf_retcode NE 0.
    return_code = 1.
  ELSE.
    return_code = 0.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
*       FORM PROCESSING                                               *
*---------------------------------------------------------------------*
FORM processing USING    proc_screen
                CHANGING cf_retcode.

  DATA: ls_print_data_to_read TYPE ledlv_print_data_to_read.
  DATA: ls_dlv_delnote        TYPE ledlv_delnote.
  DATA: lf_fm_name            TYPE rs38l_fnam.
  DATA: ls_control_param      TYPE ssfctrlop.
  DATA: ls_composer_param     TYPE ssfcompop.
  DATA: ls_recipient          TYPE swotobjid.
  DATA: ls_sender             TYPE swotobjid.
  DATA: lf_formname           TYPE tdsfname.
  DATA: ls_addr_key           LIKE addr_key.

*{  BEGIN OF INSERT WMR-260517-3000007333
  DATA: lt_return  TYPE bapirettab,
        ls_data    TYPE zosfegres_data_nojson,
        ls_options TYPE zosfees_extract_options VALUE 'XX',
        cl_extgre  TYPE REF TO zossdcl_pro_extrac_fe_gr,
        gw_license TYPE string.                             "I-NTP190417-3000007094
*}  END OF INSERT WMR-260517-3000007333

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
                              ls_dlv_delnote
                              cf_retcode.

*{  BEGIN OF INSERT WMR-181016-3000005779
    " Obtener datos
    CREATE OBJECT cl_extgre.

    cl_extgre->extrae_data_guia_remision(
      EXPORTING
        i_entrega = ls_dlv_delnote-hd_gen-deliv_numb
        is_options = ls_options
      IMPORTING
        et_return     = lt_return
        es_datanojson = ls_data
      EXCEPTIONS
        error     = 1
        OTHERS    = 2
    ).
  ENDIF.

  IF cf_retcode = 0.
    PERFORM set_print_param USING    ls_addr_key
                            CHANGING ls_control_param
                                     ls_composer_param
                                     ls_recipient
                                     ls_sender
                                     cf_retcode.
  ENDIF.

  IF cf_retcode = 0.
* determine smartform function module for delivery note
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
*   call smartform delivery note
    CALL FUNCTION lf_fm_name
      EXPORTING
        archive_index      = toa_dara
        archive_parameters = arc_params
        control_parameters = ls_control_param
*       mail_appl_obj      =
        mail_recipient     = ls_recipient
        mail_sender        = ls_sender
        output_options     = ls_composer_param
        user_settings      = ' '
        is_dlv_delnote     = ls_dlv_delnote
        is_nast            = nast
*{  BEGIN OF INSERT WMR-260517-3000007333
        is_data            = ls_data
*}  END OF INSERT WMR-260517-3000007333
*      importing  document_output_info =
*       job_output_info    =
*       job_output_options =
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
*     get SmartForm protocoll and store it in the NAST protocoll
      PERFORM add_smfrm_prot.                  "INS_HP_335958
    ENDIF.
  ENDIF.

* get SmartForm protocoll and store it in the NAST protocoll
* PERFORM ADD_SMFRM_PROT.                       DEL_HP_335958

ENDFORM.
