"Name: \PR:IDPRCNINVOICE\FO:PRINT_AND_RELEASE\SE:BEGIN\EI
ENHANCEMENT 0 ZOSFEENH_ELECTRONIC_BILLING.
*{E-SVM220618-3000009382
*  DATA: lw_fecha    TYPE char10,
*        lw_dias     TYPE char2,
*        lw_mensa1   TYPE char50,
*        lw_mensa2   TYPE char50,
*        lw_mensa3   TYPE char50.
*
*  IF CHK_PRI IS NOT INITIAL.              "Solo para IDCP Impresion
*    CALL FUNCTION 'ZOSFM_CHECKS_PRINT_AND_RELEASE'
*      EXPORTING
*        i_vbeln         = gt_xm_vmcfa-vbeln
*        i_chkbill       = chk_bill                                                      "I-WMR-140116
*        i_chkdeli       = chk_deli                                                      "I-WMR-140116
*     IMPORTING
*        e_fecha         = lw_fecha
*        e_dias          = lw_dias
*     EXCEPTIONS
*       error_serie      = 1
*       error_correla    = 2
*       error_fecha_fac  = 3
*       error_notas      = 4
*       error_fecha_not  = 5
*       error_pila       = 6                                                             "I-WMR-290915
*       OTHERS           = 7.                                                            "M-WMR-290915
*    CASE sy-subrc.
*      WHEN 1.
*        lw_mensa1 = 'No se puede enviar a SUNAT.'.
*        lw_mensa2 = 'Verificar serie y Clase de Documento'.
*        lw_mensa3 = 'Verificar estado de documento referencia'.
*        CALL FUNCTION 'MESSAGE_TEXT_BUILD'
*          EXPORTING
*            msgid               = '00'
*            msgnr               = '368'
*            msgv1               = lw_mensa1
*            msgv2               = lw_mensa2
*          IMPORTING
*            message_text_output = news-text.
*        news-vbeln   = gt_xm_vmcfa-vbeln.
*        news-color   = col_negative.                          "red
*        APPEND news.
*        pop_up_up = 'X'.
*        EXIT.
*      WHEN 2.
*        lw_mensa1 = 'No se puede enviar a SUNAT.'.
*        lw_mensa2 = 'Serie y Correlativo ya han sido usados'.
*        CALL FUNCTION 'MESSAGE_TEXT_BUILD'
*          EXPORTING
*            msgid               = '00'
*            msgnr               = '368'
*            msgv1               = lw_mensa1
*            msgv2               = lw_mensa2
*          IMPORTING
*            message_text_output = news-text.
*        news-vbeln   = gt_xm_vmcfa-vbeln.
*        news-color   = col_negative.                          "red
*        APPEND news.
*        pop_up_up = 'X'.
*        EXIT.
*      WHEN 3.
*        lw_mensa1 = 'No se puede enviar a SUNAT.'.
*        CONCATENATE 'Fecha máxima permitida es'
*                    lw_fecha
*                    INTO lw_mensa2 SEPARATED BY space.
*        CALL FUNCTION 'MESSAGE_TEXT_BUILD'
*          EXPORTING
*            msgid               = '00'
*            msgnr               = '368'
*            msgv1               = lw_mensa1
*            msgv2               = lw_mensa2
*          IMPORTING
*            message_text_output = news-text.
*        news-vbeln   = gt_xm_vmcfa-vbeln.
*        news-color   = col_negative.                          "red
*        APPEND news.
*        pop_up_up = 'X'.
*        EXIT.
**      WHEN 4. CSM-31.10.2014 TK-30000002374
**        lw_mensa1 = 'No se puede enviar a SUNAT.'.
**        lw_mensa2 = 'Comprobante en referencia sin CDR aceptado'.
**        CALL FUNCTION 'MESSAGE_TEXT_BUILD'
**          EXPORTING
**            msgid               = '00'
**            msgnr               = '368'
**            msgv1               = lw_mensa1
**            msgv2               = lw_mensa2
**          IMPORTING
**            message_text_output = news-text.
**        news-vbeln   = gt_xm_vmcfa-vbeln.
**        news-color   = col_negative.                          "red
**        APPEND news.
**        pop_up_up = 'X'.
**        EXIT.
*      WHEN 5.
*        lw_mensa1 = 'No se puede enviar a SUNAT.'.
*        CONCATENATE 'Fecha Comp. Referencia menor a'
*                    lw_fecha
*                    INTO lw_mensa2 SEPARATED BY space.
*        CALL FUNCTION 'MESSAGE_TEXT_BUILD'
*          EXPORTING
*            msgid               = '00'
*            msgnr               = '368'
*            msgv1               = lw_mensa1
*            msgv2               = lw_mensa2
*          IMPORTING
*            message_text_output = news-text.
*        news-vbeln   = gt_xm_vmcfa-vbeln.
*        news-color   = col_negative.                          "red
*        APPEND news.
*        pop_up_up = 'X'.
*        EXIT.
**  {  BEGIN OF INSERT WMR-290915
*      WHEN 6.
*        lw_mensa1 = 'No se puede enviar a SUNAT.'.
*        lw_mensa2 = 'Clase de documento no corresponde'.
*        lw_mensa3 = 'a Pila seleccionada'.
*        CALL FUNCTION 'MESSAGE_TEXT_BUILD'
*          EXPORTING
*            msgid               = '00'
*            msgnr               = '368'
*            msgv1               = lw_mensa1
*            msgv2               = lw_mensa2
*          IMPORTING
*            message_text_output = news-text.
*        news-vbeln   = gt_xm_vmcfa-vbeln.
*        news-color   = col_negative.                          "red
*        APPEND news.
*        pop_up_up = 'X'.
*        EXIT.
**  }  END OF INSERT WMR-290915
*    ENDCASE.
*  ENDIF.
*}E-SVM220618-3000009382

*{I-SVM220618-3000009382
  PERFORM amp01_idcp_print_and_release IN PROGRAM zosfe_amp_enha_idcp_print_fe
              USING
                 gt_xm_vmcfa-vbeln
                 chk_pri
                 chk_bill
                 chk_deli
              CHANGING
                 news[]
                 pop_up_up
               IF FOUND.
  IF pop_up_up = abap_true. EXIT. ENDIF.
*}I-SVM220618-3000009382

ENDENHANCEMENT.
