*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZOSVA_CONST_FET.................................*
FORM GET_DATA_ZOSVA_CONST_FET.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZOSTB_CONST_FET WHERE
(VIM_WHERETAB) .
    CLEAR ZOSVA_CONST_FET .
ZOSVA_CONST_FET-MANDT =
ZOSTB_CONST_FET-MANDT .
ZOSVA_CONST_FET-SPRAS =
ZOSTB_CONST_FET-SPRAS .
ZOSVA_CONST_FET-MODULO =
ZOSTB_CONST_FET-MODULO .
ZOSVA_CONST_FET-APLICACION =
ZOSTB_CONST_FET-APLICACION .
ZOSVA_CONST_FET-PROGRAMA =
ZOSTB_CONST_FET-PROGRAMA .
ZOSVA_CONST_FET-CAMPO =
ZOSTB_CONST_FET-CAMPO .
ZOSVA_CONST_FET-TEXT =
ZOSTB_CONST_FET-TEXT .
ZOSVA_CONST_FET-OPTN =
ZOSTB_CONST_FET-OPTN .
<VIM_TOTAL_STRUC> = ZOSVA_CONST_FET.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZOSVA_CONST_FET .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZOSVA_CONST_FET.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZOSVA_CONST_FET-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZOSTB_CONST_FET WHERE
  SPRAS = ZOSVA_CONST_FET-SPRAS AND
  MODULO = ZOSVA_CONST_FET-MODULO AND
  APLICACION = ZOSVA_CONST_FET-APLICACION AND
  PROGRAMA = ZOSVA_CONST_FET-PROGRAMA AND
  CAMPO = ZOSVA_CONST_FET-CAMPO .
    IF SY-SUBRC = 0.
    DELETE ZOSTB_CONST_FET .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZOSTB_CONST_FET WHERE
  SPRAS = ZOSVA_CONST_FET-SPRAS AND
  MODULO = ZOSVA_CONST_FET-MODULO AND
  APLICACION = ZOSVA_CONST_FET-APLICACION AND
  PROGRAMA = ZOSVA_CONST_FET-PROGRAMA AND
  CAMPO = ZOSVA_CONST_FET-CAMPO .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZOSTB_CONST_FET.
    ENDIF.
ZOSTB_CONST_FET-MANDT =
ZOSVA_CONST_FET-MANDT .
ZOSTB_CONST_FET-SPRAS =
ZOSVA_CONST_FET-SPRAS .
ZOSTB_CONST_FET-MODULO =
ZOSVA_CONST_FET-MODULO .
ZOSTB_CONST_FET-APLICACION =
ZOSVA_CONST_FET-APLICACION .
ZOSTB_CONST_FET-PROGRAMA =
ZOSVA_CONST_FET-PROGRAMA .
ZOSTB_CONST_FET-CAMPO =
ZOSVA_CONST_FET-CAMPO .
ZOSTB_CONST_FET-TEXT =
ZOSVA_CONST_FET-TEXT .
ZOSTB_CONST_FET-OPTN =
ZOSVA_CONST_FET-OPTN .
    IF SY-SUBRC = 0.
    UPDATE ZOSTB_CONST_FET ##WARN_OK.
    ELSE.
    INSERT ZOSTB_CONST_FET .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZOSVA_CONST_FET-UPD_FLAG,
STATUS_ZOSVA_CONST_FET-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZOSVA_CONST_FET.
  SELECT SINGLE * FROM ZOSTB_CONST_FET WHERE
SPRAS = ZOSVA_CONST_FET-SPRAS AND
MODULO = ZOSVA_CONST_FET-MODULO AND
APLICACION = ZOSVA_CONST_FET-APLICACION AND
PROGRAMA = ZOSVA_CONST_FET-PROGRAMA AND
CAMPO = ZOSVA_CONST_FET-CAMPO .
ZOSVA_CONST_FET-MANDT =
ZOSTB_CONST_FET-MANDT .
ZOSVA_CONST_FET-SPRAS =
ZOSTB_CONST_FET-SPRAS .
ZOSVA_CONST_FET-MODULO =
ZOSTB_CONST_FET-MODULO .
ZOSVA_CONST_FET-APLICACION =
ZOSTB_CONST_FET-APLICACION .
ZOSVA_CONST_FET-PROGRAMA =
ZOSTB_CONST_FET-PROGRAMA .
ZOSVA_CONST_FET-CAMPO =
ZOSTB_CONST_FET-CAMPO .
ZOSVA_CONST_FET-TEXT =
ZOSTB_CONST_FET-TEXT .
ZOSVA_CONST_FET-OPTN =
ZOSTB_CONST_FET-OPTN .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZOSVA_CONST_FET USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZOSVA_CONST_FET-SPRAS TO
ZOSTB_CONST_FET-SPRAS .
MOVE ZOSVA_CONST_FET-MODULO TO
ZOSTB_CONST_FET-MODULO .
MOVE ZOSVA_CONST_FET-APLICACION TO
ZOSTB_CONST_FET-APLICACION .
MOVE ZOSVA_CONST_FET-PROGRAMA TO
ZOSTB_CONST_FET-PROGRAMA .
MOVE ZOSVA_CONST_FET-CAMPO TO
ZOSTB_CONST_FET-CAMPO .
MOVE ZOSVA_CONST_FET-MANDT TO
ZOSTB_CONST_FET-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZOSTB_CONST_FET'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZOSTB_CONST_FET TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZOSTB_CONST_FET'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
