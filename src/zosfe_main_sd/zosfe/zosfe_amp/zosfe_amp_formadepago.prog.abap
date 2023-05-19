*----------------------------------------------------------------------*
*                         INFORMACION GENERAL
*----------------------------------------------------------------------*
* Modulo      : FE
* Descripcion : Ampliacion para forma de pago para FE
* Ticket      : Omnia Solution SAC
* Autor       : Norman Tinco
* Fecha       : 03.03.2021
*----------------------------------------------------------------------*
REPORT zosfe_amp_formadepago MESSAGE-ID zosfe_amp.

INCLUDE zosfe_inc_formadepago_u01.
INCLUDE zosfe_inc_formadepago_c01.

*----------------------------------------------------------------------*
* Fuente : UEXIT - MV45AFZZ
*
* Proceso: VA01 - Asignar augru
*----------------------------------------------------------------------*
FORM amp01a_va01_inicializa_vbak USING is_t180 TYPE t180
                                 CHANGING cs_vbak TYPE vbak.
  CREATE OBJECT amp.
  amp->amp01a_va01_inicializa_vbak(
    EXPORTING is_t180 = is_t180
    CHANGING cs_vbak = cs_vbak
    EXCEPTIONS error = 1 ).
ENDFORM.

*----------------------------------------------------------------------*
* Fuente : UEXIT - MV45AFZZ
*
* Proceso: VA01 - Desahabilitar campos
*----------------------------------------------------------------------*
FORM amp01b_va01_disablefields USING is_t180 TYPE t180
                                     is_vbak TYPE vbak.
  CREATE OBJECT amp.
  amp->amp01b_va01_disablefields(
    EXPORTING is_t180 = is_t180
              is_vbak = is_vbak
    EXCEPTIONS error = 1 ).

ENDFORM.

*----------------------------------------------------------------------*
* Fuente : UEXIT - MV45AFZZ
*
* Proceso: VA01 - Validar
*----------------------------------------------------------------------*
FORM amp01c_va01_presave USING is_t180 TYPE t180
                               is_vbak TYPE vbak
                               is_vbkd TYPE vbkdvb
                               it_vbap TYPE tab_xyvbap
                         CHANGING e_subrc TYPE clike.
  CREATE OBJECT amp.
  amp->amp01c_va01_presave(
    EXPORTING is_t180 = is_t180
              is_vbak = is_vbak
              is_vbkd = is_vbkd
              it_vbap = it_vbap
    IMPORTING e_subrc = e_subrc
    EXCEPTIONS error = 1 ).
ENDFORM.

*----------------------------------------------------------------------*
* Fuente : UEXIT - MV45AFZZ
*
* Proceso: VA01 - Popup
*----------------------------------------------------------------------*
FORM amp01d_va01_save USING is_t180 TYPE t180
                            is_vbak TYPE vbak
                            is_vbkd TYPE vbkdvb.
  CREATE OBJECT amp.
  amp->amp01d_va01_save(
    EXPORTING is_t180 = is_t180
              is_vbak = is_vbak
              is_vbkd = is_vbkd
    EXCEPTIONS error = 1 ).
ENDFORM.

*----------------------------------------------------------------------*
* Fuente : BTE - 1420
*
* Proceso: FB02 - Disable ZTERM
*----------------------------------------------------------------------*
FORM amp02a_fb02_disablefiels USING is_bkpf TYPE bkpf
                                    i_aktyp TYPE t020-aktyp
                              CHANGING et_field TYPE zcl_amp=>tab_ofibm.
  CREATE OBJECT amp.
  amp->amp02a_fb02_disablefiels(
    EXPORTING is_bkpf = is_bkpf
              i_aktyp = i_aktyp
    CHANGING et_field = et_field
    EXCEPTIONS error = 1 ).
ENDFORM.

*----------------------------------------------------------------------*
* Fuente : WSP - ZOSFM_UPDATE_CDR_IN_SAP
*
* Proceso: WSP - Actualizar doc FI de NC cero actualiza condicion pago
*----------------------------------------------------------------------*
FORM amp03a_wsp_cdr_updatedocfi CHANGING cs_felog TYPE zostb_felog.
  CREATE OBJECT amp.
  amp->amp03a_wsp_cdr_updatedocfi(
    CHANGING cs_felog = cs_felog
    EXCEPTIONS error = 1 ).
ENDFORM.
