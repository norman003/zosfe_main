*&---------------------------------------------------------------------*
*&  Include           ZOSFE_PRO_EXTRAC_FE_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  CARGA_CONSTANTES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM carga_constantes .

*{  BEGIN OF INSERT WMR-011215
  DATA: lt_constants TYPE STANDARD TABLE OF zostb_const_fe,
        ls_constants TYPE zostb_const_fe.
*}  END OF INSERT WMR-011215

*{  BEGIN OF DELETE WMR-150715
  ""* Titulo del reporte
  ""  CASE sy-tcode.
  ""    WHEN gc_tran_r.
  ""      gv_clasdoc = 'R'.
  ""      sy-title = text-t01.
  ""    WHEN gc_tran_b.
  ""      gv_clasdoc = 'J'.
  ""      sy-title = text-t02.
  ""    WHEN OTHERS.
  ""      MESSAGE text-e01 TYPE 'E'.
  ""      RETURN.
  ""  ENDCASE.
*}  END OF DELETE WMR-150715

* Rango para Identificador
  rs_status-sign   = 'I'.
  rs_status-option = 'EQ'.
  rs_status-low    = gc_status_cdr_0.
  APPEND rs_status TO gr_status.
  rs_status-sign   = 'I'.
  rs_status-option = 'EQ'.
  rs_status-low    = gc_status_cdr_5.
  APPEND rs_status TO gr_status.
  rs_status-sign   = 'I'.
  rs_status-option = 'EQ'.
  rs_status-low    = gc_status_cdr_6.
  APPEND rs_status TO gr_status.
  rs_status-sign   = 'I'.
  rs_status-option = 'EQ'.
  rs_status-low    = gc_status_cdr_7.
  APPEND rs_status TO gr_status.

*{  BEGIN OF INSERT WMR-011215
  CLEAR gs_constants.

  SELECT *
    INTO TABLE lt_constants
    FROM zostb_const_fe
    WHERE modulo      EQ gc_modul
      AND aplicacion  EQ gc_aplic.

  LOOP AT lt_constants INTO ls_constants.
    CASE ls_constants-campo.
      WHEN 'FECRES'.
        gs_constants-fecres = ls_constants-valor1.
      WHEN 'FECBAJ'.
        gs_constants-fecbaj = ls_constants-valor1.
    ENDCASE.
  ENDLOOP.
*}  END OF INSERT WMR-011215

ENDFORM.                    " CARGA_CONSTANTES

*&---------------------------------------------------------------------*
*&      Form  create_objects
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM create_objects.

*  CREATE OBJECT cl_extfac.                                                                                       "-NTP010523-3000020188
  zossdcl_pro_extrac_fe=>get_badi_object( EXPORTING i_classname = gc_classname_fe CHANGING co_obj = cl_extfac ).  "+NTP010523-3000020188

ENDFORM.                    "create_objects

*&---------------------------------------------------------------------*
*&      Form  SET_TEXTPARAM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_textparam ##NEEDED.

*{  BEGIN OF DELETE WMR-150715
  ""  CASE sy-tcode.
  ""    WHEN gc_tran_r.
  ""      %f004002_1000 = text-004.
  ""    WHEN gc_tran_b.
  ""      %f004002_1000 = text-003.
  ""    WHEN OTHERS.
  ""      MESSAGE text-e01 TYPE 'E'.
  ""      RETURN.
  ""  ENDCASE.
*}  END OF DELETE WMR-150715

ENDFORM.                    " SET_TEXTPARAM

