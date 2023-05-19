*&---------------------------------------------------------------------*
*&  Include           ZOSSD_INC_UPDCDR_WITH_WS_SEL
*&---------------------------------------------------------------------*
DATA ls_parsel TYPE ty_parsel.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE text-b01.
PARAMETERS:     p_bukrs   TYPE ty_parsel-bukrs MEMORY ID buk OBLIGATORY.
SELECT-OPTIONS: s_tipdoc  FOR ls_parsel-tipodoc,
                s_numero  FOR ls_parsel-numero,
                s_fecha   FOR ls_parsel-fecha DEFAULT sy-datum,
                s_status  FOR ls_parsel-status DEFAULT gc_status_2.
PARAMETERS:     p_previe  AS CHECKBOX DEFAULT 'X',
                p_submit  TYPE char01 NO-DISPLAY.
SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN BEGIN OF BLOCK block02 WITH FRAME TITLE text-b02.
PARAMETERS: p_single  AS CHECKBOX DEFAULT 'X',
            p_resbol  AS CHECKBOX DEFAULT 'X',
            p_combaj  AS CHECKBOX DEFAULT 'X',
            p_resrev  AS CHECKBOX DEFAULT ' '.                          "I-WMR-230419-3000010823
SELECTION-SCREEN END OF BLOCK block02.

*{  BEGIN OF DELETE WMR-190419-3000010823
**--------------------------------------------------------------------*
** Eventos
**--------------------------------------------------------------------*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_tipdoc-low.
*  PERFORM f4_tipdoc CHANGING s_tipdoc-low.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_tipdoc-high.
*  PERFORM f4_tipdoc CHANGING s_tipdoc-high.
*
*
*
*FORM f4_tipdoc CHANGING c_tipdoc TYPE zostb_felog-zzt_tipodoc.
*
*  TYPES: BEGIN OF ty_f4,
*           tipdoc TYPE zostb_felog-zzt_tipodoc,
*           desc   TYPE t003t-ltext,
*         END OF ty_f4.
*
*  DATA: lt_f4     TYPE TABLE OF ty_f4,
*        ls_f4     TYPE          ty_f4,
*        lt_return TYPE          ism_ddshretval,
*        ls_return TYPE          ddshretval.
*
*
**1. Obtiene datos a mostrar
*  ls_f4-tipdoc = '01'.
*  ls_f4-desc   = 'Factura'.
*  APPEND ls_f4 TO lt_f4.
*
*  ls_f4-tipdoc = '03'.
*  ls_f4-desc   = 'Boleta'.
*  APPEND ls_f4 TO lt_f4.
*
*  ls_f4-tipdoc = '07'.
*  ls_f4-desc   = 'Nota de Crédito'.
*  APPEND ls_f4 TO lt_f4.
*
*  ls_f4-tipdoc = '08'.
*  ls_f4-desc   = 'Nota de Débito'.
*  APPEND ls_f4 TO lt_f4.
*
*  ls_f4-tipdoc = 'RC'.
*  ls_f4-desc   = 'Resumen de Boletas'.
*  APPEND ls_f4 TO lt_f4.
*
*  ls_f4-tipdoc = 'RA'.
*  ls_f4-desc   = 'Comunicación de Bajas'.
*  APPEND ls_f4 TO lt_f4.
*
*
**2. Muestra ayuda de busqueda
*  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*    EXPORTING
*      retfield        = 'TIPDOC'               "Campo a devolver
*      value_org       = 'S'
*    TABLES
*      value_tab       = lt_f4
*      return_tab      = lt_return
*    EXCEPTIONS
*      parameter_error = 1
*      no_values_found = 2
*      others          = 3.
*
*
**3. Devuelve valor escogido
*  READ TABLE lt_return INTO ls_return INDEX 1.
*  IF sy-subrc = 0.
*    c_tipdoc = ls_return-fieldval.
*  ENDIF.
*
*ENDFORM.
*}  END OF DELETE WMR-190419-3000010823
