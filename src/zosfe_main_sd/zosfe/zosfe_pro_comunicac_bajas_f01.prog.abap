*&---------------------------------------------------------------------*
*&  Include           ZOSFE_PRO_COMUNICAC_BAJAS_F01
*&---------------------------------------------------------------------*
*{  BEGIN OF INSERT WMR-281016-3000005971
*&---------------------------------------------------------------------*
*&      Form  SHOW_BUTTON
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM show_button .

  DATA: ls_functxt  TYPE  smp_dyntxt.


* Nro. Instalación Sap
  CALL FUNCTION 'SLIC_GET_LICENCE_NUMBER'
    IMPORTING
      license_number = gw_license.

* Agregar botón
  IF gw_license EQ '0020316164'. "Modasa
    CLEAR ls_functxt.
    ls_functxt-icon_id    = icon_date.
    ls_functxt-quickinfo  = 'Comunicado Bajas por Fecha Factura'.
    ls_functxt-icon_text  = 'Fecha Factura'.
    sscrfields-functxt_01 = ls_functxt.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SSCRFIELDS_UCOMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sscrfields_ucomm .

  CASE sscrfields-ucomm.
    WHEN 'FC01'.
      SUBMIT zosfe_pro_comunic_baja_fecfac VIA SELECTION-SCREEN AND RETURN.
  ENDCASE.

ENDFORM.
*}  END OF INSERT WMR-281016-3000005971
*&---------------------------------------------------------------------*
*&      Form  SUBMIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM submit .

  CHECK gw_error = abap_off.                                                  "I-WMR-130319-3000010823

  IF p_baj_gr IS INITIAL.                                                 "+NTP010523-3000020188
    SUBMIT zosfe_pro_extrac_fe
      WITH p_bukrs  EQ p_bukrs
      WITH p_fecfac EQ p_fecem
      WITH p_cladoc EQ 'J'
      WITH p_chkrep EQ p_chkrep
      WITH p_getffo EQ p_getffo                                           "I-WMR-070417-3000007034
*{  BEGIN OF INSERT WMR-281016-3000005971
      WITH p_getfdo EQ abap_false
*}  END OF INSERT WMR-281016-3000005971
      AND RETURN.
*{+NTP010523-3000020188
  ELSE.
    SUBMIT zosfe_pro_extrac_fe
      WITH p_bukrs  EQ p_bukrs
      WITH p_fecfac EQ p_fecem
      WITH p_cladoc EQ 'G'
      AND RETURN.
  ENDIF.
*}+NTP010523-3000020188

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  OCULTAR_CAMPOS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ocultar_campos .

* Ocultar parámetro
  IF gw_license EQ '0020316164'. "Modasa
    LOOP AT SCREEN.
      IF screen-name CS 'P_GETFFO'.
        screen-input = 0.     " Campo editable
        screen-invisible = 1. " Campo invisible
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDFORM.
*{  BEGIN OF INSERT WMR-130319-3000010823
*&---------------------------------------------------------------------*
*&      Form  CHECKS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM checks .

  gw_error = abap_off.

  " Validar autorización a Sociedad
  zosclpell_libros_legales=>_authority_check_f_bkpf_buk(
    EXPORTING  i_bukrs = p_bukrs
    EXCEPTIONS error   = 1
               OTHERS  = 2 ).
  IF sy-subrc <> 0.
    gw_error = abap_on.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CHECK gw_error = abap_off.

ENDFORM.
*}  END OF INSERT WMR-130319-3000010823
