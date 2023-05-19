*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_JSON_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_guia_remision.

*  DATA: lo_fe       TYPE REF TO zossdcl_pro_extrac_fe_gr,
*        lt_cab      TYPE TABLE OF zostb_fegrcab,
*        lt_det      TYPE TABLE OF zostb_fegrdet,
*        lt_cab_json TYPE TABLE OF zoses_fegrcab_json,
*        lt_det_json TYPE TABLE OF zoses_fegrdet_json.
*
*
*  "Data
*  SELECT * INTO TABLE lt_cab FROM zostb_fegrcab WHERE vbeln = p_vbeln.
*  SELECT * INTO TABLE lt_det FROM zostb_fegrdet WHERE vbeln = p_vbeln.
*
*  CREATE OBJECT lo_fe.
*
*  lo_fe->set_json_rem(
*    EXPORTING
*      pi_cab      = lt_cab
*      pi_det      = lt_det
*    IMPORTING
*      pe_cab_json = lt_cab_json
*      pe_det_json = lt_det_json
*  ).
*
*  PERFORM show_cab_det_alv USING lt_cab_json lt_det_json.

ENDFORM.                    "build_guia_remision

*&---------------------------------------------------------------------*
*&      Form  build_percepcion
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM build_percepcion.

*  DATA: lo_fe       TYPE REF TO zossdcl_pro_extrac_fe_pr,
*        lt_cab      TYPE TABLE OF zostb_feprcab,
*        lt_det      TYPE TABLE OF zostb_feprdet,
*        lt_cab_json TYPE TABLE OF zoses_feprcab_json,
*        lt_det_json TYPE TABLE OF zoses_feprdet_json.
*
*
*  "Data
*  SELECT * INTO TABLE lt_cab FROM zostb_feprcab WHERE bukrs = p_bukrs AND zznrosun = p_nrosun.
*  SELECT * INTO TABLE lt_det FROM zostb_feprdet WHERE bukrs = p_bukrs AND zznrosun = p_nrosun.
*
*  CREATE OBJECT lo_fe.
*
*  lo_fe->set_json_per(
*    EXPORTING
*      it_cab      = lt_cab
*      it_det      = lt_det
*    IMPORTING
*      et_cab_json = lt_cab_json
*      et_det_json = lt_det_json
*  ).
*
*  PERFORM show_cab_det_alv USING lt_cab_json lt_det_json.

ENDFORM.                    "build_percepcion

*&---------------------------------------------------------------------*
*&      Form  build_retencion
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM build_retencion.

  DATA: lo_fe       TYPE REF TO zossdcl_pro_extrac_fe_rt,
        lt_cab      TYPE TABLE OF zostb_fertcab,
        lt_det      TYPE TABLE OF zostb_fertdet,
        lt_cab_json TYPE TABLE OF zoses_fertcab_json,
        lt_det_json TYPE TABLE OF zoses_fertdet_json.


  "Data
  SELECT * INTO TABLE lt_cab FROM zostb_fertcab WHERE bukrs = p_bukrs AND zznrosun = p_nrosun.
  SELECT * INTO TABLE lt_det FROM zostb_fertdet WHERE bukrs = p_bukrs AND zznrosun = p_nrosun.

  CREATE OBJECT lo_fe.

  lo_fe->set_json_ret(
    EXPORTING
      it_cab      = lt_cab
      it_det      = lt_det
    IMPORTING
      et_cab_json = lt_cab_json
      et_det_json = lt_det_json
  ).

  PERFORM show_cab_det_alv USING lt_cab_json lt_det_json.

ENDFORM.                    "build_retencion

*&---------------------------------------------------------------------*
*&      Form  build_rev_percepcion
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM build_rev_percepcion.

*  DATA: lo_fe       TYPE REF TO zossdcl_pro_extrac_fe_pr,
*        lt_cab      TYPE TABLE OF zostb_reprcab,
*        lt_det      TYPE TABLE OF zostb_reprdet,
*        lt_cab_json TYPE TABLE OF zoses_reprcab_json,
*        lt_det_json TYPE TABLE OF zoses_reprdet_json.
*
*
*  "Data
*  SELECT * INTO TABLE lt_cab FROM zostb_reprcab WHERE bukrs = p_bukrs AND zzidres = p_idres.
*  SELECT * INTO TABLE lt_det FROM zostb_reprdet WHERE bukrs = p_bukrs AND zzidres = p_idres.
*
*  CREATE OBJECT lo_fe.
*
*  lo_fe->set_json_per_rev(
*    EXPORTING
*      it_cab      = lt_cab
*      it_det      = lt_det
*    IMPORTING
*      et_cab_json = lt_cab_json
*      et_det_json = lt_det_json
*  ).
*
*  PERFORM show_cab_det_alv USING lt_cab_json lt_det_json.

ENDFORM.                    "build_rev_percepcion