*{E-3000011744-NTP300419
**&---------------------------------------------------------------------*
**&      Form  CHECK_DATE
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**      <--PO_ERROR  text
**----------------------------------------------------------------------*
*FORM check_date CHANGING po_error TYPE char1.
*
*  DATA: lw_fecge TYPE i,
**{  BEGIN OF INSERT WMR-011215
*        lw_max   TYPE i.
**}  END OF INSERT WMR-011215
*
**{  BEGIN OF INSERT WMR-150715
*  gv_clasdoc = p_cladoc.
**}  END OF INSERT WMR-150715
*
**{  BEGIN OF INSERT WMR-011215
*  CASE gv_clasdoc.
*    WHEN 'R'. lw_max = gs_constants-fecres.
*    WHEN 'J'. lw_max = gs_constants-fecbaj.
*  ENDCASE.
**}  END OF INSERT WMR-011215
*
*  IF gv_clasdoc = 'J'. "OR gv_clasdoc = 'R'.  "E-3000011712-NTP250419
*    lw_fecge = sy-datum - p_fecfac.
**{  BEGIN OF INSERT WMR-011215
*    ""    IF lw_fecge  > 7.
*    IF lw_fecge GT lw_max.
**}  END OF INSERT WMR-011215
*      po_error = abap_true.
*      MESSAGE text-e02 TYPE 'S'.
*    ENDIF.
*  ENDIF.
*
*ENDFORM.                    " CHECK_DATE
*}E-3000011744-NTP300419

*&---------------------------------------------------------------------*
*&      Form  get_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PO_ERROR   text
*----------------------------------------------------------------------*
FORM get_data CHANGING po_error TYPE char1.

* Extraer datos
  IF gv_clasdoc = 'R'.
*{E-NTP-221215
*    CALL METHOD cl_extfac->extrae_data_boletas_res
*      EXPORTING
*        p_fecfac  = p_fecfac
*        p_repro   = gv_repro
*      IMPORTING
*        p_error   = po_error
*        p_message = gt_message.
*}E-NTP-221215
*{R-NTP-221215
    cl_extfac->extrae_data_resumen_boletas(
      EXPORTING
        i_bukrs     = p_bukrs
        i_fkdat     = p_fecfac
        i_repro     = gv_repro
      IMPORTING
        et_return   = gt_message
      EXCEPTIONS
        error       = 1
    ).
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 DISPLAY LIKE 'E'.
    ENDIF.
*}R-NTP-221215
  ELSEIF gv_clasdoc = 'J'.
    CALL METHOD cl_extfac->extrae_data_comunicado_bajas
      EXPORTING
        p_bukrs   = p_bukrs                                       "I-WMR-200715
        p_fecfac  = p_fecfac
        p_repro   = gv_repro
        p_getfdoc = p_getfdo                                      "I-WMR-281016-3000005971
        p_getffo  = p_getffo                                      "I-WMR-070417-3000007034
      IMPORTING
*       p_error   = po_error
        p_message = gt_message
      EXCEPTIONS
        error     = 1.

* Verificar si hay datos
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 DISPLAY LIKE 'E'.
    ENDIF.
*{+NTP010523-3000020188
  ELSEIF gv_clasdoc = 'G'.
    DATA: gr TYPE REF TO object.

    zossdcl_pro_extrac_fe=>get_badi_object( EXPORTING i_classname = gc_classname_gr CHANGING co_obj = gr ).

    CALL METHOD gr->('EXTRAE_DATA_GUIA_BAJA')
      EXPORTING
        i_bukrs   = p_bukrs
        i_fecemi  = p_fecfac
      IMPORTING
        et_return = gt_message
      EXCEPTIONS
        error     = 1.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
*}+NTP010523-3000020188

*{E-NTP-221215
** Verificar si hay datos
*  IF po_error = '1'.
*    MESSAGE text-e03 TYPE 'S'.
*  ELSEIF po_error = '2'.
*    MESSAGE text-e04 TYPE 'S'.
*  ENDIF.
*}E-NTP-221215

ENDFORM.                    " GET_DATA

*&---------------------------------------------------------------------*
*&      Form  SHOW_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM show_log .

  IF gt_message[] IS NOT INITIAL.
    CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
      EXPORTING
        it_message = gt_message.
  ENDIF.

ENDFORM.                    " SHOW_LOG

