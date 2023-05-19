*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_RESUMEN_COMP_IMP_CLA
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION                             *
*----------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION ##CLASS_FINAL.
  PUBLIC SECTION.
    METHODS:
      handle_user_onf4 FOR EVENT onf4 OF cl_gui_alv_grid
        IMPORTING e_fieldname e_fieldvalue es_row_no er_event_data et_bad_cells e_display,

      top_of_page FOR EVENT top_of_page OF cl_gui_alv_grid
        IMPORTING e_dyndoc_id,

      handle_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object e_interactive, "#EC NEEDED

      double_click FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column es_row_no sender, "#EC NEEDED

      handle_hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING e_row_id e_column_id es_row_no,  "#EC NEEDED

      handle_user_command FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm.
ENDCLASS.             "lcl_event_handler DEFINITION


*----------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION                         *
*----------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

*....TOP_OF_PAGE....
  METHOD top_of_page.
    DATA : ls_texto1 TYPE c LENGTH 255,
           ls_texto2 TYPE c LENGTH 255,
           ls_texto3 TYPE c LENGTH 255,
           lw_date   TYPE c LENGTH 10,
           lw_time   TYPE c LENGTH 8.

* Populating header to top-of-page
    CALL METHOD e_dyndoc_id->add_gap.
    CALL METHOD e_dyndoc_id->add_text
      EXPORTING
        text         = TEXT-001
        sap_emphasis = cl_dd_area=>strong
        sap_style    = cl_dd_area=>heading.

* Agregar nueva linea
    CALL METHOD e_dyndoc_id->new_line.

    CONCATENATE TEXT-002 sy-uname INTO ls_texto1 SEPARATED BY space.

    CALL METHOD e_dyndoc_id->add_gap.
    CALL METHOD e_dyndoc_id->add_text
      EXPORTING
        text         = ls_texto1
        sap_emphasis = cl_dd_area=>strong.

* Agregar nueva linea
    CALL METHOD e_dyndoc_id->new_line.

    WRITE sy-datum TO lw_date USING EDIT MASK '__/__/____'.
    CONCATENATE TEXT-003 lw_date INTO ls_texto2 SEPARATED BY space.

    CALL METHOD e_dyndoc_id->add_gap.
    CALL METHOD e_dyndoc_id->add_text
      EXPORTING
        text         = ls_texto2
        sap_emphasis = cl_dd_area=>strong.

* Agregar nueva linea
    CALL METHOD e_dyndoc_id->new_line.

    WRITE sy-uzeit TO lw_time.
    CONCATENATE TEXT-004 lw_time INTO ls_texto3 SEPARATED BY space.

    CALL METHOD e_dyndoc_id->add_gap.
    CALL METHOD e_dyndoc_id->add_text
      EXPORTING
        text         = ls_texto3
        sap_emphasis = cl_dd_area=>strong.

* Agregar nueva linea
    CALL METHOD e_dyndoc_id->new_line.

* Crear objeto html
    IF go_html_top IS INITIAL.
      CREATE OBJECT go_html_top
        EXPORTING
          parent = go_parent_html.
    ENDIF.

* Get TOP->HTML_TABLE ready
    CALL METHOD go_dyndoc_top->merge_document.
* Connect TOP document to HTML-Control
    go_dyndoc_top->html_control = go_html_top.

* Display TOP document
    CALL METHOD go_dyndoc_top->display_document
      EXPORTING
        reuse_control      = 'X'
        parent             = go_parent_html
      EXCEPTIONS
        html_display_error = 1.

  ENDMETHOD.                    "top_of_page

*....HANDLE_DOUBLE_CLICK....
  METHOD double_click.
    CHECK NOT e_row IS INITIAL.
    CHECK NOT e_column IS INITIAL.

  ENDMETHOD.                    "handle_double_click

*....HANDLE_HOTSPOT_CLICK....
  METHOD handle_hotspot_click.
    CHECK NOT e_row_id-index IS INITIAL.
    CHECK NOT e_column_id IS INITIAL.

  ENDMETHOD.                    "handle_hotspot_click

*....HANDLE_TOOLBAR....
  METHOD handle_toolbar.
    DATA: ls_toolbar  TYPE stb_button.

*   Agregamos Separador para toolbar
    CLEAR ls_toolbar.
    MOVE 3 TO ls_toolbar-butn_type.
    APPEND ls_toolbar TO e_object->mt_toolbar.

*   Botón de Descargar
    CLEAR ls_toolbar.
    MOVE '&DESCARGAR'      TO ls_toolbar-function.
    MOVE icon_export       TO ls_toolbar-icon.
    MOVE TEXT-005          TO ls_toolbar-text.
    ls_toolbar-disabled    = space.
    APPEND ls_toolbar TO e_object->mt_toolbar.

  ENDMETHOD.                    "HANDLE_TOOLBAR

*....HANDLE_USER_COMMAND....
  METHOD handle_user_command.
    DATA  ls_reporte LIKE LINE OF gt_reporte. "#EC NEEDED

    CASE e_ucomm.
      WHEN '&DESCARGAR'.
        LOOP AT gt_reporte INTO ls_reporte WHERE motiv IS INITIAL.
          EXIT.
        ENDLOOP.
        IF sy-subrc EQ 0.
          MESSAGE TEXT-006
            TYPE 'S' DISPLAY LIKE 'E'.
        ELSE.
          PERFORM generar_archivo_txt.
          PERFORM descargar_archivo_txt.
        ENDIF.
    ENDCASE.
  ENDMETHOD.                    "handle_user_command

*....HANDLE_USER_ONF4....
  METHOD handle_user_onf4.

    PERFORM d0100_event_onf4 USING e_fieldname
                                   e_fieldvalue
                                   es_row_no
                                   er_event_data
                                   et_bad_cells
                                   e_display.

  ENDMETHOD.                           "handle_onf4

ENDCLASS.                    "lcl_event_handler IMPLEMENTATION
