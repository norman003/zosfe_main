*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZOSVA_CONSTAKONV................................*
FORM GET_DATA_ZOSVA_CONSTAKONV.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZOSTB_CONSTAKONV WHERE
(VIM_WHERETAB) .
    CLEAR ZOSVA_CONSTAKONV .
ZOSVA_CONSTAKONV-MANDT =
ZOSTB_CONSTAKONV-MANDT .
ZOSVA_CONSTAKONV-KSCHL =
ZOSTB_CONSTAKONV-KSCHL .
ZOSVA_CONSTAKONV-ZZ_OPCION01 =
ZOSTB_CONSTAKONV-ZZ_OPCION01 .
ZOSVA_CONSTAKONV-ZZ_OPCION02 =
ZOSTB_CONSTAKONV-ZZ_OPCION02 .
ZOSVA_CONSTAKONV-ZZ_OPCION03 =
ZOSTB_CONSTAKONV-ZZ_OPCION03 .
ZOSVA_CONSTAKONV-FLJVTA =
ZOSTB_CONSTAKONV-FLJVTA .
<VIM_TOTAL_STRUC> = ZOSVA_CONSTAKONV.
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
FORM DB_UPD_ZOSVA_CONSTAKONV .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZOSVA_CONSTAKONV.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZOSVA_CONSTAKONV-ST_DELETE EQ GELOESCHT.
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
  SELECT SINGLE FOR UPDATE * FROM ZOSTB_CONSTAKONV WHERE
  KSCHL = ZOSVA_CONSTAKONV-KSCHL .
    IF SY-SUBRC = 0.
    DELETE ZOSTB_CONSTAKONV .
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
  SELECT SINGLE FOR UPDATE * FROM ZOSTB_CONSTAKONV WHERE
  KSCHL = ZOSVA_CONSTAKONV-KSCHL .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZOSTB_CONSTAKONV.
    ENDIF.
ZOSTB_CONSTAKONV-MANDT =
ZOSVA_CONSTAKONV-MANDT .
ZOSTB_CONSTAKONV-KSCHL =
ZOSVA_CONSTAKONV-KSCHL .
ZOSTB_CONSTAKONV-ZZ_OPCION01 =
ZOSVA_CONSTAKONV-ZZ_OPCION01 .
ZOSTB_CONSTAKONV-ZZ_OPCION02 =
ZOSVA_CONSTAKONV-ZZ_OPCION02 .
ZOSTB_CONSTAKONV-ZZ_OPCION03 =
ZOSVA_CONSTAKONV-ZZ_OPCION03 .
ZOSTB_CONSTAKONV-FLJVTA =
ZOSVA_CONSTAKONV-FLJVTA .
    IF SY-SUBRC = 0.
    UPDATE ZOSTB_CONSTAKONV .
    ELSE.
    INSERT ZOSTB_CONSTAKONV .
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
CLEAR: STATUS_ZOSVA_CONSTAKONV-UPD_FLAG,
STATUS_ZOSVA_CONSTAKONV-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZOSVA_CONSTAKONV.
  SELECT SINGLE * FROM ZOSTB_CONSTAKONV WHERE
KSCHL = ZOSVA_CONSTAKONV-KSCHL .
ZOSVA_CONSTAKONV-MANDT =
ZOSTB_CONSTAKONV-MANDT .
ZOSVA_CONSTAKONV-KSCHL =
ZOSTB_CONSTAKONV-KSCHL .
ZOSVA_CONSTAKONV-ZZ_OPCION01 =
ZOSTB_CONSTAKONV-ZZ_OPCION01 .
ZOSVA_CONSTAKONV-ZZ_OPCION02 =
ZOSTB_CONSTAKONV-ZZ_OPCION02 .
ZOSVA_CONSTAKONV-ZZ_OPCION03 =
ZOSTB_CONSTAKONV-ZZ_OPCION03 .
ZOSVA_CONSTAKONV-FLJVTA =
ZOSTB_CONSTAKONV-FLJVTA .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZOSVA_CONSTAKONV USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZOSVA_CONSTAKONV-KSCHL TO
ZOSTB_CONSTAKONV-KSCHL .
MOVE ZOSVA_CONSTAKONV-MANDT TO
ZOSTB_CONSTAKONV-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZOSTB_CONSTAKONV'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZOSTB_CONSTAKONV TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZOSTB_CONSTAKONV'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
*...processing: ZOSVA_CONSTAUART................................*
FORM GET_DATA_ZOSVA_CONSTAUART.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZOSTB_CONSTAUART WHERE
(VIM_WHERETAB) .
    CLEAR ZOSVA_CONSTAUART .
