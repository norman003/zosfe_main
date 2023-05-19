*---------------------------------------------------------------------*
* Report ZOSFEGR_TMP_MOVE_CAB_TO_TEXT
*---------------------------------------------------------------------*
* Migrar de cab a txt
*---------------------------------------------------------------------*
REPORT zosfegr_tmp_update.

TYPES: BEGIN OF ty_new,
         zzcoprnro   TYPE string,
         zzcoprtpd_h TYPE string,
         zzcoprden   TYPE string,
       END OF ty_new.

DATA: lt_cab  TYPE TABLE OF zostb_fegrcab,
      lt_text TYPE TABLE OF zostb_fegrtxt,
      ls_cab  LIKE LINE OF lt_cab,
      ls_text LIKE LINE OF lt_text,
      gr      TYPE REF TO zossdcl_pro_extrac_fe_gr,
      ls_new  TYPE ty_new.
FIELD-SYMBOLS: <fs_cab> LIKE LINE OF lt_cab.

CREATE OBJECT gr.

"1. migrar a txt
SELECT COUNT(*) FROM zostb_fegrtxt.
IF sy-subrc <> 0.
  SELECT * INTO TABLE lt_cab FROM zostb_fegrcab.
  LOOP AT lt_cab INTO ls_cab.
    lt_text = gr->fegrtxt_set( is_data = ls_cab ).
  ENDLOOP.
  MODIFY zostb_fegrtxt FROM TABLE lt_text.
ENDIF.

"2. new fields actualizar zostb_fegrcab
LOOP AT lt_cab ASSIGNING <fs_cab>.
  ls_new-zzcoprnro = <fs_cab>-zzconnro.
  MOVE-CORRESPONDING ls_new TO <fs_cab>.
ENDLOOP.
MODIFY zostb_fegrcab FROM TABLE lt_cab.
