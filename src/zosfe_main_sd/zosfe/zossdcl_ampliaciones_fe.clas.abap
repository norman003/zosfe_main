class ZOSSDCL_AMPLIACIONES_FE definition
  public
  final
  create public .

public section.
  type-pools ABAP .

  methods UE_RV60AFZZ_NUMBER_RANGE
    importing
      !IT_VBRK type VBRKVB_T
    exporting
      !E_ERRMSG type STRING
    changing
      !C_FCODE type C .
  methods CONSTRUCTOR .
protected section.
PRIVATE SECTION.

  TYPES:
    tr_statcdr TYPE RANGE OF zostb_felog-zzt_status_cdr .
  TYPES:
    BEGIN OF ty_company .
          INCLUDE TYPE zostb_consextsun.
  TYPES: END OF ty_company .
  TYPES:
    th_company TYPE HASHED TABLE OF ty_company WITH UNIQUE KEY bukrs .

  CONSTANTS gc_chare TYPE char01 VALUE 'E' ##NO_TEXT.
  CONSTANTS gc_charn TYPE char01 VALUE 'N' ##NO_TEXT.
  CONSTANTS gc_chars TYPE char01 VALUE 'S' ##NO_TEXT.
  CONSTANTS gc_statuscdr_1 TYPE zosed_status_cdr VALUE '1' ##NO_TEXT.
  CONSTANTS gc_statuscdr_3 TYPE zosed_status_cdr VALUE '3' ##NO_TEXT.
  CONSTANTS gc_statuscdr_4 TYPE zosed_status_cdr VALUE '4' ##NO_TEXT.
  CONSTANTS gc_statuscdr_5 TYPE zosed_status_cdr VALUE '5' ##NO_TEXT.
  CONSTANTS gc_module TYPE string VALUE 'FE' ##NO_TEXT.
  CONSTANTS gc_aplication TYPE string VALUE 'EXTRACTOR' ##NO_TEXT.
  CONSTANTS gc_tdobject TYPE thead-tdobject VALUE 'VBBK' ##NO_TEXT.
  CONSTANTS gc_fcode_intro TYPE string VALUE 'ENT1' ##NO_TEXT.
  CONSTANTS gc_solicitante TYPE vbpa-parvw VALUE 'AG' ##NO_TEXT.
  DATA lt_company TYPE th_company .
  DATA lr_statcdr_accepted TYPE tr_statcdr .
  DATA lr_statcdr_rejected TYPE tr_statcdr .
  DATA lw_maxdays TYPE i .
  DATA lw_license TYPE string VALUE '' ##NO_TEXT.

  METHODS validar_fecha_anulacion
    IMPORTING
      !is_vbrk TYPE vbrkvb
    EXCEPTIONS
      unacceptable_canceldate .
  METHODS validar_motivo_anulacion
    IMPORTING
      !is_vbrk TYPE vbrkvb
    EXCEPTIONS
      empty_reason .
  METHODS es_doc_original_aceptado
    IMPORTING
      !is_vbrk           TYPE vbrkvb
    RETURNING
      VALUE(er_accepted) TYPE xfeld .
  METHODS es_doc_original_rechazado
    IMPORTING
      !is_vbrk           TYPE vbrkvb
    RETURNING
      VALUE(er_rejected) TYPE xfeld .
  METHODS es_doc_electronico
    IMPORTING
      !is_vbrk            TYPE vbrkvb
    RETURNING
      VALUE(er_billelect) TYPE xfeld .
ENDCLASS.



CLASS ZOSSDCL_AMPLIACIONES_FE IMPLEMENTATION.


  METHOD constructor.

    DATA: lt_constants TYPE STANDARD TABLE OF zostb_const_fe,
          ls_constants TYPE zostb_const_fe,
          ls_statcdr   LIKE LINE OF lr_statcdr_accepted.

    " Carga de Sociedad con Facturación Electrónica
    SELECT *
      INTO TABLE lt_company
      FROM zostb_consextsun.

    " Status de Aceptación Sunat
    CLEAR ls_statcdr.
    ls_statcdr = 'IEQ'.
    ls_statcdr-low  = gc_statuscdr_1.
    APPEND ls_statcdr TO lr_statcdr_accepted.

    CLEAR ls_statcdr.
    ls_statcdr = 'IEQ'.
    ls_statcdr-low  = gc_statuscdr_4.
    APPEND ls_statcdr TO lr_statcdr_accepted.

    " Status de Rechazo Sunat
    CLEAR ls_statcdr.
    ls_statcdr = 'IEQ'.
    ls_statcdr-low  = gc_statuscdr_3.
    APPEND ls_statcdr TO lr_statcdr_rejected.

