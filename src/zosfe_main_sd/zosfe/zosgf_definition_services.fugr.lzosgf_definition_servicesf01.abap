*----------------------------------------------------------------------*
***INCLUDE LZOSGF_DEFINITION_SERVICESF01.
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  upd_resbo
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PE_ANSWER  text
*----------------------------------------------------------------------*
FORM upd_resbo CHANGING pe_answer TYPE char1.

  DATA: lt_felog TYPE TABLE OF zostb_felog,
*{  BEGIN OF INSERT WMR-100118-3000008865
        lt_det_v2 TYPE TABLE OF zostb_rbdet_v2,
        ls_det_v2 TYPE zostb_rbdet_v2,
*}  END OF INSERT WMR-100118-3000008865
        ls_rblog TYPE zostb_rblog,
*{  BEGIN OF INSERT WMR-100118-3000008865
        ls_ubl TYPE zosfetb_ubl,

        l_tabix  TYPE i.
*}  END OF INSERT WMR-100118-3000008865

  FIELD-SYMBOLS: <fs_felog> LIKE LINE OF lt_felog.

***********************************************************************
* Actualizar Status del Resúmen                                       *
***********************************************************************

* Leer el registro Log
  SELECT SINGLE *
  FROM zostb_rblog
  INTO ls_rblog
  WHERE bukrs            EQ gw_bukrs                                  "I-WMR-200715
    AND zzt_identifiresu EQ gw_numera.
  IF sy-subrc NE 0.
    pe_answer = '1'.
    EXIT.
  ENDIF.

*{  BEGIN OF INSERT WMR-100118-3000008865
  " Obtener la versión de Resumen de boletas
  SELECT SINGLE * INTO ls_ubl
    FROM zosfetb_ubl
    WHERE tpproc = gc_prefix_rb    "Tipo de facturación electronica SUNAT
      AND begda <= ls_rblog-zzt_femision   "Fecha de inicio de validez
      AND endda >= ls_rblog-zzt_femision.  "Fecha fin de validez
  IF sy-subrc <> 0.
    pe_answer = '1'.  EXIT.
  ENDIF.

  CASE ls_ubl-zz_versivigen.
    WHEN gc_version_2.
      " Obtener detalle individual
      SELECT * INTO TABLE lt_det_v2
        FROM zostb_rbdet_v2
        WHERE bukrs = ls_rblog-bukrs
          AND zz_identifiresu = ls_rblog-zzt_identifiresu.
  ENDCASE.
*}  END OF INSERT WMR-100118-3000008865

* Completar valores
  ls_rblog-zzt_status_cdr = gw_status.    " Status
  ls_rblog-zzt_errorext   = gw_errorext.  " Mensaje Error Extractor
  ls_rblog-zzt_iderrsun   = gw_iderrsun.  " ID Error SUNAT
* Grurb de datos del CDR
  ls_rblog-zzt_idcdr      = gw_idcdr.
  ls_rblog-zzt_fecrec     = gw_fecrec.
  ls_rblog-zzt_horrec     = gw_horrec.
  ls_rblog-zzt_fecres     = gw_fecres.
  ls_rblog-zzt_horres     = gw_horres.
  ls_rblog-zzt_mensacdr   = gw_mensacdr.
  ls_rblog-zzt_obsercdr   = gw_obsercdr.

* Actualizar tabla
  MODIFY zostb_rblog FROM ls_rblog.

***********************************************************************
* Actualizar Status de las boletas asociadas                          *
***********************************************************************

*{  BEGIN OF DELETE WMR-160316
  ""* Verificar que el estado sea aprobado
  ""  CHECK gw_status EQ gc_status_1 OR gw_status EQ gc_status_4.
*}  END OF DELETE WMR-160316