ZOSVA_CONSTAUART-MANDT =
ZOSTB_CONSTAUART-MANDT .
ZOSVA_CONSTAUART-AUART =
ZOSTB_CONSTAUART-AUART .
ZOSVA_CONSTAUART-ZZ_OPCION01 =
ZOSTB_CONSTAUART-ZZ_OPCION01 .
ZOSVA_CONSTAUART-FLJVTA =
ZOSTB_CONSTAUART-FLJVTA .
<VIM_TOTAL_STRUC> = ZOSVA_CONSTAUART.
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
FORM DB_UPD_ZOSVA_CONSTAUART .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZOSVA_CONSTAUART.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZOSVA_CONSTAUART-ST_DELETE EQ GELOESCHT.
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
  SELECT SINGLE FOR UPDATE * FROM ZOSTB_CONSTAUART WHERE
  AUART = ZOSVA_CONSTAUART-AUART .
    IF SY-SUBRC = 0.
    DELETE ZOSTB_CONSTAUART .
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
  SELECT SINGLE FOR UPDATE * FROM ZOSTB_CONSTAUART WHERE
  AUART = ZOSVA_CONSTAUART-AUART .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZOSTB_CONSTAUART.
    ENDIF.
ZOSTB_CONSTAUART-MANDT =
ZOSVA_CONSTAUART-MANDT .
ZOSTB_CONSTAUART-AUART =
ZOSVA_CONSTAUART-AUART .
ZOSTB_CONSTAUART-ZZ_OPCION01 =
ZOSVA_CONSTAUART-ZZ_OPCION01 .
ZOSTB_CONSTAUART-FLJVTA =
ZOSVA_CONSTAUART-FLJVTA .
    IF SY-SUBRC = 0.
    UPDATE ZOSTB_CONSTAUART .
    ELSE.
    INSERT ZOSTB_CONSTAUART .
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
CLEAR: STATUS_ZOSVA_CONSTAUART-UPD_FLAG,
STATUS_ZOSVA_CONSTAUART-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZOSVA_CONSTAUART.
  SELECT SINGLE * FROM ZOSTB_CONSTAUART WHERE
AUART = ZOSVA_CONSTAUART-AUART .
ZOSVA_CONSTAUART-MANDT =
ZOSTB_CONSTAUART-MANDT .
ZOSVA_CONSTAUART-AUART =
ZOSTB_CONSTAUART-AUART .
ZOSVA_CONSTAUART-ZZ_OPCION01 =
ZOSTB_CONSTAUART-ZZ_OPCION01 .
ZOSVA_CONSTAUART-FLJVTA =
ZOSTB_CONSTAUART-FLJVTA .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZOSVA_CONSTAUART USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZOSVA_CONSTAUART-AUART TO
ZOSTB_CONSTAUART-AUART .
MOVE ZOSVA_CONSTAUART-MANDT TO
ZOSTB_CONSTAUART-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZOSTB_CONSTAUART'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZOSTB_CONSTAUART TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZOSTB_CONSTAUART'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
*...processing: ZOSVA_CONSTFKART................................*
FORM GET_DATA_ZOSVA_CONSTFKART.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZOSTB_CONSTFKART WHERE
(VIM_WHERETAB) .
    CLEAR ZOSVA_CONSTFKART .