*&---------------------------------------------------------------------*
*&      Form  reproceso
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PO_ERROR   text
*----------------------------------------------------------------------*
FORM reproceso CHANGING po_error TYPE char1.

  gv_clasdoc = p_cladoc.                                                "I-3000011712-NTP250419

  IF gv_clasdoc = 'J'.
    PERFORM repro_bajas CHANGING po_error.
  ELSEIF gv_clasdoc = 'R'.
    PERFORM repro_resumen CHANGING po_error.
  ENDIF.

ENDFORM.                    " REPROCESO_BAJAS

*&---------------------------------------------------------------------*
*&      Form  repro_bajas
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PO_ERROR   text
*----------------------------------------------------------------------*
FORM repro_bajas CHANGING po_error TYPE char1.

  DATA: ls_balog TYPE zostb_balog ##NEEDED.

  DATA: lw_fcreacion    TYPE zosed_fecreacion ##NEEDED,
        lw_text(150)    TYPE c,
        lv_identifibaja TYPE zosed_identifibaja.

  DATA: rl_identifibaja TYPE RANGE OF zosed_identifibaja,
        rs_identifibaja LIKE LINE OF rl_identifibaja.

* Identificador de la comunicación
  CONCATENATE 'RA-' sy-datum '*' INTO lv_identifibaja.

* Crea Rango
  rs_identifibaja-sign   = 'I'.
  rs_identifibaja-option = 'CP'.
  rs_identifibaja-low    = lv_identifibaja.
  APPEND rs_identifibaja TO rl_identifibaja.

* Ubica registro segun Fecha
  SELECT MAX( zzt_identifibaja )
  INTO lv_identifibaja
  FROM zostb_balog
*{  BEGIN OF REPLACE WMR-200715
""   WHERE zzt_femision     EQ p_fecfac
   WHERE bukrs            EQ p_bukrs
     AND zzt_femision     EQ p_fecfac
*}  END OF REPLACE WMR-200715
     AND zzt_identifibaja IN rl_identifibaja
     AND zzt_status_cdr   IN gr_status.
  IF lv_identifibaja IS NOT INITIAL.
*{  BEGIN OF INSERT WMR-150715
    IF sy-batch EQ abap_true. " Vía Job
      IF p_chkrep EQ abap_true.
        gv_repro = '1'.
      ELSE.
        gv_repro = '2'.
        po_error = abap_true.
        MESSAGE TEXT-e05 TYPE 'S'.
      ENDIF.
    ELSE.
*}  END OF INSERT WMR-150715
      CONCATENATE TEXT-t04 lv_identifibaja TEXT-t05 INTO lw_text SEPARATED BY space.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = TEXT-t03
          text_question         = lw_text
          text_button_1         = TEXT-i01
          text_button_2         = TEXT-i02
          default_button        = '1'
          display_cancel_button = ' '
          start_column          = 25
          start_row             = 6
        IMPORTING
          answer                = gv_repro
        EXCEPTIONS
          text_not_found        = 1
          OTHERS                = 2.
      IF sy-subrc <> 0 ##NEEDED.
* Implement suitable error handling here
      ENDIF.
      IF gv_repro <> '1'.
        po_error = abap_true.
      ENDIF.
*{  BEGIN OF INSERT WMR-150715
    ENDIF.
*}  END OF INSERT WMR-150715
  ENDIF.

ENDFORM.                    " REPRO_BAJAS

*&---------------------------------------------------------------------*
*&      Form  repro_resumen
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PO_ERROR   text
*----------------------------------------------------------------------*
FORM repro_resumen CHANGING po_error TYPE char1.

  DATA: ls_rblog TYPE zostb_rblog ##NEEDED.

  DATA: lw_fcreacion    TYPE zosed_fecreacion ##NEEDED,
        lw_text(150)    TYPE c,
        lv_identifiresu TYPE zosed_identifiresu,
        lw_fecha(10)    TYPE c.

  DATA: rl_identifiresu TYPE RANGE OF zosed_identifiresu,
        rs_identifiresu LIKE LINE OF rl_identifiresu.

* Identificador de la Comunicación
  CONCATENATE 'RC-' p_fecfac '*' INTO lv_identifiresu.