* Obtener boletas involucradas
  SELECT *
  FROM zostb_felog
  INTO TABLE lt_felog
  WHERE zzt_identifiresu EQ gw_numera
    AND bukrs            EQ gw_bukrs.                                 "I-WMR-200715
  IF sy-subrc EQ 0.
    LOOP AT lt_felog ASSIGNING <fs_felog>.
      l_tabix = sy-tabix.                                             "I-WMR-100118-3000008865
      CASE ls_ubl-zz_versivigen.                                    "I-WMR-100118-3000008865
        WHEN gc_version_1.                                            "I-WMR-100118-3000008865
          <fs_felog>-zzt_status_cdr = gw_status.                      "I-WMR-100118-3000008865
        WHEN gc_version_2.                                            "I-WMR-100118-3000008865
          READ TABLE lt_det_v2 INTO ls_det_v2                         "I-WMR-100118-3000008865
               WITH KEY bukrs           = <fs_felog>-bukrs            "I-WMR-100118-3000008865
                        zz_identifiresu = <fs_felog>-zzt_identifiresu "I-WMR-100118-3000008865
                        zz_tipodoc      = <fs_felog>-zzt_tipodoc      "I-WMR-100118-3000008865
                        zz_serie        = <fs_felog>-zzt_numeracion.  "I-WMR-100118-3000008865
          IF sy-subrc = 0.                                            "I-WMR-100118-3000008865
            CASE ls_det_v2-zz_estadoitem.                             "I-WMR-100118-3000008865
              WHEN '1'. " Adicionar                                   "I-WMR-100118-3000008865
                <fs_felog>-zzt_status_cdr = gw_status.                "I-WMR-100118-3000008865
              WHEN '3'. " Anulado                                     "I-WMR-100118-3000008865
                CASE gw_status.                                       "I-WMR-100118-3000008865
                  WHEN gc_status_1 OR gc_status_4.                    "I-WMR-100118-3000008865
                    <fs_felog>-zzt_status_cdr = gc_status_8.          "I-WMR-100118-3000008865
                ENDCASE.                                              "I-WMR-100118-3000008865
            ENDCASE.                                                  "I-WMR-100118-3000008865
          ELSE.                                                       "I-WMR-100118-3000008865
            DELETE lt_felog INDEX l_tabix.  CONTINUE.                 "I-WMR-100118-3000008865
          ENDIF.                                                      "I-WMR-100118-3000008865
      ENDCASE.                                                        "I-WMR-100118-3000008865
      <fs_felog>-zzt_errorext   = gw_errorext.
      <fs_felog>-zzt_iderrsun   = gw_iderrsun.
      <fs_felog>-zzt_idcdr      = gw_idcdr.
      <fs_felog>-zzt_fecrec     = gw_fecrec.
      <fs_felog>-zzt_horrec     = gw_horrec.
      <fs_felog>-zzt_fecres     = gw_fecres.
      <fs_felog>-zzt_horres     = gw_horres.
      <fs_felog>-zzt_mensacdr   = gw_mensacdr.
      <fs_felog>-zzt_obsercdr   = gw_obsercdr.
    ENDLOOP.

    IF lt_felog[] IS INITIAL.                                         "I-WMR-100118-3000008865
      pe_answer = '1'.                                                "I-WMR-100118-3000008865
      ROLLBACK WORK.                                                  "I-WMR-100118-3000008865
      EXIT.                                                           "I-WMR-100118-3000008865
    ENDIF.                                                            "I-WMR-100118-3000008865
  ENDIF.

* Actualizar tabla
  MODIFY zostb_felog FROM TABLE lt_felog.

***********************************************************************
* Actualizar Parámetro de Retorno                                     *
***********************************************************************
*{BI NTP-050716
  ""  pe_answer = '0'.
* Parámetro de salida
  IF sy-subrc = 0.
    COMMIT WORK.
    pe_answer = '0'.
  ELSE.
    pe_answer = '1'.
    ROLLBACK WORK.
  ENDIF.
*}EI NTP-050716

ENDFORM.                    " UPD_RESBO