ZOSVA_CONSTFKART-MANDT =
ZOSTB_CONSTFKART-MANDT .
ZOSVA_CONSTFKART-FKART =
ZOSTB_CONSTFKART-FKART .
ZOSVA_CONSTFKART-ZZ_OPCION01 =
ZOSTB_CONSTFKART-ZZ_OPCION01 .
ZOSVA_CONSTFKART-ZZ_OPCION02 =
ZOSTB_CONSTFKART-ZZ_OPCION02 .
ZOSVA_CONSTFKART-FLJVTA =
ZOSTB_CONSTFKART-FLJVTA .
<VIM_TOTAL_STRUC> = ZOSVA_CONSTFKART.
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
FORM DB_UPD_ZOSVA_CONSTFKART .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZOSVA_CONSTFKART.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZOSVA_CONSTFKART-ST_DELETE EQ GELOESCHT.
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
  SELECT SINGLE FOR UPDATE * FROM ZOSTB_CONSTFKART WHERE
  FKART = ZOSVA_CONSTFKART-FKART AND
  ZZ_OPCION01 = ZOSVA_CONSTFKART-ZZ_OPCION01 AND
  ZZ_OPCION02 = ZOSVA_CONSTFKART-ZZ_OPCION02 .
    IF SY-SUBRC = 0.
    DELETE ZOSTB_CONSTFKART .
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
  SELECT SINGLE FOR UPDATE * FROM ZOSTB_CONSTFKART WHERE
  FKART = ZOSVA_CONSTFKART-FKART AND
  ZZ_OPCION01 = ZOSVA_CONSTFKART-ZZ_OPCION01 AND
  ZZ_OPCION02 = ZOSVA_CONSTFKART-ZZ_OPCION02 .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZOSTB_CONSTFKART.
    ENDIF.
ZOSTB_CONSTFKART-MANDT =
ZOSVA_CONSTFKART-MANDT .
ZOSTB_CONSTFKART-FKART =
ZOSVA_CONSTFKART-FKART .
ZOSTB_CONSTFKART-ZZ_OPCION01 =
ZOSVA_CONSTFKART-ZZ_OPCION01 .
ZOSTB_CONSTFKART-ZZ_OPCION02 =
ZOSVA_CONSTFKART-ZZ_OPCION02 .
ZOSTB_CONSTFKART-FLJVTA =
ZOSVA_CONSTFKART-FLJVTA .
    IF SY-SUBRC = 0.
    UPDATE ZOSTB_CONSTFKART .
    ELSE.
    INSERT ZOSTB_CONSTFKART .
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
CLEAR: STATUS_ZOSVA_CONSTFKART-UPD_FLAG,
STATUS_ZOSVA_CONSTFKART-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZOSVA_CONSTFKART.
  SELECT SINGLE * FROM ZOSTB_CONSTFKART WHERE
FKART = ZOSVA_CONSTFKART-FKART AND
ZZ_OPCION01 = ZOSVA_CONSTFKART-ZZ_OPCION01 AND
ZZ_OPCION02 = ZOSVA_CONSTFKART-ZZ_OPCION02 .
ZOSVA_CONSTFKART-MANDT =
ZOSTB_CONSTFKART-MANDT .
ZOSVA_CONSTFKART-FKART =
ZOSTB_CONSTFKART-FKART .
ZOSVA_CONSTFKART-ZZ_OPCION01 =
ZOSTB_CONSTFKART-ZZ_OPCION01 .
ZOSVA_CONSTFKART-ZZ_OPCION02 =
ZOSTB_CONSTFKART-ZZ_OPCION02 .
ZOSVA_CONSTFKART-FLJVTA =
ZOSTB_CONSTFKART-FLJVTA .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZOSVA_CONSTFKART USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZOSVA_CONSTFKART-FKART TO
ZOSTB_CONSTFKART-FKART .
MOVE ZOSVA_CONSTFKART-ZZ_OPCION01 TO
ZOSTB_CONSTFKART-ZZ_OPCION01 .
MOVE ZOSVA_CONSTFKART-ZZ_OPCION02 TO
ZOSTB_CONSTFKART-ZZ_OPCION02 .
MOVE ZOSVA_CONSTFKART-MANDT TO
ZOSTB_CONSTFKART-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZOSTB_CONSTFKART'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZOSTB_CONSTFKART TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZOSTB_CONSTFKART'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
*...processing: ZOSVA_CONSTKDGRP................................*
FORM GET_DATA_ZOSVA_CONSTKDGRP.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZOSTB_CONSTKDGRP WHERE
(VIM_WHERETAB) .
    CLEAR ZOSVA_CONSTKDGRP .
