*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZOSVA_CEACTSOC..................................*
FORM GET_DATA_ZOSVA_CEACTSOC.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZOSTB_CEACTSOC WHERE
(VIM_WHERETAB) .
    CLEAR ZOSVA_CEACTSOC .
ZOSVA_CEACTSOC-MANDT =
ZOSTB_CEACTSOC-MANDT .
ZOSVA_CEACTSOC-BUKRS =
ZOSTB_CEACTSOC-BUKRS .
ZOSVA_CEACTSOC-FACTELE =
ZOSTB_CEACTSOC-FACTELE .
ZOSVA_CEACTSOC-GUIAELE =
ZOSTB_CEACTSOC-GUIAELE .
ZOSVA_CEACTSOC-RETEELE =
ZOSTB_CEACTSOC-RETEELE .
ZOSVA_CEACTSOC-PERCELE =
ZOSTB_CEACTSOC-PERCELE .
ZOSVA_CEACTSOC-ERNAM =
ZOSTB_CEACTSOC-ERNAM .
ZOSVA_CEACTSOC-ERDAT =
ZOSTB_CEACTSOC-ERDAT .
ZOSVA_CEACTSOC-ERZET =
ZOSTB_CEACTSOC-ERZET .
    SELECT SINGLE * FROM T001 WHERE
BUKRS = ZOSTB_CEACTSOC-BUKRS .
    IF SY-SUBRC EQ 0.
ZOSVA_CEACTSOC-BUTXT =
T001-BUTXT .
    ENDIF.
<VIM_TOTAL_STRUC> = ZOSVA_CEACTSOC.
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
FORM DB_UPD_ZOSVA_CEACTSOC .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZOSVA_CEACTSOC.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZOSVA_CEACTSOC-ST_DELETE EQ GELOESCHT.
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
  SELECT SINGLE FOR UPDATE * FROM ZOSTB_CEACTSOC WHERE
  BUKRS = ZOSVA_CEACTSOC-BUKRS .
    IF SY-SUBRC = 0.
    DELETE ZOSTB_CEACTSOC .
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
  SELECT SINGLE FOR UPDATE * FROM ZOSTB_CEACTSOC WHERE
  BUKRS = ZOSVA_CEACTSOC-BUKRS .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZOSTB_CEACTSOC.
    ENDIF.
ZOSTB_CEACTSOC-MANDT =
ZOSVA_CEACTSOC-MANDT .
ZOSTB_CEACTSOC-BUKRS =
ZOSVA_CEACTSOC-BUKRS .
ZOSTB_CEACTSOC-FACTELE =
ZOSVA_CEACTSOC-FACTELE .
ZOSTB_CEACTSOC-GUIAELE =
ZOSVA_CEACTSOC-GUIAELE .
ZOSTB_CEACTSOC-RETEELE =
ZOSVA_CEACTSOC-RETEELE .
ZOSTB_CEACTSOC-PERCELE =
ZOSVA_CEACTSOC-PERCELE .
ZOSTB_CEACTSOC-ERNAM =
ZOSVA_CEACTSOC-ERNAM .
ZOSTB_CEACTSOC-ERDAT =
ZOSVA_CEACTSOC-ERDAT .
ZOSTB_CEACTSOC-ERZET =
ZOSVA_CEACTSOC-ERZET .
    IF SY-SUBRC = 0.
    UPDATE ZOSTB_CEACTSOC .
    ELSE.
    INSERT ZOSTB_CEACTSOC .
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
CLEAR: STATUS_ZOSVA_CEACTSOC-UPD_FLAG,
STATUS_ZOSVA_CEACTSOC-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZOSVA_CEACTSOC.
  SELECT SINGLE * FROM ZOSTB_CEACTSOC WHERE
BUKRS = ZOSVA_CEACTSOC-BUKRS .
ZOSVA_CEACTSOC-MANDT =
ZOSTB_CEACTSOC-MANDT .
ZOSVA_CEACTSOC-BUKRS =
ZOSTB_CEACTSOC-BUKRS .
ZOSVA_CEACTSOC-FACTELE =
ZOSTB_CEACTSOC-FACTELE .
ZOSVA_CEACTSOC-GUIAELE =
ZOSTB_CEACTSOC-GUIAELE .
ZOSVA_CEACTSOC-RETEELE =
ZOSTB_CEACTSOC-RETEELE .
ZOSVA_CEACTSOC-PERCELE =
ZOSTB_CEACTSOC-PERCELE .
ZOSVA_CEACTSOC-ERNAM =
ZOSTB_CEACTSOC-ERNAM .
ZOSVA_CEACTSOC-ERDAT =
ZOSTB_CEACTSOC-ERDAT .
ZOSVA_CEACTSOC-ERZET =
ZOSTB_CEACTSOC-ERZET .
    SELECT SINGLE * FROM T001 WHERE
BUKRS = ZOSTB_CEACTSOC-BUKRS .
    IF SY-SUBRC EQ 0.
ZOSVA_CEACTSOC-BUTXT =
T001-BUTXT .
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZOSVA_CEACTSOC-BUTXT .
    ENDIF.
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZOSVA_CEACTSOC USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZOSVA_CEACTSOC-BUKRS TO
ZOSTB_CEACTSOC-BUKRS .
MOVE ZOSVA_CEACTSOC-MANDT TO
ZOSTB_CEACTSOC-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZOSTB_CEACTSOC'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZOSTB_CEACTSOC TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZOSTB_CEACTSOC'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
FORM COMPL_ZOSVA_CEACTSOC USING WORKAREA.
*      provides (read-only) fields from secondary tables related
*      to primary tables by foreignkey relationships
ZOSTB_CEACTSOC-MANDT =
ZOSVA_CEACTSOC-MANDT .
ZOSTB_CEACTSOC-BUKRS =
ZOSVA_CEACTSOC-BUKRS .
ZOSTB_CEACTSOC-FACTELE =
ZOSVA_CEACTSOC-FACTELE .
ZOSTB_CEACTSOC-GUIAELE =
ZOSVA_CEACTSOC-GUIAELE .
ZOSTB_CEACTSOC-RETEELE =
ZOSVA_CEACTSOC-RETEELE .
ZOSTB_CEACTSOC-PERCELE =
ZOSVA_CEACTSOC-PERCELE .
ZOSTB_CEACTSOC-ERNAM =
ZOSVA_CEACTSOC-ERNAM .
ZOSTB_CEACTSOC-ERDAT =
ZOSVA_CEACTSOC-ERDAT .
ZOSTB_CEACTSOC-ERZET =
ZOSVA_CEACTSOC-ERZET .
    SELECT SINGLE * FROM T001 WHERE
BUKRS = ZOSTB_CEACTSOC-BUKRS .
    IF SY-SUBRC EQ 0.
ZOSVA_CEACTSOC-BUTXT =
T001-BUTXT .
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZOSVA_CEACTSOC-BUTXT .
    ENDIF.
ENDFORM.