*{  BEGIN OF INSERT WMR-010416
    " Error XSD también debe ir la lista de Rechazo para que deje anular
    CLEAR ls_statcdr.
    ls_statcdr = 'IEQ'.
    ls_statcdr-low  = gc_statuscdr_5.
    APPEND ls_statcdr TO lr_statcdr_rejected.
*}  END OF INSERT WMR-010416

    SELECT *
      INTO TABLE lt_constants
      FROM zostb_const_fe
      WHERE modulo      EQ gc_module
        AND aplicacion  EQ gc_aplication.

    LOOP AT lt_constants INTO ls_constants.
      CASE ls_constants-campo.
        WHEN 'FECBAJ'.
          " Días máximo para emisión de anulación
          lw_maxdays = ls_constants-valor1.
      ENDCASE.
    ENDLOOP.

*{  BEGIN OF INSERT WMR-061216-3000006187
    " Número Instalación SAP
    CALL FUNCTION 'SLIC_GET_LICENCE_NUMBER'
      IMPORTING
        license_number = lw_license.
*}  END OF INSERT WMR-061216-3000006187

  ENDMETHOD.


  METHOD es_doc_electronico.

    DATA: "lt_fecab    TYPE STANDARD TABLE OF zostb_fecab,
          lt_felog    TYPE STANDARD TABLE OF zostb_felog,
          l_tipo      TYPE string,                                      "I-WMR-190918-3000009765
          l_numera    TYPE zostb_felog-zzt_numeracion.                  "I-WMR-190918-3000009765

    er_billelect = abap_false.

    SPLIT is_vbrk-xblnr AT '-' INTO l_tipo l_numera.                    "I-WMR-190918-3000009765
    SHIFT l_numera LEFT DELETING LEADING '0'.                           "I-WMR-190918-3000009765

    " Búsqueda de documento original como documento electrónico
    SELECT zzt_nrodocsap zzt_numeracion
      INTO CORRESPONDING FIELDS OF TABLE lt_felog               ##TOO_MANY_ITAB_FIELDS
*      FROM zostb_fecab                                                 "E-3000011085-NTP180219
      FROM zostb_felog                                                  "I-3000011085-NTP180219
      WHERE zzt_nrodocsap   EQ is_vbrk-sfakn
        AND zzt_numeracion  EQ l_numera.                                "I-WMR-190918-3000009765
*        AND zzt_numeracion  EQ is_vbrk-xblnr+4.                         "E-WMR-190918-3000009765

    IF lt_felog[] IS NOT INITIAL.
      er_billelect = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD es_doc_original_aceptado.

    DATA: lt_felog    TYPE STANDARD TABLE OF zostb_felog,
          l_tipo      TYPE string,                                      "I-WMR-190918-3000009765
          l_numera    TYPE zostb_felog-zzt_numeracion.                  "I-WMR-190918-3000009765


    er_accepted = abap_false.

    SPLIT is_vbrk-xblnr AT '-' INTO l_tipo l_numera.                    "I-WMR-190918-3000009765
    SHIFT l_numera LEFT DELETING LEADING '0'.                           "I-WMR-190918-3000009765

    " Búsqueda de documento original aceptado
    SELECT zzt_nrodocsap zzt_numeracion zzt_status_cdr
      INTO CORRESPONDING FIELDS OF TABLE lt_felog          ##TOO_MANY_ITAB_FIELDS
      FROM zostb_felog
      WHERE zzt_nrodocsap   EQ is_vbrk-sfakn
        AND zzt_numeracion  EQ l_numera                                 "I-WMR-190918-3000009765