ZOSVA_CONSTKDGRP-MANDT =
ZOSTB_CONSTKDGRP-MANDT .
ZOSVA_CONSTKDGRP-KDGRP =
ZOSTB_CONSTKDGRP-KDGRP .
ZOSVA_CONSTKDGRP-ZZ_OPCION01 =
ZOSTB_CONSTKDGRP-ZZ_OPCION01 .
ZOSVA_CONSTKDGRP-FLJVTA =
ZOSTB_CONSTKDGRP-FLJVTA .
<VIM_TOTAL_STRUC> = ZOSVA_CONSTKDGRP.
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
FORM DB_UPD_ZOSVA_CONSTKDGRP .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZOSVA_CONSTKDGRP.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZOSVA_CONSTKDGRP-ST_DELETE EQ GELOESCHT.
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
  SELECT SINGLE FOR UPDATE * FROM ZOSTB_CONSTKDGRP WHERE
  KDGRP = ZOSVA_CONSTKDGRP-KDGRP .
    IF SY-SUBRC = 0.
    DELETE ZOSTB_CONSTKDGRP .
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
  SELECT SINGLE FOR UPDATE * FROM ZOSTB_CONSTKDGRP WHERE
  KDGRP = ZOSVA_CONSTKDGRP-KDGRP .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZOSTB_CONSTKDGRP.
    ENDIF.
ZOSTB_CONSTKDGRP-MANDT =
ZOSVA_CONSTKDGRP-MANDT .
ZOSTB_CONSTKDGRP-KDGRP =
ZOSVA_CONSTKDGRP-KDGRP .
ZOSTB_CONSTKDGRP-ZZ_OPCION01 =
ZOSVA_CONSTKDGRP-ZZ_OPCION01 .
ZOSTB_CONSTKDGRP-FLJVTA =
ZOSVA_CONSTKDGRP-FLJVTA .
    IF SY-SUBRC = 0.
    UPDATE ZOSTB_CONSTKDGRP .
    ELSE.
    INSERT ZOSTB_CONSTKDGRP .
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
CLEAR: STATUS_ZOSVA_CONSTKDGRP-UPD_FLAG,
STATUS_ZOSVA_CONSTKDGRP-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZOSVA_CONSTKDGRP.
  SELECT SINGLE * FROM ZOSTB_CONSTKDGRP WHERE
KDGRP = ZOSVA_CONSTKDGRP-KDGRP .
ZOSVA_CONSTKDGRP-MANDT =
ZOSTB_CONSTKDGRP-MANDT .
ZOSVA_CONSTKDGRP-KDGRP =
ZOSTB_CONSTKDGRP-KDGRP .
ZOSVA_CONSTKDGRP-ZZ_OPCION01 =
ZOSTB_CONSTKDGRP-ZZ_OPCION01 .
ZOSVA_CONSTKDGRP-FLJVTA =
ZOSTB_CONSTKDGRP-FLJVTA .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZOSVA_CONSTKDGRP USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZOSVA_CONSTKDGRP-KDGRP TO
ZOSTB_CONSTKDGRP-KDGRP .
MOVE ZOSVA_CONSTKDGRP-MANDT TO
ZOSTB_CONSTKDGRP-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZOSTB_CONSTKDGRP'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZOSTB_CONSTKDGRP TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZOSTB_CONSTKDGRP'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
*...processing: ZOSVA_CONSTPSTYV................................*
FORM GET_DATA_ZOSVA_CONSTPSTYV.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZOSTB_CONSTPSTYV WHERE
(VIM_WHERETAB) .
    CLEAR ZOSVA_CONSTPSTYV .