*&---------------------------------------------------------------------*
*&      Form  build_rev_retencion
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM build_rev_retencion.

  DATA: lo_fe       TYPE REF TO zossdcl_pro_extrac_fe_rt,
        lt_cab      TYPE TABLE OF zostb_rertcab,
        lt_det      TYPE TABLE OF zostb_rertdet,
        lt_cab_json TYPE TABLE OF zoses_rertcab_json,
        lt_det_json TYPE TABLE OF zoses_rertdet_json.


  "Data
  SELECT * INTO TABLE lt_cab FROM zostb_rertcab WHERE bukrs = p_bukrs AND zzidres = p_idres.
  SELECT * INTO TABLE lt_det FROM zostb_rertdet WHERE bukrs = p_bukrs AND zzidres = p_idres.

  CREATE OBJECT lo_fe.

  lo_fe->set_json_ret_rev(
    EXPORTING
      it_cab      = lt_cab
      it_det      = lt_det
    IMPORTING
      et_cab_json = lt_cab_json
      et_det_json = lt_det_json
  ).

  PERFORM show_cab_det_alv USING lt_cab_json lt_det_json.

ENDFORM.                    "build_rev_retencion


*&---------------------------------------------------------------------*
*&      Form  show_cab_det_alv
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM show_cab_det_alv USING ct_cab TYPE STANDARD TABLE
                            ct_det TYPE STANDARD TABLE.

  DATA: lo_dock     TYPE REF TO cl_gui_docking_container,
        lo_split    TYPE REF TO cl_gui_splitter_container,

        lo_cont_cab TYPE REF TO cl_gui_container,
        lo_alv_cab  TYPE REF TO cl_salv_table,
        lo_fun_cab  TYPE REF TO cl_salv_functions_list,

        lo_cont_det TYPE REF TO cl_gui_container,
        lo_alv_det  TYPE REF TO cl_salv_table,
        lo_fun_det  TYPE REF TO cl_salv_functions_list,

        lo_tt       TYPE REF TO cl_abap_tabledescr,
        lo_ty       TYPE REF TO cl_abap_structdescr,
        ls_comp     LIKE LINE OF lo_ty->components,
        lo_cols     TYPE REF TO cl_salv_columns_table,
        lo_col      TYPE REF TO cl_salv_column,
        l_short     TYPE scrtext_s,
        l_medium    TYPE scrtext_m,
        l_long      TYPE scrtext_l.



* Crear union(dock)
  CREATE OBJECT lo_dock
    EXPORTING
      repid     = sy-cprog
      dynnr     = '100'
      extension = 2000
      name      = 'C_0100'.


* Crear division(split)
  CREATE OBJECT lo_split
    EXPORTING
      parent  = lo_dock
      rows    = 2
      columns = 1.

  "Arriba cabecera, Abajo detalle
  lo_cont_cab = lo_split->get_container( row = 1 column = 1 ).
  lo_cont_det = lo_split->get_container( row = 2 column = 1 ).


* Crea alv
  "Cab
  cl_salv_table=>factory( EXPORTING r_container    = lo_cont_cab
                                    container_name = 'C_0100'
                          IMPORTING r_salv_table   = lo_alv_cab
                          CHANGING t_table        = ct_cab ).

  "Det
  cl_salv_table=>factory( EXPORTING r_container    = lo_cont_det
                                  container_name = 'C_0100'
                        IMPORTING r_salv_table   = lo_alv_det
                        CHANGING t_table        = ct_det ).

* Modificar catalogo
  "Cab
  lo_cols = lo_alv_cab->get_columns( ).
  lo_tt  ?= cl_abap_tabledescr=>describe_by_data( ct_cab ).
  lo_ty  ?= lo_tt->get_table_line_type( ).
  LOOP AT lo_ty->components INTO ls_comp.
    lo_col = lo_cols->get_column( ls_comp-name ).
    l_short = ls_comp-name.
    l_medium = ls_comp-name.
    l_long = ls_comp-name.
    lo_col->set_short_text( l_short ).
    lo_col->set_medium_text( l_medium ).
    lo_col->set_long_text( l_long ).
  ENDLOOP.

  "Det
  lo_cols = lo_alv_det->get_columns( ).
  lo_tt  ?= cl_abap_tabledescr=>describe_by_data( ct_det ).
  lo_ty  ?= lo_tt->get_table_line_type( ).
  LOOP AT lo_ty->components INTO ls_comp.
    lo_col = lo_cols->get_column( ls_comp-name ).
    l_short = ls_comp-name.
    l_medium = ls_comp-name.
    l_long = ls_comp-name.
    lo_col->set_short_text( l_short ).
    lo_col->set_medium_text( l_medium ).
    lo_col->set_long_text( l_long ).
  ENDLOOP.

* Status
  lo_fun_cab = lo_alv_cab->get_functions( ).
  lo_fun_cab->set_default( abap_true ).

  lo_fun_det = lo_alv_det->get_functions( ).
  lo_fun_det->set_default( abap_true ).

* Show
  lo_alv_cab->display( ).
  lo_alv_det->display( ).

ENDFORM.                    "show_cab_det_alv
