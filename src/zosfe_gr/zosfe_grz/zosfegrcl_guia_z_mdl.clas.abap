CLASS zosfegrcl_guia_z_mdl DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES gty_cab TYPE zossdcl_pro_extrac_fe_gr=>gty_cab_z .
    TYPES:
      gtt_cab TYPE TABLE OF gty_cab WITH DEFAULT KEY .

    CONSTANTS gc_gray TYPE char4 VALUE '@EB@' ##NO_TEXT.
    CONSTANTS gc_green TYPE char4 VALUE '@08@' ##NO_TEXT.
    CONSTANTS gc_red TYPE char4 VALUE '@0A@' ##NO_TEXT.
    CONSTANTS gc_yellow TYPE char4 VALUE '@09@' ##NO_TEXT.
    CONSTANTS gc_chare TYPE char1 VALUE 'E' ##NO_TEXT.
    CONSTANTS gc_charw TYPE char1 VALUE 'W' ##NO_TEXT.
    CONSTANTS gc_chars TYPE char1 VALUE 'S' ##NO_TEXT.
    DATA:
      BEGIN OF gc_tabname,
        ekko   TYPE tabname VALUE 'EKKO',
        mkpf   TYPE tabname VALUE 'MKPF',
        vbak   TYPE tabname VALUE 'VBAK',
        manual TYPE tabname VALUE 'ZOSTB_FEGRCAB',
      END OF gc_tabname .
    DATA ctrl TYPE REF TO zosfegrcl_guia_z_ctrl .
    DATA gt_cabdb TYPE TABLE OF zostb_fegrcab.
    DATA gt_detdb TYPE TABLE OF zostb_fegrdet.

    METHODS baja_get_data
      RETURNING
        VALUE(rt_cab) TYPE gtt_cab
      EXCEPTIONS
        error .
    METHODS baja_save
      EXPORTING
        !et_return TYPE bapirettab
      CHANGING
        !ct_cab    TYPE gtt_cab
      EXCEPTIONS
        error .
    METHODS check
      EXCEPTIONS
        error .
    METHODS constructor .
    METHODS guia_get_data
      RETURNING
        VALUE(rt_cab) TYPE gtt_cab.
    METHODS guia_inicializa
      CHANGING
        !cs_cab TYPE gty_cab .
    METHODS guia_save
      IMPORTING
        !i_test    TYPE xfeld OPTIONAL
        !i_cab     TYPE xfeld OPTIONAL
      EXPORTING
        !et_return TYPE bapirettab
      CHANGING
        !cs_cab    TYPE gty_cab
      EXCEPTIONS
        error
        lock.
    METHODS guia_valid
      IMPORTING
        !i_cab  TYPE xfeld OPTIONAL
      CHANGING
        !cs_cab TYPE gty_cab
      EXCEPTIONS
        error .
    METHODS start
      IMPORTING
        !io_ctrl TYPE REF TO object
      EXPORTING
        et_cab   TYPE gtt_cab
        e_dynnr  TYPE sy-dynnr
      EXCEPTIONS
        error .
  PROTECTED SECTION.

    METHODS guia_get_data_cust
      CHANGING
        !ct_cab TYPE gtt_cab .
  PRIVATE SECTION.

    DATA:
      lt_cat06 TYPE TABLE OF zostb_catalogo06 .
    DATA:
      lt_cat18 TYPE TABLE OF zostb_catalogo18 .
    DATA:
      lt_cat20 TYPE TABLE OF zostb_catalogo20 .
    DATA:
      lt_hom20 TYPE TABLE OF zostb_catahomo20 .
    DATA:
      lt_grcab TYPE TABLE OF zoses_fegrcab .
    DATA:
      lt_grtxt TYPE TABLE OF zostb_fegrtxt .
    DATA:
      lt_lfa1 TYPE TABLE OF lfa1 .
    DATA:
      lt_kna1 TYPE TABLE OF kna1 .
    DATA:
      ls_cat06 LIKE LINE OF lt_cat06 .
    DATA:
      ls_cat18 LIKE LINE OF lt_cat18.
    DATA:
      ls_cat20 LIKE LINE OF lt_cat20 .
    DATA:
      ls_hom20 LIKE LINE OF lt_hom20 .
    DATA:
      ls_grcab LIKE LINE OF lt_grcab .
    DATA:
      ls_lfa1 LIKE LINE OF lt_lfa1 .
    DATA:
      ls_kna1 LIKE LINE OF lt_kna1 .
    DATA l_message TYPE string .

    METHODS cab_conductor
      CHANGING
        !cs_cab TYPE gty_cab .
    METHODS cab_destinatario
      CHANGING
        !cs_cab TYPE gty_cab .
    METHODS cab_enable
      CHANGING
        !cs_cab TYPE gty_cab .
    METHODS cab_inicializa
      CHANGING
        !cs_cab TYPE gty_cab .
    METHODS cab_is_initial
      CHANGING
        !cs_cab TYPE gty_cab .
    METHODS cab_is_initial_transporte
      CHANGING
        !cs_cab TYPE gty_cab .
    METHODS cab_remitente
      CHANGING
        !cs_cab TYPE gty_cab .
    METHODS cab_solicitante
      CHANGING
        !cs_cab TYPE gty_cab .
    METHODS cab_transportista
      CHANGING
        !cs_cab TYPE gty_cab .
    METHODS cab_traslado_modalidad
      CHANGING
        !cs_cab TYPE gty_cab .
    METHODS cab_traslado_motivo
      CHANGING
        !cs_cab TYPE gty_cab .
    METHODS det_cantidad
      IMPORTING
        !is_cab TYPE gty_cab OPTIONAL
      CHANGING
        !cs_det LIKE LINE OF is_cab-t_det .
    METHODS det_inicializa
      IMPORTING
        !is_cab TYPE gty_cab
      CHANGING
        !cs_det LIKE LINE OF is_cab-t_det .
    METHODS guia_save_do
      CHANGING
        !cs_cab TYPE gty_cab
      EXCEPTIONS
        error .
    METHODS guia_save_pre
      CHANGING
        !cs_cab TYPE gty_cab
      EXCEPTIONS
        error .
    METHODS guia_valid_cab
      CHANGING
        !cs_cab TYPE gty_cab
      EXCEPTIONS
        error .
    METHODS guia_valid_det
      CHANGING
        !cs_cab TYPE gty_cab
        !cs_det LIKE LINE OF cs_cab-t_det
      EXCEPTIONS
        error .
    METHODS guia_get_data_fill
      IMPORTING
                zznrosap      TYPE zostb_fegrcab-zznrosap
                zzgjahr       TYPE zostb_fegrcab-zzgjahr OPTIONAL
      RETURNING VALUE(rs_cab) TYPE gty_cab.
    METHODS det_descripcion
      CHANGING
        cs_det TYPE zossdcl_pro_extrac_fe_gr=>ty_det_z
      EXCEPTIONS
        error.
    METHODS cab_status CHANGING cs_cab TYPE gty_cab.
ENDCLASS.



