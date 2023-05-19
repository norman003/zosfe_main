*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_UEXIT_VF11_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  AMP01_INICIALIZA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM amp01_inicializa .

  "Limpiar
  CLEAR: zamp, zconst.

  "Obtiene constantes
  PERFORM get_constantes.

* Valida edición
  "    zamp-is_edicion = abap_on.

* Valida sociedad
  "      zamp-is_sociedad = abap_on.

* Valida ampliación activa
  IF zconst-f_activ <= sy-datum AND zconst-f_activ IS NOT INITIAL.
    zamp-is_ampl_active = abap_on.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_CONSTANTES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_constantes .

  DATA: lt_const TYPE TABLE OF zostb_constantes,
        ls_const LIKE LINE OF lt_const.

* Constantes
  IMPORT lt_const = lt_const FROM MEMORY ID 'ZOSFE_AMP_UEXIT_VF11'.
  IF lt_const IS INITIAL.
    SELECT * INTO TABLE lt_const
      FROM zostb_constantes
      WHERE modulo     EQ 'SD'
        AND aplicacion EQ 'AMPLIACION'
        AND programa   EQ 'ZOSSD_AMP_IDCP_PRINT_FE'.

    EXPORT lt_const = lt_const TO MEMORY ID 'ZOSFE_AMP_UEXIT_VF11'.
  ENDIF.

  LOOP AT lt_const INTO ls_const.
    CASE ls_const-campo.
      WHEN 'F_ACTIV'.
        CONCATENATE ls_const-valor1+6(4)
                    ls_const-valor1+3(2)
                    ls_const-valor1+0(2) INTO zconst-f_activ.
    ENDCASE.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UE_NUMBER_RANGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IT_VBRK  text
*----------------------------------------------------------------------*
FORM ue_number_range  USING    it_vbrk  TYPE vbrkvb_t.

  DATA: lo_fe_enh TYPE REF TO zossdcl_ampliaciones_fe,
        l_errmsg  TYPE string,
        l_fcode   TYPE c LENGTH 30 VALUE '(SAPMV60A)FCODE'.

  FIELD-SYMBOLS: <fs_fcode> TYPE any.

  ASSIGN (l_fcode) TO <fs_fcode>.
  IF  <fs_fcode> IS ASSIGNED
  AND <fs_fcode> EQ 'SICH'.   " Al Grabar

    CREATE OBJECT lo_fe_enh.
    lo_fe_enh->ue_rv60afzz_number_range(
      EXPORTING  it_vbrk   = it_vbrk
      IMPORTING  e_errmsg  = l_errmsg
      CHANGING   c_fcode   = <fs_fcode>
    ).
    IF l_errmsg IS NOT INITIAL.
      MESSAGE l_errmsg TYPE 'E'.
    ENDIF.
  ENDIF.

ENDFORM.
