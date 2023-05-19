*&---------------------------------------------------------------------*
*&  Include           ZOSSD_INC_IDCP_PRINT_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  AMP01_INICIALIZA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM amp01_inicializa .

  "Limpiar
  CLEAR: zamp, zconst.

  "Obtiene constantes
  PERFORM get_constantes.

* Valida edición
  "    zamp-is_edicion = abap_on.

* Valida sociedad
  "      zamp-is_sociedad = abap_on.

* Valida ampliación activa
  IF zconst-f_activ <= sy-datum AND zconst-f_activ IS NOT INITIAL.
    zamp-is_ampl_active = abap_on.
  ENDIF.


ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GET_CONSTANTES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_constantes .
  DATA: lt_const TYPE TABLE OF zostb_constantes,
        ls_const LIKE LINE OF lt_const,
        l_id     TYPE char80,
        l_string TYPE string.

* Constantes
  IMPORT lt_const = lt_const FROM MEMORY ID 'ZOSFE_AMP_ENHA_IDCP_PRINT_FE'.
  IF lt_const IS INITIAL.
    SELECT * INTO TABLE lt_const
      FROM zostb_constantes
      WHERE modulo     EQ 'SD'
        AND aplicacion EQ 'AMPLIACION'
        AND programa   EQ 'ZOSSD_AMP_IDCP_PRINT_FE'.

    EXPORT lt_const = lt_const TO MEMORY ID 'ZOSFE_AMP_ENHA_IDCP_PRINT_FE'.
  ENDIF.

  LOOP AT lt_const INTO ls_const.
    CASE ls_const-campo.
      WHEN 'F_ACTIV'.
        CONCATENATE ls_const-valor1+6(4)
                    ls_const-valor1+3(2)
                    ls_const-valor1+0(2) INTO zconst-f_activ.
    ENDCASE.
  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  _APPEND_LOG_NEWS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->I_VBELN  text
*      -->I_TEXT   text
*      -->I_COLOR  text
*      <--CT_NEWS  text
*----------------------------------------------------------------------*
FORM _append_log_news  USING    i_vbeln TYPE clike
                                i_text  TYPE clike
                                i_color TYPE clike
                       CHANGING ct_news TYPE STANDARD TABLE.

  FIELD-SYMBOLS <fs_line> TYPE any .
  FIELD-SYMBOLS <fs> TYPE any.

  APPEND INITIAL LINE TO ct_news ASSIGNING <fs_line>.

  ASSIGN COMPONENT 'VBELN' OF STRUCTURE <fs_line> TO <fs>.
  IF <fs> IS ASSIGNED.
    <fs> = i_vbeln.
    UNASSIGN <fs>.
  ENDIF.

  ASSIGN COMPONENT 'TEXT' OF STRUCTURE <fs_line> TO <fs>.
  IF <fs> IS ASSIGNED.
    <fs> = i_text.
    UNASSIGN <fs>.
  ENDIF.

  ASSIGN COMPONENT 'COLOR' OF STRUCTURE <fs_line> TO <fs>.
  IF <fs> IS ASSIGNED.
    <fs> = col_negative.
    UNASSIGN <fs>.
  ENDIF.


ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  IDCP_PRINT_AND_RELEASE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->I_VBELN      text
*      -->I_CHK_PRI    text
*      -->I_CHK_BILL   text
*      -->I_CHK_DELI   text
*      <--CT_NEWS      text
*      <--C_POP_UP_UP  text
*----------------------------------------------------------------------*
FORM idcp_print_and_release
    USING    i_vbeln      TYPE clike
             i_chk_pri    TYPE clike
             i_chk_bill   TYPE clike
             i_chk_deli   TYPE clike
    CHANGING ct_news      TYPE STANDARD TABLE
             c_pop_up_up  TYPE clike.

  DATA: lw_fecha  TYPE char10,
        lw_dias   TYPE char2,
        lw_mensa1 TYPE char50,
        lw_mensa2 TYPE char50,
        lw_mensa3 TYPE char50,
        lw_text   TYPE c LENGTH 70.

  IF i_chk_pri IS NOT INITIAL.              "Solo para IDCP Impresion
    CALL FUNCTION 'ZOSFM_CHECKS_PRINT_AND_RELEASE'
      EXPORTING
        i_vbeln         = i_vbeln
        i_chkbill       = i_chk_bill                                                      "I-WMR-140116
        i_chkdeli       = i_chk_deli                                                      "I-WMR-140116
      IMPORTING
        e_fecha         = lw_fecha
        e_dias          = lw_dias
      EXCEPTIONS
        error_serie     = 1
        error_correla   = 2
        error_fecha_fac = 3
        error_notas     = 4
        error_fecha_not = 5
        error_pila      = 6                                                             "I-WMR-290915
        OTHERS          = 7.                                                            "M-WMR-290915
    CASE sy-subrc.
      WHEN 1.
        lw_mensa1 = text-i01."'No se puede enviar a SUNAT.'.
        lw_mensa2 = text-i02."'Verificar serie y Clase de Documento'.
        lw_mensa3 = text-i03."'Verificar estado de documento referencia'.
        CALL FUNCTION 'MESSAGE_TEXT_BUILD'
          EXPORTING
            msgid               = '00'
            msgnr               = '368'
            msgv1               = lw_mensa1
            msgv2               = lw_mensa2
          IMPORTING
            message_text_output = lw_text.
        PERFORM _append_log_news
                    USING
                       i_vbeln
                       lw_text
                       col_negative   "red
                    CHANGING
                       ct_news.
        c_pop_up_up = 'X'.
        EXIT.
      WHEN 2.
        lw_mensa1 = text-i01."'No se puede enviar a SUNAT.'.
        lw_mensa2 = text-i04."'Serie y Correlativo ya han sido usados'.
        CALL FUNCTION 'MESSAGE_TEXT_BUILD'
          EXPORTING
            msgid               = '00'
            msgnr               = '368'
            msgv1               = lw_mensa1
            msgv2               = lw_mensa2
          IMPORTING
            message_text_output = lw_text.
        PERFORM _append_log_news
                    USING
                       i_vbeln
                       lw_text
                       col_negative   "red
                    CHANGING
                       ct_news.
        c_pop_up_up = 'X'.
        EXIT.
      WHEN 3.
        lw_mensa1 = text-i01."'No se puede enviar a SUNAT.'.
        CONCATENATE text-i05 "'Fecha máxima permitida es'
                    lw_fecha
                    INTO lw_mensa2 SEPARATED BY space.
        CALL FUNCTION 'MESSAGE_TEXT_BUILD'
          EXPORTING
            msgid               = '00'
            msgnr               = '368'
            msgv1               = lw_mensa1
            msgv2               = lw_mensa2
          IMPORTING
            message_text_output = lw_text.
        PERFORM _append_log_news
                    USING
                       i_vbeln
                       lw_text
                       col_negative   "red
                    CHANGING
                       ct_news.
        c_pop_up_up = 'X'.
        EXIT.
