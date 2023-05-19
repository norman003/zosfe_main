"Name: \PR:IDPRCNINVOICE\FO:USER_COMMAND\SE:END\EI
ENHANCEMENT 0 ZOSFEENH_ELECTRONIC_BILLING.

*{E-SVM220618-3000009382
*  CALL FUNCTION 'ZOSFM_SEND_DOCS_TO_EBILLIING'
*    EXPORTING
*      it_printed_invoices = printed_invoices[]
*      i_chkbill           = chk_bill                                              "I-WMR-140116
*      i_chkdeli           = chk_deli.                                             "I-WMR-140116
*}E-SVM220618-3000009382

*{I-SVM220618-3000009382
  PERFORM amp02_idcp_senddocs_ebilliing IN PROGRAM zosfe_amp_enha_idcp_print_fe
              USING
                 printed_invoices[]
                 chk_bill
                 chk_deli
              IF FOUND.
*}I-SVM220618-3000009382

ENDENHANCEMENT.