* Crea Rango
  rs_identifiresu-sign   = 'I'.
  rs_identifiresu-option = 'CP'.
  rs_identifiresu-low    = lv_identifiresu.
  APPEND rs_identifiresu TO rl_identifiresu.

* Ubica registro segun Fecha
  CONCATENATE p_fecfac+6(2) p_fecfac+4(2) p_fecfac+0(4) INTO lw_fecha SEPARATED BY '.'.
  SELECT MAX( zzt_identifiresu )
  INTO lv_identifiresu
  FROM zostb_rblog
*{  BEGIN OF REPLACE WMR-200715
""   WHERE zzt_femision     EQ p_fecfac
   WHERE bukrs            EQ p_bukrs
     AND zzt_femision     EQ p_fecfac
*}  END OF REPLACE WMR-200715
*     AND zzt_identifiresu IN  rl_identifiresu  "Se comenta porque para el reproceso solo se trabaja con la Fecha de Emisión
     AND zzt_status_cdr   IN  gr_status.
  IF lv_identifiresu IS NOT INITIAL.
*{  BEGIN OF INSERT WMR-150715
    IF sy-batch EQ abap_true. " Vía Job
      IF p_chkrep EQ abap_true.
        gv_repro = '1'.
      ELSE.
        gv_repro = '2'.
        po_error = abap_true.
        MESSAGE TEXT-e05 TYPE 'S'.
      ENDIF.
    ELSE.
*}  END OF INSERT WMR-150715
      CONCATENATE TEXT-t06 lw_fecha TEXT-t04 TEXT-t05 INTO lw_text SEPARATED BY space.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = TEXT-t03
          text_question         = lw_text
          text_button_1         = TEXT-i01
          text_button_2         = TEXT-i02
          default_button        = '1'
          display_cancel_button = ' '
          start_column          = 25
          start_row             = 6
        IMPORTING
          answer                = gv_repro
        EXCEPTIONS
          text_not_found        = 1
          OTHERS                = 2.
      IF sy-subrc <> 0 ##NEEDED.
* Implement suitable error handling here
      ENDIF.
      IF gv_repro <> '1'.
        po_error = abap_true.
      ENDIF.
*{  BEGIN OF INSERT WMR-150715
    ENDIF.
*}  END OF INSERT WMR-150715
  ENDIF.

ENDFORM.                    " REPRO_RESUMEN
*{  BEGIN OF INSERT WMR-071116-3000005897
*&---------------------------------------------------------------------*
*&      Form  CHECK_PROC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GV_ERROR  text
*----------------------------------------------------------------------*
FORM check_proc  CHANGING po_error TYPE char1.

  DATA: ls_ceactsoc  TYPE zostb_ceactsoc.

  SELECT SINGLE *
    INTO ls_ceactsoc
    FROM zostb_ceactsoc
    WHERE bukrs EQ p_bukrs.

  IF ls_ceactsoc-factele NE abap_true.
    po_error = abap_true.
    MESSAGE TEXT-e06 TYPE 'S'.
  ENDIF.

*{+NTP010523-3000020188
  IF ls_ceactsoc-guiaele NE abap_true.
    po_error = abap_true.
    MESSAGE TEXT-e07 TYPE 'S'.
  ENDIF.
*}+NTP010523-3000020188

ENDFORM.
*}  END OF INSERT WMR-071116-3000005897
*{  BEGIN OF INSERT WMR-130319-3000010823
*&---------------------------------------------------------------------*
*&      Form  CHECK_AUTHORITY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GV_ERROR  text
*----------------------------------------------------------------------*
FORM check_authority  CHANGING po_error TYPE char1.

  " Validar autorización a Sociedad
  zosclpell_libros_legales=>_authority_check_f_bkpf_buk(
    EXPORTING  i_bukrs = p_bukrs
    EXCEPTIONS error   = 1
               OTHERS  = 2 ).
  IF sy-subrc <> 0.
    po_error = abap_true.
    MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*}  END OF INSERT WMR-130319-3000010823