*&---------------------------------------------------------------------*
*&      Form  upd_bajas
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PE_ANSWER  text
*----------------------------------------------------------------------*
FORM upd_bajas CHANGING pe_answer TYPE char1.

  DATA: lt_felog TYPE TABLE OF zostb_felog,
        ls_balog TYPE zostb_balog.

  FIELD-SYMBOLS: <fs_felog> LIKE LINE OF lt_felog.

***********************************************************************
* Actualizar Status de Baja                                           *
***********************************************************************

* Leer el registro Log
  SELECT SINGLE *
  FROM zostb_balog
  INTO ls_balog
  WHERE bukrs            EQ gw_bukrs                                  "I-WMR-200715
    AND zzt_identifibaja EQ gw_numera.
  IF sy-subrc NE 0.
    pe_answer = '1'.
    EXIT.
  ENDIF.

* Completar valores
  ls_balog-zzt_status_cdr = gw_status.    " Status
  ls_balog-zzt_errorext   = gw_errorext.  " Mensaje Error Extractor
  ls_balog-zzt_iderrsun   = gw_iderrsun.  " ID Error SUNAT
* Grupo de datos del CDR
  ls_balog-zzt_idcdr      = gw_idcdr.
  ls_balog-zzt_fecrec     = gw_fecrec.
  ls_balog-zzt_horrec     = gw_horrec.
  ls_balog-zzt_fecres     = gw_fecres.
  ls_balog-zzt_horres     = gw_horres.
  ls_balog-zzt_mensacdr   = gw_mensacdr.
  ls_balog-zzt_obsercdr   = gw_obsercdr.

* Actualizar tabla
  MODIFY zostb_balog FROM ls_balog.