*        AND zzt_numeracion  EQ is_vbrk-xblnr+4                          "E-WMR-190918-3000009765
        AND zzt_status_cdr  IN lr_statcdr_accepted.

    IF lt_felog[] IS NOT INITIAL.
      er_accepted = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD es_doc_original_rechazado.

    DATA: lt_felog    TYPE STANDARD TABLE OF zostb_felog,
          l_tipo      TYPE string,                                      "I-WMR-190918-3000009765
          l_numera    TYPE zostb_felog-zzt_numeracion.                  "I-WMR-190918-3000009765

    er_rejected = abap_false.

    SPLIT is_vbrk-xblnr AT '-' INTO l_tipo l_numera.                    "I-WMR-190918-3000009765
    SHIFT l_numera LEFT DELETING LEADING '0'.                           "I-WMR-190918-3000009765

    " Búsqueda de documento original rechazado
    SELECT zzt_nrodocsap zzt_numeracion zzt_status_cdr
      INTO CORRESPONDING FIELDS OF TABLE lt_felog               ##TOO_MANY_ITAB_FIELDS
      FROM zostb_felog
      WHERE zzt_nrodocsap   EQ is_vbrk-sfakn
        AND zzt_numeracion  EQ l_numera                                 "I-WMR-190918-3000009765
*        AND zzt_numeracion  EQ is_vbrk-xblnr+4                          "E-WMR-190918-3000009765
        AND zzt_status_cdr  IN lr_statcdr_rejected.

    IF lt_felog[] IS NOT INITIAL.
      er_rejected = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD ue_rv60afzz_number_range.

    DATA: ls_vbrk     TYPE vbrkvb,
          ls_ceactsoc TYPE zostb_ceactsoc.

    LOOP AT it_vbrk INTO ls_vbrk.
      CASE ls_vbrk-vbtyp.
        WHEN gc_charn     " Anulación de factura
          OR gc_chars.    " Anulación de abono

          " Validar Proceso Facturación Electrónica
          SELECT SINGLE * INTO ls_ceactsoc
            FROM zostb_ceactsoc
            WHERE bukrs EQ ls_vbrk-bukrs.
          CHECK ls_ceactsoc-factele EQ abap_true.

          " Es el documento original electrónico?
          IF es_doc_electronico( ls_vbrk ) EQ abap_true.
            " Está el documento original Aceptado por Sunat
            IF es_doc_original_aceptado( ls_vbrk ) EQ abap_true.
              " Validación de Días Máximos para anulación
              validar_fecha_anulacion( EXPORTING is_vbrk = ls_vbrk
                                       EXCEPTIONS unacceptable_canceldate = 1 ).
              IF sy-subrc NE 0.
                c_fcode = gc_fcode_intro.
                MESSAGE e001(zosfe) INTO e_errmsg.
                EXIT.
              ENDIF.

              " Validar Motivo de anulación
              validar_motivo_anulacion( EXPORTING is_vbrk = ls_vbrk
                                        EXCEPTIONS empty_reason = 1 ).
              IF sy-subrc NE 0.
                c_fcode = gc_fcode_intro.
                MESSAGE e002(zosfe) INTO e_errmsg.
                EXIT.
              ENDIF.

            ELSE.
              " Está el documento original Rechazado por Sunat
              IF es_doc_original_rechazado( ls_vbrk ) EQ abap_true.
                " Permitir Anular sin validar
              ELSE.
                c_fcode = gc_fcode_intro.
                MESSAGE e003(zosfe) INTO e_errmsg.
                EXIT.
              ENDIF.

            ENDIF.
          ENDIF.

      ENDCASE.
    ENDLOOP.

  ENDMETHOD.


  METHOD validar_fecha_anulacion.

    DATA: ls_vbrk_ori TYPE vbrk,
          l_tipo      TYPE string,                                      "I-WMR-190918-3000009765
          l_numera    TYPE zostb_felog-zzt_numeracion.                  "I-WMR-190918-3000009765

    CASE lw_license.                                                                "I-WMR-061216-3000006187
      WHEN '0020855404'.      " Compañía Minera BuenaVentura                        "I-WMR-061216-3000006187
        " Búsqueda de la fecha de recepción del CDR del documento original          "I-WMR-061216-3000006187

        SPLIT is_vbrk-xblnr AT '-' INTO l_tipo l_numera.                "I-WMR-190918-3000009765
        SHIFT l_numera LEFT DELETING LEADING '0'.                       "I-WMR-190918-3000009765

        SELECT SINGLE zzt_nrodocsap zzt_fecrec             ##WARN_OK                "I-WMR-061216-3000006187
          INTO (ls_vbrk_ori-vbeln, ls_vbrk_ori-fkdat)                               "I-WMR-061216-3000006187
          FROM zostb_felog                                                          "I-WMR-061216-3000006187
          WHERE zzt_nrodocsap   EQ is_vbrk-sfakn                                    "I-WMR-061216-3000006187
            AND zzt_numeracion  EQ l_numera                             "I-WMR-190918-3000009765
