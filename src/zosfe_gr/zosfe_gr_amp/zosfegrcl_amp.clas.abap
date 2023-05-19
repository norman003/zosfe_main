class ZOSFEGRCL_AMP definition
  public
  create public .

public section.

  class-methods A10_VL01N_CHECK_CATALOGO
    importing
      !I_TRTYP type TRTYP
    changing
      !CS_XLIKP type LIKPVB
      !C_FCODE type CLIKE .
  class-methods A10_VL01N_GET
    importing
      !IS_LIKP type LIKP
    exporting
      !E_ZZTRSMOD_T type CLIKE
      !E_ZZTRSDEN type CLIKE .
  class-methods A10_VL01N_SET
    importing
      !IS_LIKP type LIKP
      !I_ZZTRSDEN type CLIKE
    exporting
      !ES_LIKP type LIKP .
  class-methods B10_VL01N_CHECK_TDID
    importing
      !I_TRTYP type TRTYP
      !IS_LIKP type LIKPVB .
protected section.
private section.

  class-methods RETURN_SET
    importing
      !I_MSG1 type CLIKE
      !I_MSG2 type CLIKE
      !I_MSG3 type CLIKE optional
    changing
      !CT_RETURN type BAPIRETTAB .
ENDCLASS.



CLASS ZOSFEGRCL_AMP IMPLEMENTATION.


  METHOD A10_VL01N_CHECK_CATALOGO.

    "Edicion
    IF ( i_trtyp = 'V' OR i_trtyp = 'H' ) AND cs_xlikp-updkz NE 'D'.
    ELSE.
      EXIT.
    ENDIF.

    "Accion
    "Asigna catalogo si esta vacio
    IF cs_xlikp-zztrsmot_h IS INITIAL.
      SELECT SINGLE zz_codigo_sunat INTO cs_xlikp-zztrsmot_h
        FROM zostb_catahomo20
        WHERE lfart = cs_xlikp-lfart.
      IF sy-subrc = 0.
        SELECT SINGLE a~zz_desc_cod_suna INTO cs_xlikp-zztrsden
          FROM zostb_catahomo20 AS a INNER JOIN zostb_catalogo20 AS b ON a~zz_codigo_sunat = b~zz_codigo_sunat
          WHERE a~zz_codigo_sunat = cs_xlikp-zztrsmot_h
            AND b~is_desc_cust = abap_on.
      ENDIF.
    ENDIF.
    IF cs_xlikp-zztrsmod_h IS INITIAL.
      SELECT COUNT(*) FROM zostb_catalogo20
        WHERE zz_codigo_sunat = cs_xlikp-zztrsmot_h
          AND is_trasladointerno = abap_on.
      IF sy-subrc = 0.
        cs_xlikp-zztrsmod_h = '02'. "privado
      ELSE.
        cs_xlikp-zztrsmod_h = '01'. "publico
      ENDIF.
    ENDIF.

    IF cs_xlikp-zztrsmod_h IS INITIAL AND cs_xlikp-zztrsmot_h IS INITIAL.
      MESSAGE s000 WITH 'Actualizar modalidad y motivo de transporte...' DISPLAY LIKE 'E'.
      CLEAR c_fcode.
    ELSEIF cs_xlikp-zztrsmod_h IS INITIAL.
      MESSAGE s000 WITH 'Actualizar modalidad de transporte...' DISPLAY LIKE 'E'.
      CLEAR c_fcode.
    ELSEIF cs_xlikp-zztrsmot_h IS INITIAL.
      MESSAGE s000 WITH 'Actualizar motivo de transporte...' DISPLAY LIKE 'E'.
      CLEAR c_fcode.
    ENDIF.

  ENDMETHOD.


  METHOD A10_VL01N_GET.
    DATA ls_cat20 TYPE zostb_catalogo20.

    SELECT SINGLE zz_desc_cod_suna INTO e_zztrsmod_t
      FROM zostb_catalogo18
      WHERE zz_codigo_sunat = is_likp-zztrsmod_h.

    SELECT SINGLE * INTO ls_cat20
      FROM zostb_catalogo20
      WHERE zz_codigo_sunat = is_likp-zztrsmot_h.
    IF ls_cat20-is_desc_cust IS INITIAL.
      e_zztrsden = ls_cat20-zz_desc_cod_suna.
    ELSE.
      e_zztrsden = is_likp-zztrsden.
    ENDIF.
  ENDMETHOD.


  METHOD A10_VL01N_SET.
    es_likp-zztrsmod_h = is_likp-zztrsmod_h.
    es_likp-zztrsmot_h = is_likp-zztrsmot_h.

    SELECT COUNT(*) FROM zostb_catalogo20 WHERE zz_codigo_sunat = is_likp-zztrsmot_h AND is_desc_cust = abap_on.
    IF sy-subrc = 0.
      es_likp-zztrsden = i_zztrsden.
    ENDIF.
  ENDMETHOD.


  METHOD b10_vl01n_check_tdid.
    DATA: lo_fe        TYPE REF TO zossdcl_pro_extrac_fe_gr,
          l_vbeln      TYPE vbeln,
          ls_cab       TYPE zoses_fegrcab,
          lt_line      TYPE tline_tab,
          l_lenght     TYPE i,
          c_alfanumero TYPE string,
          lt_return    TYPE bapirettab.
    CONSTANTS: c_numero TYPE string VALUE '0123456789'.

    "01. Valida
    IF i_trtyp = 'A'. "View
      RETURN.
    ENDIF.

    l_vbeln = is_likp-vbeln.
    IF l_vbeln IS INITIAL.
      l_vbeln = 'XXXXXXXXXX'.
    ENDIF.

    CREATE OBJECT lo_fe.
    lo_fe->get_constantes(
      EXPORTING
        i_vbeln  = is_likp-vbeln
        i_tpproc = 'GR'
    ).

    lo_fe->read_text_vbbk_zconst2(
      EXPORTING
        i_campo = 'TDID_CONDUCTOR'
        i_vbeln = l_vbeln
        i_kunnr = is_likp-kunnr
      IMPORTING
        e_val1  = ls_cab-zzcontpd_h "Tipo documento
        e_val2  = ls_cab-zzconnro   "Nro de documento
        e_val3  = ls_cab-zzconden   "Nombres y apellidos
        e_val4  = ls_cab-zztrabvt   "Brevete
        e_val5  = ls_cab-zzplaveh   "Número de placa del vehículo
        et_line = lt_line
    ).
    IF lt_line IS INITIAL.
      RETURN.
    ENDIF.

    "02. Valida Conductor
    CONCATENATE sy-abcde c_numero INTO c_alfanumero.
    l_lenght = strlen( ls_cab-zzcontpd_h ).
    IF ls_cab-zzcontpd_h IS INITIAL OR l_lenght <> 3.
      zosfegrcl_amp=>return_set(
        EXPORTING
          i_msg1    = 'Conductor fila 1:'
          i_msg2    = 'Actualice Tipo de documento'
          i_msg3    = '- Alfanumérico de 3 caracteres'
        CHANGING
          ct_return = lt_return
      ).
    ENDIF.
    l_lenght = strlen( ls_cab-zzconnro ).
    IF ls_cab-zzconnro IS INITIAL." OR l_lenght <> 8 OR ls_cab-zzconnro NA c_numero.
      zosfegrcl_amp=>return_set(
        EXPORTING
          i_msg1    = 'Conductor fila 2:'
          i_msg2    = 'Actualice Nro de documento'
        CHANGING
          ct_return = lt_return
      ).
    ENDIF.
    IF ls_cab-zzconden IS INITIAL.
      zosfegrcl_amp=>return_set(
        EXPORTING
          i_msg1    = 'Conductor fila 1:'
          i_msg2    = 'Actualice Nombres y apellidos'
        CHANGING
          ct_return = lt_return
      ).
    ENDIF.
    l_lenght = strlen( ls_cab-zztrabvt ).
    IF ls_cab-zztrabvt IS INITIAL OR l_lenght < 9 OR l_lenght > 10." OR ls_cab-zztrabvt NA c_alfanumero.
      zosfegrcl_amp=>return_set(
        EXPORTING
          i_msg1    = 'Conductor fila 4:'
          i_msg2    = 'Actualice Brevete'
          i_msg3    = '- Alfanumérico de 9 a 10 caracteres'
        CHANGING
          ct_return = lt_return
      ).
    ENDIF.
    l_lenght = strlen( ls_cab-zzplaveh ).
    IF ls_cab-zzplaveh IS INITIAL OR l_lenght < 6 OR l_lenght > 8." OR ls_cab-zzplaveh NA c_alfanumero.
      zosfegrcl_amp=>return_set(
        EXPORTING
          i_msg1    = 'Conductor fila 5:'
          i_msg2    = 'Actualice Placa de vehículo'
          i_msg3    = '- Alfanumérico de 6 a 8 caracteres'
        CHANGING
          ct_return = lt_return
      ).
    ENDIF.

    CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
      EXPORTING
        it_message = lt_return.
    IF lt_return IS NOT INITIAL.
      MESSAGE e000 WITH 'Actualizar datos del Conductor...'.
    ENDIF.
  ENDMETHOD.


  METHOD return_set.
    DATA: ls_return LIKE LINE OF ct_return.
    MESSAGE e000 WITH i_msg1 i_msg2 i_msg3 INTO ls_return-message.
    MOVE: sy-msgv1 TO ls_return-message_v1,
          sy-msgv2 TO ls_return-message_v2,
          sy-msgv3 TO ls_return-message_v3,
          sy-msgv4 TO ls_return-message_v4,
          sy-msgid TO ls_return-id,
          sy-msgno TO ls_return-number,
          sy-msgty TO ls_return-type.
    APPEND ls_return TO ct_return.
  ENDMETHOD.
ENDCLASS.
