*-----------------------------------------------------------------*
*                         INFORMACION GENERAL
*-----------------------------------------------------------------*
* Módulo      : SD
* Objetivo    : IDCP - Impresión de Facturas Electronicas
*
* Ticket      : 3000009382 - Omnia Solution
* Id          : SVM220618
*-----------------------------------------------------------------*

REPORT zosfe_amp_enha_idcp_print_fe.


INCLUDE zosfe_inc_enha_idcp_print_top.
INCLUDE zosfe_inc_enha_idcp_print_f01.

*----------------------------------------------------------------------*
* Fuente : Enhancement - ZOSFEENH_ELECTRONIC_BILLING
*          Programa    - IDPRCNINVOICE
*
* Proceso: IDCP - Imprimir/Liberar Factura
*----------------------------------------------------------------------*
FORM amp01_idcp_print_and_release
    USING    i_vbeln      TYPE clike
             i_chk_pri    TYPE clike
             i_chk_bill   TYPE clike
             i_chk_deli   TYPE clike
    CHANGING ct_news      TYPE STANDARD TABLE
             c_pop_up_up  TYPE clike.

  "Inicializa ampliacion
  PERFORM amp01_inicializa.

* Valida
  "    CHECK zamp-is_edicion     = abap_on.
  "    CHECK zamp-is_sociedad    = abap_on.
  CHECK zamp-is_ampl_active = abap_on.

* Accion
  PERFORM idcp_print_and_release
      USING    i_vbeln
               i_chk_pri
               i_chk_bill
               i_chk_deli
      CHANGING ct_news
               c_pop_up_up.

ENDFORM.                    "amp01_idcp_print_and_release

*----------------------------------------------------------------------*
* Fuente : Enhancement - ZOSFEENH_ELECTRONIC_BILLING
*          Programa    - IDPRCNINVOICE
*
* Proceso: IDCP - Enviar documentos electrónicos
*----------------------------------------------------------------------*
FORM amp02_idcp_senddocs_ebilliing
    USING    it_printed_invoices TYPE zostt_printed_invoices
             i_chk_bill          TYPE clike
             i_chk_deli          TYPE clike.

  "Inicializa ampliacion
  PERFORM amp02_inicializa.

* Valida
  "    CHECK zamp-is_edicion     = abap_on.
  "    CHECK zamp-is_sociedad    = abap_on.
  CHECK zamp-is_ampl_active = abap_on.

* Accion
  PERFORM idcp_send_docs_to_ebilliing
      USING    it_printed_invoices
               i_chk_bill
               i_chk_deli.

ENDFORM.                    "valid_stock_reserva
