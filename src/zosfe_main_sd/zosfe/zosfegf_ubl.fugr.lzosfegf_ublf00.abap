*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZOSFEVA_UBL.....................................*
FORM GET_DATA_ZOSFEVA_UBL.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZOSFETB_UBL WHERE
(VIM_WHERETAB) .
    CLEAR ZOSFEVA_UBL .
ZOSFEVA_UBL-MANDT =
ZOSFETB_UBL-MANDT .
ZOSFEVA_UBL-TPPROC =
ZOSFETB_UBL-TPPROC .
ZOSFEVA_UBL-BEGDA =
ZOSFETB_UBL-BEGDA .
ZOSFEVA_UBL-ENDDA =
ZOSFETB_UBL-ENDDA .
ZOSFEVA_UBL-ZZ_VERUBL =
ZOSFETB_UBL-ZZ_VERUBL .
ZOSFEVA_UBL-ZZ_VERESTRDOC =
ZOSFETB_UBL-ZZ_VERESTRDOC .
ZOSFEVA_UBL-ZZ_VERSIVIGEN =
ZOSFETB_UBL-ZZ_VERSIVIGEN .
<VIM_TOTAL_STRUC> = ZOSFEVA_UBL.
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
FORM DB_UPD_ZOSFEVA_UBL .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZOSFEVA_UBL.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZOSFEVA_UBL-ST_DELETE EQ GELOESCHT.
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
  SELECT SINGLE FOR UPDATE * FROM ZOSFETB_UBL WHERE
  TPPROC = ZOSFEVA_UBL-TPPROC AND
  BEGDA = ZOSFEVA_UBL-BEGDA .
    IF SY-SUBRC = 0.
    DELETE ZOSFETB_UBL .
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
  SELECT SINGLE FOR UPDATE * FROM ZOSFETB_UBL WHERE
  TPPROC = ZOSFEVA_UBL-TPPROC AND
  BEGDA = ZOSFEVA_UBL-BEGDA .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZOSFETB_UBL.
    ENDIF.
ZOSFETB_UBL-MANDT =
ZOSFEVA_UBL-MANDT .
ZOSFETB_UBL-TPPROC =
ZOSFEVA_UBL-TPPROC .
ZOSFETB_UBL-BEGDA =
ZOSFEVA_UBL-BEGDA .
ZOSFETB_UBL-ENDDA =
ZOSFEVA_UBL-ENDDA .
ZOSFETB_UBL-ZZ_VERUBL =
ZOSFEVA_UBL-ZZ_VERUBL .
ZOSFETB_UBL-ZZ_VERESTRDOC =
ZOSFEVA_UBL-ZZ_VERESTRDOC .
ZOSFETB_UBL-ZZ_VERSIVIGEN =
ZOSFEVA_UBL-ZZ_VERSIVIGEN .
    IF SY-SUBRC = 0.
    UPDATE ZOSFETB_UBL .
    ELSE.
    INSERT ZOSFETB_UBL .
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
CLEAR: STATUS_ZOSFEVA_UBL-UPD_FLAG,
STATUS_ZOSFEVA_UBL-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZOSFEVA_UBL.
  SELECT SINGLE * FROM ZOSFETB_UBL WHERE
TPPROC = ZOSFEVA_UBL-TPPROC AND
BEGDA = ZOSFEVA_UBL-BEGDA .
ZOSFEVA_UBL-MANDT =
ZOSFETB_UBL-MANDT .
ZOSFEVA_UBL-TPPROC =
ZOSFETB_UBL-TPPROC .
ZOSFEVA_UBL-BEGDA =
ZOSFETB_UBL-BEGDA .
ZOSFEVA_UBL-ENDDA =
ZOSFETB_UBL-ENDDA .
ZOSFEVA_UBL-ZZ_VERUBL =
ZOSFETB_UBL-ZZ_VERUBL .
ZOSFEVA_UBL-ZZ_VERESTRDOC =
ZOSFETB_UBL-ZZ_VERESTRDOC .
ZOSFEVA_UBL-ZZ_VERSIVIGEN =
ZOSFETB_UBL-ZZ_VERSIVIGEN .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZOSFEVA_UBL USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZOSFEVA_UBL-TPPROC TO
ZOSFETB_UBL-TPPROC .
MOVE ZOSFEVA_UBL-BEGDA TO
ZOSFETB_UBL-BEGDA .
MOVE ZOSFEVA_UBL-MANDT TO
ZOSFETB_UBL-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZOSFETB_UBL'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZOSFETB_UBL TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZOSFETB_UBL'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
