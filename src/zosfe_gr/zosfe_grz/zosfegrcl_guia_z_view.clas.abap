CLASS zosfegrcl_guia_z_view DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES gty_cab TYPE zossdcl_pro_extrac_fe_gr=>gty_cab_z .
    TYPES:
      gtt_cab TYPE TABLE OF gty_cab WITH DEFAULT KEY .

    DATA ctrl TYPE REF TO zosfegrcl_guia_z_ctrl .
    DATA go_100 TYPE REF TO cl_gui_alv_grid .
    DATA go_200 TYPE REF TO cl_gui_alv_grid .
    DATA gs_cab TYPE gty_cab.

    METHODS inicializa .
    METHODS start
      IMPORTING
        !io_ctrl TYPE REF TO object .
    METHODS status .
    METHODS uc .
  PROTECTED SECTION.

  PRIVATE SECTION.

    METHODS cab_100
      IMPORTING
        !i_dynnr  TYPE sy-dynnr DEFAULT '100'
      CHANGING
        !ct_table TYPE STANDARD TABLE
        !co_alv   TYPE REF TO cl_gui_alv_grid .
    METHODS cab_100_cell
      IMPORTING
        !i_tabix TYPE i OPTIONAL
        !it_cell TYPE lvc_t_modi OPTIONAL .
    METHODS cab_100_changed
          FOR EVENT data_changed_finished OF cl_gui_alv_grid
      IMPORTING
          !e_modified
          !et_good_cells .
    METHODS cab_100_check_sel
      IMPORTING
        !i_xblnr  TYPE xfeld OPTIONAL
        !i_status TYPE char01 OPTIONAL
        !i_title  TYPE clike
      EXCEPTIONS
        error .
    METHODS cab_100_click
          FOR EVENT hotspot_click OF cl_gui_alv_grid
      IMPORTING
          !e_row_id
          !e_column_id .
    METHODS cab_100_doble FOR EVENT double_click OF cl_gui_alv_grid IMPORTING e_row e_column.
    METHODS cab_100_uc
          FOR EVENT user_command OF cl_gui_alv_grid
      IMPORTING
          !e_ucomm .
    METHODS det_200
      IMPORTING
        !i_dynnr  TYPE sy-dynnr
      CHANGING
        !ct_table TYPE STANDARD TABLE
        !co_alv   TYPE REF TO cl_gui_alv_grid .
    METHODS det_200_changed
          FOR EVENT data_changed_finished OF cl_gui_alv_grid
      IMPORTING
          !e_modified
          !et_good_cells .
    METHODS det_200_click
          FOR EVENT hotspot_click OF cl_gui_alv_grid
      IMPORTING
          !e_row_id
          !e_column_id .
    METHODS det_200_doble FOR EVENT double_click OF cl_gui_alv_grid IMPORTING e_row e_column.
    METHODS det_200_uc
          FOR EVENT user_command OF cl_gui_alv_grid
      IMPORTING
          !e_ucomm .
    METHODS det_200_valid
      IMPORTING
        !i_test  TYPE xfeld OPTIONAL
        !i_tabix TYPE i OPTIONAL
        !it_cell TYPE lvc_t_modi OPTIONAL .
ENDCLASS.