*            AND zzt_numeracion  EQ is_vbrk-xblnr+4                                  "I-WMR-061216-3000006187  "E-WMR-190918-3000009765
            AND zzt_status_cdr  IN lr_statcdr_accepted.                             "I-WMR-061216-3000006187
*{I-3000011712-NTP250419
      WHEN '0021061097'.      " Cmh
        " Búsqueda de la fecha de recepción del CDR del documento original

        SPLIT is_vbrk-xblnr AT '-' INTO l_tipo l_numera.
        SHIFT l_numera LEFT DELETING LEADING '0'.

        SELECT SINGLE zzt_nrodocsap zzt_fecres             ##WARN_OK
          INTO (ls_vbrk_ori-vbeln, ls_vbrk_ori-fkdat)
          FROM zostb_felog
          WHERE zzt_nrodocsap   EQ is_vbrk-sfakn
            AND zzt_numeracion  EQ l_numera
            AND zzt_status_cdr  IN lr_statcdr_accepted.
*}I-3000011712-NTP250419
      WHEN OTHERS.                                                                  "I-WMR-061216-3000006187
        " Búsqueda de la fecha de factura del documento original
        SELECT SINGLE vbeln fkdat
          INTO (ls_vbrk_ori-vbeln, ls_vbrk_ori-fkdat)
          FROM vbrk
          WHERE vbeln EQ is_vbrk-sfakn.
    ENDCASE.                                                                        "I-WMR-061216-3000006187

    CHECK sy-subrc EQ 0.

    " Calcular fecha máxima de anulación
    CALL FUNCTION 'CALCULATE_DATE'
      EXPORTING
        days        = lw_maxdays
        start_date  = ls_vbrk_ori-fkdat
      IMPORTING
        result_date = ls_vbrk_ori-fkdat.

    " Comparar Fecha de anulación máxima contra fecha del sistema
    IF ls_vbrk_ori-fkdat LT sy-datum.
      RAISE unacceptable_canceldate.
    ENDIF.

  ENDMETHOD.


  METHOD validar_motivo_anulacion.

    DATA: lt_lines   TYPE STANDARD TABLE OF tline,
          ls_thead   TYPE thead,
          ls_company TYPE ty_company,
          l_spras    TYPE kna1-spras.             "I-NTP250817-3000006468

    READ TABLE lt_company INTO ls_company
         WITH TABLE KEY bukrs = is_vbrk-bukrs.

    CHECK ( sy-subrc EQ 0 AND ls_company-zz_tdidbaj IS NOT INITIAL ).

*{I-NTP250817-3000006468
*   1.Obtiene con el idioma del cliente
    SELECT SINGLE b~spras INTO l_spras                      ##WARN_OK
      FROM vbpa AS a INNER JOIN kna1 AS b ON a~kunnr = b~kunnr
      WHERE vbeln = is_vbrk-sfakn_rd
        AND posnr = space
        AND parvw = gc_solicitante.
    IF sy-subrc = 0.
      ls_thead-tdid     = ls_company-zz_tdidbaj.
      ls_thead-tdname   = is_vbrk-vbeln.
      ls_thead-tdobject = gc_tdobject.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = ls_thead-tdid
          language                = l_spras
          name                    = ls_thead-tdname
          object                  = ls_thead-tdobject
        TABLES
          lines                   = lt_lines
        EXCEPTIONS                ##FM_SUBRC_OK
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
    ENDIF.
*}I-NTP250817-3000006468

    IF lt_lines[] IS INITIAL.
*   2.Obtiene con el idioma del sistema
      ls_thead-tdid     = ls_company-zz_tdidbaj.
      ls_thead-tdname   = is_vbrk-vbeln.
      ls_thead-tdobject = gc_tdobject.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = ls_thead-tdid
          language                = sy-langu
          name                    = ls_thead-tdname
          object                  = ls_thead-tdobject
        TABLES
          lines                   = lt_lines
        EXCEPTIONS                  ##FM_SUBRC_OK
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF lt_lines[] IS INITIAL.
        RAISE empty_reason.
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
