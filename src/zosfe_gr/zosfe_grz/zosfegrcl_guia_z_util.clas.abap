CLASS zosfegrcl_guia_z_util DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS gc_gray TYPE char4 VALUE '@EB@' ##NO_TEXT.
    CONSTANTS gc_green TYPE char4 VALUE '@08@' ##NO_TEXT.
    CONSTANTS gc_red TYPE char4 VALUE '@0A@' ##NO_TEXT.
    CONSTANTS gc_yellow TYPE char4 VALUE '@09@' ##NO_TEXT.
    CONSTANTS gc_chare TYPE char1 VALUE 'E' ##NO_TEXT.
    CONSTANTS gc_charw TYPE char1 VALUE 'W' ##NO_TEXT.


    CLASS-METHODS get_datelimit_baja
      IMPORTING
        !i_fecemi          TYPE dats OPTIONAL
      RETURNING
        VALUE(r_datelimit) TYPE dats
      EXCEPTIONS
        error .
    METHODS alvgrid_exclude
      RETURNING
        VALUE(rt_excl) TYPE ui_functions .
    METHODS alvgrid_focus
      IMPORTING
        !i_tabix    TYPE i OPTIONAL
        !it_cell    TYPE lvc_t_modi OPTIONAL
        !it_table   TYPE STANDARD TABLE
        !it_ret_cab TYPE bapirettab OPTIONAL
        !io_alv     TYPE REF TO cl_gui_alv_grid .
    METHODS alvgrid_isselected
      CHANGING
        !co_alv   TYPE REF TO cl_gui_alv_grid
        !ct_table TYPE STANDARD TABLE
      EXCEPTIONS
        error .
    METHODS alvgrid_refresh
      IMPORTING
        !io_alv TYPE REF TO cl_gui_alv_grid .
    METHODS alv_fcatgen
      EXPORTING
        !et_fcat  TYPE lvc_t_fcat
      CHANGING
        !ct_table TYPE STANDARD TABLE
        !c_campo  TYPE clike OPTIONAL .
    METHODS alv_fcatname
      IMPORTING
        !i_unico TYPE clike
        !i_large TYPE clike OPTIONAL
      CHANGING
        !cs_fcat TYPE lvc_s_fcat .
    METHODS cell_setcolor_e
      IMPORTING
        !i_campo       TYPE fieldname
        !i_color       TYPE i DEFAULT 6
      RETURNING
        VALUE(rs_scol) TYPE lvc_s_scol .
    METHODS cell_setcolor_w
      IMPORTING
        !i_campo       TYPE fieldname
        !i_color       TYPE i DEFAULT 7
      RETURNING
        VALUE(rs_scol) TYPE lvc_s_scol .
    METHODS cell_setstyle
      IMPORTING
        !i_campo       TYPE fieldname
        !i_style       TYPE lvc_style DEFAULT cl_gui_alv_grid=>mc_style_enabled
      RETURNING
        VALUE(rs_styl) TYPE lvc_s_styl .
    METHODS convert_material_unit
      IMPORTING
        !i_matnr       TYPE matnr
        !i_uniti       TYPE meins
        !i_unito       TYPE meins
        !i_menge       TYPE menge_d
      RETURNING
        VALUE(r_menge) TYPE menge_d .
    METHODS field_is_initial
      IMPORTING
        !is_data   TYPE any
        !i_field   TYPE clike
        !i_text    TYPE clike
        !i_row     TYPE clike OPTIONAL
        !i_w       TYPE clike OPTIONAL
      CHANGING
        !ct_return TYPE bapirettab .
    METHODS get_next_snro
      IMPORTING
        !is_inri        TYPE inri
      RETURNING
        VALUE(r_number) TYPE string .
    METHODS isconfirm
      IMPORTING
        !i_question TYPE string
        !i_cancel   TYPE xfeld OPTIONAL
      EXCEPTIONS
        cancel .
    METHODS lotno_lock
      IMPORTING
        !i_bukrs TYPE bukrs
        !i_lotno TYPE lotno
        !i_bokno TYPE bokno
      EXCEPTIONS
        error .
    METHODS lotno_next
      IMPORTING
        !i_bukrs       TYPE bukrs
        !i_lotno       TYPE lotno
        !i_bokno       TYPE bokno
      RETURNING
        VALUE(r_xblnr) TYPE xblnr
      EXCEPTIONS
        error .
    METHODS lotno_unlock
      IMPORTING
        !i_bukrs TYPE bukrs
        !i_lotno TYPE lotno
        i_bokno  TYPE bokno .
    METHODS message_show .
    METHODS replace_character
      CHANGING
        !cs_data TYPE any .
    METHODS return_from_sy
      IMPORTING
        !i_field         TYPE clike
        !i_row           TYPE clike OPTIONAL
      RETURNING
        VALUE(rs_return) TYPE bapiret2 .
    METHODS return_icon
      IMPORTING
        !it_return    TYPE bapirettab
        !i_row        TYPE clike OPTIONAL
      RETURNING
        VALUE(r_icon) TYPE icon-id .
    METHODS return_show
      IMPORTING
        !it_return TYPE bapirettab .
    METHODS return_showline
      IMPORTING
        !is_return TYPE bapiret2 .
    METHODS return_to_scol
      IMPORTING
        !it_return TYPE bapirettab
      CHANGING
        !cs_cab    TYPE any
        !ct_det    TYPE STANDARD TABLE OPTIONAL .
    METHODS tcode_mb03
      IMPORTING
        !i_mblnr TYPE mblnr
        !i_mjahr TYPE mjahr .
    METHODS tcode_me23n
      IMPORTING
        !i_ebeln TYPE ebeln .
    METHODS tcode_va03
      IMPORTING
        !i_vbeln TYPE vbak-vbeln .
    METHODS alv_text IMPORTING i_title TYPE clike i_mode TYPE xfeld CHANGING c_text TYPE clike.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zosfegrcl_guia_z_util IMPLEMENTATION.


  METHOD alvgrid_exclude.
    APPEND cl_gui_alv_grid=>mc_fc_refresh           TO rt_excl.  "refresh
    APPEND cl_gui_alv_grid=>mc_fc_loc_append_row    TO rt_excl.  "Añadir   fila
    APPEND cl_gui_alv_grid=>mc_fc_loc_insert_row    TO rt_excl.  "Insertar fila
    APPEND cl_gui_alv_grid=>mc_fc_loc_delete_row    TO rt_excl.  "Borrar   fila
    APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row      TO rt_excl.  "Copiar fila
    APPEND cl_gui_alv_grid=>mc_fc_loc_paste_new_row TO rt_excl.  "Pegar  fila
    APPEND cl_gui_alv_grid=>mc_fc_loc_move_row      TO rt_excl.  "Mover  fila
    APPEND cl_gui_alv_grid=>mc_fc_loc_copy          TO rt_excl.  "Copiar
    APPEND cl_gui_alv_grid=>mc_fc_loc_cut           TO rt_excl.  "Cortar
    APPEND cl_gui_alv_grid=>mc_fc_loc_paste         TO rt_excl.  "Pegar
    APPEND cl_gui_alv_grid=>mc_fc_loc_undo          TO rt_excl.  "Deshacer
    APPEND cl_gui_alv_grid=>mc_fc_check             TO rt_excl.  "Check
    APPEND cl_gui_alv_grid=>mc_fc_graph             TO rt_excl.  "Graph
    APPEND cl_gui_alv_grid=>mc_fc_info              TO rt_excl.  "Info
    APPEND cl_gui_alv_grid=>mc_fc_views             TO rt_excl.  "Views
  ENDMETHOD.


  METHOD alvgrid_focus.
    DATA: lt_fcat   TYPE lvc_t_fcat,
          ls_col    TYPE lvc_s_col,
          ls_row    TYPE lvc_s_roid,
          l_tabix   TYPE i,
          ls_cell   LIKE LINE OF it_cell,
          ls_scol   TYPE lvc_s_scol,
          ls_return TYPE bapiret2.
    FIELD-SYMBOLS: <fs_table> TYPE any,
                   <scol>     TYPE lvc_t_scol,
                   <return>   TYPE bapirettab.

    alvgrid_refresh( io_alv ).

    IF i_tabix > 0.
      READ TABLE it_table ASSIGNING <fs_table> INDEX i_tabix.
      IF sy-subrc = 0.
        ASSIGN COMPONENT 'SCOL' OF STRUCTURE <fs_table> TO <scol>.
      ENDIF.
      l_tabix = i_tabix.
    ELSEIF it_cell IS SUPPLIED.
      LOOP AT it_cell INTO ls_cell.
        READ TABLE it_table ASSIGNING <fs_table> INDEX ls_cell-row_id.
        IF sy-subrc = 0.
          l_tabix = sy-tabix.
          ASSIGN COMPONENT 'SCOL' OF STRUCTURE <fs_table> TO <scol>.
          IF <scol> IS NOT INITIAL.
            EXIT.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ELSE.
      LOOP AT it_table ASSIGNING <fs_table>.
        l_tabix = sy-tabix.
        ASSIGN COMPONENT 'SCOL' OF STRUCTURE <fs_table> TO <scol>.
        IF <scol> IS NOT INITIAL.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.

    IF l_tabix IS INITIAL.
      l_tabix = 1.
      READ TABLE it_table ASSIGNING <fs_table> INDEX l_tabix.
      ASSIGN COMPONENT 'SCOL' OF STRUCTURE <fs_table> TO <scol>.
    ENDIF.
    ls_row-row_id = l_tabix.


    ASSIGN COMPONENT 'T_STATU' OF STRUCTURE <fs_table> TO <return>.
    READ TABLE <return> INTO ls_return WITH KEY type = gc_chare.
    READ TABLE <scol> INTO ls_scol INDEX 1.
    IF sy-subrc = 0.
      IF ls_return IS NOT INITIAL.
        "Field de error
        ls_col-fieldname = ls_return-field.
      ELSE.
        "Field de validacion
        ls_col-fieldname = ls_scol-fname.
      ENDIF.

      IF it_ret_cab IS NOT SUPPLIED.
        IMPORT lt_fcat = lt_fcat FROM MEMORY ID 'CAB'.
        IF lt_fcat IS INITIAL.
          io_alv->get_frontend_fieldcatalog( IMPORTING et_fieldcatalog = lt_fcat ).
          EXPORT lt_fcat = lt_fcat TO MEMORY ID 'CAB'.
        ENDIF.
        READ TABLE lt_fcat WITH KEY fieldname = ls_col-fieldname TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          ls_col-fieldname = 'BTN_DET'.
        ENDIF.
      ENDIF.

      IF ls_return IS NOT INITIAL.
        return_showline( ls_return ).
      ENDIF.
    ELSE.
      IF it_ret_cab IS NOT SUPPLIED.
        ls_col-fieldname = 'BTN_CHECK'.
      ELSE.
        ls_col-fieldname = 'BTN_BACK'.

        READ TABLE it_ret_cab WITH KEY type = gc_chare TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.
          MESSAGE s000 WITH 'Verificar errores de cabecera' DISPLAY LIKE 'E'.
        ENDIF.
      ENDIF.
    ENDIF.

    io_alv->set_current_cell_via_id( is_column_id = ls_col is_row_no = ls_row ).
  ENDMETHOD.


  METHOD alvgrid_isselected.
    DATA lt_row TYPE lvc_t_row.
    FIELD-SYMBOLS: <fs_table> TYPE any,
                   <fs>       TYPE any.

    co_alv->get_selected_rows( IMPORTING et_index_rows = lt_row ).
    IF lt_row IS INITIAL.
      RAISE error.
    ENDIF.

    LOOP AT ct_table ASSIGNING <fs_table>.
      ASSIGN COMPONENT 'box' OF STRUCTURE <fs_table> TO <fs>.
      IF sy-subrc = 0.
        CLEAR <fs>.
        READ TABLE lt_row WITH KEY index = sy-tabix TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.
          <fs> = abap_on.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD alvgrid_refresh.
    DATA ls_stbl TYPE lvc_s_stbl VALUE 'XX'.
    io_alv->refresh_table_display( is_stable = ls_stbl ).
  ENDMETHOD.


  METHOD alv_fcatgen.
    DATA: lo_alv   TYPE REF TO cl_salv_table,
          lt_campo TYPE lvc_t_coid.
    FIELD-SYMBOLS: <fs_fcat> LIKE LINE OF et_fcat.

    TRY.
        cl_salv_table=>factory( IMPORTING r_salv_table = lo_alv CHANGING t_table = ct_table ).
        et_fcat = cl_salv_controller_metadata=>get_lvc_fieldcatalog( r_columns = lo_alv->get_columns( ) r_aggregations = lo_alv->get_aggregations( ) ).
        IF c_campo IS NOT INITIAL.
          TRANSLATE c_campo TO UPPER CASE.
          SPLIT c_campo AT ',' INTO TABLE lt_campo.
          LOOP AT et_fcat ASSIGNING <fs_fcat>.
            READ TABLE lt_campo WITH KEY fieldname = <fs_fcat>-fieldname TRANSPORTING NO FIELDS.
            IF sy-subrc = 0.
              <fs_fcat>-col_pos = sy-tabix.
            ELSE.
              CLEAR <fs_fcat>-col_pos.
            ENDIF.
          ENDLOOP.
          SORT et_fcat BY col_pos.
          DELETE et_fcat WHERE col_pos IS INITIAL.
        ENDIF.
      CATCH cx_root.                                    "#EC NO_HANDLER
    ENDTRY.
  ENDMETHOD.


  METHOD alv_fcatname.
    DATA: l_large TYPE string.

    "'1 Inicializa
    CLEAR: cs_fcat-rollname, cs_fcat-scrtext_s, cs_fcat-scrtext_m.
    l_large = i_large.
    IF l_large IS INITIAL.
      l_large = i_unico.
    ENDIF.

    "'2 Asigna textos
    cs_fcat-coltext = i_unico.      "40
    cs_fcat-reptext = i_unico.      "55
    IF strlen( i_unico ) <= 10.
      cs_fcat-scrtext_s = i_unico.  "10
    ENDIF.
    IF strlen( i_unico ) <= 20.
      cs_fcat-scrtext_m = i_unico.  "20
    ENDIF.
    cs_fcat-seltext   = l_large.    "40
    cs_fcat-scrtext_l = l_large.    "40
  ENDMETHOD.


  METHOD cell_setcolor_e.
    rs_scol-fname     = i_campo.
    rs_scol-color-col = i_color.
  ENDMETHOD.

  METHOD cell_setcolor_w.
    rs_scol-fname     = i_campo.
    rs_scol-color-col = i_color.
  ENDMETHOD.

  METHOD cell_setstyle.
    rs_styl-fieldname = i_campo.
    rs_styl-style     = i_style.
  ENDMETHOD.


  METHOD convert_material_unit.
    CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
      EXPORTING
        i_matnr              = i_matnr
        i_in_me              = i_uniti
        i_out_me             = i_unito
        i_menge              = i_menge
      IMPORTING
        e_menge              = r_menge
      EXCEPTIONS
        error_in_application = 1
        error                = 2
        OTHERS               = 3.
    IF sy-subrc <> 0.
    ENDIF.
  ENDMETHOD.


  METHOD field_is_initial.
    DATA: l_field  TYPE string,
          l_string TYPE string.
    FIELD-SYMBOLS <fs> TYPE any.

    l_field = i_field.
    TRANSLATE l_field TO UPPER CASE.
    ASSIGN COMPONENT l_field OF STRUCTURE is_data TO <fs>.
    IF <fs> IS INITIAL.
      IF i_w IS INITIAL.
        MESSAGE e000 WITH i_text INTO l_string.
      ELSE.
        MESSAGE w000 WITH i_text INTO l_string.
      ENDIF.

      APPEND return_from_sy( i_field = l_field i_row = i_row ) TO ct_return.
    ENDIF.
  ENDMETHOD.





  METHOD get_datelimit_baja.
    DATA: l_valor TYPE string,
          l_day   TYPE i.

    SELECT SINGLE valor1 INTO l_valor FROM zostb_const_fe WHERE campo = 'FECBAJ'.
    l_day = l_valor.
    TRY .
        r_datelimit = sy-datum - l_day.
      CATCH cx_root.
        r_datelimit = sy-datum - 7.
    ENDTRY.

    IF i_fecemi IS SUPPLIED.
      IF i_fecemi < r_datelimit.
        MESSAGE e000 WITH 'La fecha de generación tiene un plazo de días calendarios' RAISING error.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD get_next_snro.
    CALL FUNCTION 'NUMBER_RANGE_ENQUEUE'
      EXPORTING
        object           = is_inri-object
      EXCEPTIONS
        foreign_lock     = 1
        object_not_found = 2
        system_failure   = 3
        OTHERS           = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = is_inri-nrrangenr     "N° Rango
        object                  = is_inri-object        "
        subobject               = is_inri-subobject     "
        toyear                  = is_inri-toyear        "Año opcional
      IMPORTING
        number                  = r_number
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


    CALL FUNCTION 'NUMBER_RANGE_DEQUEUE'
      EXPORTING
        object           = is_inri-object
      EXCEPTIONS
        object_not_found = 1
        OTHERS           = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDMETHOD.                    "GET_NEXT_SNRO


  METHOD isconfirm.
    DATA: l_answer TYPE char01.

    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = 'Confirmación'  "text-c01
        text_question         = i_question
        icon_button_1         = '@2K@'
        icon_button_2         = '@2O@'
        display_cancel_button = space
      IMPORTING
        answer                = l_answer.

    IF l_answer <> '1'.
      MESSAGE e000 WITH 'Acción cancelada...' RAISING cancel.
    ENDIF.
  ENDMETHOD.


  METHOD lotno_lock.
    IF i_bukrs IS NOT INITIAL AND i_lotno IS NOT INITIAL AND i_bokno IS NOT INITIAL.
      CALL FUNCTION 'ENQUEUE_EBOOKNO'
        EXPORTING
          mode_idcn_boma = 'E'
          bukrs          = i_bukrs
          lotno          = i_lotno
          bokno          = i_bokno
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2
          OTHERS         = 3.

      CASE sy-subrc.
        WHEN 0.
        WHEN 1.
          MESSAGE e890(icc_cn) WITH sy-msgv1 i_bokno i_lotno RAISING error.
        WHEN OTHERS.
          MESSAGE e860(icc_cn) WITH i_bokno i_lotno RAISING error.
      ENDCASE.
    ENDIF.
  ENDMETHOD.


  METHOD lotno_next.
    DATA: ls_loma  TYPE idcn_loma,
          l_liinv  TYPE idcn_boma-liinv,
          l_numero TYPE n LENGTH 7.

    SELECT SINGLE * INTO ls_loma
      FROM idcn_loma
      WHERE bukrs EQ i_bukrs
        AND lotno EQ i_lotno.

    SELECT SINGLE liinv INTO l_liinv
      FROM idcn_boma
      WHERE bukrs EQ i_bukrs
        AND lotno EQ i_lotno
        AND bokno EQ i_bokno.

    ADD 1 TO l_liinv.
    l_numero = l_liinv.
    CONCATENATE ls_loma-invtp ls_loma-rgtno+1 l_numero INTO r_xblnr SEPARATED BY '-'.

    CALL FUNCTION 'FIRST_LAST_INV_UPDATE'
      EXPORTING
        bukrs        = i_bukrs
        lotno        = i_lotno
        bokno        = i_bokno
        liinv        = l_liinv
        issdt        = sy-datlo
      EXCEPTIONS
        update_error = 1
        not_found    = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING error.
    ENDIF.
  ENDMETHOD.


  METHOD lotno_unlock.
    IF i_bukrs IS NOT INITIAL AND i_lotno IS NOT INITIAL AND i_bokno IS NOT INITIAL.
      CALL FUNCTION 'DEQUEUE_EBOOKNO'
        EXPORTING
          mode_idcn_boma = 'E'
          mandt          = sy-mandt
          bukrs          = i_bukrs
          lotno          = i_lotno
          bokno          = i_bokno.
    ENDIF.
  ENDMETHOD.


  METHOD message_show.
    CHECK sy-msgid IS NOT INITIAL.

    IF sy-msgty = 'E'.
      MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 DISPLAY LIKE 'E'.
    ELSE.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.


  METHOD replace_character.
    DATA: lo_type TYPE REF TO cl_abap_structdescr,
          ls_comp LIKE LINE OF lo_type->components,
          l_type  TYPE string,
          l_len   TYPE i.
    FIELD-SYMBOLS: <fs>  TYPE any.

    lo_type ?= cl_abap_structdescr=>describe_by_data( cs_data ).
    LOOP AT lo_type->components INTO ls_comp.
      ASSIGN COMPONENT ls_comp-name OF STRUCTURE cs_data TO <fs>.
      IF <fs> IS NOT INITIAL.
        DESCRIBE FIELD <fs> TYPE l_type.
        IF l_type = 'C'.
          DESCRIBE FIELD <fs> LENGTH l_len IN CHARACTER MODE.
          IF l_len >= 15.
            REPLACE cl_abap_char_utilities=>cr_lf INTO <fs> WITH ''.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD return_from_sy.
    rs_return-field = i_field.
    TRANSLATE rs_return-field TO UPPER CASE.
    rs_return-row = i_row.
    MOVE: sy-msgv1 TO rs_return-message_v1,
          sy-msgv2 TO rs_return-message_v2,
          sy-msgv3 TO rs_return-message_v3,
          sy-msgv4 TO rs_return-message_v4,
          sy-msgid TO rs_return-id,
          sy-msgno TO rs_return-number,
          sy-msgty TO rs_return-type.
  ENDMETHOD.


  METHOD return_icon.
    IF i_row IS INITIAL.
      READ TABLE it_return WITH KEY type = gc_chare TRANSPORTING NO FIELDS.
    ELSE.
      READ TABLE it_return WITH KEY type = gc_chare row = i_row TRANSPORTING NO FIELDS.
    ENDIF.
    IF sy-subrc = 0.
      r_icon = gc_red.
    ELSE.
      IF i_row IS INITIAL.
        READ TABLE it_return WITH KEY type = gc_charw TRANSPORTING NO FIELDS.
      ELSE.
        READ TABLE it_return WITH KEY type = gc_charw row = i_row TRANSPORTING NO FIELDS.
      ENDIF.
      IF sy-subrc = 0.
        r_icon = gc_yellow.
      ELSE.
        r_icon = gc_green.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD return_show.
    CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
      EXPORTING
        it_message = it_return.
  ENDMETHOD.


  METHOD return_showline.
    DATA l_type TYPE sy-msgty.

    IF is_return-type = 'E'.
      l_type = 'S'.
    ELSE.
      l_type = is_return-type.
    ENDIF.
    MESSAGE ID is_return-id TYPE l_type NUMBER is_return-number
          WITH is_return-message_v1 is_return-message_v2
               is_return-message_v3 is_return-message_v4 DISPLAY LIKE is_return-type.
  ENDMETHOD.


  METHOD return_to_scol.
    DATA: ls_return LIKE LINE OF it_return,
          lt_scol   TYPE lvc_t_scol,
          ls_scol   LIKE LINE OF lt_scol.
    FIELD-SYMBOLS: <fs_det> TYPE any,
                   <fs>     TYPE lvc_t_scol,
                   <posnr>  TYPE posnr.

    LOOP AT it_return INTO ls_return WHERE row IS INITIAL AND field IS NOT INITIAL.
      IF ls_return-type = gc_charw.
        APPEND cell_setcolor_w( ls_return-field ) TO lt_scol.
      ELSE.
        APPEND cell_setcolor_e( ls_return-field ) TO lt_scol.
      ENDIF.
    ENDLOOP.
    IF lt_scol IS NOT INITIAL.
      ASSIGN COMPONENT 'SCOL' OF STRUCTURE cs_cab TO <fs>.
      LOOP AT lt_scol INTO ls_scol.
        READ TABLE <fs> WITH KEY fname = ls_scol-fname TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          APPEND ls_scol TO <fs>.
        ENDIF.
      ENDLOOP.
      CLEAR lt_scol.
    ENDIF.

    LOOP AT ct_det ASSIGNING <fs_det>.
      ASSIGN COMPONENT 'POSNR' OF STRUCTURE <fs_det> TO <posnr>.
      LOOP AT it_return INTO ls_return WHERE row = <posnr> AND field IS NOT INITIAL.
        IF ls_return-type = gc_charw.
          APPEND cell_setcolor_w( ls_return-field ) TO lt_scol.
        ELSE.
          APPEND cell_setcolor_e( ls_return-field ) TO lt_scol.
        ENDIF.
      ENDLOOP.
      IF lt_scol IS NOT INITIAL.
        ASSIGN COMPONENT 'SCOL' OF STRUCTURE <fs_det> TO <fs>.
        LOOP AT lt_scol INTO ls_scol.
          READ TABLE <fs> WITH KEY fname = ls_scol-fname TRANSPORTING NO FIELDS.
          IF sy-subrc <> 0.
            APPEND ls_scol TO <fs>.
          ENDIF.
        ENDLOOP.
        CLEAR lt_scol.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD tcode_mb03.
    SET PARAMETER ID: 'MBN' FIELD i_mblnr,
                      'MJA' FIELD i_mjahr.
    CALL TRANSACTION 'MB03' AND SKIP FIRST SCREEN.
  ENDMETHOD.


  METHOD tcode_me23n.
    SET PARAMETER ID: 'BES' FIELD i_ebeln.
    CALL TRANSACTION 'ME23N' AND SKIP FIRST SCREEN.
  ENDMETHOD.


  METHOD tcode_va03.
    SET PARAMETER ID 'AUN'  FIELD i_vbeln.
    CALL TRANSACTION 'VA03' AND SKIP FIRST SCREEN.
  ENDMETHOD.

  METHOD alv_text.
    DATA: lt_text   TYPE catsxt_longtext_itab,
          ls_text   LIKE LINE OF lt_text,
          l_title   TYPE sy-title,
          l_display TYPE xfeld.

    SPLIT c_text AT '#' INTO TABLE lt_text.

    l_title = i_title.
    if i_mode = 'V'.
      l_display = abap_on.
    ENDIF.

    CALL FUNCTION 'CATSXT_SIMPLE_TEXT_EDITOR'
      EXPORTING
        im_title        = l_title
        im_display_mode = l_display
        im_start_column = 50
        im_start_row    = 5
      CHANGING
        ch_text         = lt_text.

    IF l_display IS INITIAL.
      CLEAR c_text.
      LOOP AT lt_text INTO ls_text.
        IF c_text IS INITIAL.
          c_text = ls_text.
        ELSE.
          CONCATENATE c_text ls_text INTO c_text SEPARATED BY '#'.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