CLASS zosfegrcl_guia_z_view IMPLEMENTATION.


  METHOD cab_100.
    DATA: ls_layo TYPE lvc_s_layo,
          lt_fcat TYPE lvc_t_fcat,
          ls_vari TYPE disvariant,
          lt_excl TYPE ui_functions,
          l_campo TYPE tdata,
          lo_cont TYPE REF TO cl_gui_custom_container.
    DATA: l_deno_lenght TYPE i VALUE 25,
          l_nro_lenght  TYPE i VALUE 11.
    FIELD-SYMBOLS: <fs_fcat> TYPE lvc_s_fcat.

    "'1 Message
    DESCRIBE TABLE ct_table.
    MESSAGE s000(su) WITH 'Se visualizan' sy-tfill 'registro(s)'.

    IF co_alv IS INITIAL.
      "'2 Layout
      ls_layo-zebra       = abap_on.
      ls_layo-ctab_fname = 'SCOL'.
      ls_layo-stylefname = 'STYL'.
      ls_layo-sel_mode   = 'A'.

      "'3 Variante
      ls_vari-username = sy-uname.
      ls_vari-report   = sy-repid.
      ls_vari-handle   = i_dynnr.

      "'4 Catalogo
      CONCATENATE 'btn_statu,btn_det,btn_check,zznrosap,zzgjahr,zznrosun,zzt_status_cdr,zzfecemi,'
                  'zzparwer,zzparlgo,zzparlif,zzparubi,zzpardir,'
                  'kunnr,lifnr,zzdstwer,zzdstlgo,'
                  'zzdstnro,zzdsttpd_h,zzdstden,'
                  'zzllekun,zzllelif,zzlleubi,zzlledir,'
                  'zzslcnro,zzslctpd_h,zzslcden,'
                  'zztrsmot_h,zztrsden,'
                  'zztrafec,zztrahor,'
                  'zztrsmod_h,'
                  'zztralif,zztranro,zztratpd_h,zztraden,zztramtc,'
                  'zzplaveh,zztranci,zztramar,zztrancv,'
                  'zzconnro,zzcontpd_h,zzconden,zztrabvt,'
                  'zztotblt,'
                  'zzobserv,zztdadi1'
                   '' INTO l_campo.
      ctrl->ui->alv_fcatgen( IMPORTING et_fcat = lt_fcat CHANGING ct_table = ct_table c_campo = l_campo ).

      "'5 Fcat - Descripcion
      LOOP AT lt_fcat ASSIGNING <fs_fcat>.
        CASE <fs_fcat>-fieldname.
          WHEN 'BTN_STATU' OR 'BTN_DET' OR 'BTN_CHECK'.
            <fs_fcat>-key       = abap_on.
            <fs_fcat>-hotspot   = abap_on.
            <fs_fcat>-just      = 'C'.
            CASE <fs_fcat>-fieldname.
              WHEN 'BTN_STATU'. l_campo = 'Statu'.
              WHEN 'BTN_DET'. l_campo = 'Det'.
              WHEN 'BTN_CHECK'. l_campo = 'Check'.
            ENDCASE.
            ctrl->ui->alv_fcatname( EXPORTING i_unico = l_campo CHANGING cs_fcat = <fs_fcat> ).
          WHEN 'ZZNROSAP'. <fs_fcat>-hotspot = abap_on.


            "Partida
          WHEN 'ZZPARLIF'.
            <fs_fcat>-ref_table = 'LFA1'.
            <fs_fcat>-ref_field = 'LIFNR'.
            ctrl->ui->alv_fcatname( EXPORTING i_unico = 'Prov.Partida' CHANGING cs_fcat = <fs_fcat> ).
          WHEN 'ZZPARWER'.
            <fs_fcat>-ref_table = 'T001W'.
            <fs_fcat>-ref_field = 'WERKS'.
            ctrl->ui->alv_fcatname( EXPORTING i_unico = 'Ce.Partida' CHANGING cs_fcat = <fs_fcat> ).
          WHEN 'ZZPARLGO'.
            <fs_fcat>-ref_table = 'T001L'.
            <fs_fcat>-ref_field = 'LGORT'.
            ctrl->ui->alv_fcatname( EXPORTING i_unico = 'Alm.Partida' CHANGING cs_fcat = <fs_fcat> ).
          WHEN 'ZZPARDIR'.
            <fs_fcat>-outputlen = l_deno_lenght.
            ctrl->ui->alv_fcatname( EXPORTING i_unico = 'Partida Dirección' CHANGING cs_fcat = <fs_fcat> ).


            "Destinatario
          WHEN 'KUNNR'.
            <fs_fcat>-ref_table = 'KNA1'.
            <fs_fcat>-ref_field = 'KUNNR'.
            ctrl->ui->alv_fcatname( EXPORTING i_unico = 'Clie.Destinatario' CHANGING cs_fcat = <fs_fcat> ).
          WHEN 'LIFNR'.
            <fs_fcat>-ref_table = 'LFA1'.
            <fs_fcat>-ref_field = 'LIFNR'.
            ctrl->ui->alv_fcatname( EXPORTING i_unico = 'Prov.Destinatario' CHANGING cs_fcat = <fs_fcat> ).
          WHEN 'ZZDSTWER'.
            <fs_fcat>-ref_table = 'T001W'.
            <fs_fcat>-ref_field = 'WERKS'.
            ctrl->ui->alv_fcatname( EXPORTING i_unico = 'Ce.Destino' CHANGING cs_fcat = <fs_fcat> ).
          WHEN 'ZZDSTLGO'.
            <fs_fcat>-ref_table = 'T001L'.
            <fs_fcat>-ref_field = 'LGORT'.
            ctrl->ui->alv_fcatname( EXPORTING i_unico = 'Alm.Destino' CHANGING cs_fcat = <fs_fcat> ).
          WHEN 'ZZDSTNRO'. <fs_fcat>-outputlen = l_nro_lenght.
          WHEN 'ZZDSTDEN'.
            <fs_fcat>-outputlen = l_deno_lenght.
            ctrl->ui->alv_fcatname( EXPORTING i_unico = 'Destinatario Denominación' CHANGING cs_fcat = <fs_fcat> ).


            "Llegada
          WHEN 'ZZLLEKUN'.
            <fs_fcat>-ref_table = 'KNA1'.
            <fs_fcat>-ref_field = 'KUNNR'.
            ctrl->ui->alv_fcatname( EXPORTING i_unico = 'Clie.Llegada' CHANGING cs_fcat = <fs_fcat> ).
          WHEN 'ZZLLELIF'.
            <fs_fcat>-ref_table = 'LFA1'.
            <fs_fcat>-ref_field = 'LIFNR'.
            ctrl->ui->alv_fcatname( EXPORTING i_unico = 'Prov.Llegada' CHANGING cs_fcat = <fs_fcat> ).
          WHEN 'ZZLLEUBI'.
          WHEN 'ZZLLEDIR'.
            <fs_fcat>-outputlen = l_deno_lenght.
            ctrl->ui->alv_fcatname( EXPORTING i_unico = 'Llegada Dirección' CHANGING cs_fcat = <fs_fcat> ).


            "Solicitante
          WHEN 'ZZSLCNRO'. <fs_fcat>-outputlen = l_nro_lenght.
          WHEN 'ZZSLCDEN'.
            <fs_fcat>-outputlen = l_deno_lenght.
            ctrl->ui->alv_fcatname( EXPORTING i_unico = 'Solicitante Denominación' CHANGING cs_fcat = <fs_fcat> ).


            "Transporte
          WHEN 'ZZTRSMOT_H'.
            <fs_fcat>-ref_table = 'ZOSTB_CATALOGO20'.
            <fs_fcat>-ref_field = 'ZZ_CODIGO_SUNAT'.
          WHEN 'ZZTRSDEN'.
            <fs_fcat>-outputlen = l_nro_lenght.
            ctrl->ui->alv_fcatname( EXPORTING i_unico = 'Traslado Denominación' CHANGING cs_fcat = <fs_fcat> ).
          WHEN 'ZZTRSMOD_H'.
            <fs_fcat>-ref_table = 'ZOSTB_CATALOGO18'.
            <fs_fcat>-ref_field = 'ZZ_CODIGO_SUNAT'.
          WHEN 'ZZTRALIF'.
            <fs_fcat>-ref_table = 'LFA1'.
            <fs_fcat>-ref_field = 'LIFNR'.
            ctrl->ui->alv_fcatname( EXPORTING i_unico = 'Prov.Transportista' CHANGING cs_fcat = <fs_fcat> ).
          WHEN 'ZZTRANRO'. <fs_fcat>-outputlen = l_nro_lenght.
          WHEN 'ZZTRADEN'.
            <fs_fcat>-outputlen = l_deno_lenght.
            ctrl->ui->alv_fcatname( EXPORTING i_unico = 'Transportista Denominación' CHANGING cs_fcat = <fs_fcat> ).
          WHEN 'ZZTRAMTC'. <fs_fcat>-outputlen = l_nro_lenght.


            "Vehiculo Principal
          WHEN 'ZZTRANCI'. <fs_fcat>-outputlen = l_nro_lenght.
          WHEN 'ZZTRAMAR'. <fs_fcat>-outputlen = l_nro_lenght.
          WHEN 'ZZTRANCV'.
            <fs_fcat>-outputlen = l_nro_lenght.
            ctrl->ui->alv_fcatname( EXPORTING i_unico = 'Veh.Pri.Config.Vehicular' CHANGING cs_fcat = <fs_fcat> ).

          WHEN 'ZZCONNRO'. <fs_fcat>-outputlen = l_nro_lenght.
          WHEN 'ZZCONDEN'.
            <fs_fcat>-outputlen = l_deno_lenght.
            ctrl->ui->alv_fcatname( EXPORTING i_unico = 'Conductor Principal: Denominación' CHANGING cs_fcat = <fs_fcat> ).


            "Vehiculo Secundario

            "Adicionales
          WHEN 'ZZOBSERV'.
            <fs_fcat>-outputlen = l_deno_lenght.
            ctrl->ui->alv_fcatname( EXPORTING i_unico = 'Observación' CHANGING cs_fcat = <fs_fcat> ).
          WHEN 'ZZTDADI1'.
            <fs_fcat>-outputlen = l_deno_lenght.
            ctrl->ui->alv_fcatname( EXPORTING i_unico = 'Texto Pie Detalle' CHANGING cs_fcat = <fs_fcat> ).
        ENDCASE.

        IF <fs_fcat>-fieldname CS 'KUNNR'. <fs_fcat>-emphasize = 'C111'. ENDIF.
        IF <fs_fcat>-fieldname CS 'LIFNR'. <fs_fcat>-emphasize = 'C111'. ENDIF.
        IF <fs_fcat>-fieldname CS 'ZZDST'. <fs_fcat>-emphasize = 'C111'. ENDIF.
        IF <fs_fcat>-fieldname CS 'ZZTRA'. <fs_fcat>-emphasize = 'C300'. ENDIF.
        IF <fs_fcat>-fieldname CS 'ZZLLE'. <fs_fcat>-emphasize = 'C500'. ENDIF.
      ENDLOOP.

      IF ctrl->g_aktyp <> ctrl->gc_ver.
        DELETE lt_fcat WHERE fieldname = 'BTN_CHECK'.
      ENDIF.

      "'6 Eventos
      CONCATENATE 'C' i_dynnr INTO l_campo.
      CREATE OBJECT lo_cont EXPORTING container_name = l_campo.
      CREATE OBJECT co_alv EXPORTING i_parent = lo_cont.

      SET HANDLER cab_100_uc       FOR co_alv.
      SET HANDLER cab_100_click    FOR co_alv.
      SET HANDLER cab_100_doble    FOR co_alv.
      SET HANDLER cab_100_changed  FOR co_alv.
      co_alv->register_edit_event( cl_gui_alv_grid=>mc_evt_modified ).
      co_alv->register_edit_event( cl_gui_alv_grid=>mc_evt_enter ).
      lt_excl = ctrl->ui->alvgrid_exclude( ).

      "'7 Alv
      co_alv->set_table_for_first_display(
        EXPORTING
          i_bypassing_buffer    = abap_on
          i_buffer_active       = abap_on
          is_layout             = ls_layo
          it_toolbar_excluding  = lt_excl
          is_variant            = ls_vari
          i_save                = 'A'
        CHANGING
          it_outtab             = ct_table
          it_fieldcatalog       = lt_fcat
      ).

      co_alv->set_ready_for_input( ).
    ENDIF.

    ctrl->ui->alvgrid_refresh( co_alv ).

    PERFORM call_screen IN PROGRAM (sy-cprog) USING i_dynnr.
  ENDMETHOD.


  METHOD cab_100_cell.
    ctrl->ui->alvgrid_focus(
        i_tabix    = i_tabix
        it_cell    = it_cell
        it_table   = ctrl->gt_cab
        io_alv     = go_100
    ).
  ENDMETHOD.


  METHOD cab_100_changed.
    DATA: lt_cell LIKE et_good_cells.
    FIELD-SYMBOLS: <fs_cell> TYPE lvc_s_modi,
                   <fs_cab>  LIKE LINE OF ctrl->gt_cab.

    IF et_good_cells IS NOT INITIAL.
      lt_cell = et_good_cells.
      SORT lt_cell BY row_id.
      DELETE ADJACENT DUPLICATES FROM lt_cell COMPARING row_id.

      LOOP AT lt_cell ASSIGNING <fs_cell>.
        READ TABLE ctrl->gt_cab ASSIGNING <fs_cab> INDEX <fs_cell>-row_id.
        ctrl->model->guia_valid( EXPORTING i_cab = abap_on CHANGING cs_cab = <fs_cab> EXCEPTIONS error = 1 ).
      ENDLOOP.

      cab_100_cell( it_cell = lt_cell ).
    ENDIF.
  ENDMETHOD.


  METHOD cab_100_check_sel.
    DATA l_title TYPE string.

    IF i_xblnr = abap_on.
      LOOP AT ctrl->gt_cab TRANSPORTING NO FIELDS WHERE box = abap_on AND xblnr IS INITIAL.
        EXIT.
      ENDLOOP.
    ENDIF.
    IF i_status IS NOT INITIAL.
      LOOP AT ctrl->gt_cab TRANSPORTING NO FIELDS WHERE box = abap_on AND zzt_status_cdr <> i_status.
        EXIT.
      ENDLOOP.
    ENDIF.
    IF sy-subrc <> 0.
      CONCATENATE i_title '(s)' INTO l_title.
      MESSAGE e000 WITH 'Seleccione registro(s)' l_title RAISING error.
    ENDIF.
  ENDMETHOD.


  METHOD cab_100_click.
    DATA: l_tabix TYPE i,
          ls_col  TYPE lvc_s_col.
    FIELD-SYMBOLS <fs_cab> LIKE LINE OF ctrl->gt_cab.

    READ TABLE ctrl->gt_cab ASSIGNING <fs_cab> INDEX e_row_id-index.
    CASE e_column_id.
      WHEN 'BTN_DET'.
        gs_cab = <fs_cab>.
        det_200( EXPORTING i_dynnr = '200' CHANGING ct_table = gs_cab-t_det co_alv = go_200 ).
        <fs_cab> = gs_cab.

        IF gs_cab-zznrosap IS INITIAL.
          ls_col = 'BTN_CHECK'.
          cab_100_click( e_row_id = e_row_id e_column_id = ls_col ).
        ENDIF.


      WHEN 'BTN_CHECK'.
        CHECK <fs_cab>-btn_check IS NOT INITIAL.
        l_tabix = e_row_id-index.
        ctrl->model->guia_valid( EXPORTING i_cab = abap_on CHANGING cs_cab = <fs_cab> EXCEPTIONS error = 1 ).
        cab_100_cell( i_tabix = l_tabix ).


      WHEN 'BTN_STATU'. ctrl->ui->return_show( <fs_cab>-t_statu ).


      WHEN 'ZZNROSAP'.
        CASE <fs_cab>-tabname.
          WHEN ctrl->model->gc_tabname-ekko.
            ctrl->ui->tcode_me23n( <fs_cab>-zznrosap ).
          WHEN ctrl->model->gc_tabname-mkpf.
            ctrl->ui->tcode_mb03( i_mblnr = <fs_cab>-zznrosap i_mjahr = <fs_cab>-zzgjahr ).
          WHEN ctrl->model->gc_tabname-vbak.
            ctrl->ui->tcode_va03( <fs_cab>-zznrosap ).
        ENDCASE.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.

  METHOD cab_100_doble.
    FIELD-SYMBOLS: <fs_cab> LIKE LINE OF ctrl->gt_cab,
                   <fs>     TYPE any.

    CASE e_column-fieldname.
      WHEN 'ZZOBSERV' OR 'ZZTDADI1'.
        READ TABLE ctrl->gt_cab ASSIGNING <fs_cab> INDEX e_row.
        ASSIGN COMPONENT e_column-fieldname OF STRUCTURE <fs_cab> TO <fs>.

        ctrl->ui->alv_text(
          EXPORTING
            i_title = e_column-fieldname
            i_mode  = <fs_cab>-aktyp
          CHANGING
            c_text = <fs>
        ).

        ctrl->ui->alvgrid_refresh( go_100 ).
    ENDCASE.
  ENDMETHOD.


  METHOD cab_100_uc.
    DATA: lt_return TYPE bapirettab,
          ls_cab    LIKE LINE OF ctrl->gt_cab,
          l_test    TYPE xfeld.

    FIELD-SYMBOLS <fs_cab> LIKE LINE OF ctrl->gt_cab.


    ctrl->ui->alvgrid_isselected( CHANGING co_alv = go_100 ct_table = ctrl->gt_cab EXCEPTIONS error = 1 ).

    CASE e_ucomm.
      WHEN 'NEW'.
        MOVE-CORRESPONDING ctrl->zsel TO ls_cab.
        ctrl->model->guia_inicializa( CHANGING cs_cab = ls_cab ).
        APPEND ls_cab TO ctrl->gt_cab.
        DESCRIBE TABLE ctrl->gt_cab.
        cab_100_cell( i_tabix = sy-tfill ).


      WHEN 'DEL'.
        cab_100_check_sel( EXPORTING i_xblnr = abap_on i_title = 'eliminable' EXCEPTIONS error = 1 ).
        IF sy-subrc <> 0.
          ctrl->ui->message_show( ).
          EXIT.
        ENDIF.

        LOOP AT ctrl->gt_cab TRANSPORTING NO FIELDS WHERE box = abap_on.
          DELETE ctrl->gt_cab INDEX sy-tabix.
        ENDLOOP.

        ctrl->ui->alvgrid_refresh( go_100 ).


      WHEN 'CHECK' OR 'LIB'.
        cab_100_check_sel( EXPORTING i_xblnr = abap_on i_title = 'generable' EXCEPTIONS error = 1 ).
        IF sy-subrc <> 0.
          ctrl->ui->message_show( ).
          EXIT.
        ENDIF.

        IF e_ucomm = 'CHECK'.
          l_test = abap_on.
        ENDIF.

        LOOP AT ctrl->gt_cab ASSIGNING <fs_cab> WHERE box = abap_on.
          ctrl->model->guia_save(
            EXPORTING
              i_cab     = abap_on
              i_test    = l_test
            CHANGING
              cs_cab    = <fs_cab>
            EXCEPTIONS
              error     = 1
              lock      = 2
          ).
          IF sy-subrc = 2.
            ctrl->ui->message_show( ).
          ENDIF.
        ENDLOOP.

        cab_100_cell( i_tabix = sy-tfill ).


      WHEN 'BAJA'.
        cab_100_check_sel( EXPORTING i_status = '8' i_title = 'procesable' EXCEPTIONS error = 1 ).
        IF sy-subrc = 0.
          ctrl->model->baja_save( IMPORTING et_return = lt_return CHANGING ct_cab = ctrl->gt_cab EXCEPTIONS error = 1 ).
          ctrl->ui->alvgrid_refresh( go_100 ).
          ctrl->ui->return_show( it_return = lt_return ).
        ENDIF.
    ENDCASE.
  ENDMETHOD.


  METHOD det_200.
    DATA: ls_layo TYPE lvc_s_layo,
          lt_fcat TYPE lvc_t_fcat,
          ls_vari TYPE disvariant,
          lt_excl TYPE ui_functions,
          l_campo TYPE tdata,
          lo_cont TYPE REF TO cl_gui_custom_container.
    FIELD-SYMBOLS: <fs_fcat> TYPE lvc_s_fcat.

    "'1 Message
    DESCRIBE TABLE ct_table.
    MESSAGE s000(su) WITH 'Se visualizan' sy-tfill 'registro(s)'.

    IF co_alv IS INITIAL.
      "'2 Layout
      ls_layo-zebra      = abap_on.
      ls_layo-ctab_fname = 'SCOL'.
      ls_layo-stylefname = 'STYL'.
      ls_layo-sel_mode   = 'A'.

      "'3 Variante
      ls_vari-username = sy-uname.
      ls_vari-report   = sy-repid.
      ls_vari-handle   = i_dynnr.

      "'4 Catalogo
      CONCATENATE 'btn_statu,btn_back,zznrosap,posnr,'
                  'matnr,zzitecod,arktx,lfimg,vrkme,brgew,gewei,'
                  'zziteqty,zziteund_h,zziteqty,zzitepbt,'
                  'zztxtpos'
                  '' INTO l_campo.
      ctrl->ui->alv_fcatgen( IMPORTING et_fcat = lt_fcat CHANGING ct_table = ct_table c_campo = l_campo ).

      "'5 Fcat - Descripcion
      LOOP AT lt_fcat ASSIGNING <fs_fcat>.
        CASE <fs_fcat>-fieldname.
          WHEN 'BTN_STATU' OR 'BTN_BACK'.
            <fs_fcat>-key       = abap_on.
            <fs_fcat>-hotspot   = abap_on.
            <fs_fcat>-just      = 'C'.
            CASE <fs_fcat>-fieldname.
              WHEN 'BTN_STATU'. l_campo = 'Statu'.
              WHEN 'BTN_BACK'. l_campo = 'Back'.
            ENDCASE.
            ctrl->ui->alv_fcatname( EXPORTING i_unico = l_campo CHANGING cs_fcat = <fs_fcat> ).
          WHEN 'MATNR'.
            <fs_fcat>-ref_table = 'MARA'.
            <fs_fcat>-ref_field = 'MATNR'.
          WHEN 'ZZITECOD'.
          WHEN 'VRKME' OR 'GEWEI'.
            <fs_fcat>-ref_table = 'T006'.
            <fs_fcat>-ref_field = 'MSEHI'.
          WHEN 'ARKTX'.     <fs_fcat>-outputlen = 30.
          WHEN 'ZZTXTPOS'.  <fs_fcat>-outputlen = 30.
        ENDCASE.
      ENDLOOP.

      "'6 Eventos
      CONCATENATE 'C' i_dynnr INTO l_campo.
      CREATE OBJECT lo_cont EXPORTING container_name = l_campo.
      CREATE OBJECT co_alv EXPORTING i_parent = lo_cont.

      SET HANDLER det_200_uc       FOR co_alv.
      SET HANDLER det_200_click    FOR co_alv.
      SET HANDLER det_200_doble    FOR co_alv.
      SET HANDLER det_200_changed  FOR co_alv.
      co_alv->register_edit_event( cl_gui_alv_grid=>mc_evt_modified ).
      co_alv->register_edit_event( cl_gui_alv_grid=>mc_evt_enter ).
      lt_excl = ctrl->ui->alvgrid_exclude( ).

      "'9 Alv
      co_alv->set_table_for_first_display(
        EXPORTING
          i_bypassing_buffer    = abap_on
          i_buffer_active       = abap_on
          is_layout             = ls_layo
          it_toolbar_excluding  = lt_excl
          is_variant            = ls_vari
          i_save                = 'A'
        CHANGING
          it_outtab             = ct_table
          it_fieldcatalog       = lt_fcat
      ).

      co_alv->set_ready_for_input( ).
    ENDIF.

    ctrl->ui->alvgrid_refresh( co_alv ).
    IF gs_cab-zznrosap IS INITIAL.
      det_200_valid( i_test = abap_on i_tabix = 1 ).
    ENDIF.

    PERFORM call_screen IN PROGRAM (sy-cprog) USING i_dynnr.
  ENDMETHOD.


  METHOD det_200_changed.
    DATA: lt_cell LIKE et_good_cells.
    IF et_good_cells IS NOT INITIAL.
      lt_cell = et_good_cells.
      SORT lt_cell BY row_id.
      DELETE ADJACENT DUPLICATES FROM lt_cell COMPARING row_id.

      det_200_valid( i_test = abap_on it_cell = lt_cell ).
    ENDIF.
  ENDMETHOD.


  METHOD det_200_click.
    FIELD-SYMBOLS <fs_det> LIKE LINE OF gs_cab-t_det.

    READ TABLE gs_cab-t_det ASSIGNING <fs_det> INDEX e_row_id-index.
    CASE e_column_id.
      WHEN 'BTN_BACK'.
        SET SCREEN 0.
        LEAVE SCREEN.


      WHEN 'BTN_STATU'. ctrl->ui->return_show( <fs_det>-t_statu ).
    ENDCASE.
  ENDMETHOD.

  METHOD det_200_doble.
    FIELD-SYMBOLS: <fs_det> LIKE LINE OF gs_cab-t_det,
                   <fs>     TYPE any.

    CASE e_column-fieldname.
      WHEN 'ZZTXTPOS'.
        READ TABLE gs_cab-t_det ASSIGNING <fs_det> INDEX e_row.
        ASSIGN COMPONENT e_column-fieldname OF STRUCTURE <fs_det> TO <fs>.

        ctrl->ui->alv_text(
          EXPORTING
            i_title = e_column-fieldname
            i_mode  = gs_cab-aktyp
          CHANGING
            c_text = <fs>
        ).

        ctrl->ui->alvgrid_refresh( go_200 ).
    ENDCASE.
  ENDMETHOD.


  METHOD det_200_uc.
    DATA: ls_det LIKE LINE OF gs_cab-t_det,
          l_test TYPE xfeld.

    FIELD-SYMBOLS <fs_det> LIKE LINE OF gs_cab-t_det.

    ctrl->ui->alvgrid_isselected( CHANGING co_alv = go_200 ct_table = gs_cab-t_det EXCEPTIONS error = 1 ).

    CASE e_ucomm.
      WHEN 'NEW'.

        ls_det-zznrosap = gs_cab-zznrosap.
        ls_det-zzgjahr  = gs_cab-zzgjahr.
        ls_det-posnr = 10.

        DESCRIBE TABLE gs_cab-t_det.
        READ TABLE gs_cab-t_det ASSIGNING <fs_det> INDEX sy-tfill.
        IF sy-subrc = 0.
          ls_det-posnr = <fs_det>-posnr + ls_det-posnr.
        ENDIF.
        APPEND ls_det TO gs_cab-t_det.

        det_200_valid( i_test = abap_on i_tabix = sy-tfill + 1 ).


      WHEN 'DEL'.
        LOOP AT gs_cab-t_det TRANSPORTING NO FIELDS WHERE box = abap_on.
          EXIT.
        ENDLOOP.
        IF sy-subrc <> 0.
          MESSAGE s000 WITH 'Seleccione documento generable...' DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
        LOOP AT gs_cab-t_det TRANSPORTING NO FIELDS WHERE box = abap_on.
          DELETE gs_cab-t_det INDEX sy-tabix.
        ENDLOOP.

        ctrl->ui->alvgrid_refresh( go_200 ).


      WHEN 'CHECK' OR 'LIB'.
        IF gs_cab-aktyp <> ctrl->gc_ver.
          MESSAGE s000 WITH 'Seleccione documento generable...' DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.

        IF e_ucomm = 'CHECK'.
          l_test = abap_on.
        ENDIF.

        ctrl->model->guia_save(
          EXPORTING
            i_test    = l_test
          CHANGING
            cs_cab    = gs_cab
          EXCEPTIONS
            error     = 1
        ).

        ctrl->ui->alvgrid_focus(
            it_table   = gs_cab-t_det
            it_ret_cab = gs_cab-t_statu
            io_alv     = go_200
        ).

    ENDCASE.
  ENDMETHOD.


  METHOD det_200_valid.
    IF i_test IS NOT INITIAL.
      ctrl->model->guia_valid( CHANGING cs_cab = gs_cab EXCEPTIONS error = 1 ).
    ENDIF.

    ctrl->ui->alvgrid_focus(
      EXPORTING
        i_tabix    = i_tabix
        it_cell    = it_cell
        it_table   = gs_cab-t_det
        it_ret_cab = gs_cab-t_statu
        io_alv     = go_200
    ).
  ENDMETHOD.


  METHOD inicializa.
    DATA l_badi TYPE string.

    "Desactiva los campos personalizados de otros cliente
    IMPORT l_badi = l_badi FROM MEMORY ID 'BADI'.
    IF l_badi IS INITIAL.
      l_badi = 'NOCUST'.
    ENDIF.

    LOOP AT SCREEN.
      IF screen-name CS 'B_' AND screen-name NS l_badi.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD start.
    ctrl ?= io_ctrl.

    cab_100(
      EXPORTING
        i_dynnr  = ctrl->g_dynnr
      CHANGING
        ct_table = ctrl->gt_cab
        co_alv   = go_100
    ).
  ENDMETHOD.


  METHOD status.
    DATA: lt_excl TYPE slis_t_extab,
          l_statu TYPE string,
          l_title TYPE string,
          l_text  TYPE string.

    CONCATENATE 'ST_' sy-dynnr INTO l_statu.
    CONCATENATE 'TI_' sy-dynnr INTO l_title.

    CASE ctrl->g_aktyp.
      WHEN 'A'.           l_text = 'Modificar'.
      WHEN ctrl->gc_ver.  l_text = 'Visualizar'.
      WHEN OTHERS.        l_text = 'Reporte/Emisión'.
    ENDCASE.

    APPEND 'SAVE' TO lt_excl.

    IF ctrl->g_aktyp = ctrl->gc_ver OR ( gs_cab-aktyp = ctrl->gc_ver AND sy-dynnr = 200 ).
      APPEND 'NEW' TO lt_excl.
      APPEND 'DEL' TO lt_excl.
      APPEND 'CHECK' TO lt_excl.
      APPEND 'LIB' TO lt_excl.
    ENDIF.

    SET PF-STATUS l_statu OF PROGRAM sy-cprog EXCLUDING lt_excl.
    SET TITLEBAR l_title OF PROGRAM sy-cprog WITH l_text.
  ENDMETHOD.


  METHOD uc.
    DATA l_ucomm TYPE sy-ucomm.

    l_ucomm = sy-ucomm.
    CLEAR sy-ucomm.

    CASE l_ucomm.
      WHEN 'BACK' OR 'EXIT' OR 'CANC'.
        SET SCREEN 0.
        LEAVE SCREEN.
    ENDCASE.

    CASE sy-dynnr.
      WHEN 100 OR 150. cab_100_uc( e_ucomm = l_ucomm ).
      WHEN 200. det_200_uc( e_ucomm = l_ucomm ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