***********************************************************************
* Actualizar Parámetro de Retorno                                     *
***********************************************************************
*{BI NTP-050716
  ""  pe_answer = '0'.
* Parámetro de salida
  IF sy-subrc = 0.
    COMMIT WORK.
    pe_answer = '0'.

***********************************************************************
* Actualizar Status de los Documentos asociados                       *
***********************************************************************

* Verificar que el estado sea aprobado
    IF gw_status EQ gc_status_1 OR gw_status EQ gc_status_4.

* Obtener boletas involucradas
      SELECT *
      FROM zostb_felog
      INTO TABLE lt_felog
      WHERE zzt_identifibaja EQ gw_numera
        AND bukrs            EQ gw_bukrs.                                 "I-WMR-200715
      IF sy-subrc EQ 0.
        LOOP AT lt_felog ASSIGNING <fs_felog>.
          <fs_felog>-zzt_status_cdr = gc_status_8. "Status Baja para los documento individuales
          <fs_felog>-zzt_errorext   = gw_errorext.
          <fs_felog>-zzt_iderrsun   = gw_iderrsun.
          <fs_felog>-zzt_idcdr      = gw_idcdr.
          <fs_felog>-zzt_fecrec     = gw_fecrec.
          <fs_felog>-zzt_horrec     = gw_horrec.
          <fs_felog>-zzt_fecres     = gw_fecres.
          <fs_felog>-zzt_horres     = gw_horres.
          <fs_felog>-zzt_mensacdr   = gw_mensacdr.
          <fs_felog>-zzt_obsercdr   = gw_obsercdr.
        ENDLOOP.
      ENDIF.

* Actualizar tabla
      MODIFY zostb_felog FROM TABLE lt_felog.

***********************************************************************
* Actualizar Parámetro de Retorno                                     *
***********************************************************************
*{BI NTP-050716
      ""  pe_answer = '0'.
* Parámetro de salida
      IF sy-subrc = 0.
        COMMIT WORK.
        pe_answer = '0'.
      ELSE.
        pe_answer = '1'.
        ROLLBACK WORK.
      ENDIF.
*}EI NTP-050716
    ENDIF.
  ELSE.
    pe_answer = '1'.
    ROLLBACK WORK.
  ENDIF.

ENDFORM.                    " UPD_BAJAS

*&---------------------------------------------------------------------*
*&      Form  upd_felog
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PE_ANSWER  text
*----------------------------------------------------------------------*
FORM upd_felog CHANGING pe_answer TYPE char1.

  DATA: ls_felog TYPE zostb_felog.

* Leer el registro Log
  SELECT SINGLE *
  FROM zostb_felog
  INTO ls_felog
  WHERE zzt_numeracion EQ gw_numera
    AND bukrs          EQ gw_bukrs                                    "I-WMR-200715
    AND zzt_tipodoc    EQ gw_tipodoc.                                 "I-WMR-170915
  IF sy-subrc NE 0.
    pe_answer = '1'.
    EXIT.
  ENDIF.

* Completar valores
  ls_felog-zzt_status_cdr = gw_status.    " Status
  ls_felog-zzt_errorext   = gw_errorext.  " Mensaje Error Extractor
  ls_felog-zzt_iderrsun   = gw_iderrsun.  " ID Error SUNAT
* Grupo de datos del CDR
  ls_felog-zzt_idcdr      = gw_idcdr.
  ls_felog-zzt_fecrec     = gw_fecrec.
  ls_felog-zzt_horrec     = gw_horrec.
  ls_felog-zzt_fecres     = gw_fecres.
  ls_felog-zzt_horres     = gw_horres.
  ls_felog-zzt_mensacdr   = gw_mensacdr.
  ls_felog-zzt_obsercdr   = gw_obsercdr.

* Actualizar tabla
  MODIFY zostb_felog FROM ls_felog.

* Parámetro de salida
*{BI NTP-050716
  ""  pe_answer = '0'.
* Parámetro de salida
  IF sy-subrc = 0.
    COMMIT WORK.
    pe_answer = '0'.
  ELSE.
    pe_answer = '1'.
    ROLLBACK WORK.
  ENDIF.
*}EI NTP-050716

* Actualizar NC cero
  PERFORM amp03a_wsp_cdr_updatedocfi IN PROGRAM zosfe_amp_formadepago CHANGING ls_felog. "I-060321-NTP-3000016407

ENDFORM.                    " UPD_FELOG

*&---------------------------------------------------------------------*
*&      Form  UPD_REVRET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_PE_ANSWER  text
*----------------------------------------------------------------------*
FORM upd_revret  CHANGING pe_answer.

  DATA: lt_cplog TYPE TABLE OF zostb_cplog,
        ls_rertlog TYPE zostb_rertlog.

  FIELD-SYMBOLS: <fs_cplog> LIKE LINE OF lt_cplog.

***********************************************************************
* Actualizar Status del Resúmen                                       *
***********************************************************************

* Leer el registro Log
  SELECT SINGLE *
  FROM zostb_rertlog
  INTO ls_rertlog
  WHERE bukrs   EQ gw_bukrs
    AND zzidres EQ gw_numera.
  IF sy-subrc NE 0.
    pe_answer = '1'.
    EXIT.
  ENDIF.

* Completar valores
  ls_rertlog-zzt_status_cdr = gw_status.    " Status
  ls_rertlog-zzt_errorext   = gw_errorext.  " Mensaje Error Extractor
  ls_rertlog-zzt_iderrsun   = gw_iderrsun.  " ID Error SUNAT
* Grurb de datos del CDR
  ls_rertlog-zzt_idcdr      = gw_idcdr.
  ls_rertlog-zzt_fecrec     = gw_fecrec.
  ls_rertlog-zzt_horrec     = gw_horrec.
  ls_rertlog-zzt_fecres     = gw_fecres.
  ls_rertlog-zzt_horres     = gw_horres.
  ls_rertlog-zzt_mensacdr   = gw_mensacdr.
  ls_rertlog-zzt_obsercdr   = gw_obsercdr.

* Actualizar tabla
  MODIFY zostb_rertlog FROM ls_rertlog.

***********************************************************************
* Actualizar Parámetro de Retorno                                     *
***********************************************************************
*{BI NTP-050716
  ""  pe_answer = '0'.
* Parámetro de salida
  IF sy-subrc = 0.
    COMMIT WORK.
    pe_answer = '0'.

***********************************************************************
* Actualizar Status de las boletas asociadas                          *
***********************************************************************
* Verificar que el estado sea aprobado
    IF gw_status EQ gc_status_1 OR gw_status EQ gc_status_4.

* Obtener retenciones involucradas
      SELECT *
      FROM zostb_cplog
      INTO TABLE lt_cplog
      WHERE zzt_identifibaja EQ gw_numera
        AND bukrs            EQ gw_bukrs.
      IF sy-subrc EQ 0.
        LOOP AT lt_cplog ASSIGNING <fs_cplog>.
          <fs_cplog>-zzt_status_cdr = gc_status_8. "Status Baja para los documento individuales
          <fs_cplog>-zzt_errorext   = gw_errorext.
          <fs_cplog>-zzt_iderrsun   = gw_iderrsun.
          <fs_cplog>-zzt_idcdr      = gw_idcdr.
          <fs_cplog>-zzt_fecrec     = gw_fecrec.
          <fs_cplog>-zzt_horrec     = gw_horrec.
          <fs_cplog>-zzt_fecres     = gw_fecres.
          <fs_cplog>-zzt_horres     = gw_horres.
          <fs_cplog>-zzt_mensacdr   = gw_mensacdr.
          <fs_cplog>-zzt_obsercdr   = gw_obsercdr.
        ENDLOOP.
      ENDIF.

* Actualizar tabla
      MODIFY zostb_cplog FROM TABLE lt_cplog.

***********************************************************************
* Actualizar Parámetro de Retorno                                     *
***********************************************************************
*{BI NTP-050716
      ""  pe_answer = '0'.
* Parámetro de salida
      IF sy-subrc = 0.
        COMMIT WORK.
        pe_answer = '0'.
      ELSE.
        pe_answer = '1'.
        ROLLBACK WORK.
      ENDIF.
*}EI NTP-050716
    ENDIF.
  ELSE.
    pe_answer = '1'.
    ROLLBACK WORK.
  ENDIF.
*}EI NTP-050716

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPD_REVPER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_PE_ANSWER  text
*----------------------------------------------------------------------*
FORM upd_revper  CHANGING pe_answer.

  DATA: lt_cplog TYPE TABLE OF zostb_cplog,
        ls_reprlog TYPE zostb_reprlog.

  FIELD-SYMBOLS: <fs_cplog> LIKE LINE OF lt_cplog.

***********************************************************************
* Actualizar Status del Resúmen                                       *
***********************************************************************

* Leer el registro Log
  SELECT SINGLE *
  FROM zostb_reprlog
  INTO ls_reprlog
  WHERE bukrs   EQ gw_bukrs
    AND zzidres EQ gw_numera.
  IF sy-subrc NE 0.
    pe_answer = '1'.
    EXIT.
  ENDIF.

* Completar valores
  ls_reprlog-zzt_status_cdr = gw_status.    " Status
  ls_reprlog-zzt_errorext   = gw_errorext.  " Mensaje Error Extractor
  ls_reprlog-zzt_iderrsun   = gw_iderrsun.  " ID Error SUNAT
* Grurb de datos del CDR
  ls_reprlog-zzt_idcdr      = gw_idcdr.
  ls_reprlog-zzt_fecrec     = gw_fecrec.
  ls_reprlog-zzt_horrec     = gw_horrec.
  ls_reprlog-zzt_fecres     = gw_fecres.
  ls_reprlog-zzt_horres     = gw_horres.
  ls_reprlog-zzt_mensacdr   = gw_mensacdr.
  ls_reprlog-zzt_obsercdr   = gw_obsercdr.

* Actualizar tabla
  MODIFY zostb_reprlog FROM ls_reprlog.

***********************************************************************
* Actualizar Parámetro de Retorno                                     *
***********************************************************************
*{BI NTP-050716
  ""  pe_answer = '0'.
* Parámetro de salida
  IF sy-subrc = 0.
    COMMIT WORK.
    pe_answer = '0'.

***********************************************************************
* Actualizar Status de las boletas asociadas                          *
***********************************************************************
* Verificar que el estado sea aprobado
    IF gw_status EQ gc_status_1 OR gw_status EQ gc_status_4.

* Obtener retenciones involucradas
      SELECT *
      FROM zostb_cplog
      INTO TABLE lt_cplog
      WHERE zzt_identifibaja EQ gw_numera
        AND bukrs            EQ gw_bukrs.
      IF sy-subrc EQ 0.
        LOOP AT lt_cplog ASSIGNING <fs_cplog>.
          <fs_cplog>-zzt_status_cdr = gc_status_8. "Status Baja para los documento individuales
          <fs_cplog>-zzt_errorext   = gw_errorext.
          <fs_cplog>-zzt_iderrsun   = gw_iderrsun.
          <fs_cplog>-zzt_idcdr      = gw_idcdr.
          <fs_cplog>-zzt_fecrec     = gw_fecrec.
          <fs_cplog>-zzt_horrec     = gw_horrec.
          <fs_cplog>-zzt_fecres     = gw_fecres.
          <fs_cplog>-zzt_horres     = gw_horres.
          <fs_cplog>-zzt_mensacdr   = gw_mensacdr.
          <fs_cplog>-zzt_obsercdr   = gw_obsercdr.
        ENDLOOP.
      ENDIF.

* Actualizar tabla
      MODIFY zostb_cplog FROM TABLE lt_cplog.

***********************************************************************
* Actualizar Parámetro de Retorno                                     *
***********************************************************************
*{BI NTP-050716
      ""  pe_answer = '0'.
* Parámetro de salida
      IF sy-subrc = 0.
        COMMIT WORK.
        pe_answer = '0'.
      ELSE.
        pe_answer = '1'.
        ROLLBACK WORK.
      ENDIF.
*}EI NTP-050716
    ENDIF.
  ELSE.
    pe_answer = '1'.
    ROLLBACK WORK.
  ENDIF.
*}EI NTP-050716

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPD_CPLOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_PE_ANSWER  text
*----------------------------------------------------------------------*
FORM upd_cplog  CHANGING pe_answer.

  DATA: ls_cplog TYPE zostb_cplog.

* Leer el registro Log
  SELECT SINGLE *
  FROM zostb_cplog
  INTO ls_cplog
  WHERE zzt_numeracion EQ gw_numera
    AND bukrs          EQ gw_bukrs
    AND zzt_tipodoc    EQ gw_tipodoc.
  IF sy-subrc NE 0.
    pe_answer = '1'.
    EXIT.
  ENDIF.

* Completar valores
  ls_cplog-zzt_status_cdr = gw_status.    " Status
  ls_cplog-zzt_errorext   = gw_errorext.  " Mensaje Error Extractor
  ls_cplog-zzt_iderrsun   = gw_iderrsun.  " ID Error SUNAT
* Grupo de datos del CDR
  ls_cplog-zzt_idcdr      = gw_idcdr.
  ls_cplog-zzt_fecrec     = gw_fecrec.
  ls_cplog-zzt_horrec     = gw_horrec.
  ls_cplog-zzt_fecres     = gw_fecres.
  ls_cplog-zzt_horres     = gw_horres.
  ls_cplog-zzt_mensacdr   = gw_mensacdr.
  ls_cplog-zzt_obsercdr   = gw_obsercdr.

* Actualizar tabla
  MODIFY zostb_cplog FROM ls_cplog.

* Parámetro de salida
*{BI NTP-050716
  ""  pe_answer = '0'.
* Parámetro de salida
  IF sy-subrc = 0.
    COMMIT WORK.
    pe_answer = '0'.
  ELSE.
    pe_answer = '1'.
    ROLLBACK WORK.
  ENDIF.
*}EI NTP-050716

ENDFORM.
