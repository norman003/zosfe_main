*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_FORMADEPAGO_U01
*&---------------------------------------------------------------------*
CLASS zcl_util DEFINITION
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA gt_batch TYPE bdcdata_tab .
    DATA gt_batchret TYPE bapiret2_tab .

    METHODS batch_call
      IMPORTING
        !i_tcode  TYPE clike
        !is_param TYPE ctu_params OPTIONAL .
    METHODS batch_dynpro
      IMPORTING
        !i_program TYPE clike
        !i_dynpro  TYPE clike
        !i_key     TYPE clike OPTIONAL .
    METHODS batch_field
      IMPORTING
        !i_field TYPE clike
        !i_value TYPE any .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_util IMPLEMENTATION.

  METHOD batch_call.
    DATA: lt_bdcret TYPE TABLE OF bdcmsgcoll,
          ls_param  TYPE ctu_params.

    REFRESH gt_batchret.

    IF is_param IS INITIAL.
      ls_param-dismode = 'N'.
      ls_param-updmode = 'S'.
      ls_param-nobinpt = 'X'.
    ELSE.
      ls_param = is_param.
    ENDIF.

    CALL TRANSACTION i_tcode USING gt_batch
                    OPTIONS FROM ls_param
                   MESSAGES INTO lt_bdcret.

    CALL FUNCTION 'CONVERT_BDCMSGCOLL_TO_BAPIRET2'
      TABLES
        imt_bdcmsgcoll = lt_bdcret
        ext_return     = gt_batchret.

    REFRESH gt_batch.
  ENDMETHOD.

  METHOD batch_dynpro.
    DATA: ls_batch TYPE bdcdata.
    ls_batch-program = i_program.
    ls_batch-dynpro  = i_dynpro.
    ls_batch-dynbegin = abap_on.
    APPEND ls_batch  TO gt_batch.
    CLEAR ls_batch.

    IF i_key IS NOT INITIAL.
      ls_batch-fnam = 'BDC_OKCODE'.
      ls_batch-fval = i_key.
      APPEND ls_batch  TO gt_batch.
    ENDIF.
  ENDMETHOD.

  METHOD batch_field.
    DATA: ls_batch TYPE bdcdata.
    ls_batch-fnam = i_field.
    WRITE i_value TO ls_batch-fval.
    CONDENSE ls_batch-fval.
    APPEND ls_batch  TO gt_batch.
  ENDMETHOD.

ENDCLASS.
