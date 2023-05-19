*----------------------------------------------------------------------*
*                         INFORMACION GENERAL
*----------------------------------------------------------------------*
* Ticket: 3000020188 - Omnia Solution SAC
* Autor : Norman Tinco
* Fecha : 05.04.2023
*----------------------------------------------------------------------*
REPORT zosfegr_int_extract_z MESSAGE-ID zosfe.

DATA: ctrl TYPE REF TO zosfegrcl_guia_z_ctrl.

TABLES: mkpf, ekko, vbak, resb, aufk, bkpf, zostb_fegrcab.

"Parametros
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-b01.
SELECT-OPTIONS: s_ebeln FOR ekko-ebeln MEMORY ID bes.
SELECT-OPTIONS: s_mblnr FOR mkpf-mblnr MEMORY ID mbn.
SELECT-OPTIONS: s_mjahr FOR mkpf-mjahr MEMORY ID mja NO-EXTENSION NO INTERVALS.
SELECT-OPTIONS: s_vbeln FOR vbak-vbeln MEMORY ID aun.
SELECT-OPTIONS: s_aufnr FOR aufk-aufnr MEMORY ID anr.
SELECT-OPTIONS: s_rsnum FOR resb-rsnum MEMORY ID res.

"Personalizacion de los clientes
SELECT-OPTIONS: b_aib_nr FOR bkpf-arcid MATCHCODE OBJECT zsgmp_hsguia01.
SELECT-OPTIONS: b_aib_gj FOR bkpf-gjahr MEMORY ID gja NO-EXTENSION NO INTERVALS.

"Guia
SELECT-OPTIONS: s_nrosap FOR zostb_fegrcab-zznrosap.
PARAMETERS: p_gr_nro TYPE zostb_fegrcab-zznrosap NO-DISPLAY.
PARAMETERS: p_gr_gja TYPE zostb_fegrcab-zzgjahr NO-DISPLAY.
SELECTION-SCREEN END OF BLOCK b1.

"Lote
SELECTION-SCREEN BEGIN OF BLOCK o1 WITH FRAME TITLE TEXT-o01.
PARAMETERS: p_bukrs TYPE bkpf-bukrs MEMORY ID buk,
            p_lotno TYPE idcn_boma-lotno MEMORY ID lotno,
            p_bokno TYPE idcn_boma-bokno MEMORY ID bokno.
SELECTION-SCREEN END OF BLOCK o1.

"Opciones
SELECTION-SCREEN BEGIN OF BLOCK o2 WITH FRAME TITLE TEXT-o02.
PARAMETERS: p_imp RADIOBUTTON GROUP g1,
*            p_rem RADIOBUTTON GROUP g1,
            p_baj RADIOBUTTON GROUP g1.
SELECTION-SCREEN END OF BLOCK o2.


INITIALIZATION.
  CREATE OBJECT ctrl.
  ctrl->view->inicializa( ).


START-OF-SELECTION.
  ctrl->zsel-ebeln_r = s_ebeln[].
  ctrl->zsel-mjahr_r = s_mjahr[].
  ctrl->zsel-mblnr_r = s_mblnr[].
  ctrl->zsel-vbeln_r = s_vbeln[].
  ctrl->zsel-aufnr_r = s_aufnr[].
  ctrl->zsel-rsnum_r = s_rsnum[].
  ctrl->zsel-zznrosap_r   = s_nrosap[].
  ctrl->zsel-zznrosap     = p_gr_nro.
  ctrl->zsel-zzgjahr      = p_gr_gja.

  "Personalizacion de los clientes
  ctrl->zsel-aib_nrguia_r = b_aib_nr[].
  ctrl->zsel-aib_gjahr_r  = b_aib_gj[].

  ctrl->zsel-bukrs = p_bukrs.
  ctrl->zsel-lotno = p_lotno.
  ctrl->zsel-bokno = p_bokno.
  ctrl->zsel-impre = p_imp.
*  ctrl->zsel-reenu = p_rem.
  ctrl->zsel-baja  = p_baj.

  ctrl->model->start(
    EXPORTING
      io_ctrl = ctrl
    IMPORTING
      et_cab  = ctrl->gt_cab
      e_dynnr = ctrl->g_dynnr
    EXCEPTIONS
      error   = 1
  ).
  IF sy-subrc = 0.
    ctrl->view->start( EXPORTING io_ctrl = ctrl ).
  ELSE.
    ctrl->ui->message_show( ).
  ENDIF.


FORM call_screen USING i_screen.
  CALL SCREEN i_screen.
ENDFORM.
MODULE status OUTPUT.
  ctrl->view->status( ).
ENDMODULE.
MODULE user_command INPUT.
  ctrl->view->uc( ).
ENDMODULE.