ZOSVA_CONSTPSTYV-MANDT =
ZOSTB_CONSTPSTYV-MANDT .
ZOSVA_CONSTPSTYV-PSTYV =
ZOSTB_CONSTPSTYV-PSTYV .
ZOSVA_CONSTPSTYV-ZZ_OPCION01 =
ZOSTB_CONSTPSTYV-ZZ_OPCION01 .
ZOSVA_CONSTPSTYV-FLJVTA =
ZOSTB_CONSTPSTYV-FLJVTA .
<VIM_TOTAL_STRUC> = ZOSVA_CONSTPSTYV.
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
FORM DB_UPD_ZOSVA_CONSTPSTYV .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZOSVA_CONSTPSTYV.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZOSVA_CONSTPSTYV-ST_DELETE EQ GELOESCHT.
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
  SELECT SINGLE FOR UPDATE * FROM ZOSTB_CONSTPSTYV WHERE
  PSTYV = ZOSVA_CONSTPSTYV-PSTYV AND
  ZZ_OPCION01 = ZOSVA_CONSTPSTYV-ZZ_OPCION01 .
    IF SY-SUBRC = 0.
    DELETE ZOSTB_CONSTPSTYV .
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
  SELECT SINGLE FOR UPDATE * FROM ZOSTB_CONSTPSTYV WHERE
  PSTYV = ZOSVA_CONSTPSTYV-PSTYV AND
  ZZ_OPCION01 = ZOSVA_CONSTPSTYV-ZZ_OPCION01 .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZOSTB_CONSTPSTYV.
    ENDIF.
ZOSTB_CONSTPSTYV-MANDT =
ZOSVA_CONSTPSTYV-MANDT .
ZOSTB_CONSTPSTYV-PSTYV =
ZOSVA_CONSTPSTYV-PSTYV .
ZOSTB_CONSTPSTYV-ZZ_OPCION01 =
ZOSVA_CONSTPSTYV-ZZ_OPCION01 .
ZOSTB_CONSTPSTYV-FLJVTA =
ZOSVA_CONSTPSTYV-FLJVTA .
    IF SY-SUBRC = 0.
    UPDATE ZOSTB_CONSTPSTYV .
    ELSE.
    INSERT ZOSTB_CONSTPSTYV .
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
CLEAR: STATUS_ZOSVA_CONSTPSTYV-UPD_FLAG,
STATUS_ZOSVA_CONSTPSTYV-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZOSVA_CONSTPSTYV.
  SELECT SINGLE * FROM ZOSTB_CONSTPSTYV WHERE
PSTYV = ZOSVA_CONSTPSTYV-PSTYV AND
ZZ_OPCION01 = ZOSVA_CONSTPSTYV-ZZ_OPCION01 .
ZOSVA_CONSTPSTYV-MANDT =
ZOSTB_CONSTPSTYV-MANDT .
ZOSVA_CONSTPSTYV-PSTYV =
ZOSTB_CONSTPSTYV-PSTYV .
ZOSVA_CONSTPSTYV-ZZ_OPCION01 =
ZOSTB_CONSTPSTYV-ZZ_OPCION01 .
ZOSVA_CONSTPSTYV-FLJVTA =
ZOSTB_CONSTPSTYV-FLJVTA .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZOSVA_CONSTPSTYV USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZOSVA_CONSTPSTYV-PSTYV TO
ZOSTB_CONSTPSTYV-PSTYV .
MOVE ZOSVA_CONSTPSTYV-ZZ_OPCION01 TO
ZOSTB_CONSTPSTYV-ZZ_OPCION01 .
MOVE ZOSVA_CONSTPSTYV-MANDT TO
ZOSTB_CONSTPSTYV-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZOSTB_CONSTPSTYV'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZOSTB_CONSTPSTYV TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZOSTB_CONSTPSTYV'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*