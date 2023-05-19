FUNCTION zosfm_update_cdr_in_sap.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     VALUE(PI_BUKRS) TYPE  BUKRS
*"     VALUE(PI_TIPODOC) TYPE  ZOSD_TIPDOC
*"     VALUE(PI_NUMERA) TYPE  ZOSED_NUMERACION
*"     VALUE(PI_STATUS) TYPE  ZOSED_STATUS_CDR
*"     VALUE(PI_ERROREXT) TYPE  ZOSED_ERROREXT
*"     VALUE(PI_IDERRSUN) TYPE  ZOSED_IDERRSUN
*"     VALUE(PI_IDCDR) TYPE  ZOSED_IDCDR
*"     VALUE(PI_FECREC) TYPE  ZOSED_FECREC
*"     VALUE(PI_HORREC) TYPE  ZOSED_HORREC
*"     VALUE(PI_FECRES) TYPE  ZOSED_FECRES
*"     VALUE(PI_HORRES) TYPE  ZOSED_HORRES
*"     VALUE(PI_MENSACDR) TYPE  ZOSED_MENSACDR
*"     VALUE(PI_OBSERCDR) TYPE  ZOSED_OBSERCDR
*"  EXPORTING
*"     VALUE(PE_ANSWER) TYPE  CHAR1
*"----------------------------------------------------------------------

* Respuesta: 0 Exito, 1 Error
  pe_answer = 1.

* Asignar parámetros a variables globales
*{  BEGIN OF INSERT WMR-200715
  gw_bukrs    = pi_bukrs.
*}  END OF INSERT WMR-200715
*{  BEGIN OF INSERT WMR-170915
  gw_tipodoc  = pi_tipodoc.
*}  END OF INSERT WMR-170915
  gw_numera   = pi_numera.
  gw_status   = pi_status.
  gw_errorext = pi_errorext.
  gw_iderrsun = pi_iderrsun.
  gw_idcdr    = pi_idcdr.
  gw_fecrec   = pi_fecrec.
  gw_horrec   = pi_horrec.
  gw_fecres   = pi_fecres.
  gw_horres   = pi_horres.
  gw_mensacdr = pi_mensacdr.
  gw_obsercdr = pi_obsercdr.

* Evalua tipo de doc
  CASE pi_tipodoc.
    WHEN 'RT'.
      PERFORM upd_revret CHANGING pe_answer. EXIT. " Reversión Retencion    "I-NTP-080316
    WHEN 'PR'.
      PERFORM upd_revper CHANGING pe_answer. EXIT. " Reversión Percepcion   "I-NTP-080316
    WHEN '20' OR '40'.
      PERFORM upd_cplog CHANGING pe_answer.  EXIT. " Retención / Percepción "I-NTP-080316
  ENDCASE.

* Evaluar tipo de CDR
  CASE pi_numera(2).
    WHEN 'RC'.
      PERFORM upd_resbo CHANGING pe_answer.     " Resúmen Boletas
    WHEN 'RA'.
      PERFORM upd_bajas CHANGING pe_answer..    " Bajas
    WHEN OTHERS.
      PERFORM upd_felog CHANGING pe_answer.     " Facturas / Boletas / NC / ND
  ENDCASE.

ENDFUNCTION.