CLASS zosfegrcl_guia_z_mdl IMPLEMENTATION.


  METHOD baja_get_data.
    DATA: lt_log      TYPE TABLE OF zostb_felog,
          ls_log      LIKE LINE OF lt_log,
          ls_const    TYPE zostb_const_fe,
          l_datelimit TYPE sy-datum.
    FIELD-SYMBOLS <fs_cab> LIKE LINE OF rt_cab.

    "valid
    SELECT COUNT(*) FROM zostb_usrautreg WHERE uname = sy-uname AND cbgrele = abap_on.
    IF sy-subrc <> 0.
      MESSAGE e000 WITH 'No tiene autorización' 'para dar de baja Guias Electrónicas' RAISING error.
    ENDIF.

    "fecha
    l_datelimit = ctrl->ui->get_datelimit_baja( ).

    "log
    IF ctrl->zsel-ebeln_r IS NOT INITIAL.
      SELECT * INTO TABLE lt_log FROM zostb_felog WHERE zzt_nrodocsap IN ctrl->zsel-ebeln_r.
    ENDIF.
    IF ctrl->zsel-mblnr_r IS NOT INITIAL.
      SELECT * APPENDING TABLE lt_log FROM zostb_felog WHERE zzt_nrodocsap IN ctrl->zsel-mblnr_r AND gjahr IN ctrl->zsel-mjahr_r.
    ENDIF.
    IF ctrl->zsel-vbeln_r IS NOT INITIAL.
      SELECT * APPENDING TABLE lt_log FROM zostb_felog WHERE zzt_nrodocsap IN ctrl->zsel-vbeln_r.
    ENDIF.
    IF ctrl->zsel-aib_nrguia_r IS NOT INITIAL.
      SELECT * APPENDING TABLE lt_log FROM zostb_felog WHERE zzt_nrodocsap IN ctrl->zsel-aib_nrguia_r AND gjahr IN ctrl->zsel-aib_gjahr_r.
    ENDIF.
    IF ctrl->zsel-zznrosap_r IS NOT INITIAL.
      SELECT * APPENDING TABLE lt_log FROM zostb_felog WHERE zzt_nrodocsap IN ctrl->zsel-zznrosap_r AND tabname = gc_tabname-manual.
    ENDIF.
    IF lt_log IS INITIAL.
      SELECT * INTO TABLE lt_log FROM zostb_felog WHERE zzt_fcreacion >= l_datelimit.
    ENDIF.

    "filtro fecha y status
    DELETE lt_log WHERE zzt_fcreacion < l_datelimit OR ( zzt_status_cdr <> 1 OR zzt_status_cdr = 4 ).

    "get
    IF lt_log IS NOT INITIAL.
      SELECT * INTO CORRESPONDING FIELDS OF TABLE rt_cab
        FROM zostb_fegrcab
        FOR ALL ENTRIES IN lt_log
        WHERE zznrosap = lt_log-zzt_nrodocsap
          AND zzgjahr  = lt_log-gjahr
          AND is_guia_z = abap_on.

      LOOP AT rt_cab ASSIGNING <fs_cab>.
        READ TABLE lt_log INTO ls_log WITH KEY zzt_nrodocsap = <fs_cab>-zznrosap gjahr = <fs_cab>-zzgjahr.
        <fs_cab>-zzt_status_cdr = ls_log-zzt_status_cdr.

        SELECT * INTO CORRESPONDING FIELDS OF TABLE <fs_cab>-t_det
          FROM zostb_fegrdet
          WHERE zznrosap = <fs_cab>-zznrosap
            AND zzgjahr = <fs_cab>-zzgjahr.
      ENDLOOP.
    ENDIF.

    IF rt_cab IS INITIAL.
      MESSAGE e000 WITH 'No hay documentos de selección' RAISING error.
    ENDIF.
  ENDMETHOD.


  METHOD baja_save.
    DATA: lt_return  TYPE bapirettab.

    FIELD-SYMBOLS: <fs_cab> LIKE LINE OF ct_cab.

    ctrl->ui->isconfirm( EXPORTING i_question = 'Desea liberar la(s) guia(s)' EXCEPTIONS cancel = 1 ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.

    LOOP AT ct_cab ASSIGNING <fs_cab> WHERE box IS NOT INITIAL.
      ctrl->gr->extrae_data_guia_baja(
        EXPORTING
          i_bukrs   = <fs_cab>-bukrs
          i_fecemi  = <fs_cab>-zzfecemi
          i_nrosap  = <fs_cab>-zznrosap
          i_nrosun  = <fs_cab>-zznrosun
          i_gjahr   = <fs_cab>-zzgjahr
        IMPORTING
          et_return = lt_return
        EXCEPTIONS
          error     = 1
      ).
      IF sy-subrc = 0.
        <fs_cab>-zzt_status_cdr = 8.
        APPEND LINES OF lt_return TO et_return.
      ELSE.
        RAISE error.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD cab_conductor.
    IF cs_cab-zzconnro IS NOT INITIAL AND cs_cab-zzcontpd_h IS INITIAL.
      READ TABLE lt_grcab INTO ls_grcab WITH KEY zzconnro = cs_cab-zzconnro.
      IF sy-subrc <> 0.
        SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_grcab FROM zostb_fegrcab WHERE zzconnro = cs_cab-zzconnro.
        IF sy-subrc = 0.
          ctrl->gr->fegrtxt_get( CHANGING cs_cab = ls_grcab ).
          APPEND ls_grcab TO lt_grcab.
        ENDIF.
      ENDIF.
      IF sy-subrc = 0.
        cs_cab-zzcontpd_h = ls_grcab-zzcontpd_h.
        cs_cab-zzconden   = ls_grcab-zzconden.
        cs_cab-zztrabvt   = ls_grcab-zztrabvt.
      ENDIF.
    ELSEIF cs_cab-zzconnro IS NOT INITIAL AND cs_cab-zzcontpd_h IS NOT INITIAL.
      READ TABLE lt_cat06 INTO ls_cat06 WITH KEY zz_codigo_sunat = cs_cab-zzcontpd_h.
      IF sy-subrc = 0.
        IF ls_cat06-nrolen <> strlen( cs_cab-zzconnro ).
          MESSAGE e000 WITH cs_cab-zzconnro 'debe tener' ls_cat06-nrolen 'digitos' INTO l_message.
          APPEND ctrl->ui->return_from_sy( 'zzconnro' ) TO cs_cab-t_statu.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD cab_destinatario.
    IF cs_cab-kunnr IS INITIAL AND cs_cab-lifnr IS INITIAL AND cs_cab-zzdstwer IS INITIAL.
      IF cs_cab-zzdstnro IS NOT INITIAL AND cs_cab-zzdsttpd_h IS INITIAL.
        READ TABLE lt_grcab INTO ls_grcab WITH KEY zzdstnro = cs_cab-zzdstnro.
        IF sy-subrc <> 0.
          SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_grcab FROM zostb_fegrcab WHERE zzdstnro = cs_cab-zzdstnro.
          IF sy-subrc = 0.
            ctrl->gr->fegrtxt_get( CHANGING cs_cab = ls_grcab ).
            APPEND ls_grcab TO lt_grcab.
          ENDIF.
        ENDIF.
        IF sy-subrc = 0.
          cs_cab-zzdsttpd_h = ls_grcab-zzdsttpd_h.
          cs_cab-zzdstden   = ls_grcab-zzdstden.
        ENDIF.
      ELSEIF cs_cab-zzdstnro IS NOT INITIAL AND cs_cab-zzdsttpd_h IS NOT INITIAL.
        READ TABLE lt_cat06 INTO ls_cat06 WITH KEY zz_codigo_sunat = cs_cab-zzdsttpd_h.
        IF sy-subrc = 0.
          IF ls_cat06-nrolen <> strlen( cs_cab-zzdstnro ).
            MESSAGE e000 WITH cs_cab-zzdstnro 'debe tener' ls_cat06-nrolen 'digitos' INTO l_message.
            APPEND ctrl->ui->return_from_sy( 'zzdstnro' ) TO cs_cab-t_statu.
          ENDIF.
        ENDIF.
      ENDIF.
    ELSEIF cs_cab-zzdstwer IS NOT INITIAL.
      SELECT COUNT(*) FROM t001w WHERE werks = cs_cab-zzdstwer.
      IF sy-subrc <> 0.
        MESSAGE e000 WITH 'Centro' cs_cab-kunnr 'no existe' INTO l_message.
        APPEND ctrl->ui->return_from_sy( 'zzdstwer' ) TO cs_cab-t_statu.
      ENDIF.
    ELSEIF cs_cab-kunnr IS NOT INITIAL.
      READ TABLE lt_kna1 WITH KEY kunnr = cs_cab-kunnr TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        SELECT SINGLE * INTO ls_kna1 FROM kna1 WHERE kunnr = cs_cab-kunnr.
        IF sy-subrc = 0.
          APPEND ls_kna1 TO lt_kna1.
        ENDIF.
      ENDIF.
      IF sy-subrc <> 0.
        MESSAGE e000 WITH 'Cliente' cs_cab-kunnr 'no existe' INTO l_message.
        APPEND ctrl->ui->return_from_sy( 'kunnr' ) TO cs_cab-t_statu.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD cab_enable.
    "Partida
    INSERT ctrl->ui->cell_setstyle( 'ZZPARWER' )    INTO TABLE cs_cab-styl.
    INSERT ctrl->ui->cell_setstyle( 'ZZPARLGO' )    INTO TABLE cs_cab-styl.
    IF cs_cab-zzparwer IS INITIAL.
      INSERT ctrl->ui->cell_setstyle( 'ZZPARLIF' )  INTO TABLE cs_cab-styl.
    ENDIF.
    IF cs_cab-zzparwer IS INITIAL AND cs_cab-zzparlif IS INITIAL.
      INSERT ctrl->ui->cell_setstyle( 'ZZPARUBI' )    INTO TABLE cs_cab-styl.
      INSERT ctrl->ui->cell_setstyle( 'ZZPARDIR' )    INTO TABLE cs_cab-styl.
    ENDIF.


    "Llegada
    INSERT ctrl->ui->cell_setstyle( 'KUNNR' )       INTO TABLE cs_cab-styl.
    IF cs_cab-kunnr IS INITIAL.
      INSERT ctrl->ui->cell_setstyle( 'LIFNR' )     INTO TABLE cs_cab-styl.
    ENDIF.
    IF cs_cab-kunnr IS INITIAL AND cs_cab-lifnr IS INITIAL.
      INSERT ctrl->ui->cell_setstyle( 'ZZDSTWER' )    INTO TABLE cs_cab-styl.
      INSERT ctrl->ui->cell_setstyle( 'ZZDSTLGO' )    INTO TABLE cs_cab-styl.
    ENDIF.

    IF cs_cab-kunnr IS INITIAL AND cs_cab-zzdstwer IS INITIAL AND cs_cab-lifnr IS INITIAL.
      INSERT ctrl->ui->cell_setstyle( 'ZZDSTNRO' )    INTO TABLE cs_cab-styl.
      INSERT ctrl->ui->cell_setstyle( 'ZZDSTTPD_H' )  INTO TABLE cs_cab-styl.
      INSERT ctrl->ui->cell_setstyle( 'ZZDSTDEN' )    INTO TABLE cs_cab-styl.
    ENDIF.

    INSERT ctrl->ui->cell_setstyle( 'ZZLLEKUN' )    INTO TABLE cs_cab-styl.
    IF cs_cab-zzllekun IS INITIAL.
      INSERT ctrl->ui->cell_setstyle( 'ZZLLELIF' ) INTO TABLE cs_cab-styl.
    ENDIF.
    IF cs_cab-zzllekun IS INITIAL AND cs_cab-zzllelif IS INITIAL.
      INSERT ctrl->ui->cell_setstyle( 'ZZLLEUBI' ) INTO TABLE cs_cab-styl.
      INSERT ctrl->ui->cell_setstyle( 'ZZLLEDIR' ) INTO TABLE cs_cab-styl.
    ENDIF.

    INSERT ctrl->ui->cell_setstyle( 'ZZSLCNRO' )    INTO TABLE cs_cab-styl.
    INSERT ctrl->ui->cell_setstyle( 'ZZSLCTPD_H' )  INTO TABLE cs_cab-styl.
    INSERT ctrl->ui->cell_setstyle( 'ZZSLCDEN' )    INTO TABLE cs_cab-styl.


    "Trasnporte
    INSERT ctrl->ui->cell_setstyle( 'ZZTRSMOT_H' )  INTO TABLE cs_cab-styl.
    IF cs_cab-is_trsden_cust = abap_on.
      INSERT ctrl->ui->cell_setstyle( 'ZZTRSDEN' )  INTO TABLE cs_cab-styl.
    ENDIF.
    INSERT ctrl->ui->cell_setstyle( 'ZZTRAFEC' )    INTO TABLE cs_cab-styl.
    INSERT ctrl->ui->cell_setstyle( 'ZZTRAHOR' )    INTO TABLE cs_cab-styl.
    INSERT ctrl->ui->cell_setstyle( 'ZZTRSMOD_H' )  INTO TABLE cs_cab-styl.

    INSERT ctrl->ui->cell_setstyle( 'ZZTRALIF' )    INTO TABLE cs_cab-styl.
    IF cs_cab-zztralif IS INITIAL.
      INSERT ctrl->ui->cell_setstyle( 'ZZTRANRO' )    INTO TABLE cs_cab-styl.
      INSERT ctrl->ui->cell_setstyle( 'ZZTRATPD_H' )  INTO TABLE cs_cab-styl.
      INSERT ctrl->ui->cell_setstyle( 'ZZTRADEN' )    INTO TABLE cs_cab-styl.
    ENDIF.
    INSERT ctrl->ui->cell_setstyle( 'ZZTRAMTC' )    INTO TABLE cs_cab-styl.


    "Principal
    INSERT ctrl->ui->cell_setstyle( 'ZZPLAVEH' )    INTO TABLE cs_cab-styl.
    INSERT ctrl->ui->cell_setstyle( 'ZZTRAMAR' )    INTO TABLE cs_cab-styl.
    INSERT ctrl->ui->cell_setstyle( 'ZZTRANCI' )    INTO TABLE cs_cab-styl.
    INSERT ctrl->ui->cell_setstyle( 'ZZTRANCV' )    INTO TABLE cs_cab-styl.

    INSERT ctrl->ui->cell_setstyle( 'ZZCONNRO' )    INTO TABLE cs_cab-styl.
    INSERT ctrl->ui->cell_setstyle( 'ZZCONTPD_H' )  INTO TABLE cs_cab-styl.
    INSERT ctrl->ui->cell_setstyle( 'ZZCONDEN' )    INTO TABLE cs_cab-styl.
    INSERT ctrl->ui->cell_setstyle( 'ZZTRABVT' )    INTO TABLE cs_cab-styl.


    "Adicional
    INSERT ctrl->ui->cell_setstyle( 'ZZTOTBLT' )    INTO TABLE cs_cab-styl.
    INSERT ctrl->ui->cell_setstyle( 'ZZOBSERV' )    INTO TABLE cs_cab-styl.
    INSERT ctrl->ui->cell_setstyle( 'ZZOBSERV' )    INTO TABLE cs_cab-styl.
  ENDMETHOD.


  METHOD cab_inicializa.
    DATA: ls_det LIKE LINE OF cs_cab-t_det.

    IF cs_cab-tabname IS INITIAL.
      cs_cab-tabname = gc_tabname-manual.
    ENDIF.

    IF cs_cab-is_guia_z IS INITIAL.
      cs_cab-is_guia_z = abap_on.
    ENDIF.

    IF cs_cab-btn_statu IS INITIAL.
      cs_cab-btn_statu = gc_gray.
      cs_cab-btn_det   = icon_list.
      cs_cab-btn_check = icon_check.
    ENDIF.

    IF cs_cab-zzfecemi IS INITIAL.
      cs_cab-zzfecemi = sy-datlo.
      cs_cab-zzhoremi = sy-timlo.
    ENDIF.

    IF cs_cab-zztrafec IS INITIAL.
      cs_cab-zztrafec = sy-datlo.
      cs_cab-zztrahor = sy-timlo.
    ENDIF.

    IF cs_cab-t_det IS INITIAL.
      MOVE-CORRESPONDING cs_cab TO ls_det.
      ls_det-posnr = 10.
      APPEND ls_det TO cs_cab-t_det.
    ENDIF.

    cs_cab-ernam = sy-uname.
  ENDMETHOD.


  METHOD cab_is_initial.
    "Partida
    IF cs_cab-zzparwer IS INITIAL AND cs_cab-zzparlgo IS INITIAL AND cs_cab-zzparlif IS INITIAL AND cs_cab-zzparubi IS INITIAL.
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzparwer'   i_text = 'Ingrese Centro de partida' CHANGING ct_return = cs_cab-t_statu ).
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzparlgo'   i_text = 'Ingrese Almacen de partida' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzparlif'   i_text = 'Ingrese Proveedor de partida' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzparubi'   i_text = 'Ingrese partida ubigeo' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzpardir'   i_text = 'Ingrese partida direccion' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).
    ENDIF.

    IF cs_cab-zzpardir IS NOT INITIAL.
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzpardir'   i_text = 'Ingrese partida direccion' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).
    ENDIF.
    IF cs_cab-zzparwer IS INITIAL AND cs_cab-zzparlgo IS INITIAL AND cs_cab-zzparlif IS INITIAL AND cs_cab-zzparubi IS NOT INITIAL.
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzpardir'   i_text = 'Ingrese partida direccion' CHANGING ct_return = cs_cab-t_statu ).
    ENDIF.


    "Llegada
    IF cs_cab-kunnr IS INITIAL AND cs_cab-lifnr IS INITIAL AND cs_cab-zzdstwer IS INITIAL AND cs_cab-zzdstnro IS INITIAL.
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'kunnr'      i_text = 'Ingrese Cliente destinatario' CHANGING ct_return = cs_cab-t_statu ).
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'lifnr'      i_text = 'Ingrese Proveedor destinatario' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzdstwer'   i_text = 'Ingrese Centro de llegada' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzdstlgo'   i_text = 'Ingrese Almacen de llegada' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzdstnro'   i_text = 'Ingrese destinatario nro' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzdsttpd_h' i_text = 'Ingrese destinatario nro tipo' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzdstden'   i_text = 'Ingrese destinatario denominacion' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).
    ENDIF.
    IF cs_cab-kunnr IS INITIAL AND cs_cab-lifnr IS INITIAL AND cs_cab-zzdstwer IS INITIAL AND cs_cab-zzdstnro IS NOT INITIAL.
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzdsttpd_h' i_text = 'Ingrese destinatario nro tipo' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzdstden'   i_text = 'Ingrese destinatario denominacion' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).
    ENDIF.
    IF cs_cab-kunnr IS INITIAL AND cs_cab-lifnr IS INITIAL AND cs_cab-zzdstwer IS INITIAL AND cs_cab-zzlleubi IS INITIAL.
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzllekun'   i_text = 'Ingrese Cliente de llegada' CHANGING ct_return = cs_cab-t_statu ).
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzllelif'   i_text = 'Ingrese Proveedor de llegada' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzlleubi'   i_text = 'Ingrese llegada ubigeo' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzlledir'   i_text = 'Ingrese llegada direccion' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).
    ENDIF.
    IF cs_cab-zzlleubi IS NOT INITIAL.
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzlledir'   i_text = 'Ingrese llegada direccion' CHANGING ct_return = cs_cab-t_statu ).
    ENDIF.
    IF cs_cab-kunnr IS INITIAL AND cs_cab-lifnr IS INITIAL AND cs_cab-zzdstwer IS INITIAL AND cs_cab-zzdstnro IS INITIAL.
      "ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzslclif'   i_text = 'Ingrese Proveedor solicitante' CHANGING ct_return = cs_cab-t_statu ).
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzslcnro'   i_text = 'Ingrese solicitante nro' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzslctpd_h' i_text = 'Ingrese solicitante nro tipo' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzslcden'   i_text = 'Ingrese solicitante denominacion' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).
    ENDIF.


    "Transporte
    ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zztrsmot_h'   i_text = 'Ingrese Motivo de traslado' CHANGING ct_return = cs_cab-t_statu ).
    IF cs_cab-is_trsden_cust = abap_on.
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zztrsden'   i_text = 'Ingrese denominacion de traslado' CHANGING ct_return = cs_cab-t_statu ).
    ENDIF.
    ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zztrafec'     i_text = 'Ingrese fecha de traslado' CHANGING ct_return = cs_cab-t_statu ).
    ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zztrahor'     i_text = 'Ingrese hora de traslado' CHANGING ct_return = cs_cab-t_statu ).
    ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zztrsmod_h'   i_text = 'Ingrese Modalidad de traslado' CHANGING ct_return = cs_cab-t_statu ).

    cab_is_initial_transporte( CHANGING cs_cab = cs_cab ).
  ENDMETHOD.


  METHOD cab_is_initial_transporte.
    IF cs_cab-is_trsmod_public = abap_on.
      IF cs_cab-zztralif IS INITIAL AND cs_cab-zztranro IS INITIAL.
        ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zztralif'   i_text = 'Ingrese Proveedor transportista' CHANGING ct_return = cs_cab-t_statu ).
        ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zztranro'   i_text = 'Ingrese transportista nro' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).
        ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zztratpd_h' i_text = 'Ingrese transportista nro tipo' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).
        ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zztraden'   i_text = 'Ingrese transportista denominacion' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).
      ENDIF.
      IF cs_cab-zztranro IS NOT INITIAL.
        ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zztratpd_h' i_text = 'Ingrese transportista nro tipo' CHANGING ct_return = cs_cab-t_statu ).
        ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zztraden'   i_text = 'Ingrese transportista denominacion' CHANGING ct_return = cs_cab-t_statu ).
        ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zztramtc'   i_text = 'Ingrese MTC' CHANGING ct_return = cs_cab-t_statu ).
      ENDIF.
    ENDIF.

    ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzplaveh'   i_text = 'Ingrese transportista placa' CHANGING ct_return = cs_cab-t_statu ).
    ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zztramar'   i_text = 'Ingrese marca de vehiculo' CHANGING ct_return = cs_cab-t_statu ).
    ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zztranci'   i_text = 'Ingrese constancia de inscripcion' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).
    ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zztrancv'   i_text = 'Ingrese configuracion vehicular' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).

    ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzconnro'   i_text = 'Ingrese conductor nro' CHANGING ct_return = cs_cab-t_statu ).
    ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzcontpd_h' i_text = 'Ingrese conductor nro tipo' CHANGING ct_return = cs_cab-t_statu ).
    ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzconden'   i_text = 'Ingrese conductor denominacion' CHANGING ct_return = cs_cab-t_statu ).
    ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zztrabvt'   i_text = 'Ingrese conductor licencia' CHANGING ct_return = cs_cab-t_statu ).
  ENDMETHOD.


  METHOD cab_remitente.
    IF cs_cab-zzparwer IS NOT INITIAL.
      SELECT COUNT(*) FROM t001w WHERE werks = cs_cab-zzparwer.
      IF sy-subrc <> 0.
        MESSAGE e000 WITH 'Puesto' cs_cab-zzparwer 'no existe' INTO l_message.
        APPEND ctrl->ui->return_from_sy( 'zzparwer' ) TO cs_cab-t_statu.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD cab_solicitante.
    IF cs_cab-zzslcnro IS NOT INITIAL.
      READ TABLE lt_grcab INTO ls_grcab WITH KEY zzslcnro = cs_cab-zzslcnro.
      IF sy-subrc <> 0.
        SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_grcab FROM zostb_fegrcab WHERE zzslcnro = cs_cab-zzslcnro.
        IF sy-subrc = 0.
          ctrl->gr->fegrtxt_get( CHANGING cs_cab = ls_grcab ).
          APPEND ls_grcab TO lt_grcab.
        ENDIF.
      ENDIF.
      IF sy-subrc = 0.
        cs_cab-zzslctpd_h = ls_grcab-zzslctpd_h.
        cs_cab-zzslcden   = ls_grcab-zzslcden.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD cab_transportista.
    IF cs_cab-zztralif IS NOT INITIAL.
      READ TABLE lt_lfa1 INTO ls_lfa1 WITH KEY lifnr = cs_cab-zztralif.
      IF sy-subrc = 0.

      ENDIF.
    ELSEIF cs_cab-zztranro IS NOT INITIAL AND cs_cab-zztratpd_h IS INITIAL.
      READ TABLE lt_grcab INTO ls_grcab WITH KEY zztranro = cs_cab-zztranro.
      IF sy-subrc <> 0.
        SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_grcab FROM zostb_fegrcab WHERE zztranro = cs_cab-zztranro.
        IF sy-subrc = 0.
          ctrl->gr->fegrtxt_get( CHANGING cs_cab = ls_grcab ).
          APPEND ls_grcab TO lt_grcab.
        ENDIF.
      ENDIF.
      IF sy-subrc = 0.
        cs_cab-zztratpd_h = ls_grcab-zztratpd_h.
        cs_cab-zztraden   = ls_grcab-zztraden.
      ENDIF.
    ELSEIF cs_cab-zztranro IS NOT INITIAL AND cs_cab-zztratpd_h IS NOT INITIAL.
      READ TABLE lt_cat06 INTO ls_cat06 WITH KEY zz_codigo_sunat = cs_cab-zztratpd_h.
      IF sy-subrc = 0.
        IF ls_cat06-nrolen <> strlen( cs_cab-zztranro ).
          MESSAGE e000 WITH cs_cab-zztranro 'debe tener' ls_cat06-nrolen 'digitos' INTO l_message.
          APPEND ctrl->ui->return_from_sy( 'zzconnro' ) TO cs_cab-t_statu.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD cab_traslado_modalidad.
    IF cs_cab-zzparwer IS NOT INITIAL AND cs_cab-zzdstwer IS NOT INITIAL AND cs_cab-zztrsmod_h IS INITIAL.
      cs_cab-zztrsmod_h = '02'.
    ENDIF.
    IF cs_cab-zztrsmod_h IS NOT INITIAL.
      READ TABLE lt_cat18 INTO ls_cat18 WITH KEY zz_codigo_sunat = cs_cab-zztrsmod_h.
      IF sy-subrc = 0.
        cs_cab-is_trsmod_public = ls_cat18-is_trans_public.
      ELSE.
        MESSAGE e000 WITH 'Modalidad' cs_cab-zztrsmod_h 'no existe' INTO l_message.
        APPEND ctrl->ui->return_from_sy( 'zztrsmod_h' ) TO cs_cab-t_statu.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD cab_traslado_motivo.
    IF cs_cab-zztrsmot_h IS NOT INITIAL.
      READ TABLE lt_cat20 INTO ls_cat20 WITH KEY zz_codigo_sunat = cs_cab-zztrsmot_h.
      IF sy-subrc = 0.
        cs_cab-is_trsden_cust    = ls_cat20-is_desc_cust.
        IF cs_cab-is_trsden_cust = abap_on.
          cs_cab-zztrsden        = ls_cat20-zz_desc_cod_suna.
        ENDIF.
      ELSE.
        MESSAGE e000 WITH 'Motivo' cs_cab-zztrsmod_h 'no existe' INTO l_message.
        APPEND ctrl->ui->return_from_sy( 'zztrsmot_h' ) TO cs_cab-t_statu.
      ENDIF.
    ELSE.
      IF cs_cab-bwart IS NOT INITIAL.
        READ TABLE lt_hom20 INTO ls_hom20 WITH KEY bwart = cs_cab-bwart.
        IF sy-subrc = 0.
          cs_cab-zztrsmot_h     = ls_hom20-zz_codigo_sunat.
          cs_cab-is_trsden_cust = ls_cat20-is_desc_cust.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD check.
    DATA: l_rgtno TYPE idcn_loma-rgtno.

    " Validar autorización a Sociedad
    zosclpell_libros_legales=>_authority_check_f_bkpf_buk( EXPORTING i_bukrs = ctrl->zsel-bukrs EXCEPTIONS error = 1 ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.

    " Sociedad
    IF ctrl->zsel-bukrs IS INITIAL.
      MESSAGE e000 WITH 'Ingrese sociedad' RAISING error.
    ELSE.
      SELECT COUNT(*) FROM zostb_ceactsoc WHERE bukrs = ctrl->zsel-bukrs AND guiaele = abap_on.
      IF sy-subrc <> 0.
        MESSAGE e000 WITH 'Sociedad' ctrl->zsel-bukrs 'no activada para emisión' 'de guia electrónica' RAISING error.
      ENDIF.
    ENDIF.

    " Lote
    IF ctrl->zsel-lotno IS INITIAL.
      MESSAGE e000 WITH 'Ingrese lote' RAISING error.
    ELSE.
      SELECT SINGLE rgtno INTO l_rgtno FROM idcn_loma WHERE lotno = ctrl->zsel-lotno.
      l_rgtno = l_rgtno+1.
      SELECT COUNT(*) FROM zostb_lotno WHERE lotno = l_rgtno AND is_lotno_gr = abap_on.
      IF sy-subrc <> 0.
        MESSAGE e000 WITH 'Lote' ctrl->zsel-lotno 'no configurado para guias electrónicas' RAISING error.
      ENDIF.
    ENDIF.

    IF ctrl->zsel-bokno IS INITIAL.
      MESSAGE e000 WITH 'Ingrese libro' RAISING error.
    ELSE.
      SELECT COUNT(*) FROM idcn_boma WHERE lotno = ctrl->zsel-lotno AND bokno = ctrl->zsel-bokno.
      IF sy-subrc <> 0.
        MESSAGE e000 WITH 'Libro' ctrl->zsel-bokno 'no existe para lote' ctrl->zsel-lotno RAISING error.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD constructor.
    SELECT * FROM zostb_catalogo06 INTO TABLE lt_cat06.
    SELECT * FROM zostb_catalogo18 INTO TABLE lt_cat18.
    SELECT * FROM zostb_catalogo20 INTO TABLE lt_cat20.
  ENDMETHOD.


  METHOD det_cantidad.
    DATA: ls_marm TYPE marm.

    IF cs_det-lfimg IS NOT INITIAL AND cs_det-vrkme IS NOT INITIAL AND cs_det-brgew IS INITIAL.
      SELECT SINGLE * INTO ls_marm FROM marm WHERE matnr = cs_det-matnr AND umrez = 1.
      IF sy-subrc = 0.
        ctrl->ui->convert_material_unit(
          EXPORTING
            i_matnr = cs_det-matnr
            i_uniti = cs_det-vrkme
            i_unito = ls_marm-gewei
            i_menge = cs_det-lfimg
          RECEIVING
            r_menge = cs_det-brgew
        ).

        cs_det-gewei = ls_marm-gewei.
      ELSE.
        cs_det-brgew = cs_det-lfimg.
        cs_det-gewei = cs_det-vrkme.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD det_descripcion.
    IF cs_det-matnr IS NOT INITIAL.
      SELECT COUNT(*) FROM mara WHERE matnr = cs_det-matnr.
      IF sy-subrc <> 0.
        MESSAGE e000 WITH 'Material' cs_det-matnr 'no existe' INTO l_message.
        APPEND ctrl->ui->return_from_sy( 'matnr' ) TO cs_det-t_statu.
      ELSE.
        SELECT SINGLE maktx INTO cs_det-arktx FROM makt WHERE matnr = cs_det-matnr AND spras = sy-langu.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD det_inicializa.
    cs_det-btn_statu = gc_gray.
    cs_det-btn_back = icon_pdir_back.

    IF cs_det-werks IS INITIAL.
      cs_det-werks = is_cab-zzparwer.
    ENDIF.
  ENDMETHOD.


  METHOD guia_get_data.

    DATA: lt_ekko  TYPE TABLE OF ekko,
          lt_ekpo  TYPE TABLE OF ekpo,
          lt_mkpf  TYPE TABLE OF mkpf,
          lt_mseg  TYPE TABLE OF mseg,
          lt_mseg2 TYPE TABLE OF mseg,
          lt_vbak  TYPE TABLE OF vbak,
          lt_vbap  TYPE TABLE OF vbap,
          lt_aufk  TYPE TABLE OF aufk,
          lt_resb  TYPE TABLE OF resb,
          lt_cabdb TYPE TABLE OF zostb_fegrcab,

          ls_ekko  LIKE LINE OF lt_ekko,
          ls_ekpo  LIKE LINE OF lt_ekpo,
          ls_mkpf  LIKE LINE OF lt_mkpf,
          ls_mseg  LIKE LINE OF lt_mseg,
          ls_vbak  LIKE LINE OF lt_vbak,
          ls_vbap  LIKE LINE OF lt_vbap.
    DATA: ls_cab   LIKE LINE OF rt_cab,
          ls_det   LIKE LINE OF ls_cab-t_det,
          ls_cabdb LIKE LINE OF gt_cabdb.


    "01. Cargar: ekko, mkpf, vbak, aufk, resb
    IF ctrl->zsel-ebeln_r IS NOT INITIAL.
      SELECT * FROM ekko INTO TABLE lt_ekko WHERE ebeln IN ctrl->zsel-ebeln_r AND bukrs = ctrl->zsel-bukrs.
      SELECT * FROM ekpo INTO TABLE lt_ekpo WHERE ebeln IN ctrl->zsel-ebeln_r AND loekz = space.
    ENDIF.
    IF ctrl->zsel-mblnr_r IS NOT INITIAL.
      SELECT * FROM mkpf INTO TABLE lt_mkpf WHERE mblnr IN ctrl->zsel-mblnr_r AND mjahr IN ctrl->zsel-mjahr_r.
      SELECT * FROM mseg INTO TABLE lt_mseg WHERE mblnr IN ctrl->zsel-mblnr_r AND mjahr IN ctrl->zsel-mjahr_r.
    ENDIF.
    IF ctrl->zsel-vbeln_r IS NOT INITIAL.
      SELECT * FROM vbak INTO TABLE lt_vbak WHERE vbeln IN ctrl->zsel-vbeln_r AND bukrs_vf = ctrl->zsel-bukrs.
      SELECT * FROM vbap INTO TABLE lt_vbap WHERE vbeln IN ctrl->zsel-vbeln_r.
    ENDIF.
    IF ctrl->zsel-aufnr_r IS NOT INITIAL.
      SELECT * FROM aufk INTO TABLE lt_aufk WHERE aufnr IN ctrl->zsel-aufnr_r AND bukrs = ctrl->zsel-bukrs.
      IF lt_aufk IS NOT INITIAL.
        SELECT * FROM resb INTO TABLE lt_resb FOR ALL ENTRIES IN lt_aufk WHERE aufnr = lt_aufk-aufnr AND xloek = space.
      ENDIF.
    ENDIF.
    IF ctrl->zsel-rsnum_r IS NOT INITIAL.
      SELECT * FROM resb INTO TABLE lt_resb WHERE rsnum IN ctrl->zsel-rsnum_r AND xloek = space.
    ENDIF.
    IF lt_resb IS NOT INITIAL.
      SELECT * FROM mseg INTO TABLE lt_mseg2 FOR ALL ENTRIES IN lt_resb WHERE rsnum = lt_resb-rsnum AND rspos = lt_resb-rspos.
      IF lt_mseg2 IS NOT INITIAL.
        SELECT * FROM mkpf APPENDING TABLE lt_mkpf FOR ALL ENTRIES IN lt_mseg2 WHERE mblnr = lt_mseg2-mblnr AND mjahr = lt_mseg2-mjahr.
        APPEND LINES OF lt_mseg2 TO lt_mseg.
      ENDIF.
    ENDIF.


    "02. gr manual
    IF ctrl->zsel-zznrosap_r IS NOT INITIAL.
      SELECT * FROM zostb_fegrcab APPENDING TABLE lt_cabdb WHERE zznrosap IN ctrl->zsel-zznrosap_r AND bukrs = ctrl->zsel-bukrs AND tabname = gc_tabname-manual.
    ENDIF.
    IF ctrl->zsel-zznrosap IS NOT INITIAL.
      SELECT * FROM zostb_fegrcab APPENDING TABLE lt_cabdb WHERE zznrosap = ctrl->zsel-zznrosap AND zzgjahr = ctrl->zsel-zzgjahr.
    ENDIF.


    "03. fegr
    IF lt_ekko IS NOT INITIAL.
      SELECT * FROM zostb_fegrcab APPENDING TABLE gt_cabdb FOR ALL ENTRIES IN lt_ekko WHERE zznrosap = lt_ekko-ebeln.
    ENDIF.
    IF lt_vbak IS NOT INITIAL.
      SELECT * FROM zostb_fegrcab APPENDING TABLE gt_cabdb FOR ALL ENTRIES IN lt_vbak WHERE zznrosap = lt_vbak-vbeln.
    ENDIF.
    IF lt_mkpf IS NOT INITIAL.
      SELECT * FROM zostb_fegrcab APPENDING TABLE gt_cabdb FOR ALL ENTRIES IN lt_mkpf WHERE zznrosap = lt_mkpf-mblnr AND zzgjahr = lt_mkpf-mjahr.
    ENDIF.
    APPEND LINES OF lt_cabdb TO gt_cabdb.
    IF gt_cabdb IS NOT INITIAL.
      SELECT * FROM zostb_fegrdet INTO TABLE gt_detdb FOR ALL ENTRIES IN gt_cabdb WHERE zznrosap = gt_cabdb-zznrosap AND zzgjahr = gt_cabdb-zzgjahr.
    ENDIF.


    "02. Llenar cab
    "02.1 Pedidos
    LOOP AT lt_ekko INTO ls_ekko.
      CLEAR ls_cab.
      ls_cab = guia_get_data_fill( zznrosap = ls_mkpf-mblnr zzgjahr = ls_mkpf-mjahr ).
      IF ls_cab IS INITIAL.
        CLEAR ls_cab.
        ls_cab-zznrosap = ls_ekko-ebeln.
        ls_cab-tabname  = 'EKKO'.
        ls_cab-bukrs    = ctrl->zsel-bukrs.
        ls_cab-zzparlif = ls_ekko-lifnr.

        READ TABLE lt_ekpo INTO ls_ekpo WITH KEY ebeln = ls_ekko-ebeln.
        IF sy-subrc = 0.
          ls_cab-zzdstwer = ls_ekpo-werks.
          ls_cab-zzdstlgo = ls_ekpo-lgort.

          LOOP AT lt_ekpo INTO ls_ekpo WHERE ebeln = ls_ekko-ebeln.
            MOVE-CORRESPONDING ls_cab TO ls_det.
            ls_det-posnr = ls_ekpo-ebelp.
            ls_det-matnr = ls_ekpo-matnr.
            ls_det-arktx = ls_ekpo-txz01.
            ls_det-lfimg = ls_ekpo-menge.
            ls_det-vrkme = ls_ekpo-meins.
            ls_det-brgew = ls_ekpo-ntgew.
            ls_det-gewei = ls_ekpo-gewei.
            ls_det-werks = ls_ekpo-werks.
            ls_det-lgort = ls_ekpo-lgort.
            APPEND ls_det TO ls_cab-t_det.
            CLEAR ls_det.

            ADD ls_det-lfimg TO ls_cab-btgew.
          ENDLOOP.
        ENDIF.
      ENDIF.

      APPEND ls_cab TO rt_cab.
    ENDLOOP.


    "02.2 Movimientos de mercancias
    LOOP AT lt_mkpf INTO ls_mkpf.
      CLEAR ls_cab.
      ls_cab = guia_get_data_fill( zznrosap = ls_ekko-ebeln ).
      IF ls_cab IS INITIAL.
        ls_cab-zznrosap = ls_mkpf-mblnr.
        ls_cab-zzgjahr  = ls_mkpf-mjahr.
        ls_cab-tabname  = 'MKPF'.
        ls_cab-bukrs    = ctrl->zsel-bukrs.

        READ TABLE lt_mseg INTO ls_mseg WITH KEY mblnr = ls_mkpf-mblnr mjahr = ls_mkpf-mjahr.
        IF sy-subrc = 0.
          IF ls_mseg-bwart = '122' OR ls_mseg-bwart = '101'.
            ls_cab-lifnr = ls_mseg-lifnr.
            ls_cab-zzparwer = ls_mseg-werks.
            ls_cab-zzparlgo = ls_mseg-lgort.
          ELSE.
            ls_cab-zzparlif = ls_mseg-lifnr.
            ls_cab-zzdstwer = ls_mseg-werks.
            ls_cab-zzdstlgo = ls_mseg-lgort.
          ENDIF.

          LOOP AT lt_mseg INTO ls_mseg WHERE mblnr = ls_mkpf-mblnr AND mjahr = ls_mkpf-mjahr.
            MOVE-CORRESPONDING ls_cab TO ls_det.
            ls_det-posnr = ls_mseg-zeile.
            ls_det-matnr = ls_mseg-matnr.
            ls_det-arktx = ls_mseg-sgtxt.
            ls_det-lfimg = ls_mseg-erfmg. "menge.
            ls_det-vrkme = ls_mseg-erfme. "meins.
            ls_det-brgew = ls_mseg-erfmg.
            ls_det-gewei = ls_mseg-erfme.
            ls_det-werks = ls_mseg-werks.
            ls_det-lgort = ls_mseg-lgort.
            APPEND ls_det TO ls_cab-t_det.
            CLEAR ls_det.

            ADD ls_det-lfimg TO ls_cab-btgew.
            ls_cab-bwart = ls_mseg-bwart.
          ENDLOOP.
        ENDIF.
      ENDIF.

      APPEND ls_cab TO rt_cab.
    ENDLOOP.


    "02.3 Ventas
    LOOP AT lt_vbak INTO ls_vbak.
      CLEAR ls_cab.
      ls_cab = guia_get_data_fill( zznrosap = ls_vbak-vbeln ).
      IF ls_cab IS INITIAL.
        ls_cab-zznrosap = ls_vbak-vbeln.
        ls_cab-tabname  = 'VBAK'.
        ls_cab-bukrs    = ls_vbak-bukrs_vf.
        ls_cab-kunnr    = ls_vbak-kunnr.

        READ TABLE lt_vbap INTO ls_vbap WITH KEY vbeln = ls_vbak-vbeln.
        IF sy-subrc = 0.
          ls_cab-zzparwer = ls_vbap-werks.
          ls_cab-zzparlgo = ls_vbap-lgort.
          ls_cab-gewei    = ls_vbap-gewei.

          LOOP AT lt_vbap INTO ls_vbap WHERE vbeln = ls_vbak-vbeln.
            MOVE-CORRESPONDING ls_cab TO ls_det.
            ls_det-posnr = ls_vbap-posnr.
            ls_det-matnr = ls_vbap-matnr.
            ls_det-arktx = ls_vbap-arktx.
            ls_det-lfimg = ls_vbap-kwmeng.
            ls_det-vrkme = ls_vbap-vrkme.
            ls_det-brgew = ls_vbap-brgew.
            ls_det-gewei = ls_vbap-gewei.
            ls_det-werks = ls_vbap-werks.
            ls_det-lgort = ls_vbap-lgort.
            APPEND ls_det TO ls_cab-t_det.
            CLEAR ls_det.

            ADD ls_det-lfimg TO ls_cab-btgew.
          ENDLOOP.
        ENDIF.
      ENDIF.

      APPEND ls_cab TO rt_cab.
    ENDLOOP.


    "02.4 Manual
    LOOP AT lt_cabdb INTO ls_cabdb.
      CLEAR ls_cab.
      ls_cab = guia_get_data_fill( zznrosap = ls_cabdb-zznrosap zzgjahr = ls_cabdb-zzgjahr ).
      APPEND ls_cab TO rt_cab.
    ENDLOOP.


    guia_get_data_cust( CHANGING ct_cab = rt_cab ).

  ENDMETHOD.


  METHOD guia_get_data_cust.
  ENDMETHOD.


  METHOD guia_get_data_fill.
    DATA: ls_cab   LIKE LINE OF gt_cabdb,
          ls_det   LIKE LINE OF gt_detdb,
          ls_detgr LIKE LINE OF rs_cab-t_det.

    READ TABLE gt_cabdb INTO ls_cab WITH KEY zznrosap = zznrosap zzgjahr = zzgjahr.
    IF sy-subrc = 0.
      MOVE-CORRESPONDING ls_cab TO rs_cab.
      ctrl->gr->fegrtxt_get( CHANGING cs_cab = rs_cab ).

      SELECT SINGLE zzt_status_cdr INTO rs_cab-zzt_status_cdr FROM zostb_felog WHERE zzt_nrodocsap = rs_cab-zznrosap AND gjahr = rs_cab-zzgjahr.

      LOOP AT gt_detdb INTO ls_det WHERE zznrosap = zznrosap AND zzgjahr = zzgjahr.
        MOVE-CORRESPONDING ls_det TO ls_detgr.

        ls_detgr-btn_back = icon_pdir_back.
        APPEND ls_detgr TO rs_cab-t_det.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD guia_inicializa.
    cab_inicializa( CHANGING cs_cab = cs_cab ).

    guia_save( EXPORTING i_test = abap_on
                         i_cab = abap_on
               CHANGING cs_cab = cs_cab
               EXCEPTIONS error  = 1 ).
  ENDMETHOD.


  METHOD guia_save.
    IF i_test IS INITIAL.
      ctrl->ui->lotno_lock(
        EXPORTING
          i_bukrs = ctrl->zsel-bukrs
          i_lotno = ctrl->zsel-lotno
          i_bokno = ctrl->zsel-bokno
        EXCEPTIONS
          error   = 1
      ).
      IF sy-subrc <> 0.
        RAISE lock.
      ENDIF.
    ENDIF.

    guia_valid( EXPORTING i_cab = i_cab CHANGING cs_cab = cs_cab EXCEPTIONS error  = 1 ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.

    IF i_test IS INITIAL.
      ctrl->ui->isconfirm( EXPORTING i_question = 'Desea liberar la(s) guia(s)' EXCEPTIONS cancel    = 1 ).
      IF sy-subrc <> 0.
        RAISE error.
      ENDIF.

      guia_save_pre( CHANGING cs_cab = cs_cab EXCEPTIONS error  = 1 ).
      IF sy-subrc <> 0.
        RAISE error.
      ENDIF.

      guia_save_do( CHANGING cs_cab = cs_cab EXCEPTIONS error  = 1 ).
      IF sy-subrc <> 0.
        RAISE error.
      ENDIF.

      cab_status( CHANGING cs_cab = cs_cab ).
      MESSAGE s000 WITH 'Guia' cs_cab-xblnr 'enviada a Sunat'.

      ctrl->ui->lotno_unlock(
          i_bukrs = ctrl->zsel-bukrs
          i_lotno = ctrl->zsel-lotno
          i_bokno = ctrl->zsel-bokno
      ).

      CLEAR: cs_cab-scol, cs_cab-styl, cs_cab-btn_check.
    ENDIF.

  ENDMETHOD.


  METHOD guia_save_do.
    DATA lt_return TYPE bapirettab.

    ctrl->gr->extrae_data_guia_remision_z(
      IMPORTING
        et_return     = lt_return
      CHANGING
        cs_cab        = cs_cab
      EXCEPTIONS
        error         = 1
    ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.
  ENDMETHOD.


  METHOD guia_save_pre.

    IF cs_cab-zznrosap IS INITIAL.
      DATA: ls_inri TYPE inri.

      ls_inri-object    = 'ZOSFEGR'.
      ls_inri-nrrangenr = '01'.
      cs_cab-zznrosap = ctrl->ui->get_next_snro( ls_inri ).
    ENDIF.

    IF cs_cab-xblnr IS INITIAL.
      ctrl->ui->lotno_next(
        EXPORTING
          i_bukrs = cs_cab-bukrs
          i_lotno = ctrl->zsel-lotno
          i_bokno = ctrl->zsel-bokno
        RECEIVING
          r_xblnr = cs_cab-xblnr
        EXCEPTIONS
          error   = 1
      ).
      IF sy-subrc <> 0.
        RAISE error.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD guia_valid.
    DATA: l_error   TYPE xfeld,
          ls_option TYPE zosfees_extract_options,
          lt_return TYPE bapirettab.

    FIELD-SYMBOLS: <fs_det> LIKE LINE OF cs_cab-t_det.

    LOOP AT cs_cab-t_det ASSIGNING <fs_det>.
      det_inicializa( EXPORTING is_cab = cs_cab CHANGING cs_det = <fs_det> ).

      guia_valid_det(
        CHANGING
          cs_cab = cs_cab
          cs_det = <fs_det>
        EXCEPTIONS
          error  = 1
      ).
      IF sy-subrc <> 0.
        l_error = abap_on.
      ENDIF.
    ENDLOOP.

    cab_inicializa( CHANGING cs_cab = cs_cab ).

    guia_valid_cab(
      CHANGING
        cs_cab = cs_cab
      EXCEPTIONS
        error  = 1
    ).

    ls_option-test = abap_on.
    ctrl->gr->extrae_data_guia_remision_z(
      EXPORTING
        is_options    = ls_option
      IMPORTING
        et_return     = lt_return
      CHANGING
        cs_cab        = cs_cab
      EXCEPTIONS
        error         = 1
    ).
    IF sy-subrc <> 0.
      ctrl->ui->return_to_scol( EXPORTING it_return = lt_return CHANGING cs_cab = cs_cab ct_det = cs_cab-t_det ).
      APPEND LINES OF lt_return TO cs_cab-t_statu.
      cs_cab-btn_statu = ctrl->ui->return_icon( cs_cab-t_statu  ).
      LOOP AT cs_cab-t_det ASSIGNING <fs_det>.
        ctrl->ui->return_icon( EXPORTING it_return = cs_cab-t_statu i_row = <fs_det>-posnr RECEIVING r_icon = <fs_det>-btn_statu ).
      ENDLOOP.

      RAISE error.
    ENDIF.
  ENDMETHOD.


  METHOD guia_valid_cab.
    CLEAR: cs_cab-t_statu, cs_cab-scol, cs_cab-styl.

    ctrl->ui->replace_character( CHANGING cs_data = cs_cab ).

    "Validar general
    cab_traslado_modalidad( CHANGING cs_cab = cs_cab ).
    cab_traslado_motivo( CHANGING cs_cab = cs_cab ).

    IF cs_cab-tabname = gc_tabname-manual.
      "Enable
      cab_enable( CHANGING cs_cab = cs_cab ).

      "Validar
      cab_remitente( CHANGING cs_cab = cs_cab ).
      cab_destinatario( CHANGING cs_cab = cs_cab ).
      cab_solicitante( CHANGING cs_cab = cs_cab ).
      cab_transportista( CHANGING cs_cab = cs_cab ).
      cab_conductor( CHANGING cs_cab = cs_cab ).
      "cab_emision_partida( CHANGING cs_cab = cs_cab ).
      "cab_destino_llegada( CHANGING cs_cab = cs_cab ).

      "Inicial
      cab_is_initial( CHANGING cs_cab = cs_cab ).

    ELSE.
      "Enable
      INSERT ctrl->ui->cell_setstyle( 'KUNNR' )       INTO TABLE cs_cab-styl.

      INSERT ctrl->ui->cell_setstyle( 'ZZTRSMOT_H' )  INTO TABLE cs_cab-styl.
      IF cs_cab-is_trsden_cust = abap_on.
        INSERT ctrl->ui->cell_setstyle( 'ZZTRSDEN' )  INTO TABLE cs_cab-styl.
      ENDIF.
      INSERT ctrl->ui->cell_setstyle( 'ZZTRSMOD_H' )  INTO TABLE cs_cab-styl.

      INSERT ctrl->ui->cell_setstyle( 'ZZTRALIF' )   INTO TABLE cs_cab-styl.
      INSERT ctrl->ui->cell_setstyle( 'ZZPLAVEH' )    INTO TABLE cs_cab-styl.
      INSERT ctrl->ui->cell_setstyle( 'ZZTRAMAR' )    INTO TABLE cs_cab-styl.
      INSERT ctrl->ui->cell_setstyle( 'ZZTRANCI' )    INTO TABLE cs_cab-styl.

      INSERT ctrl->ui->cell_setstyle( 'ZZCONNRO' )    INTO TABLE cs_cab-styl.
      INSERT ctrl->ui->cell_setstyle( 'ZZCONTPD_H' )  INTO TABLE cs_cab-styl.
      INSERT ctrl->ui->cell_setstyle( 'ZZCONDEN' )    INTO TABLE cs_cab-styl.
      INSERT ctrl->ui->cell_setstyle( 'ZZTRABVT' )    INTO TABLE cs_cab-styl.

      INSERT ctrl->ui->cell_setstyle( 'ZZPARUBI' )    INTO TABLE cs_cab-styl.

      INSERT ctrl->ui->cell_setstyle( 'ZZLLEKUN' )    INTO TABLE cs_cab-styl.
      INSERT ctrl->ui->cell_setstyle( 'ZZLLELIF' )    INTO TABLE cs_cab-styl.
      INSERT ctrl->ui->cell_setstyle( 'ZZLLEUBI' )    INTO TABLE cs_cab-styl.

      INSERT ctrl->ui->cell_setstyle( 'ZZOBSERV' )    INTO TABLE cs_cab-styl.

      "Validar
*      cab_remitente( CHANGING cs_cab = cs_cab ).
*      cab_destinatario( CHANGING cs_cab = cs_cab ).
*      cab_solicitante( CHANGING cs_cab = cs_cab ).
*      cab_traslado_modalidad( CHANGING cs_cab = cs_cab ).
*      cab_traslado_motivo( CHANGING cs_cab = cs_cab ).
*      cab_transportista( CHANGING cs_cab = cs_cab ).
      cab_conductor( CHANGING cs_cab = cs_cab ).
*      cab_emision_partida( CHANGING cs_cab = cs_cab ).
*      cab_destino_llegada( CHANGING cs_cab = cs_cab ).

      "Inicial
      IF cs_cab-is_trsden_cust = abap_on.
        ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zztrsden' i_text = 'Ingrese denominacion de traslado' CHANGING ct_return = cs_cab-t_statu ).
      ENDIF.

      cab_is_initial_transporte( CHANGING cs_cab = cs_cab ).

      ctrl->ui->field_is_initial( EXPORTING is_data = cs_cab i_field = 'zzobserv'   i_text = 'Ingrese observaciones' i_w = abap_on CHANGING ct_return = cs_cab-t_statu ).

    ENDIF.

    "result
    ctrl->ui->return_to_scol( EXPORTING it_return = cs_cab-t_statu CHANGING cs_cab = cs_cab ).
    cs_cab-btn_statu = ctrl->ui->return_icon( cs_cab-t_statu ).

    IF cs_cab-tabname = gc_tabname-manual.
      READ TABLE cs_cab-t_statu TRANSPORTING NO FIELDS WITH KEY type = gc_chare.
      IF sy-subrc = 0.
        RAISE error.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD guia_valid_det.

    CLEAR: cs_det-t_statu, cs_det-scol, cs_det-styl.

    "caracteres extraños
    ctrl->ui->replace_character( CHANGING cs_data = cs_det ).

    IF cs_cab-tabname = gc_tabname-manual.

      "Enable
      IF cs_det-matnr IS INITIAL.
        INSERT ctrl->ui->cell_setstyle( 'ARKTX' )  INTO TABLE cs_det-styl.
      ENDIF.

      "Validar
      det_cantidad( CHANGING cs_det = cs_det ).
      det_descripcion( CHANGING cs_det = cs_det  ).
    ENDIF.

    "Enable
    INSERT ctrl->ui->cell_setstyle( 'MATNR' )  INTO TABLE cs_det-styl.
    INSERT ctrl->ui->cell_setstyle( 'ZZITECOD' )  INTO TABLE cs_det-styl.
    INSERT ctrl->ui->cell_setstyle( 'LFIMG' )  INTO TABLE cs_det-styl.
    INSERT ctrl->ui->cell_setstyle( 'VRKME' )  INTO TABLE cs_det-styl.
    INSERT ctrl->ui->cell_setstyle( 'BRGEW' )  INTO TABLE cs_det-styl.
    INSERT ctrl->ui->cell_setstyle( 'GEWEI' )  INTO TABLE cs_det-styl.
    INSERT ctrl->ui->cell_setstyle( 'ZZTXTPOS' )  INTO TABLE cs_det-styl.

    "Inicial
    IF cs_det-matnr IS INITIAL AND cs_det-zzitecod IS INITIAL.
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_det i_field = 'matnr'  i_text = 'Ingrese código de item' i_row = cs_det-posnr CHANGING ct_return = cs_det-t_statu ).
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_det i_field = 'zzitecod'  i_text = 'Ingrese código de item z' i_row = cs_det-posnr i_w = abap_on CHANGING ct_return = cs_det-t_statu ).
    ENDIF.
    IF cs_det-matnr IS INITIAL AND cs_det-zzitecod IS NOT INITIAL.
      ctrl->ui->field_is_initial( EXPORTING is_data = cs_det i_field = 'arktx'  i_text = 'Ingrese descripción' i_row = cs_det-posnr CHANGING ct_return = cs_det-t_statu ).
    ENDIF.
    ctrl->ui->field_is_initial( EXPORTING is_data = cs_det i_field = 'lfimg'    i_text = 'Ingrese cantidad' i_row = cs_det-posnr CHANGING ct_return = cs_det-t_statu ).
    ctrl->ui->field_is_initial( EXPORTING is_data = cs_det i_field = 'vrkme'    i_text = 'Ingrese UM' i_row = cs_det-posnr CHANGING ct_return = cs_det-t_statu ).
    ctrl->ui->field_is_initial( EXPORTING is_data = cs_det i_field = 'brgew'    i_text = 'Ingrese peso bruto' i_row = cs_det-posnr CHANGING ct_return = cs_det-t_statu ).
*    ctrl->ui->field_is_initial( EXPORTING is_data = cs_det i_field = 'zztxtpos' i_text = 'Ingrese observación' i_row = cs_det-posnr i_w = abap_on CHANGING ct_return = cs_det-t_statu ).

    "result
    ctrl->ui->return_to_scol( EXPORTING it_return = cs_det-t_statu CHANGING cs_cab = cs_cab ct_det = cs_cab-t_det ).
    cs_det-btn_statu = ctrl->ui->return_icon( cs_det-t_statu ).

    IF cs_cab-tabname = gc_tabname-manual.
      READ TABLE cs_det-t_statu TRANSPORTING NO FIELDS WITH KEY type = gc_chare.
      IF sy-subrc = 0.
        RAISE error.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD start.
    DATA l_dynnr TYPE sy-dynnr.

    FIELD-SYMBOLS <fs_cab> LIKE LINE OF et_cab.

    ctrl ?= io_ctrl.

    IF ctrl->zsel-zznrosap IS INITIAL.
      check( EXCEPTIONS error = 1 ).
      IF sy-subrc <> 0.
        RAISE error.
      ENDIF.
    ENDIF.

    CASE abap_on.
      WHEN ctrl->zsel-baja.
        baja_get_data( RECEIVING rt_cab = et_cab EXCEPTIONS error = 1 ).
        IF sy-subrc <> 0.
          RAISE error.
        ENDIF.

        e_dynnr = 150. "Baja
      WHEN OTHERS.
        et_cab = guia_get_data( ).

        e_dynnr = 100.
    ENDCASE.

    LOOP AT et_cab ASSIGNING <fs_cab>.
      <fs_cab>-btn_det = icon_list.

      cab_status( CHANGING cs_cab = <fs_cab> ).

      IF <fs_cab>-aktyp <> ctrl->gc_ver.
        ctrl->model->guia_inicializa( CHANGING cs_cab = <fs_cab> ).
      ENDIF.
    ENDLOOP.

    DESCRIBE TABLE et_cab.
    IF sy-tfill = 1.
      ctrl->g_aktyp = <fs_cab>-aktyp.
    ELSEIF ctrl->zsel-baja IS NOT INITIAL.
      ctrl->g_aktyp = ctrl->gc_ver.
    ENDIF.

  ENDMETHOD.

  METHOD cab_status.
    IF cs_cab-zzt_status_cdr = 0 OR cs_cab-zzt_status_cdr = 5 OR cs_cab-zzt_status_cdr = 6.
      cs_cab-aktyp = 'A'.
    ELSE.
      cs_cab-aktyp = ctrl->gc_ver.
      cs_cab-btn_statu = gc_gray.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
