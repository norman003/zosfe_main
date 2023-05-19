*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZOSVA_FEBANK....................................*
FORM GET_DATA_ZOSVA_FEBANK.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZOSTB_FEBANK WHERE
(VIM_WHERETAB) .
    CLEAR ZOSVA_FEBANK .
ZOSVA_FEBANK-MANDT =
ZOSTB_FEBANK-MANDT .
ZOSVA_FEBANK-BUKRS =
ZOSTB_FEBANK-BUKRS .
ZOSVA_FEBANK-WAERS =
ZOSTB_FEBANK-WAERS .
ZOSVA_FEBANK-POSNR =
ZOSTB_FEBANK-POSNR .
ZOSVA_FEBANK-WAERS_T =
ZOSTB_FEBANK-WAERS_T .
ZOSVA_FEBANK-BANKL =
ZOSTB_FEBANK-BANKL .
ZOSVA_FEBANK-BANKN =
ZOSTB_FEBANK-BANKN .
ZOSVA_FEBANK-BANKN2 =
ZOSTB_FEBANK-BANKN2 .
ZOSVA_FEBANK-SEDEB =
ZOSTB_FEBANK-SEDEB .
<VIM_TOTAL_STRUC> = ZOSVA_FEBANK.
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
FORM DB_UPD_ZOSVA_FEBANK .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZOSVA_FEBANK.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZOSVA_FEBANK-ST_DELETE EQ GELOESCHT.
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
  SELECT SINGLE FOR UPDATE * FROM ZOSTB_FEBANK WHERE
  BUKRS = ZOSVA_FEBANK-BUKRS AND
  WAERS = ZOSVA_FEBANK-WAERS AND
  POSNR = ZOSVA_FEBANK-POSNR .
    IF SY-SUBRC = 0.
    DELETE ZOSTB_FEBANK .
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
  SELECT SINGLE FOR UPDATE * FROM ZOSTB_FEBANK WHERE
  BUKRS = ZOSVA_FEBANK-BUKRS AND
  WAERS = ZOSVA_FEBANK-WAERS AND
  POSNR = ZOSVA_FEBANK-POSNR .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZOSTB_FEBANK.
    ENDIF.
ZOSTB_FEBANK-MANDT =
ZOSVA_FEBANK-MANDT .
ZOSTB_FEBANK-BUKRS =
ZOSVA_FEBANK-BUKRS .
ZOSTB_FEBANK-WAERS =
ZOSVA_FEBANK-WAERS .
ZOSTB_FEBANK-POSNR =
ZOSVA_FEBANK-POSNR .
ZOSTB_FEBANK-WAERS_T =
ZOSVA_FEBANK-WAERS_T .
ZOSTB_FEBANK-BANKL =
ZOSVA_FEBANK-BANKL .
ZOSTB_FEBANK-BANKN =
ZOSVA_FEBANK-BANKN .
ZOSTB_FEBANK-BANKN2 =
ZOSVA_FEBANK-BANKN2 .
ZOSTB_FEBANK-SEDEB =
ZOSVA_FEBANK-SEDEB .
    IF SY-SUBRC = 0.
    UPDATE ZOSTB_FEBANK .
    ELSE.
    INSERT ZOSTB_FEBANK .
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
CLEAR: STATUS_ZOSVA_FEBANK-UPD_FLAG,
STATUS_ZOSVA_FEBANK-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZOSVA_FEBANK.
  SELECT SINGLE * FROM ZOSTB_FEBANK WHERE
BUKRS = ZOSVA_FEBANK-BUKRS AND
WAERS = ZOSVA_FEBANK-WAERS AND
POSNR = ZOSVA_FEBANK-POSNR .
ZOSVA_FEBANK-MANDT =
ZOSTB_FEBANK-MANDT .
ZOSVA_FEBANK-BUKRS =
ZOSTB_FEBANK-BUKRS .
ZOSVA_FEBANK-WAERS =
ZOSTB_FEBANK-WAERS .
ZOSVA_FEBANK-POSNR =
ZOSTB_FEBANK-POSNR .
ZOSVA_FEBANK-WAERS_T =
ZOSTB_FEBANK-WAERS_T .
ZOSVA_FEBANK-BANKL =
ZOSTB_FEBANK-BANKL .
ZOSVA_FEBANK-BANKN =
ZOSTB_FEBANK-BANKN .
ZOSVA_FEBANK-BANKN2 =
ZOSTB_FEBANK-BANKN2 .
ZOSVA_FEBANK-SEDEB =
ZOSTB_FEBANK-SEDEB .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZOSVA_FEBANK USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZOSVA_FEBANK-BUKRS TO
ZOSTB_FEBANK-BUKRS .
MOVE ZOSVA_FEBANK-WAERS TO
ZOSTB_FEBANK-WAERS .
MOVE ZOSVA_FEBANK-POSNR TO
ZOSTB_FEBANK-POSNR .
MOVE ZOSVA_FEBANK-MANDT TO
ZOSTB_FEBANK-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZOSTB_FEBANK'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZOSTB_FEBANK TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZOSTB_FEBANK'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*