*      WHEN 4. CSM-31.10.2014 TK-30000002374
*        lw_mensa1 = TEXT-I01."'No se puede enviar a SUNAT.'.
*        lw_mensa2 = TEXT-I06."'Comprobante en referencia sin CDR aceptado'.
*        CALL FUNCTION 'MESSAGE_TEXT_BUILD'
*          EXPORTING
*            msgid               = '00'
*            msgnr               = '368'
*            msgv1               = lw_mensa1
*            msgv2               = lw_mensa2
*          IMPORTING
*            message_text_output = lw_text.
*        PERFORM _append_log_news
*                    USING
*                       i_vbeln
*                       lw_text
*                       col_negative   "red
*                    CHANGING
*                       ct_news.
*        c_pop_up_up = 'X'.
*        EXIT.
      WHEN 5.
        lw_mensa1 = text-i01."'No se puede enviar a SUNAT.'.
        CONCATENATE text-i07 "'Fecha Comp. Referencia menor a'
                    lw_fecha
                    INTO lw_mensa2 SEPARATED BY space.
        CALL FUNCTION 'MESSAGE_TEXT_BUILD'
          EXPORTING
            msgid               = '00'
            msgnr               = '368'
            msgv1               = lw_mensa1
            msgv2               = lw_mensa2
          IMPORTING
            message_text_output = lw_text.
        PERFORM _append_log_news
                    USING
                       i_vbeln
                       lw_text
                       col_negative   "red
                    CHANGING
                       ct_news.
        c_pop_up_up = 'X'.
        EXIT.
*  {  BEGIN OF INSERT WMR-290915
      WHEN 6.
        lw_mensa1 = text-i01."'No se puede enviar a SUNAT.'.
        lw_mensa2 = text-i08."'Clase de documento no corresponde'.
        lw_mensa3 = text-i09."'a Pila seleccionada'.
        CALL FUNCTION 'MESSAGE_TEXT_BUILD'
          EXPORTING
            msgid               = '00'
            msgnr               = '368'
            msgv1               = lw_mensa1
            msgv2               = lw_mensa2
          IMPORTING
            message_text_output = lw_text.
        PERFORM _append_log_news
                    USING
                       i_vbeln
                       lw_text
                       col_negative   "red
                    CHANGING
                       ct_news.
        c_pop_up_up = 'X'.
        EXIT.
*  }  END OF INSERT WMR-290915
    ENDCASE.
  ENDIF.


ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  AMP02_INICIALIZA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM amp02_inicializa .

  "Limpiar
  CLEAR: zamp, zconst.

  "Obtiene constantes
  PERFORM get_constantes.

* Valida edición
  "    zamp-is_edicion = abap_on.

* Valida sociedad
  "      zamp-is_sociedad = abap_on.

* Valida ampliación activa
  IF zconst-f_activ <= sy-datum AND zconst-f_activ IS NOT INITIAL.
    zamp-is_ampl_active = abap_on.
  ENDIF.


ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  IDCP_SEND_DOCS_TO_EBILLIING
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->IT_PRINTED_INVOICES  text
*      -->I_CHK_BILL  text
*      -->I_CHK_DELI  text
*----------------------------------------------------------------------*
FORM idcp_send_docs_to_ebilliing
    USING    it_printed_invoices TYPE zostt_printed_invoices
             i_chk_bill          TYPE clike
             i_chk_deli          TYPE clike.

  CALL FUNCTION 'ZOSFM_SEND_DOCS_TO_EBILLIING'
    EXPORTING
      it_printed_invoices = it_printed_invoices[]
      i_chkbill           = i_chk_bill                                              "I-WMR-140116
      i_chkdeli           = i_chk_deli.                                             "I-WMR-140116

ENDFORM.
