CLASS zossdcl_pro_extrac_fe_gr DEFINITION
  PUBLIC
  CREATE PUBLIC .

*"* public components of class ZOSSDCL_PRO_EXTRAC_FE_GR
*"* do not include other source files here!!!
  PUBLIC SECTION.

    TYPES:
*{+NTP010423-3000020188: Guia Z
      BEGIN OF ty_alv_z,
        box       TYPE xfeld,
        scol      TYPE lvc_t_scol,
        styl      TYPE lvc_t_styl,
        "btn
        btn_statu TYPE icon-id,
        btn_check TYPE icon-id,
        btn_back  TYPE icon-id,
        btn_det   TYPE icon-id,
        "log
        t_statu   TYPE bapirettab,
      END OF ty_alv_z .
    TYPES:
      BEGIN OF ty_det_z.
        INCLUDE TYPE zostb_fegrdet.
        INCLUDE TYPE ty_alv_z.
    TYPES: END OF ty_det_z .
    TYPES:
      BEGIN OF gty_cab_z.
        INCLUDE TYPE zoses_fegrcab.
        INCLUDE TYPE ty_alv_z.
    TYPES: zzt_status_cdr TYPE zostb_felog-zzt_status_cdr,
           aktyp          TYPE aktyp,
           t_det          TYPE TABLE OF ty_det_z WITH DEFAULT KEY,
           END OF gty_cab_z .
*}+NTP010423-3000020188
    TYPES gty_fegrcab TYPE zoses_fegrcab .
    TYPES:
      gtt_fegrcab TYPE TABLE OF gty_fegrcab .
    TYPES:
      gtt_fegrdet TYPE TABLE OF zostb_fegrdet .
    TYPES:
      gtt_fegrtxt TYPE TABLE OF zostb_fegrtxt WITH DEFAULT KEY .
    TYPES:
      gtt_fegrdet_json TYPE TABLE OF zoses_fegrdet_json .
    TYPES:
      gtt_fegrcab_json TYPE TABLE OF zoses_fegrcab_json .
    TYPES gty_data_nojson TYPE zosfegres_data_nojson .
    TYPES:
      BEGIN OF gty_likp,
        "key
        vbeln               TYPE likp-vbeln,
        "---
        xblnr               TYPE likp-xblnr,
        bzirk               TYPE likp-bzirk,
        vkorg               TYPE likp-vkorg,
        kunnr               TYPE likp-kunnr,
        kunag               TYPE likp-kunag,
        lfart               TYPE likp-lfart,
        vstel               TYPE likp-vstel,
        tddat               TYPE likp-tddat,
        btgew               TYPE likp-btgew,
        anzpk               TYPE likp-anzpk,
        gewei               TYPE likp-gewei,
        ntgew               TYPE likp-ntgew,
        wadat_ist           TYPE likp-wadat_ist,                                                "I-WMR-191018-3000009770
        wadat               TYPE likp-wadat,                                                    "+081122-NTP-3000020296
        spe_wauhr_ist       TYPE likp-spe_wauhr_ist,                                        "I-WMR-191018-3000009770
        erdat               TYPE likp-erdat,                                                        "I-WMR-130619-3000010823
        vbtyp               TYPE likp-vbtyp,                                                        "I-WMR-130619-3000010823
        zzkvgr2             TYPE string,
*{I-3000010823-NTP-060819
        bolnr               TYPE likp-bolnr,
        xabln               TYPE likp-xabln,
        traty               TYPE likp-traty,
        traid               TYPE likp-traid,
*}I-3000010823-NTP-060819
        zztotblt            TYPE meng15,                                                         "I-3000013055-NTP-041219
        zztotblt_c          TYPE char19,                                                       "I-PBM180520-3000013745
        ernam               TYPE likp-ernam,                                                     "I-PBM180520-3000013745
        erzet               TYPE likp-erzet,                                                     "I-PBM210922-3000020039
        vsbed               TYPE likp-vsbed,                                                     "I-PBM081222-3000019824
*{+NTP010423-3000020188
        lifnr               TYPE likp-lifnr,
        zztrsmod_h          TYPE zosfegred_likp_trsmod_h,
        zztrsmot_h          TYPE zosfegred_likp_trsmot_h,
        zztrsden            TYPE zosfegred_likp_trsden,
*}+NTP010423-3000020188

        "Adicional
        is_gr_transportista TYPE xfeld,                                                         "+NTP010323-3000019645
        btd_id              TYPE char35,                                                        "+NTP010323-3000019645
        tor_id              TYPE char20,                                                        "+NTP010323-3000019645

*{+NTP010423-3000020188: Guia Z
        is_guia_z           TYPE zostb_fegrcab-is_guia_z,
        tabname             TYPE zostb_fegrcab-tabname,
        zzparwer            TYPE zostb_fegrcab-zzparwer,
        zzparlgo            TYPE zostb_fegrcab-zzparlgo,
        zzparlif            TYPE zostb_fegrcab-zzparlif,
        zzdstwer            TYPE zostb_fegrcab-zzdstwer,
        zzdstlgo            TYPE zostb_fegrcab-zzdstlgo,
        zzllekun            TYPE zostb_fegrcab-zzllekun,
        zzllelif            TYPE zostb_fegrcab-zzllelif,
*}+NTP010423-3000020188
        tm_active           TYPE zostb_fegrcab-zztmactive,                                      "I-WMR-27112020-3000014557
      END OF gty_likp .
    TYPES:
      BEGIN OF gty_lips,
        "key
        vbeln       TYPE lips-vbeln,
        posnr       TYPE lips-posnr,
        "---
        lfimg       TYPE lips-lfimg,
        vrkme       TYPE lips-vrkme,
        matnr       TYPE lips-matnr,
        arktx       TYPE lips-arktx,
        matkl       TYPE lips-matkl,
        lgort       TYPE lips-lgort,
        meins       TYPE lips-meins,
        werks       TYPE lips-werks,
        charg       TYPE lips-charg,
        vgbel       TYPE lips-vgbel,
        uecha       TYPE lips-uecha,
        brgew       TYPE lips-brgew,
        gewei       TYPE lips-gewei,
        ntgew       TYPE lips-ntgew,                                                    "I-WMR-021118-3000010833
        vgtyp       TYPE lips-vgtyp,                                                    "I-WMR-221019-3000013105
        ean11       TYPE lips-ean11,                                                          " INSERT @003
        pstyv       TYPE lips-pstyv,                                                   "+081122-NTP-3000020296
        vgpos       TYPE lips-vgpos,                                                   "I-PBM160123-3000020028
        kdmat       TYPE lips-kdmat,                                                   "I-PBM190423-3000020600
        kdmat_matnr TYPE lips-matnr,                                             "I-PBM190423-3000020600
        "Campos homologación
      END OF gty_lips .
    TYPES:
      gtt_likp TYPE TABLE OF gty_likp .
    TYPES:
      gtt_lips TYPE TABLE OF gty_lips .

    METHODS build_xml
      IMPORTING
        !i_nrodocsap  TYPE zosfetb_json-zzt_nrodocsap
        !i_numeracion TYPE zosfetb_json-zzt_numeracion
        !i_show       TYPE xfeld OPTIONAL
        !i_down       TYPE xfeld OPTIONAL
        !i_folder     TYPE string OPTIONAL
      EXCEPTIONS
        error .
    METHODS extrae_data_guia_baja
      IMPORTING
        !i_bukrs   TYPE bukrs
        !i_fecemi  TYPE zostb_fegrcab-zzfecemi
        !i_nrosap  TYPE zostb_fegrcab-zznrosap OPTIONAL
        !i_gjahr   TYPE zostb_fegrcab-zzgjahr OPTIONAL
        !i_nrosun  TYPE zostb_fegrcab-zznrosun OPTIONAL
      EXPORTING
        !et_return TYPE bapirettab
      EXCEPTIONS
        error .
    METHODS extrae_data_guia_remision
      IMPORTING
        !i_entrega     TYPE vbeln
        !is_options    TYPE zosfees_extract_options OPTIONAL
      EXPORTING
        !et_return     TYPE bapirettab
        !es_datanojson TYPE zosfegres_data_nojson
      EXCEPTIONS
        error .
    METHODS extrae_data_guia_remision_z
      IMPORTING
        !is_options    TYPE zosfees_extract_options OPTIONAL
      EXPORTING
        !et_return     TYPE bapirettab
        !es_datanojson TYPE zosfegres_data_nojson
      CHANGING
        !cs_cab        TYPE gty_cab_z
      EXCEPTIONS
        error .
    METHODS fegrtxt_get
      CHANGING
        !cs_cab TYPE any .
    METHODS fegrtxt_set
      IMPORTING
        !is_data      TYPE any
      RETURNING
        VALUE(rt_txt) TYPE gtt_fegrtxt .
    METHODS get_constantes
      IMPORTING
        !i_vbeln  TYPE vbeln
        !i_tpproc TYPE zosfetb_ubl-tpproc
      EXCEPTIONS
        error .
    METHODS read_text_vbbk_zconst2
      IMPORTING
        !i_campo TYPE clike
        !i_vbeln TYPE vbeln
        !i_posnr TYPE posnr OPTIONAL
        !i_kunnr TYPE kunnr
      EXPORTING
        !e_val1  TYPE clike
        !e_val2  TYPE clike
        !e_val3  TYPE clike
        !e_val4  TYPE clike
        !e_val5  TYPE clike
        !e_val6  TYPE clike
        !et_line TYPE tline_tab .
    METHODS split_xblnr
      IMPORTING
        !i_xblnr  TYPE any
      EXPORTING
        !e_tipo   TYPE string
        !e_serie  TYPE string
        !e_corre  TYPE string
        !e_sercor TYPE zostb_fegrcab-zznrosun .
  PROTECTED SECTION.

    TYPES:
**********************************************************************
* TIPOS GLOBAL
**********************************************************************
      BEGIN OF gty_vbuk,
        "key
        vbeln TYPE vbuk-vbeln,
        "---
        wbstk TYPE vbuk-wbstk,
      END OF gty_vbuk .
    TYPES:
      BEGIN OF gty_vttk,
        "key
        tknum         TYPE vttk-tknum,
        "---
        shtyp         TYPE vttk-shtyp,
        tdlnr         TYPE vttk-tdlnr,
        datbg         TYPE vttk-datbg,
        signi         TYPE vttk-signi,
        text3         TYPE vttk-text3,
        text4         TYPE vttk-text4,
        exti2         TYPE vttk-exti2,                                                      "I-WMR-260517-3000007333
        tpbez         TYPE vttk-tpbez,                                                      "I-WMR-260517-3000007333
        text2         TYPE vttk-text2,                                                      "I-WMR-260517-3000007333
        tndr_trkid    TYPE vttk-tndr_trkid,                                            "I-ACZ250118-3000008769
        exti1         TYPE vttk-exti1,                                                      "I-ACZ250118-3000008769
        uatbg         TYPE vttk-uatbg,                                                 "I-WMR-261018-3000010720
        /bev1/rpfar1  TYPE vttk-/bev1/rpfar1,                                       "I-WMR-111218-3000009765
        /bev1/rpmowa  TYPE vttk-/bev1/rpmowa,                                       "I-WMR-111218-3000009765
        dalen         TYPE vttk-dalen,                                                      "I-WMR-080119-3000011134
        dtabf         TYPE vttk-dtabf,                                                      "I-WMR-080119-3000011134
        uzabf         TYPE vttk-uzabf,                                                      "I-WMR-080119-3000011134
        /bev1/rpanhae TYPE vttk-/bev1/rpanhae,                                      "I-WMR-080119-3000011134
        text1         TYPE vttk-text2,                                                      "I-PBM021120-3000014959
        add01         TYPE vttk-add01,                                                      "I-PBM021120-3000014959
        add02         TYPE vttk-add02,                                                      "+081122-NTP-3000020296
      END OF gty_vttk .
    TYPES:
      BEGIN OF gty_vtts,
        "key
        tknum TYPE vtts-tknum,
        tsnum TYPE vtts-tsnum,
      END OF gty_vtts .
    TYPES:
      BEGIN OF gty_vttp,
        "key
        tknum TYPE vttp-tknum,
        tpnum TYPE vttp-tpnum,
        "---
        vbeln TYPE vttp-vbeln,
      END OF gty_vttp .
    TYPES:
      BEGIN OF gty_vbpa,                                                              "I-WMR-050717-3000007333
        "key                                                                        "I-WMR-050717-3000007333
        vbeln TYPE vbpa-vbeln,                                                      "I-WMR-050717-3000007333
        posnr TYPE vbpa-posnr,                                                      "I-WMR-050717-3000007333
        parvw TYPE vbpa-parvw,                                                      "I-WMR-050717-3000007333
        "---                                                                        "I-WMR-050717-3000007333
        kunnr TYPE vbpa-kunnr,                                                      "I-WMR-050717-3000007333
        lifnr TYPE vbpa-lifnr,                                                      "I-WMR-050717-3000007333
        pernr TYPE vbpa-pernr,                                                      "I-WMR-050717-3000007333
        adrnr TYPE vbpa-adrnr,                                                      "I-WMR-050717-3000007333
        xcpdk TYPE vbpa-xcpdk,                                                      "+081122-NTP-3000020296
        land1 TYPE vbpa-land1,                                                      "I-PBM190423-3000020600
      END OF gty_vbpa .                                                             "I-WMR-050717-3000007333
    TYPES:
      BEGIN OF gty_vtpa,                                                              "I-WMR-260517-3000007333
        "key                                                                        "I-WMR-260517-3000007333
        vbeln TYPE vtpa-vbeln,                                                      "I-WMR-260517-3000007333
        posnr TYPE vtpa-posnr,                                                      "I-WMR-260517-3000007333
        parvw TYPE vtpa-parvw,                                                      "I-WMR-260517-3000007333
        "---                                                                        "I-WMR-260517-3000007333
        kunnr TYPE vtpa-kunnr,                                                      "I-WMR-260517-3000007333
        lifnr TYPE vtpa-lifnr,                                                      "I-WMR-260517-3000007333
        adrnr TYPE vtpa-adrnr,                                                      "I-WMR-260517-3000007333
      END OF gty_vtpa .                                                             "I-WMR-260517-3000007333
    TYPES:
      BEGIN OF gty_vbfa,                                                              "I-WMR-280617-3000007333
        "key                                                                        "I-WMR-280617-3000007333
        vbelv   TYPE vbfa-vbelv,                                                      "I-WMR-280617-3000007333
        "---                                                                        "I-WMR-280617-3000007333
        posnv   TYPE vbfa-posnv,
        vbeln   TYPE vbfa-vbeln,                                                      "I-WMR-280617-3000007333
        posnn   TYPE vbfa-posnn,                                                      "I-WMR-280617-3000007333
        vbtyp_n TYPE vbfa-vbtyp_n,                                                  "I-WMR-280617-3000007333
        xblnr   TYPE vbrk-xblnr,                                                      "I-WMR-280617-3000007333
      END OF gty_vbfa .                                                             "I-WMR-280617-3000007333
    TYPES:
      BEGIN OF gty_vbrk,                                                              "I-WMR-280617-3000007333
        "key                                                                        "I-WMR-280617-3000007333
        vbeln TYPE vbrk-vbeln,                                                      "I-WMR-280617-3000007333
        "---                                                                        "I-WMR-280617-3000007333
        xblnr TYPE vbrk-xblnr,                                                      "I-WMR-280617-3000007333
        bukrs TYPE vbrk-bukrs,                                                      "I-WMR-161219-3000013055
        numer TYPE zostb_felog-zzt_numeracion,                                      "I-WMR-280617-3000007333
        tipdo TYPE zostb_felog-zzt_tipodoc,                                         "I-WMR-280617-3000007333
      END OF gty_vbrk .
    TYPES:
      BEGIN OF gty_kna1,
        "key
        kunnr    TYPE lfa1-kunnr,
        "---
        stcd1    TYPE lfa1-stcd1,
        stcdt    TYPE lfa1-stcdt,
        xcpdk    TYPE lfa1-xcpdk,
        adrnr    TYPE lfa1-adrnr,
        name1    TYPE lfa1-name1,
        name2    TYPE lfa1-name2,
        name3    TYPE lfa1-name3,
        name4    TYPE lfa1-name4,
        stkzn    TYPE lfa1-stkzn,
        stcd2    TYPE lfa1-stcd2,         "+081122-NTP-3000020296
        werks    TYPE lfa1-werks,         "I-PBM061222-3000020028

        lifnr    TYPE lfa1-lifnr,         "+NTP010423-3000020188
        zzpardir TYPE string,            "I-NTP180918-3000010450
      END OF gty_kna1 .
    TYPES:
      BEGIN OF gty_direccion,
        "key
        adrnr        TYPE  adrnr,
        "---
        name         TYPE  string,
        name1        TYPE  adrc-name1,
        name2        TYPE  adrc-name2,
        name3        TYPE  adrc-name3,
        name4        TYPE  adrc-name4,
        pais         TYPE  adrc-country,
        depmto       TYPE  t005u-bezei,  "Departamento (Pais-Region T005U)
        provin       TYPE  adrc-city1,   "Provincia
        distri       TYPE  adrc-city2,   "Distrito
        street       TYPE  adrc-street,  "Dirección
        stnumb       TYPE  adrc-house_num1,    "Número
        str_suppl1   TYPE adrc-str_suppl1,  "Dirección
        str_suppl2   TYPE adrc-str_suppl2,  "Dirección
        str_suppl3   TYPE adrc-str_suppl3,  "Dirección
        ubigeo       TYPE adrc-cityp_code,  "Ubigeo
        smtp_addr    TYPE string,           "Correos
        tel_number   TYPE adrc-tel_number,  "Teléfono
        langu        TYPE adrc-langu,       "Idioma                                   "I-WMR-050717-3000007333
        direccion    TYPE string,           "Direccion completa                       "I-111219-NTP-3000013055
        urbanizacion TYPE string,         "Urbanizacion                             "+010922-NTP-3000018956
        "adicional
        regiogroup   TYPE adrc-regiogroup,
        location     TYPE adrc-location,
        po_box       TYPE adrc-po_box,
        po_box_lobby TYPE adrc-po_box_lobby,
        remark       TYPE adrct-remark,     "Comentario                               "+NTP280223_3000020702
      END OF gty_direccion .
*{+010922-NTP-3000018956
*    TYPES:
*      BEGIN OF gty_tvko,
*        "key
*        vkorg TYPE tvko-vkorg,
*        "---
*        bukrs TYPE tvko-bukrs,
*      END OF gty_tvko .
*}+010922-NTP-3000018956
    TYPES gty_t001z TYPE t001z .
    TYPES:
      BEGIN OF gty_tvst,
        "key
        vstel TYPE tvst-vstel,
        "---
        adrnr TYPE tvst-adrnr,
      END OF gty_tvst .
    TYPES:
      BEGIN OF gty_lineas,
        linea TYPE char1024,
      END OF gty_lineas .
    TYPES:
      BEGIN OF gty_process,
        license TYPE string,            " N° Instalación SAP                  "I-WMR-190918-3000009765
        s4core  TYPE xfeld,             " S/4 Hana activo                     "I-WMR-190918-3000009765
      END OF gty_process .
    TYPES:
      BEGIN OF gty_bus_part,
        kunnr    TYPE kna1-kunnr,                                                        "I-WMR-121018-3000009765
        partner  TYPE dfkkbptaxnum-partner,                                              "I-WMR-121018-3000009765
        taxtype  TYPE dfkkbptaxnum-taxtype,                                              "I-WMR-121018-3000009765
        taxnum   TYPE dfkkbptaxnum-taxnum,                                               "I-WMR-121018-3000009765
        taxnumxl TYPE string. "dfkkbptaxnum-taxnumxl. "+JCHOQUE 17062019
    TYPES: END OF gty_bus_part .
    TYPES:
      BEGIN OF gty_asgtnhr.
        INCLUDE TYPE zosfetb_asgtnhr.
    TYPES: END OF gty_asgtnhr .
    TYPES:
*{I-NTP180918-3000010450
      BEGIN OF gty_t001w,
        werks TYPE t001w-werks,
        stras TYPE t001w-stras,
        adrnr TYPE t001w-adrnr,
        bukrs TYPE t001z-bukrs,
      END OF gty_t001w .
    TYPES:
      BEGIN OF gty_vbak,
        vbeln TYPE vbak-vbeln,
        vtweg TYPE vbak-vtweg,
        kvgr2 TYPE vbak-kvgr2,            " Motivo de Traslado GRE                  "I-WMR-021018-3000010605
        augru TYPE vbak-augru,
        kvgr1 TYPE vbak-kvgr1,                                                      "+081122-NTP-3000020296
      END OF gty_vbak .
    TYPES:
      BEGIN OF gty_updates,
        objectclas TYPE cdhdr-objectclas,                                           "I-WMR-130819-3000010823
        objectid   TYPE cdhdr-objectid,                                             "I-WMR-130819-3000010823
        changenr   TYPE cdhdr-changenr,                                             "I-WMR-130819-3000010823
        udate      TYPE cdhdr-udate,                                                "I-WMR-130819-3000010823
        utime      TYPE cdhdr-utime,                                                "I-WMR-130819-3000010823
        tcode      TYPE cdhdr-tcode,                                                "I-WMR-130819-3000010823
        tabname    TYPE cdpos-tabname,                                              "I-WMR-130819-3000010823
        tabkey     TYPE cdpos-tabkey,                                               "I-WMR-130819-3000010823
        fname      TYPE cdpos-fname,                                                "I-WMR-130819-3000010823
        chngind    TYPE cdpos-chngind,                                              "I-WMR-130819-3000010823
        value_new  TYPE cdpos-value_new,                                            "I-WMR-130819-3000010823
        value_old  TYPE cdpos-value_old,                                            "I-WMR-130819-3000010823
      END OF gty_updates .
    TYPES:
      BEGIN OF gty_oigsi,
        shnumber   TYPE oigsi-shnumber,
        shitem     TYPE oigsi-shitem,
        doc_number TYPE oigsi-doc_number,
      END OF gty_oigsi .
    TYPES:
      BEGIN OF gty_oigsv,
        shnumber TYPE oigsv-shnumber,
        veh_nr   TYPE oigsv-veh_nr,
        vehicle  TYPE oigsv-vehicle,
        carrier  TYPE oigsv-carrier,
      END OF gty_oigsv .
    TYPES:
*}I-NTP180918-3000010450
      BEGIN OF gty_twlad,                                                           " INSERT @001
        "key                                                                      " INSERT @001
        lgort TYPE twlad-lgort,                                                   " INSERT @001
        "---                                                                      " INSERT @001
        adrnr TYPE twlad-adrnr,                                                   " INSERT @001
      END OF gty_twlad .
    TYPES:
      BEGIN OF gty_vbkd,
        "key
        vbeln TYPE vbkd-vbeln,
        posnr TYPE vbkd-posnr,
        "---
        bstkd TYPE vbkd-bstkd,
        inco1 TYPE vbkd-inco1,                        "+NTP010323-3000019645
        inco2 TYPE vbkd-inco2,                        "+NTP010323-3000019645
      END OF gty_vbkd .
    TYPES:
*{I-PBM081222-3000019824
      BEGIN OF gty_tordrf,
        db_key     TYPE /bofu/conf_key,
        parent_key TYPE /bofu/conf_key,
        btd_tco    TYPE char05,
        btd_id     TYPE char35,

        tor_type   TYPE char04,
        tor_id     TYPE char20,                       "+NTP010323-3000019645
        tspid      TYPE char10,                       "+NTP010323-3000019645
      END OF gty_tordrf .
    TYPES:
      BEGIN OF gty_torite,
        db_key      TYPE /bofu/conf_key,
        parent_key  TYPE /bofu/conf_key,
        item_type   TYPE char04,
        item_cat    TYPE char04,
        res_key     TYPE /bofu/conf_key,
        platenumber TYPE char20,
        tracking_no TYPE char50,
        res_id      TYPE char40,
        base_btd_id TYPE char35,

        vbeln       TYPE likp-vbeln,
      END OF gty_torite .
    TYPES:
      BEGIN OF gty_txcroot,
        db_key   TYPE /bobf/d_txcroot-db_key,
        host_key TYPE /bobf/d_txcroot-host_key,
        root_key TYPE /bobf/d_txccon-root_key,
        text     TYPE /bobf/d_txccon-text,
      END OF gty_txcroot .
    TYPES:
      BEGIN OF gty_restmssk,
        res_type   TYPE numc2,
        tmsresuuid TYPE /bofu/conf_key,
        qualitype  TYPE char18,
        qualivalue TYPE char20,
      END OF gty_restmssk .
    TYPES:
*}I-PBM081222-3000019824
      BEGIN OF gty_tvaut,
        augru TYPE tvaut-augru,
        bezei TYPE tvaut-bezei,
      END OF gty_tvaut .
    TYPES:
      BEGIN OF gty_mara,
        matnr TYPE mara-matnr,
        normt TYPE mara-normt,
      END OF gty_mara .
    TYPES:
*{I-PBM160123-3000020028
      BEGIN OF gty_ekpo,
        ebeln TYPE ekpo-ebeln,
        ebelp TYPE ekpo-ebelp,
        txz01 TYPE ekpo-txz01,
      END OF gty_ekpo .
    TYPES:
*}I-PBM160123-3000020028
**********************************************************************
* TIPOS DE TABLAS GLOBAL
**********************************************************************
      gtt_fecli TYPE TABLE OF zostb_fecli .
    TYPES:
      gtt_kna1 TYPE TABLE OF gty_kna1 .
    TYPES:
      gtth_direccion TYPE HASHED TABLE OF gty_direccion WITH UNIQUE KEY adrnr .
    TYPES:
**********************************************************************
* TIPOS DE RANGOS GLOBAL
**********************************************************************
      gtr_adrnr TYPE RANGE OF adrnr .

    DATA zossdcl_pro_extrac_fe_ TYPE string VALUE 'ZOSSDCL_PRO_EXTRAC_FE_' ##NO_TEXT.
    DATA:
      BEGIN OF gc_cat,
        catalogo01 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO01',
        catalogo02 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO02',
        catalogo03 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO03',
        catalogo04 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO04',
        catalogo05 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO05',
        catalogo06 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO06',
        catalogo07 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO07',
        catalogo08 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO08',
        catalogo09 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO09',
        catalogo10 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO10',
        catalogo11 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO11',
        catalogo12 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO12',
        catalogo13 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO13',
        catalogo14 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO14',
        catalogo15 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO15',
        catalogo16 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO16',
        catalogo17 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO17',
        catalogo18 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO18',
        catalogo19 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO19',
        catalogo20 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO20',
        catalogo21 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO21',
        catalogo22 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO22',
        catalogo23 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO23',
        catalogo24 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO24',
        catalogo25 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO25',
        catalogo51 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO51',
        catalogo52 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO52',
        catalogo53 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO53',
        catalogo54 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO54',
        catalogo55 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO55',
        catalogo59 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO59',
        catalogo61 TYPE zosfetb_catacons-zz_catalogo VALUE 'CATALOGO61',
      END OF gc_cat .
    DATA:
**********************************************************************
* Constantes
**********************************************************************
      BEGIN OF zconst,
        ptoe_lfdnr              TYPE lfdnr,
        zzfecemi                TYPE char02,
        zzhoremi                TYPE char02,
        zztrafec                TYPE char02,
        zzdstnro                TYPE char02,
        pstyv_zzitedes_add_text TYPE TABLE OF zostb_const_fe,
      END OF zconst .
    DATA:
      BEGIN OF zpiramide,
        r_lfart       TYPE RANGE OF lfart,
        r_parvw_desti TYPE RANGE OF parvw,
        r_parvw_soli  TYPE RANGE OF parvw,
        s_desti       TYPE gty_kna1,
        s_soli        TYPE gty_kna1,
        vtweg_30      TYPE vtweg VALUE '30',
        parvw_we      TYPE parvw VALUE 'WE',
      END OF zpiramide .

    DATA:
      gth_dire TYPE HASHED TABLE OF gty_direccion WITH UNIQUE KEY adrnr .
    DATA:
        gth_twlad TYPE HASHED TABLE OF twlad WITH UNIQUE KEY werks lgort .                                "I-3000013055-NTP-041219


    METHODS get_data_rem_cust
      IMPORTING
        !i_entrega TYPE vbeln .
    METHODS read_text_vbbk_zconst
      IMPORTING
        !i_campo        TYPE clike
        !i_vbeln        TYPE vbeln
        !i_posnr        TYPE posnr OPTIONAL
        !i_kunnr        TYPE kunnr OPTIONAL
        !i_compress     TYPE char01 OPTIONAL
        !i_fulltext     TYPE xfeld OPTIONAL
      RETURNING
        VALUE(e_string) TYPE string .
    METHODS set_data_rem
      IMPORTING
        !it_likp TYPE gtt_likp
        !it_lips TYPE gtt_lips
      EXPORTING
        !et_det  TYPE gtt_fegrdet
        !et_cab  TYPE gtt_fegrcab .
    METHODS set_data_rem_emision_partida
      IMPORTING
        !ls_likp TYPE gty_likp
        !it_lips TYPE gtt_lips
      CHANGING
        !ls_cab  TYPE gty_fegrcab .
private section.

  types:
*"* private components of class ZOSSDCL_PRO_EXTRAC_FE_GR
*"* do not include other source files here!!!
    BEGIN OF lty_catacons.
        INCLUDE TYPE zosfetb_catacons.
    TYPES: END OF lty_catacons .

  constants GC_00010101 type DATS value '00010101' ##NO_TEXT.
  constants GC_APLIC type ZOSTB_CONST_FE-APLICACION value 'EXTRACTOR' ##NO_TEXT.
  constants GC_CAMPO_HOST type STRING value 'HOSTNAME' ##NO_TEXT.
  constants GC_CAMPO_MANDT_PRD type STRING value 'MANDTPRD' ##NO_TEXT.
  constants GC_CAMPO_TEST_ACT type STRING value 'TEST_ACT' ##NO_TEXT.
  constants GC_COMPONENT_S4CORE type CVERS-COMPONENT value 'S4CORE' ##NO_TEXT.
  constants GC_FALSE type STRING value 'FALSE' ##NO_TEXT.
  constants GC_MODTRAS_PUBLICO type ZOSED_CODIGOSUNAT value '01' ##NO_TEXT.
  constants GC_NO type CHAR02 value 'NO' ##NO_TEXT.
  data GC_MODTRAS_PRIVADO type ZOSED_CODIGOSUNAT value '02' ##NO_TEXT.
  constants GC_PARTY type T001Z-PARTY value 'TAXNR' ##NO_TEXT.
  constants GC_PREFIX_GR type CHAR02 value 'GR' ##NO_TEXT.
  constants GC_PROG type PROGRAMM value 'ZOSSD_PRO_EXTRAC' ##NO_TEXT.
  constants GC_SI type CHAR02 value 'SI' ##NO_TEXT.
  constants GC_STATUSCDR_0 type ZOSED_STATUS_CDR value '0' ##NO_TEXT.
  constants GC_STATUSCDR_1 type ZOSED_STATUS_CDR value '1' ##NO_TEXT.
  constants GC_STATUSCDR_2 type ZOSED_STATUS_CDR value '2' ##NO_TEXT.
  constants GC_STATUSCDR_4 type ZOSED_STATUS_CDR value '4' ##NO_TEXT.
  constants GC_STATUSCDR_7 type ZOSED_STATUS_CDR value '7' ##NO_TEXT.
  constants GC_SYSTEM_PRD type SYST-HOST value 'PRD' ##NO_TEXT.
  constants GC_SYSTEM_QAS type SYST-HOST value 'QAS' ##NO_TEXT.
  constants GC_SYSTEM_SUNAT_HOMO type STRING value 'HOM' ##NO_TEXT.
  constants GC_SYSTEM_SUNAT_PROD type STRING value 'PRD' ##NO_TEXT.
  constants GC_SYSTEM_SUNAT_TEST type STRING value 'TES' ##NO_TEXT.
  constants GC_TABPSE type TABNAME value 'ZOSFETB_ASGPSE' ##NO_TEXT.
  constants GC_TIPDOC_GR type CHAR02 value '09' ##NO_TEXT.
  constants GC_TIPDOC_GR_TRANSPORTISTA type CHAR02 value '31' ##NO_TEXT.
  constants GC_TRUE type STRING value 'TRUE' ##NO_TEXT.
  constants GC_VERSION_1 type ZOSED_VERSIVIGEN value '01' ##NO_TEXT.
  constants GC_VERSION_2 type ZOSED_VERSIVIGEN value '02' ##NO_TEXT.
  data GC_PARVW_AG type PARVW value 'AG' ##NO_TEXT.
  data:
    BEGIN OF gc_traslado_indenv,
        transbordo_programado        TYPE string VALUE 'SUNAT_Envio_IndicadorTransbordoProgramado',
        retornovacio_envase          TYPE string VALUE 'SUNAT_Envio_IndicadorRetornoVehiculoEnvaseVacio',
        retornovacio                 TYPE string VALUE 'SUNAT_Envio_IndicadorRetornoVehiculoVacio',
        transporte_subcontratado     TYPE string VALUE 'SUNAT_Envio_IndicadorTrasporteSubcontratado',
        pagador_flete_remitente      TYPE string VALUE 'SUNAT_Envio_IndicadorPagadorFlete_Remitente',
        pagador_flete_subcontratador TYPE string VALUE 'SUNAT_Envio_IndicadorPagadorFlete_Subcontratador',
        pagador_flete_tercero        TYPE string VALUE 'SUNAT_Envio_IndicadorPagadorFlete_Tercero',
        transbordo_total             TYPE string VALUE 'SUNAT_Envio_IndicadorTrasladoTotal',
      END OF gc_traslado_indenv .
  data:
    BEGIN OF gc_guia,
        remitente     TYPE string VALUE '09',
        transportista TYPE string VALUE '31',
      END OF gc_guia .
  data GS_CONSEXTSUN type ZOSTB_CONSEXTSUN .
  data GS_UBL type ZOSFETB_UBL .
  data GS_PROCESS type GTY_PROCESS .
  data G_BUKRS type BUKRS .
  data G_FECDOC type DATUM .
  data:
    lt_catacons TYPE TABLE OF lty_catacons .
  data:
    gth_hom06 TYPE HASHED TABLE OF zostb_catahomo06 WITH UNIQUE KEY stcdt .
  data:
    gth_hom18 TYPE HASHED TABLE OF zostb_catahomo18 WITH UNIQUE KEY shtyp lfart tor_type .
  data:
*    gth_hom20 TYPE HASHED TABLE OF zostb_catahomo20 WITH UNIQUE KEY lfart .       "E-WMR-021018-3000010605
*    gth_hom20 TYPE HASHED TABLE OF zostb_catahomo20 WITH UNIQUE KEY lfart kvgr2 .         "I-WMR-021018-3000010605
    gth_hom20 TYPE TABLE OF zostb_catahomo20 .                                                 "+071122-NTP-3000020296
  data:
    gth_cat20 TYPE HASHED TABLE OF zostb_catalogo20 WITH UNIQUE KEY zz_codigo_sunat .
  data:
    gth_cat18 TYPE HASHED TABLE OF zostb_catalogo18 WITH UNIQUE KEY zz_codigo_sunat .                     "I-WMR-071218-3000009765
  data:
    gth_cat61 TYPE HASHED TABLE OF zostb_catalogo61 WITH UNIQUE KEY zz_codigo_sunat .                     "+NTP010323-3000019645
  data:
    gth_kna1 TYPE HASHED TABLE OF gty_kna1 WITH UNIQUE KEY kunnr .
  data:
    gth_t001 TYPE HASHED TABLE OF t001 WITH UNIQUE KEY bukrs .
  data:
    gth_t001z TYPE HASHED TABLE OF gty_t001z WITH UNIQUE KEY bukrs .
  data:
*  data:                                                            "-010922-NTP-3000018956
*    gth_tvko TYPE HASHED TABLE OF gty_tvko WITH UNIQUE KEY vkorg . "-010922-NTP-3000018956
    gth_tvst TYPE HASHED TABLE OF gty_tvst WITH UNIQUE KEY vstel .
  data:
    gth_vbuk TYPE HASHED TABLE OF gty_vbuk WITH UNIQUE KEY vbeln .
  data:
    gth_vttk TYPE HASHED TABLE OF gty_vttk WITH UNIQUE KEY tknum .
  data:
    gth_vttp TYPE HASHED TABLE OF gty_vttp WITH UNIQUE KEY vbeln .
  data:
    gth_vtts TYPE HASHED TABLE OF gty_vtts WITH UNIQUE KEY tknum tsnum .
  data:
    gt_vbpa  TYPE STANDARD TABLE OF gty_vbpa .                                                          "I-WMR-050717-3000007333
  data:
    gt_vbpa3 TYPE STANDARD TABLE OF vbpa3 .                                                             "+081122-NTP-3000020296
  data:
    gt_vtpa  TYPE STANDARD TABLE OF gty_vtpa .                                                          "I-WMR-260517-3000007333
  data:
    gth_vbfa TYPE HASHED TABLE OF gty_vbfa WITH UNIQUE KEY vbelv .                                      "I-WMR-280617-3000007333
  data:
    gth_t001w TYPE HASHED TABLE OF gty_t001w WITH UNIQUE KEY werks .                                    "I-NTP180918-3000010450
  data:
    gth_vbak TYPE HASHED TABLE OF gty_vbak WITH UNIQUE KEY vbeln .                                      "I-NTP180918-3000010450
  data:
    gth_mara TYPE HASHED TABLE OF gty_mara WITH UNIQUE KEY matnr .                    "I-PBM190423-3000020600
  data:
    gt_vbkd TYPE STANDARD TABLE OF gty_vbkd .                                                     "I-PBM060722-3000019552
  data:
    gt_tvaut TYPE STANDARD TABLE OF gty_tvaut .                                                   "I-PBM060722-3000019552
  data:
    gt_ekpo TYPE STANDARD TABLE OF gty_ekpo .                                                     "I-PBM160123-3000020028
  data:
    gt_const TYPE TABLE OF zostb_const_fe .
  data:
    gt_proxy TYPE TABLE OF zostb_envwsfe .
  data:
    gt_vigen TYPE TABLE OF zostb_constvigen .
  data:
    gth_asgtnhr   TYPE HASHED TABLE OF gty_asgtnhr  WITH UNIQUE KEY taxtype .
  data:
    gt_oigsi TYPE TABLE OF gty_oigsi .
  data:
    gt_oigsv TYPE TABLE OF gty_oigsv .
  data:
    gt_tordrf TYPE TABLE OF gty_tordrf .                "I-PBM081222-3000019824
  data:
    gt_torite TYPE TABLE OF gty_torite .                "+NTP010323-3000019645
  data:
    gt_restmssk TYPE TABLE OF gty_restmssk .             "+NTP010323-3000019645
  data:
    gt_txcroot TYPE TABLE OF gty_txcroot .              "+NTP010323-3000019645
  data:
    gt_cab_his TYPE TABLE OF zostb_fegrcab .             "+NTP010323-3000019645
  data GW_LICENSE type STRING .
  data:
    ls_const LIKE LINE OF gt_const .          "+NTP010423-3000020188

  methods CALL_IS_GRE
    importing
      !I_BUKRS type BUKRS
      !I_FKDAT type FKDAT
      !IT_CAB type GTT_FEGRCAB_JSON
      !IT_DET type GTT_FEGRDET_JSON
      !IT_CLI type GTT_FECLI
      !IS_NOJSON_DATA type ZOSFEGRES_DATA_NOJSON
      !IS_OPTIONS type ZOSFEES_EXTRACT_OPTIONS
    exporting
      !PE_MESSAGE type BAPIRETTAB
    exceptions
      ERROR .
  methods CALL_WS_MAIN
    importing
      !PI_BUKRS type BUKRS
      !PI_TIPDOC type CHAR02
      !PI_FECFAC type VBRK-FKDAT
      !PI_INPUT type ANY
      !PI_NROSAP type ZOSTB_FEGRCAB-ZZNROSAP optional
      !PI_GJAHR type ZOSTB_FEGRCAB-ZZGJAHR
      !PI_ID type CLIKE
      !IS_OPTIONS type ZOSFEES_EXTRACT_OPTIONS
    exporting
      !PE_OUTPUT type ANY
      !PE_MESSAGE type BAPIRETTAB .
  methods CALL_WS_REM
    importing
      !I_BUKRS type BUKRS
      !I_FKDAT type FKDAT
      !PI_CAB type GTT_FEGRCAB_JSON
      !PI_DET type GTT_FEGRDET_JSON
      !PI_FECLI type GTT_FECLI
      !IS_OPTIONS type ZOSFEES_EXTRACT_OPTIONS
    exporting
      !PE_MESSAGE type BAPIRETTAB
    exceptions
      ERROR .
  methods CALL_WS_XML
    importing
      !IS_JSON type ZOSFETB_JSON
      !I_FILENAME type STRING .
  methods CHECK_HOMO_REM
    importing
      !PI_CAB type GTT_FEGRCAB
      !PI_DET type GTT_FEGRDET
      !IS_OPTIONS type ZOSFEES_EXTRACT_OPTIONS optional
    exporting
      !ET_RETURN type BAPIRETTAB
    exceptions
      ERROR .
  methods CHECK_HOMO_REM_FIELD
    importing
      !IS_DATA type ANY
      !I_FIELD type CLIKE
      !I_ROW type CLIKE optional
      !I_TEXT type CLIKE
      !I_TEXT2 type CLIKE optional
    changing
      value(CT_RETURN) type BAPIRETTAB .
  methods FREE_DATA .
  methods GET_CODIGO_ESTAB_SUNAT
    importing
      !I_WERKS type ZOSFETB_ASGCODES-WERKS
      !LS_LIPS type GTY_LIPS
    changing
      !C_CODEST type GTY_FEGRCAB-ZZPAREST .
  methods GET_DATA_REM
    importing
      !I_ENTREGA type VBELN
      !IS_OPTIONS type ZOSFEES_EXTRACT_OPTIONS optional
    exporting
      !ET_LIKP type GTT_LIKP
      !ET_LIPS type GTT_LIPS
    exceptions
      NO_DATA
      NO_PILA_ACEPTADA .
  methods GET_DATA_REM_OIL .
  methods GET_DATA_REM_Z
    importing
      !IS_CAB type GTY_CAB_Z
      !IS_OPTIONS type ZOSFEES_EXTRACT_OPTIONS
    exporting
      !ET_LIKP type GTT_LIKP
      !ET_LIPS type GTT_LIPS
    exceptions
      NO_DATA
      NO_PILA_ACEPTADA .
  methods GET_DATA_TM_DELIVERY
    importing
      !IS_LIKP type GTY_LIKP
      !IT_LIPS type GTT_LIPS
    changing
      !CS_CAB_GRE type GTY_FEGRCAB
    exceptions
      NO_FOUND .
  methods GET_DIRECCIONES
    importing
      !IR_ADRNR type GTR_ADRNR
    exporting
      !ETH_DIRECCION type GTTH_DIRECCION .
  methods GET_FORMAT_TEXT_TYPE_PARAGRAPH
    importing
      !IS_THEAD type THEAD
    returning
      value(R_TEXT) type STRING .
  methods GET_INTERLOCUTOR
    importing
      !I_VBELN type VBELN
      !I_CAMPO type CLIKE optional
      !I_PARVW type CLIKE optional
    exporting
      !ES_KNA1 type GTY_KNA1
      !ES_DIRE type GTY_DIRECCION .
  methods GET_MATERIAL_CODIGO_CUBSO
    importing
      !IS_LIKP type GTY_LIKP
      !IS_LIPS type GTY_LIPS
    returning
      value(R_MATERIAL_SUNAT) type ZOSTB_FEGRDET-ZZ_MATERIAL_SUNAT .
  methods GET_SUNAT_RESOLUTION
    importing
      !I_BUKRS type BUKRS
    returning
      value(R_RESOL) type STRING .
  methods MOVE_CORRESPONDING
    importing
      !IS_DATA type ANY
    changing
      !CS_DATA type ANY .
  methods READ_TEXT
    importing
      !IS_THEAD type THEAD
    returning
      value(E_STRING) type STRING .
  methods S4_COMPLETAR_DATOS_NIF
    importing
      !IP_TYPE type CHAR01
    changing
      !CT_KNA1 type GTT_KNA1 .
  methods SERIALIZE_JSON
    importing
      !I_TABNAME type TABNAME optional
      !DATA type DATA
    returning
      value(JSON) type STRING .
  methods SERIALIZE_JSON_RECURSIVE
    importing
      !I_TABNAME type TABNAME optional
      !I_DATA type DATA
      !I_RECURSIVE_CALL type BOOLEAN optional
    changing
      !CT_STRING type TREXT_STRING .
  methods SERIALIZE_JSON_REPLACE
    importing
      !I_DATA type DATA
    returning
      value(R_DATA) type STRING .
  methods SET_ADITIONAL_TEXT_POS
    importing
      !IS_LIKP type GTY_LIKP
      !IS_LIPS type GTY_LIPS
      !IT_LIPS type GTT_LIPS
    returning
      value(R_TEXTPOS) type ZOSTB_FEGRDET-ZZTXTPOS .
  methods SET_DATA_REM_ANULADO
    importing
      !LS_LIKP type GTY_LIKP
    changing
      !LS_CAB type GTY_FEGRCAB .
  methods SET_DATA_REM_CONSIGNACION
    importing
      !LS_LIKP type GTY_LIKP
    changing
      !LS_CAB type GTY_FEGRCAB .
  methods SET_DATA_REM_DESTINO_LLEGADA
    importing
      !LS_LIKP type GTY_LIKP
      !IT_LIPS type GTT_LIPS
    changing
      !LS_CAB type GTY_FEGRCAB .
  methods SET_DATA_REM_DESTINO_LLEGADA_Z
    importing
      !LS_LIKP type GTY_LIKP
      !IT_LIPS type GTT_LIPS
    changing
      !LS_CAB type GTY_FEGRCAB .
  methods SET_DATA_REM_EMISION_PARTIDA_Z
    importing
      !LS_LIKP type GTY_LIKP
      !IT_LIPS type GTT_LIPS
    changing
      !LS_CAB type GTY_FEGRCAB .
  methods SET_DATA_REM_GR_TRANSPORTISTA
    importing
      !IS_LIKP type GTY_LIKP
      !IT_LIPS type GTT_LIPS
    changing
      !CS_CAB type GTY_FEGRCAB .
  methods SET_DATA_REM_ITEM
    importing
      !LS_LIKP type GTY_LIKP
      !IT_LIPS type GTT_LIPS
      !LS_CAB type GTY_FEGRCAB
    exporting
      !ET_DET type GTT_FEGRDET .
  methods SET_DATA_REM_OBSERVACION
    importing
      !LS_LIKP type GTY_LIKP
    changing
      !LS_CAB type GTY_FEGRCAB .
  methods SET_DATA_REM_PALLET
    importing
      !LS_LIKP type GTY_LIKP
      !IT_LIPS type GTT_LIPS
    changing
      !LS_CAB type GTY_FEGRCAB .
  methods SET_DATA_REM_REMITENTE
    importing
      !LS_LIKP type GTY_LIKP
      !IT_LIPS type GTT_LIPS
    changing
      !LS_CAB type GTY_FEGRCAB .
  methods SET_DATA_REM_SOLICITANTE
    importing
      !LS_LIKP type GTY_LIKP
    changing
      !LS_CAB type GTY_FEGRCAB .
  methods SET_DATA_REM_TRASLADO_MOD
    importing
      !LS_LIKP type GTY_LIKP
      !IT_LIPS type GTT_LIPS
    changing
      !LS_CAB type GTY_FEGRCAB .
  methods SET_DATA_REM_TRASLADO_MOD_INKA
    importing
      !LS_LIKP type GTY_LIKP
      !LS_LIPS type GTY_LIPS
    changing
      !LS_CAB type GTY_FEGRCAB .
  methods SET_DATA_REM_TRASLADO_MOT
    importing
      !LS_LIKP type GTY_LIKP
      !IT_LIPS type GTT_LIPS
    changing
      !LS_CAB type GTY_FEGRCAB .
  methods SET_HOMO_CLI
    importing
      !PI_CAB type GTT_FEGRCAB
    exporting
      !PE_CLI type GTT_FECLI .
  methods SET_HOMO_JSON_AND_SEND_WS
    importing
      !IS_OPTIONS type ZOSFEES_EXTRACT_OPTIONS optional
    exporting
      !ES_DATANOJSON type ZOSFEGRES_DATA_NOJSON
      !ET_RETURN type BAPIRETTAB
    changing
      !LT_CAB type GTT_FEGRCAB
      !LT_DET type GTT_FEGRDET
      !LT_CLI type GTT_FECLI
    exceptions
      ERROR .
  methods SET_HOMO_REM
    changing
      !CT_DET type GTT_FEGRDET
      !CT_CAB type GTT_FEGRCAB .
  methods SET_JSON_CLI
    importing
      !PI_CLI type GTT_FECLI
    exporting
      !PE_CLI_JSON type GTT_FECLI .
  methods SET_JSON_REM
    importing
      !PI_CAB type GTT_FEGRCAB
      !PI_DET type GTT_FEGRDET
    exporting
      !PE_CAB_JSON type GTT_FEGRCAB_JSON
      !PE_DET_JSON type GTT_FEGRDET_JSON .
  methods STRING_TO_XSTRING
    importing
      !INPUT type STRING
    returning
      value(OUTPUT) type XSTRING .
  methods SY_TO_RET
    importing
      !I_FIELD type CLIKE optional
      !I_ROW type CLIKE optional
    returning
      value(RS_RETURN) type BAPIRET2 .
  methods UI_STRING_TO_XSTRING_XML
    importing
      !INPUT type STRING
    returning
      value(OUTPUT) type XSTRING
    exceptions
      ERROR .
  methods UPD_TABLA_REM
    importing
      !IT_CAB type GTT_FEGRCAB
      !IT_DET type GTT_FEGRDET
      !IT_CLI type GTT_FECLI
      !IT_CAB_JSON type GTT_FEGRCAB_JSON
      !IT_DET_JSON type GTT_FEGRDET_JSON
    exceptions
      ERROR .
  methods XSTRING_TO_STRING
    importing
      !INPUT type XSTRING
    returning
      value(OUTPUT) type STRING .
ENDCLASS.



CLASS ZOSSDCL_PRO_EXTRAC_FE_GR IMPLEMENTATION.


  METHOD build_xml.

*{-010922-NTP-3000018956
***********************************************************************
** METODO MOMENTÁNEO
***********************************************************************
*
*    TYPES: BEGIN OF ty_fecli,
*             zzt_nrodocsap  TYPE zostb_fecli-zzt_nrodocsap,
*             zzt_numeracion TYPE zostb_fecli-zzt_numeracion,
*             ruc            TYPE zostb_fecli-ruc,
*             razon_social   TYPE zostb_fecli-razon_social,
*             direccion      TYPE zostb_fecli-direccion,
*             telefono       TYPE zostb_fecli-telefono,
*             email          TYPE zostb_fecli-email,
*           END OF ty_fecli.
*
*    DATA: lt_fegrcab  TYPE TABLE OF zostb_fegrcab,
*          lt_fegrdet  TYPE TABLE OF zostb_fegrdet,
*          lt_fecli    TYPE TABLE OF ty_fecli,
*
*          lt_cab_json TYPE gtt_fegrcab_json,
*          lt_det_json TYPE gtt_fegrdet_json.
*}-010922-NTP-3000018956

    DATA: ls_json    TYPE zosfetb_json,
          l_folder   TYPE c LENGTH 500,
          l_size     TYPE i,
          l_filename TYPE string,
          l_filefull TYPE string,
          l_string   TYPE string,
          l_json     TYPE string.

    DATA: l_xstring TYPE xstring,
          lo_xml    TYPE REF TO cl_xml_document.

*{-010922-NTP-3000018956
***********************************************************************
** Get data
***********************************************************************
*    get_constantes( i_vbeln   = i_nrodocsap                       "I-210922-3000020039
*                    i_tpproc  = gc_prefix_gr ).                   "I-210922-3000020039
*
*    "Cabecera
*    SELECT * FROM zostb_fegrcab
*    INTO TABLE lt_fegrcab
*     WHERE vbeln = i_nrodocsap
*       AND zznrosun = i_numeracion.
*
*    "Detalle
*    SELECT * FROM zostb_fegrdet
*    INTO TABLE lt_fegrdet
*     WHERE vbeln = i_nrodocsap
*       AND zznrosun = i_numeracion.
*
*    "Cliente
*    SELECT * FROM zostb_fecli
*    INTO CORRESPONDING FIELDS OF TABLE lt_fecli
*     WHERE zzt_nrodocsap = i_nrodocsap
*       AND zzt_numeracion = i_numeracion.
*
***********************************************************************
** Setear valores JSon
***********************************************************************
*    set_json_rem( EXPORTING pi_cab      = lt_fegrcab
*                            pi_det      = lt_fegrdet
*                  IMPORTING pe_cab_json = lt_cab_json
*                            pe_det_json = lt_det_json ).
*
***********************************************************************
** Json conversion
***********************************************************************
*    l_string = serialize_json( data = lt_cab_json ).
*    ls_json-jsoncab = string_to_xstring( l_string ).
*    l_string = serialize_json( data = lt_det_json ).
*    ls_json-jsondet = string_to_xstring( l_string ).
*    l_string = serialize_json( data = lt_fecli ).
*    ls_json-jsoncli = string_to_xstring( l_string ).
*}-010922-NTP-3000018956
*{+010922-NTP-3000018956
* 1 get data
    SELECT SINGLE * INTO ls_json FROM zosfetb_json
      WHERE zzt_nrodocsap = i_nrodocsap
        AND zzt_numeracion = i_numeracion.
    IF sy-subrc <> 0.
      MESSAGE e000 WITH 'Documento no existe' i_nrodocsap i_numeracion RAISING error.
    ENDIF.
*}+010922-NTP-3000018956

**********************************************************************
* Construir XML
**********************************************************************
    "1. Concatenar todos los json
    l_string = xstring_to_string( ls_json-jsoncab ).
    CONCATENATE '{"cab":' l_string INTO l_json.
    IF ls_json-jsondet IS NOT INITIAL.
      l_string = xstring_to_string( ls_json-jsondet ).
      CONCATENATE l_json ',"det":' l_string INTO l_json.
    ENDIF.
    IF ls_json-jsoncli IS NOT INITIAL.
      l_string = xstring_to_string( ls_json-jsoncli ).
      CONCATENATE l_json ',"cli":' l_string INTO l_json.
    ENDIF.
    CONCATENATE l_json '}' INTO l_json.

    "2. Construir xml
*{+010922-NTP-3000018956
    ui_string_to_xstring_xml(
      EXPORTING
        input  = l_json
      RECEIVING
        output = l_xstring
      EXCEPTIONS
        error  = 1
    ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.
*}+010922-NTP-3000018956

    "2.1 Mostrar
    IF i_show IS NOT INITIAL.
      CREATE OBJECT lo_xml.
*{+NTP010323_3000019645
      IF ls_json-web IS NOT INITIAL.
        lo_xml->parse_xstring( ls_json-web ).
      ELSE.
*}+NTP010323_3000019645
        lo_xml->parse_xstring( l_xstring ).
      ENDIF.
      lo_xml->display( ).
    ENDIF.

    "2.2 Descargar
    IF i_down IS NOT INITIAL.
      l_folder = i_folder.
      IF l_folder IS INITIAL.
        MESSAGE e000 WITH 'Falta folder' RAISING error.
      ENDIF.

      "Nombre del archivo
      CONCATENATE i_nrodocsap i_numeracion INTO l_filename SEPARATED BY '-'.

      "Folder
      l_size = strlen( l_folder ) - 1.
      IF l_folder+l_size(1) = '\'.
        CONCATENATE l_folder l_filename INTO l_filename.
      ELSE.
        CONCATENATE l_folder l_filename INTO l_filename SEPARATED BY '\'.
      ENDIF.

      CONCATENATE l_filename '.xml' INTO l_filefull.
      cl_salv_data_services=>download_xml_to_file( filename = l_filefull xcontent = l_xstring ).

*{+010922-NTP-3000018956
      "Nisira
      IF ls_json-web IS NOT INITIAL.
        ui_string_to_xstring_xml(
          EXPORTING
            input  = xstring_to_string( ls_json-web )
          RECEIVING
            output = l_xstring
          EXCEPTIONS
            error  = 1
        ).
        IF sy-subrc <> 0.
          RAISE error.
        ENDIF.

        CONCATENATE l_filename '_web.xml' INTO l_filefull.
        cl_salv_data_services=>download_xml_to_file( filename = l_filefull xcontent = l_xstring ).
      ENDIF.
*}+010922-NTP-3000018956

      call_ws_xml( is_json = ls_json i_filename = l_filename ). "+NTP010323-3000019645
    ENDIF.


  ENDMETHOD.


  METHOD call_is_gre.

    DATA: l_psecod TYPE string,
          lo_feis  TYPE REF TO object,
          lo_root  TYPE REF TO cx_root,
          l_class  TYPE string.

    " Obtener asignación a PSE
    SELECT COUNT(*) FROM dd02l WHERE tabname = gc_tabpse.
    IF sy-subrc = 0.
      SELECT SINGLE psecod INTO l_psecod FROM (gc_tabpse)
        WHERE bukrs = i_bukrs
          AND begda <= sy-datum
          AND endda >= sy-datum.
    ENDIF.

    " Direccionar Servicio
    IF l_psecod IS INITIAL.
      " WS on Premise
      call_ws_rem( EXPORTING  i_bukrs    = i_bukrs
                              i_fkdat    = i_fkdat
                              pi_cab     = it_cab
                              pi_det     = it_det
                              pi_fecli   = it_cli
                              is_options = is_options           "+NTP010523-3000020188
                   IMPORTING  pe_message = pe_message
                   EXCEPTIONS error      = 1 ).
      IF sy-subrc <> 0.
        RAISE error.
      ENDIF.

    ELSE.
      " Integración de Servicios
      CONCATENATE zossdcl_pro_extrac_fe_ l_psecod INTO l_class.  "+3000018956-010722-NTP
      TRY.
          CREATE OBJECT lo_feis TYPE (l_class).
          CALL METHOD lo_feis->('CALL_PSE_GR')
            EXPORTING
              is_data_gr = is_nojson_data
              is_options = is_options
            IMPORTING
              et_return  = pe_message.
        CATCH cx_root INTO lo_root.
      ENDTRY.
    ENDIF.

  ENDMETHOD.


  METHOD call_ws_main.

*   Llamada dinamica de webservices
    DATA: l_system    TYPE syst-host,
          l_test_act  TYPE xfeld,       "Indicador Sistema Test activo
          l_mandt_prd TYPE symandt,     "Mandante Productivo Real.
          l_envsun    TYPE zostb_envwsfe-envsun,
          l_clase     TYPE string,
          l_metho     TYPE string,

          lv_prefix   TYPE string,

          "WS
          lo_obj      TYPE REF TO object,
          lo_sys      TYPE REF TO cx_ai_system_fault,
          lo_app      TYPE REF TO cx_ai_application_fault,
          l_cx_system TYPE string,
          l_sunat     TYPE string,

          "Const
          ls_const    LIKE LINE OF gt_const,
          ls_proxy    LIKE LINE OF gt_proxy,
          ls_vigen    LIKE LINE OF gt_vigen.

*   Lectura de resultado
    DATA: l_registrado TYPE char1,
          lt_sunat     TYPE TABLE OF char256,
          ls_sunat     TYPE char256,

          lt_lineas    TYPE TABLE OF gty_lineas,
          ls_lineas    LIKE LINE OF lt_lineas,
          ls_message   LIKE LINE OF pe_message,
          ls_felog     TYPE zostb_felog.

    FIELD-SYMBOLS: <input>  TYPE any,
                   <output> TYPE any,
                   <fs>     TYPE any.

*BI-NTP-210416
    CASE pi_tipdoc.
      WHEN gc_tipdoc_gr
        OR gc_tipdoc_gr_transportista.            "+NTP240323-3000020928
        lv_prefix = gc_prefix_gr.
    ENDCASE.
*EI-NTP-210416

*   Lectura de constantes
    LOOP AT gt_const INTO ls_const.
      CASE ls_const-campo.
          "Test
        WHEN gc_campo_test_act.
          l_test_act = ls_const-valor1.

          "PRD
        WHEN gc_campo_mandt_prd.
          l_mandt_prd = ls_const-valor1.

          "Determinar nombre del sistema
        WHEN gc_campo_host.
          IF ls_const-valor1 = sy-host.
            l_system = ls_const-valor2.
          ENDIF.
      ENDCASE.
    ENDLOOP.


*   Segun Sistema - Identificar Modo TEST HOMO PRD
    CASE l_system.
        "QAS
      WHEN gc_system_qas.
        IF l_test_act EQ abap_on.
          l_envsun = gc_system_sunat_test.
        ELSE.
          l_envsun = gc_system_sunat_homo.
        ENDIF.
        "PRD
      WHEN gc_system_prd.
        IF sy-mandt EQ l_mandt_prd.
          l_envsun = gc_system_sunat_prod.
        ELSE.
          l_envsun = gc_system_sunat_test.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.

*   Asignar input, output
    ASSIGN pi_input  TO <input>.
    ASSIGN pe_output TO <output>.


*   Determinar Clase y Metodo WS
    READ TABLE gt_proxy INTO ls_proxy WITH KEY bukrs   = pi_bukrs
                                               envsun  = l_envsun
                                               tpproc  = lv_prefix.
    IF sy-subrc EQ 0.

*     Determina Versión de FE Activa
      LOOP AT gt_vigen INTO ls_vigen WHERE begda <= pi_fecfac
                                       AND endda >= pi_fecfac
                                       AND tpproc = lv_prefix.
      ENDLOOP.
      IF sy-subrc = 0.
        CASE ls_vigen-zz_versivigen.
          WHEN gc_version_1.
            l_clase = ls_proxy-class.
            l_metho = ls_proxy-method.
          WHEN gc_version_2.
            l_clase = ls_proxy-class2.
            l_metho = ls_proxy-method2.
        ENDCASE.
      ELSE.
        l_clase = ls_proxy-class.
        l_metho = ls_proxy-method.
      ENDIF.

*     Llamar Web Service
      TRY.
          CREATE OBJECT lo_obj TYPE (l_clase)
            EXPORTING
              logical_port_name = gs_consextsun-zz_proxy_name. "ZP01

          TRY.
              CALL METHOD lo_obj->(l_metho)
                EXPORTING
                  input  = <input>
                IMPORTING
                  output = <output>.
            CATCH cx_ai_system_fault      INTO lo_sys.
            CATCH cx_ai_application_fault INTO lo_app.
          ENDTRY.

        CATCH cx_ai_system_fault INTO lo_sys.
      ENDTRY.

      "Exception
      IF lo_sys IS BOUND.
        l_cx_system = lo_sys->get_text( ).
      ENDIF.

      "Resultado
      ASSIGN COMPONENT 'RESULTADO' OF STRUCTURE <output> TO <fs>.
      IF <fs> IS ASSIGNED.
        l_sunat = <fs>.
      ENDIF.
    ELSE.
      CONCATENATE TEXT-i01
                  TEXT-i02
                  lv_prefix
             INTO l_cx_system SEPARATED BY space.
    ENDIF.


**********************************************************************
*   Resultado
**********************************************************************
*   Excepción (error de conexión)
    IF l_cx_system IS NOT INITIAL.
      ls_message-type       = 'E'.
      ls_message-id         = '00'.
      ls_message-number     = '398'.
      ls_message-message_v1 = TEXT-e03.
      ls_message-message_v2 = TEXT-e04.
      CONCATENATE ls_message-message_v1
                  ls_message-message_v2
                  INTO ls_message-message SEPARATED BY space.
      APPEND ls_message TO pe_message.
    ELSE.

*   Leer resultado sunat
      CASE lv_prefix.
        WHEN gc_prefix_gr.

          SHIFT l_sunat BY 3 PLACES.                "Borrar los 3 primeros
          SPLIT l_sunat AT ';' INTO TABLE lt_sunat. "Mensajes separados
          LOOP AT lt_sunat INTO ls_sunat.
            ls_lineas-linea = ls_sunat+4.
            IF ls_sunat(3) = '007'.
              l_registrado = abap_true.
              CONCATENATE pi_id ls_lineas-linea INTO ls_lineas-linea SEPARATED BY space.
            ENDIF.
            APPEND ls_lineas TO lt_lineas.
          ENDLOOP.

          LOOP AT lt_lineas INTO ls_lineas.
            CASE l_registrado.
              WHEN abap_true.  ls_message-type = 'S'.
              WHEN abap_false. ls_message-type = 'E'.
            ENDCASE.

            ls_message-id       = '00'.
            ls_message-number   = '398'.
            ls_message-message  = ls_lineas-linea.
            CALL FUNCTION 'CRM_MESSAGE_TEXT_SPLIT'
              EXPORTING
                iv_text    = ls_lineas-linea
              IMPORTING
                ev_msgvar1 = ls_message-message_v1
                ev_msgvar2 = ls_message-message_v2
                ev_msgvar3 = ls_message-message_v3
                ev_msgvar4 = ls_message-message_v4.
            APPEND ls_message TO pe_message.
          ENDLOOP.
      ENDCASE.
    ENDIF.

*   Actualiza Log
    CASE lv_prefix.
      WHEN gc_prefix_gr.
*       Log de Factura Electrónica
*        ls_felog-zzt_nrodocsap  = pi_vbeln.
        ls_felog-zzt_nrodocsap  = pi_nrosap.
        ls_felog-gjahr          = pi_gjahr.
        ls_felog-zzt_numeracion = pi_id.
        ls_felog-zzt_correlativ = 1.
        ls_felog-zzt_fcreacion  = sy-datum.
        ls_felog-zzt_hcreacion  = sy-uzeit.
        ls_felog-zzt_ucreacion  = sy-uname.
        ls_felog-bukrs          = pi_bukrs.
        ls_felog-zzt_tipodoc    = pi_tipdoc.
        IF l_cx_system IS NOT INITIAL.
          ls_felog-zzt_status_cdr = gc_statuscdr_7.
          ls_felog-zzt_errorext   = ls_message-message.
        ELSEIF is_options-only_syncstat IS NOT INITIAL.       "+NTP010523-3000020188
          ls_felog-zzt_status_cdr = is_options-only_syncstat. "+NTP010523-3000020188
        ELSE.
          ls_felog-zzt_status_cdr = gc_statuscdr_2.
          IF l_registrado = abap_off.
            ls_felog-zzt_errorext   = ls_message-message.
          ENDIF.
        ENDIF.
        MODIFY zostb_felog FROM ls_felog.

*{+NTP010323_3000019645
        DATA: l_json  TYPE string,
              l_xjson TYPE xstring.

        l_json = serialize_json( data = pi_input ).
        REPLACE ALL OCCURRENCES OF '"controller":[],' IN l_json WITH ''.
        REPLACE ALL OCCURRENCES OF gs_consextsun-zz_usuario_web IN l_json WITH ''.
        REPLACE ALL OCCURRENCES OF gs_consextsun-zz_pass_web IN l_json WITH ''.
        ui_string_to_xstring_xml( EXPORTING input = l_json RECEIVING output = l_xjson ).

        UPDATE zosfetb_json
           SET web = l_xjson
          WHERE zzt_nrodocsap  = ls_felog-zzt_nrodocsap
            AND gjahr          = ls_felog-gjahr
            AND zzt_numeracion = ls_felog-zzt_numeracion.
*}+NTP010323_3000019645
    ENDCASE.

  ENDMETHOD.                    "call_ws_res


  METHOD call_ws_rem.

    DATA: input   TYPE zosfe_wsosgrm_documentos_reque, "Test Homo Prd
          output  TYPE zosfe_wsosgrm_documentos_respo, "Test Homo Prd
          ls_item LIKE LINE OF input-d_guiaremision_array-d_guiaremision.

    DATA: ls_cab   LIKE LINE OF pi_cab,
          ls_det   LIKE LINE OF pi_det,
          ls_fecli LIKE LINE OF pi_fecli.

    CHECK lines( pi_cab ) > 0.

* Cabecera
    LOOP AT pi_cab INTO ls_cab.
      input-user = gs_consextsun-zz_usuario_web.
      input-pass = gs_consextsun-zz_pass_web.
      input-bukrs = gs_consextsun-bukrs.                              "I-NTP-140716

      input-c_guiaremision-ser_num_grm = ls_cab-zznrosun.
      input-c_guiaremision-fec_emi_grm = ls_cab-zzfecemi.
*    input-c_guiaremision-fir_dig_grm = .               "No va
      input-c_guiaremision-tip_doc_grm = ls_cab-zztipgui.
      input-c_guiaremision-obs_doc_grm = ls_cab-zzobserv.
*    input-c_guiaremision-snm_baj_grm = ls_cab-. "Serie-Nro Doc.Baja
*    input-c_guiaremision-ctd_baj_grm = ls_cab-. "Tp.Doc.Baja
*    input-c_guiaremision-ntd_baj_grm = ls_cab-. "Nom.Tp.Doc.Baja
*    input-c_guiaremision-ndc_rel_grm = ls_cab-. "Nro.Relacionado
*    input-c_guiaremision-ctd_rel_grm = ls_cab-. "Tp.Doc.Relacionado
      input-c_guiaremision-tni_rem_grm = ls_cab-zzremnro.   "Remitente
      input-c_guiaremision-nom_rem_grm = ls_cab-zzremden.
      input-c_guiaremision-tni_des_grm = ls_cab-zzdstnro.   "Destinatario
      input-c_guiaremision-nom_des_grm = ls_cab-zzdstden.
      input-c_guiaremision-tni_ter_grm = ls_cab-zzetrnro.   "Tercero
      input-c_guiaremision-nom_ter_grm = ls_cab-zzetrden.
      input-c_guiaremision-mot_tra_grm = ls_cab-zztrsmot_h. "Motivo
      input-c_guiaremision-pbr_tra_grm = ls_cab-zzpesbru.   "Peso
      input-c_guiaremision-fec_tra_grm = ls_cab-zztrafec.
      input-c_guiaremision-mni_tra_grm = ls_cab-zztrsmod_h. "Modalidad
      input-c_guiaremision-tni_tra_grm = ls_cab-zztranro.   "Transportista
      input-c_guiaremision-nom_tra_grm = ls_cab-zztraden.
      input-c_guiaremision-vcn_trp_grm = ls_cab-zzplaveh.   "Vehiculo y Transporte privado
**      input-c_guiaremision-tni_di1_grm = ls_cab-zzdi1nro.   "Destinatario Intermedio 1 "I-251220-NTP-3000014557 "ILEN
      input-c_guiaremision-pto_lle_grm = ls_cab-zzlleubi.   "Llegada
      input-c_guiaremision-pto_par_grm = ls_cab-zzparubi.   "Partida
      input-c_guiaremision-dat_aux_grm = ls_cab-zzcntnro.   "Num. De contenedor y Código de puerto
      input-c_guiaremision-ver_ubl_grm = ls_cab-zzverubl.
      input-c_guiaremision-ver_est_grm = ls_cab-zzverstr.
      input-c_guiaremision-dtx_adi_grm = ls_cab-zztagadd.   "Tags Adicionales         "I-WMR-260517-3000007333
      input-c_guiaremision-ref_doc_grm = ls_cab-zzrefere.   "Referencias              "I-WMR-280617-3000007333
      input-c_guiaremision-cmp_pag_grm = ls_cab-zztpnrcp.   "Tipo y N°Comprobante Pago"I-WMR-280617-3000007333
*    input-c_guiaremision-vlr_rsm_grm = ls_cab-.
      input-c_guiaremision-ley_rep_grm = TEXT-w01.
      input-c_guiaremision-ley_res_grm = get_sunat_resolution( ls_cab-bukrs ).
*    input-c_guiaremision-fec_reg_grm = ls_cab-.
      input-c_guiaremision-est_reg_grm = is_options-only_syncstat.                              "+NTP010523-3000020188
      input-c_guiaremision-tra_ped_grm = ls_cab-zzntrnpc.   "N°transporte/N°pedido cliente      "I-WMR-070318-3000008769
      input-c_guiaremision-nro_sol_grm = ls_cab-zzslcnro.   "N°y tipo doc.identidad Solicitante "I-WMR-070318-3000008769
      input-c_guiaremision-den_sol_grm = ls_cab-zzslcden.   "Denominación Solicitante           "I-WMR-070318-3000008769
**      input-c_guiaremision-dir_tra_grm = ls_cab-zztradir.
      input-c_guiaremision-fin_doc_grm = ls_cab-zztxtffd.   "Texto adicional fin de documento   "I-WMR-070318-3000008769
**    input-c_guiaremision-dir_emi_grm = ls_cab-zzpemdir.   "Punto Emisión                      "I-WMR-250918-3000010450
*    input-c_guiaremision-pie_tot_grm = ls_cab-zzpietot_j. "DetallePie - Totales               "I-051219-NTP-3000013055
      input-c_guiaremision-usu_ent_grm = ls_cab-ernam.      "Usuario Creado por                 "I-PBM180520-3000013745
      input-c_guiaremision-hor_emi_grm = ls_cab-zzhoremi.    "Hora de emisión                    "I-PBM210922-3000020039
      input-c_guiaremision-dat_env_grm = ls_cab-zzdatenv.    "Datos del envío                    "I-PBM210922-3000020039
      input-c_guiaremision-ndc_rel_grm = ls_cab-zzdamnro. "Nro.Relacionado (DAM)              "I-PBM210922-3000020039
*{+NTP010323-3000019645
      "Guia Transportista
**    input-c_guiaremision-grt_docrel     = ls_cab-zzgrt_docrel.      "Documentos relacionados
**    input-c_guiaremision-grt_indenv_tp  = ls_cab-zzgrt_indenv_tp.   "Indicador transbordo programado
**    input-c_guiaremision-grt_indenv_rv  = ls_cab-zzgrt_indenv_rv.   "Indicador retorno vacio
**    input-c_guiaremision-grt_indenv_rve = ls_cab-zzgrt_indenv_rve.  "Indicador retorno envase vacio
**    input-c_guiaremision-grt_indenv_ts  = ls_cab-zzgrt_indenv_ts.   "Indicador transporte subcontratado
**    input-c_guiaremision-grt_indenv_pft = ls_cab-zzgrt_indenv_pft.  "Indicador pagador flete tercero
**    input-c_guiaremision-grt_pftnro     = ls_cab-zzgrt_pftnro.      "Pagador flete nro
**    input-c_guiaremision-grt_pftden     = ls_cab-zzgrt_pftden.      "Pagador flete deno
*}+NTP010323-3000019645
    ENDLOOP.

* Detalle
    LOOP AT pi_det INTO ls_det.
      ls_item-ser_num_grm = ls_det-zznrosun.
      ls_item-num_itm_grm = ls_det-zzitepos.
      ls_item-cod_itm_grm = ls_det-zzitecod.
      ls_item-des_itm_grm = ls_det-zzitedes.
      ls_item-cnt_itm_grm = ls_det-zziteqty.
      ls_item-pbr_itm_grm = ls_det-zzitepbr.
      ls_item-pto_itm_grm = ls_det-zzitepbt.
      ls_item-esp_itm_grm = ls_det-zztxtpos.                " Texto adicional de posición       "I-WMR-080119-3000011134
      APPEND ls_item TO input-d_guiaremision_array-d_guiaremision.
    ENDLOOP.

* Cliente
    LOOP AT pi_fecli INTO ls_fecli.
      input-d_empresa-ruc_emp     = ls_fecli-ruc.
      input-d_empresa-raz_soc_emp = ls_fecli-razon_social.
      input-d_empresa-dir_emp     = ls_fecli-direccion.
      input-d_empresa-tel_emp     = ls_fecli-telefono.
      input-d_empresa-con_emp     = ls_fecli-email.
    ENDLOOP.

    call_ws_main(
      EXPORTING
        pi_bukrs      = i_bukrs
        pi_tipdoc     = ls_cab-zztipgui2 "gc_tipdoc_gr
        pi_fecfac     = i_fkdat
        pi_input      = input
*        pi_vbeln      = ls_cab-vbeln
        pi_nrosap     = ls_cab-zznrosap
        pi_gjahr      = ls_cab-zzgjahr
        pi_id         = ls_cab-zznrosun
        is_options    = is_options
      IMPORTING
        pe_output     = output
        pe_message    = pe_message
    ).

  ENDMETHOD.


  METHOD call_ws_xml.

    DATA: ls_proxy   TYPE zostb_envwsfe,
          ls_consext TYPE zostb_consextsun,
*          ls_input   TYPE zosfe_ws_getxmlrequest,
*          ls_output  TYPE zosfe_ws_getxmlresponse,
          lo_obj     TYPE REF TO object,
          l_filefull TYPE string.

    SELECT COUNT(*) FROM dd02l WHERE tabname = gc_tabpse.
    IF sy-subrc = 0.
      SELECT COUNT(*) FROM (gc_tabpse)
        WHERE bukrs = is_json-bukrs
          AND begda <= sy-datum
          AND endda >= sy-datum
          AND psecod <> space.
    ENDIF.
    IF sy-subrc <> 0.

      "determinar_ambiente_sunat
      SELECT SINGLE valor2 INTO ls_proxy-envsun
        FROM zostb_const_fe
        WHERE programa = gc_prog
          AND valor1   = sy-host.
      CASE ls_proxy-envsun.
        WHEN zossdcl_pro_extrac_fe=>gc_system_qas.
          ls_proxy-envsun = 'TES'.
        WHEN zossdcl_pro_extrac_fe=>gc_system_prd.
          ls_proxy-envsun = 'PRD'.
        WHEN OTHERS.
          EXIT.
      ENDCASE.

      "Usuario y pass
      SELECT SINGLE * INTO ls_consext FROM zostb_consextsun
        WHERE bukrs = is_json-bukrs.

      "Obtiene Clase y Metodo WS
      SELECT SINGLE * INTO ls_proxy
        FROM zostb_envwsfe
        WHERE bukrs EQ is_json-bukrs
          AND envsun EQ ls_proxy-envsun
          AND tpproc EQ 'XM'. "xml
      IF sy-subrc EQ 0.
*        ls_input-user   = ls_consext-zz_usuario_web.
*        ls_input-pass   = ls_consext-zz_pass_web.
*        ls_input-bukrs  = is_json-bukrs.
*        ls_input-numera = is_json-zzt_numeracion.
*        ls_input-tipo_doc = is_json-zzt_tipdoc.
*
*        "Call WS
*        TRY.
*            CREATE OBJECT lo_obj TYPE (ls_proxy-class)
*              EXPORTING
*                logical_port_name = ls_consext-zz_proxy_name.
*            TRY.
*                CALL METHOD lo_obj->(ls_proxy-method)
*                  EXPORTING
*                    input  = ls_input
*                  IMPORTING
*                    output = ls_output.
*            ENDTRY.
*        ENDTRY.
*
*        IF ls_output IS NOT INITIAL.
*          CONCATENATE i_filename '_sun.xml' INTO l_filefull.
*          cl_salv_data_services=>download_xml_to_file( filename = l_filefull xcontent = ls_output-c_xml-stringxml ).
*        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD check_homo_rem.

    DATA: ls_return LIKE LINE OF et_return, "+NTP010523-3000020188
          ls_log    TYPE zostb_felog.       "+NTP010423-3000020188

    FIELD-SYMBOLS: <fs_cab> LIKE LINE OF pi_cab,
                   <fs_det> LIKE LINE OF pi_det.

* Errores cabecera
    LOOP AT pi_cab ASSIGNING <fs_cab>.
      CLEAR ls_log.
      ls_log-bukrs          = <fs_cab>-bukrs.
*      ls_log-zzt_nrodocsap  = <fs_cab>-vbeln.    "-NTP010423-3000020188
      ls_log-zzt_nrodocsap  = <fs_cab>-zznrosap.  "+NTP010423-3000020188
      ls_log-gjahr          = <fs_cab>-zzgjahr.   "+NTP010423-3000020188
      ls_log-zzt_numeracion = <fs_cab>-zznrosun.
      ls_log-zzt_status_cdr = gc_statuscdr_0.
      ls_log-zzt_fcreacion  = sy-datum.
      ls_log-zzt_hcreacion  = sy-uzeit.
      ls_log-zzt_ucreacion  = sy-uname.
      ls_log-zzt_tipodoc    = <fs_cab>-zztipgui.

*{+NTP010423-3000020188
      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZREMTPD_H' i_text = TEXT-e05 i_text2 = 'tipo doc' CHANGING ct_return = et_return ).
      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZREMDEN'   i_text = TEXT-e05 i_text2 = 'denominación' CHANGING ct_return = et_return ).
      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZREMNRO'   i_text = TEXT-e05 i_text2 = 'nro.documento' CHANGING ct_return = et_return ).

      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZPARUBI'   i_text = TEXT-e14 i_text2 = 'ubigeo' CHANGING ct_return = et_return ).
      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZPARDIR'   i_text = TEXT-e14 i_text2 = 'dirección' CHANGING ct_return = et_return ).

      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZDSTNRO'   i_text = TEXT-e06 i_text2 = 'nro.documento' CHANGING ct_return = et_return ).
      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZDSTTPD_H' i_text = TEXT-e06 i_text2 = 'tipo doc' CHANGING ct_return = et_return ).
      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZDSTDEN'   i_text = TEXT-e06 i_text2 = 'denominación' CHANGING ct_return = et_return ).

      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZLLEUBI'   i_text = TEXT-e13 i_text2 = 'ubigeo' CHANGING ct_return = et_return ).
      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZLLEDIR'   i_text = TEXT-e13 i_text2 = 'dirección' CHANGING ct_return = et_return ).

      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZSLCNRO'   i_text = TEXT-e20 i_text2 = 'nro.documento' CHANGING ct_return = et_return ).
      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZSLCTPD_H' i_text = TEXT-e20 i_text2 = 'tipo doc.' CHANGING ct_return = et_return ).
      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZSLCDEN'   i_text = TEXT-e20 i_text2 = 'denominación' CHANGING ct_return = et_return ).

      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZTRSMOT_H' i_text = TEXT-e07 CHANGING ct_return = et_return ).
      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZTRSMOD_H' i_text = TEXT-e12 i_text2 = '' CHANGING ct_return = et_return ).
      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZTRAFEC'   i_text = TEXT-e09 i_text2 = 'fecha' CHANGING ct_return = et_return ).
      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZTRAHOR'   i_text = TEXT-e09 i_text2 = 'hora' CHANGING ct_return = et_return ).

      CASE <fs_cab>-zztrsmod_h.
        WHEN gc_modtras_publico.
          check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZTRANRO'   i_text = TEXT-e10 i_text2 = 'nro.documento' CHANGING ct_return = et_return ).
          check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZTRATPD_H' i_text = TEXT-e10 i_text2 = 'tipo doc.' CHANGING ct_return = et_return ).
          check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZTRADEN'   i_text = TEXT-e10 i_text2 = 'denominación' CHANGING ct_return = et_return ).
          check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZTRAMTC'   i_text = TEXT-e10 i_text2 = 'MTC' CHANGING ct_return = et_return ).
      ENDCASE.

      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZPLAVEH'   i_text = TEXT-e10 i_text2 = 'placa' CHANGING ct_return = et_return ).
*      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZTRAMAR'   i_text = TEXT-e10 i_text2 = 'marca' CHANGING ct_return = et_return ).
*      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZTRANCI'   i_text = TEXT-e10 i_text2 = 'constancia de inscripción' CHANGING ct_return = et_return ).

      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZCONNRO'   i_text = TEXT-e11 i_text2 = 'nro.documento' CHANGING ct_return = et_return ).
      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZCONTPD_H' i_text = TEXT-e11 i_text2 = 'tipo doc.' CHANGING ct_return = et_return ).
      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZCONDEN'   i_text = TEXT-e11 i_text2 = 'denominación' CHANGING ct_return = et_return ).
      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZTRABVT'   i_text = TEXT-e11 i_text2 = 'brevete' CHANGING ct_return = et_return ).

      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZPESBRU'   i_text = TEXT-e08 i_text2 = 'peso' CHANGING ct_return = et_return ).
      check_homo_rem_field( EXPORTING is_data = <fs_cab> i_field = 'ZZUNDMED_H' i_text = TEXT-e08 i_text2 = 'UM' CHANGING ct_return = et_return ).
*}+NTP010423-3000020188
    ENDLOOP.

* Errores Detalle
    LOOP AT pi_det ASSIGNING <fs_det>.
*{+NTP010423-3000020188
      check_homo_rem_field( EXPORTING is_data = <fs_det> i_field = 'ZZITEQTY'   i_row = <fs_det>-posnr i_text = TEXT-e15 CHANGING ct_return = et_return ).
      check_homo_rem_field( EXPORTING is_data = <fs_det> i_field = 'ZZITEUND_H' i_row = <fs_det>-posnr i_text = TEXT-e16 CHANGING ct_return = et_return ).
*      check_homo_rem_field( EXPORTING is_data = <fs_det> i_field = 'ZZITECOD'   i_row = <fs_det>-posnr i_text = TEXT-e17 CHANGING ct_return = et_return ).
*}+NTP010423-3000020188
    ENDLOOP.

*{+NTP010423-3000020188
    IF et_return IS NOT INITIAL.
      LOOP AT et_return INTO ls_return.
        IF ls_log-log IS INITIAL.
          ls_log-log = ls_return-message.
        ELSE.
          CONCATENATE ls_log-log ls_return-message INTO ls_log-log SEPARATED BY '|'.
        ENDIF.
      ENDLOOP.

      IF is_options-test IS INITIAL.
        MODIFY zostb_felog FROM ls_log.
      ENDIF.
      RAISE error.
    ENDIF.
*}+NTP010423-3000020188

  ENDMETHOD.                    "check_homo


  METHOD check_homo_rem_field.
    DATA: l_string  TYPE string.
    FIELD-SYMBOLS <fs> TYPE any.

    ASSIGN COMPONENT i_field OF STRUCTURE is_data TO <fs>.
    IF <fs> IS INITIAL.
      MESSAGE e000 WITH i_text i_text2 INTO l_string.

      APPEND sy_to_ret( i_field = i_field i_row = i_row ) TO ct_return.
    ENDIF.
  ENDMETHOD.


  METHOD extrae_data_guia_baja.

    DATA: lt_log      TYPE TABLE OF zostb_felog,
          lt_cab_db   TYPE gtt_fegrcab,
          lt_cab      TYPE gtt_fegrcab,
          lt_det      TYPE gtt_fegrdet,
          lt_cli      TYPE gtt_fecli,
          lt_return   TYPE bapirettab,

          ls_cab      LIKE LINE OF lt_cab,
          ls_options  TYPE zosfees_extract_options,
          ls_return   LIKE LINE OF lt_return,

          l_datelimit TYPE sy-datum,
          l_tabix     TYPE i,
          l_message   TYPE string.


    "Inicializa
    g_bukrs = i_bukrs.
    get_constantes( i_vbeln = '$' i_tpproc = gc_prefix_gr ).


    "Validar fecha
    zosfegrcl_guia_z_util=>get_datelimit_baja(
      EXPORTING
        i_fecemi    = i_fecemi
      EXCEPTIONS
        error       = 1
    ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.


    "Get log
    SELECT * INTO TABLE lt_log FROM zostb_felog WHERE zzt_fcreacion >= i_fecemi.
    IF i_nrosap IS NOT INITIAL.
      DELETE lt_log WHERE zzt_nrodocsap <> i_nrosap AND gjahr <> i_gjahr AND zzt_numeracion <> i_nrosun.
    ENDIF.
    DELETE lt_log WHERE zzt_status_cdr <> 1 AND zzt_status_cdr <> 4.


    "Get guias
    IF lt_log IS NOT INITIAL.
      SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_cab_db
        FROM zostb_fegrcab
        FOR ALL ENTRIES IN lt_log
        WHERE zznrosap = lt_log-zzt_nrodocsap
          AND zzgjahr  = lt_log-gjahr
          AND zznrosun = lt_log-zzt_numeracion.

      IF i_nrosap IS INITIAL.
        DELETE lt_cab_db WHERE is_guia_z = abap_on.

        LOOP AT lt_cab_db INTO ls_cab.
          l_tabix = sy-tabix.

          SELECT COUNT(*) FROM likp WHERE vbeln = ls_cab-zznrosap.
          IF sy-subrc = 0.
            DELETE lt_cab_db INDEX l_tabix.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
    IF lt_cab_db IS INITIAL.
      MESSAGE e000 WITH 'No hay guias de remisión' 'para emision de bajas' RAISING error.
    ENDIF.


    "Asignar estado
    ls_options-only_syncstat = 8.


    "Enviar a la web
    LOOP AT lt_cab_db INTO ls_cab.
      CLEAR: lt_cab, lt_det, lt_cli.

      APPEND ls_cab TO lt_cab.
      SELECT * INTO TABLE lt_det FROM zostb_fegrdet WHERE zznrosap = ls_cab-zznrosap AND zzgjahr = ls_cab-zzgjahr.
      SELECT * INTO TABLE lt_cli FROM zostb_fecli WHERE zzt_nrodocsap = ls_cab-zznrosap AND zzt_gjahr = ls_cab-zzgjahr.

      set_homo_json_and_send_ws(
        EXPORTING
          is_options    = ls_options
        IMPORTING
          et_return     = et_return
        CHANGING
          lt_cab        = lt_cab
          lt_det        = lt_det
          lt_cli        = lt_cli
        EXCEPTIONS
          error         = 1
      ).
      IF sy-subrc <> 0.
        APPEND LINES OF lt_return TO et_return.
        RAISE error.
      ELSE.
        MESSAGE s000 WITH 'Documento sunat' ls_cab-zznrosun 'fue dado de baja' INTO l_message.
        ls_return = sy_to_ret( ).
        APPEND ls_return TO et_return.
      ENDIF.
    ENDLOOP.


  ENDMETHOD.


  METHOD extrae_data_guia_remision.

    DATA: lt_likp     TYPE gtt_likp,
          lt_lips     TYPE gtt_lips,

          lt_cab      TYPE gtt_fegrcab,
          lt_det      TYPE gtt_fegrdet,
          lt_cli      TYPE gtt_fecli,

          lt_cab_json TYPE gtt_fegrcab_json,
          lt_det_json TYPE gtt_fegrdet_json,
          ls_return   TYPE bapiret2.


* Free
    free_data( ).

* Obtener valores constantes y catálogos
    get_constantes( EXPORTING i_vbeln  = i_entrega
                              i_tpproc = gc_prefix_gr
*{+010922-NTP-3000018956
                    EXCEPTIONS error = 1 ).
    IF sy-subrc <> 0.
      APPEND sy_to_ret( ) TO et_return.
      RAISE error.
    ENDIF.
*}+010922-NTP-3000018956

* Obtener data de SAP
    get_data_rem( EXPORTING  i_entrega        = i_entrega
                             is_options       = is_options           "WMR-260517-3000007333
                  IMPORTING  et_likp          = lt_likp
                             et_lips          = lt_lips
                  EXCEPTIONS no_data          = 1
                             no_pila_aceptada = 2 ).

    CASE sy-subrc.
      WHEN 1.
*      APPEND sy_to_ret( ) TO et_return. RAISE error.         "E-NTP-140716
        ls_return = sy_to_ret( ).                               "I-NTP-140716
        APPEND ls_return TO et_return.                          "I-NTP-140716
        RAISE error.                                            "I-NTP-140716
      WHEN 2. EXIT.
    ENDCASE.

* Formar Datos Cabecera
    set_data_rem( EXPORTING it_likp = lt_likp
                            it_lips = lt_lips
                  IMPORTING et_cab  = lt_cab
                            et_det  = lt_det ).

*{+NTP010523-3000020188
    set_homo_json_and_send_ws(
      EXPORTING
        is_options    = is_options
      IMPORTING
        et_return     = et_return
        es_datanojson = es_datanojson
      CHANGING
        lt_cab        = lt_cab
        lt_det        = lt_det
        lt_cli        = lt_cli
      EXCEPTIONS
        error         = 1
    ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.
*}+NTP010523-3000020188
  ENDMETHOD.


  METHOD extrae_data_guia_remision_z.
*{+NTP010423-3000020188
    DATA: lt_likp   TYPE gtt_likp,
          lt_lips   TYPE gtt_lips,

          lt_cab    TYPE gtt_fegrcab,
          lt_det    TYPE gtt_fegrdet,
          lt_cli    TYPE gtt_fecli,

          ls_return TYPE bapiret2,
          l_subrc   TYPE sy-subrc.

    FIELD-SYMBOLS: <fs_cab>  LIKE LINE OF lt_cab,
                   <fs_det>  LIKE LINE OF lt_det,
                   <fs_det2> LIKE LINE OF cs_cab-t_det.

* Free
    free_data( ).

*    g_fecdoc = cs_cab-erdat.
    g_bukrs = cs_cab-bukrs.

* Obtener valores constantes y catálogos
    get_constantes( EXPORTING i_vbeln  = '$'
                              i_tpproc = gc_prefix_gr
                    EXCEPTIONS error = 1 ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.

* Obtener data de SAP
    get_data_rem_z( EXPORTING is_cab     = cs_cab
                              is_options = is_options
                    IMPORTING et_likp    = lt_likp
                              et_lips    = lt_lips
                    EXCEPTIONS OTHERS = 1 ).
    IF sy-subrc <> 0.
      ls_return = sy_to_ret( ).
      APPEND ls_return TO et_return.
      RAISE error.
    ENDIF.

* Formar Datos Cabecera
    set_data_rem( EXPORTING it_likp = lt_likp
                            it_lips = lt_lips
                  IMPORTING et_cab  = lt_cab
                            et_det  = lt_det ).

    "Mover
    LOOP AT lt_cab ASSIGNING <fs_cab>.
      IF <fs_cab>-zzslcnro IS INITIAL.
        <fs_cab>-zzslcnro = <fs_cab>-zzdstnro.
        <fs_cab>-zzslctpd_h = <fs_cab>-zzdsttpd_h.
        <fs_cab>-zzslcden = <fs_cab>-zzdstden.
      ENDIF.
      move_corresponding( EXPORTING is_data = cs_cab CHANGING cs_data = <fs_cab> ).
    ENDLOOP.
    LOOP AT lt_det ASSIGNING <fs_det>.
      READ TABLE cs_cab-t_det ASSIGNING <fs_det2> INDEX sy-tabix.
      move_corresponding( EXPORTING is_data = <fs_det2> CHANGING cs_data = <fs_det> ).
    ENDLOOP.

    set_homo_json_and_send_ws(
      EXPORTING
        is_options    = is_options
      IMPORTING
        et_return     = et_return
        es_datanojson = es_datanojson
      CHANGING
        lt_cab        = lt_cab
        lt_det        = lt_det
        lt_cli        = lt_cli
      EXCEPTIONS
        error         = 1
    ).
    l_subrc = sy-subrc.

    "Sync data z
    LOOP AT lt_cab ASSIGNING <fs_cab>.
      MOVE-CORRESPONDING <fs_cab> TO cs_cab.
    ENDLOOP.
    LOOP AT lt_det ASSIGNING <fs_det>.
      READ TABLE cs_cab-t_det ASSIGNING <fs_det2> INDEX sy-tabix.
      MOVE-CORRESPONDING <fs_det> TO <fs_det2>.
    ENDLOOP.

    IF l_subrc <> 0.
      RAISE error.
    ENDIF.
*}+NTP010423-3000020188
  ENDMETHOD.


  METHOD fegrtxt_get.
    DATA: BEGIN OF ls_key,
            zznrosap TYPE zostb_fegrcab-zznrosap,
            zzgjahr  TYPE zostb_fegrcab-zzgjahr,
            zznrosun TYPE zostb_fegrcab-zznrosun,
          END OF ls_key.

    DATA: lt_txt TYPE TABLE OF zostb_fegrtxt,
          ls_txt LIKE LINE OF lt_txt,
          ls_cab TYPE zostb_fegrcab.

    FIELD-SYMBOLS <fs> TYPE any.

    MOVE-CORRESPONDING cs_cab TO ls_key.

    SELECT * INTO TABLE lt_txt
      FROM zostb_fegrtxt
      WHERE zznrosap  = ls_key-zznrosap
        AND zzgjahr   = ls_key-zzgjahr
        AND zznrosun  = ls_key-zznrosun.

    LOOP AT lt_txt INTO ls_txt WHERE zznrosap = ls_key-zznrosap
                                 AND zzgjahr  = ls_key-zzgjahr
                                 AND zznrosun = ls_key-zznrosun.
      ASSIGN COMPONENT ls_txt-fieldname OF STRUCTURE cs_cab TO <fs>.
      <fs> = ls_txt-text.
    ENDLOOP.
  ENDMETHOD.


  METHOD fegrtxt_set.
    DATA: ls      TYPE zoses_fegrtxt,
          lo_type TYPE REF TO cl_abap_structdescr,
          ls_comp LIKE LINE OF lo_type->components,
          ls_txt  LIKE LINE OF rt_txt.
    FIELD-SYMBOLS <fs> TYPE any.

    lo_type ?= cl_abap_structdescr=>describe_by_data( ls ).
    LOOP AT lo_type->components INTO ls_comp.
      ASSIGN COMPONENT ls_comp-name OF STRUCTURE is_data TO <fs>.
      IF <fs> IS NOT INITIAL.
        MOVE-CORRESPONDING is_data TO ls_txt.
        ls_txt-fieldname = ls_comp-name.
        ls_txt-text = <fs>.
        APPEND ls_txt TO rt_txt.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD free_data.

    REFRESH: gth_vbuk, gth_vttk, gth_t001,
             "gth_tvko                                                              "-010922-NTP-3000018956
             gth_t001z, gth_tvst, gth_kna1, gth_dire,
             gth_vttp,
             gt_vtpa,                                                               "I-WMR-260517-3000007333
             gt_vbpa,                                                               "I-WMR-260517-3000007333
             gth_vbfa,                                                              "I-WMR-280617-3000007333
             gth_asgtnhr,                                                         "I-WMR-121018-3000009765
             gt_tordrf.                                                           "I-PBM081222-3000019824

    CLEAR: g_bukrs, gs_consextsun.
  ENDMETHOD.


  METHOD get_codigo_estab_sunat.

    DATA: select  TYPE TABLE OF edpline,
          sublist TYPE edpline,
          from    TYPE string,
          where   TYPE string,
          where2  TYPE string.

    DATA: lo_error TYPE REF TO cx_root.

    CASE gw_license.
      WHEN '0021061097'. "CMH
        " 1- SELECT
        CLEAR select. sublist = 'ZZ_CODIGO_SUNAT'.
        APPEND sublist TO select.
        " 2.- FROM
        from = 'ZOSFETB_ASGCODES'.
        " 3.- WHERE
        where = 'WERKS EQ I_WERKS'.

      WHEN '0021225088'. "Resemin
        " 1.- SELECT
        CLEAR select. sublist = 'ZZ_CODIGO_SUNAT'.
        APPEND sublist TO select.
        " 2.- FROM
        from = 'ZOSTB_CATALO_CES'.
        " 3.- WHERE
        where  = 'TAXJURCODE EQ GS_CONSEXTSUN-BUKRS AND LGORT EQ LS_LIPS-LGORT'.
        where2 = 'TAXJURCODE EQ GS_CONSEXTSUN-BUKRS AND LGORT EQ SPACE'.
      WHEN OTHERS.
        APPEND 'ZZ_CODIGO_SUNAT' TO select.
        from = 'ZOSTB_CATALO_CES'.
        where = 'TAXJURCODE EQ I_WERKS'.
    ENDCASE.

    IF ( select[] IS NOT INITIAL AND from IS NOT INITIAL AND where IS NOT INITIAL ).
      TRY .
          SELECT SINGLE (select) INTO c_codest
            FROM (from)
            WHERE (where).
        CATCH cx_root INTO lo_error.
      ENDTRY.
      IF c_codest IS INITIAL.
        TRY .
            SELECT SINGLE (select) INTO c_codest
              FROM (from)
              WHERE (where2).
          CATCH cx_root INTO lo_error.
        ENDTRY.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_constantes.

    DATA: lt_const    TYPE TABLE OF zostb_constantes,                        "I-NTP180918-3000010450
          ls_const    LIKE LINE OF lt_const,                                 "I-NTP180918-3000010450
          ls_const_fe LIKE LINE OF gt_const.                              "I-111219-NTP-3000013055
    DATA: l_fkdat TYPE likp-fkdat.

    DATA: ls_cvers TYPE cvers.                                                    "I-WMR-190918-3000009765

*    SELECT SINGLE a~erdat a~fkdat b~bukrs                      "-010922-NTP-3000018956
*      INTO (g_fecdoc, l_fkdat, g_bukrs)                        "-010922-NTP-3000018956
*      FROM likp AS a INNER JOIN tvko AS b ON a~vkorg = b~vkorg "-010922-NTP-3000018956
*{+010922-NTP-3000018956
    SELECT SINGLE a~erdat a~fkdat c~bukrs
      INTO (g_fecdoc, l_fkdat, g_bukrs)
      FROM likp AS a INNER JOIN lips AS b ON b~vbeln = a~vbeln
                     INNER JOIN t001k AS c ON c~bwkey = b~werks
*}+010922-NTP-3000018956
      WHERE a~vbeln = i_vbeln.
    IF sy-subrc = 0 OR g_bukrs IS NOT INITIAL.

      SELECT SINGLE * INTO gs_consextsun FROM zostb_consextsun WHERE bukrs = g_bukrs.

      SELECT * INTO TABLE gth_t001z FROM t001z WHERE bukrs = g_bukrs AND party = gc_party.

      SELECT * INTO TABLE gth_t001  FROM t001 WHERE bukrs = g_bukrs.

      SELECT * INTO TABLE gt_proxy FROM zostb_envwsfe WHERE bukrs = g_bukrs.
    ELSEIF i_vbeln NA '$' AND sy-tcode <> 'VL01N'.
      MESSAGE e000 WITH 'No se pudo determinar Sociedad' 'en la entrega' i_vbeln RAISING error.
    ENDIF.

    SELECT * INTO TABLE gt_vigen  FROM zostb_constvigen.

    SELECT * INTO TABLE gth_cat18 FROM zostb_catalogo18.                          "I-WMR-190918-3000009765
    SELECT * INTO TABLE gth_cat20 FROM zostb_catalogo20.
    SELECT * INTO TABLE gth_cat61 FROM zostb_catalogo61.                          "+NTP010323-3000019645

    SELECT * INTO TABLE gth_hom06 FROM zostb_catahomo06.
    SELECT * INTO TABLE gth_hom18 FROM zostb_catahomo18.
    SELECT * INTO TABLE gth_hom20 FROM zostb_catahomo20.
    SELECT * INTO TABLE gth_asgtnhr FROM zosfetb_asgtnhr.                         "I-WMR-121018-3000009765
    SELECT * INTO TABLE gt_const  FROM zostb_const_fe
      WHERE "aplicacion = gc_aplic                                                "-3000018956-010722-NTP
            programa   = gc_prog.
    SELECT * INTO TABLE lt_catacons FROM zosfetb_catacons.                        "I-PBM210922-3000019902


*{I-NTP290317-3000006749
    " Nro. Instalación Sap
    CALL FUNCTION 'SLIC_GET_LICENCE_NUMBER'
      IMPORTING
        license_number = gw_license.
*}I-NTP290317-3000006749

*{I-NTP180918-3000010450
    DATA: ls_parvw LIKE LINE OF zpiramide-r_parvw_desti,
          ls_lfart LIKE LINE OF zpiramide-r_lfart.

    CASE gw_license.
      WHEN '0020886706'. "Piramide
        SELECT * INTO TABLE lt_const
          FROM zostb_constantes
          WHERE programa = 'ZOSSDSF_GUIA_REMISION'.

        LOOP AT lt_const INTO ls_const.
          CASE ls_const-campo.
            WHEN 'SOLIC'.
              ls_parvw-sign = ls_const-signo.
              ls_parvw-option = ls_const-opcion.
              ls_parvw-low = ls_const-valor1.
              ls_parvw-high = ls_const-valor2.
              APPEND ls_parvw TO zpiramide-r_parvw_soli.
            WHEN 'DEST'.
              ls_parvw-sign = ls_const-signo.
              ls_parvw-option = ls_const-opcion.
              ls_parvw-low = ls_const-valor1.
              ls_parvw-high = ls_const-valor2.
              APPEND ls_parvw TO zpiramide-r_parvw_desti.
            WHEN 'LFART'.
              ls_lfart-sign = ls_const-signo.
              ls_lfart-option = ls_const-opcion.
              ls_lfart-low = ls_const-valor1.
              ls_lfart-high = ls_const-valor2.
              APPEND ls_lfart TO zpiramide-r_lfart.
          ENDCASE.
        ENDLOOP.
      WHEN OTHERS.
    ENDCASE.                                                            "I-PBM130223-3000020723

*{I-111219-NTP-3000013055
    LOOP AT gt_const INTO ls_const_fe.
      CASE ls_const_fe-campo.
        WHEN 'PTOE_LFDNR'. zconst-ptoe_lfdnr = ls_const_fe-valor1.
*{+071122-NTP-3000020296
        WHEN 'ZZFECEMI'. zconst-zzfecemi = ls_const_fe-valor1.
        WHEN 'ZZHOREMI'. zconst-zzhoremi = ls_const_fe-valor1.
        WHEN 'ZZTRAFEC'. zconst-zztrafec = ls_const_fe-valor1.
        WHEN 'ZZDSTNRO'. zconst-zzdstnro = ls_const_fe-valor1.
        WHEN 'PSTYV_ZZITEDES_ADD_TEXT'. APPEND ls_const_fe TO zconst-pstyv_zzitedes_add_text.
        WHEN OTHERS.
*}+071122-NTP-3000020296
      ENDCASE.
    ENDLOOP.
*}I-111219-NTP-3000013055
**    ENDCASE.                                                          "E-PBM130223-3000020723
*}I-NTP180918-3000010450

*{  BEGIN OF INSERT WMR-190918-3000009765
    " N° Instalación Sap
    gs_process-license = gw_license.
    " Verificar sistema S/4 Hana
    SELECT SINGLE component release extrelease comp_type
      INTO CORRESPONDING FIELDS OF ls_cvers
      FROM cvers
      WHERE component = gc_component_s4core.
    IF sy-subrc = 0.
      gs_process-s4core = abap_on.
    ENDIF.
*}  END OF INSERT WMR-190918-3000009765

*{I-3000010993-NTP271218
    SELECT SINGLE * INTO gs_ubl
      FROM zosfetb_ubl
      WHERE tpproc EQ i_tpproc
        AND begda  LE l_fkdat
        AND endda  GE l_fkdat.
*}I-3000010993-NTP271218

  ENDMETHOD.


  METHOD get_data_rem.
    DATA: "Temporal
      lt_likp1       TYPE TABLE OF gty_likp,
*      lt_tvko1       TYPE TABLE OF gty_tvko,                                             "-010922-NTP-3000018956
      lt_vttk1       TYPE TABLE OF gty_vttk,
      lt_kna1        TYPE TABLE OF gty_kna1,
      lt_lfa1        TYPE TABLE OF gty_kna1,                                             "I-WMR-190918-3000009765
      lt_but000      TYPE TABLE OF gty_kna1,                                             "+NTP010323-3000019645
      lt_vttp        TYPE TABLE OF gty_vttp,
      lt_vbpa        TYPE TABLE OF gty_vbpa,                                             "I-WMR-050717-3000007333
      lt_vbfa        TYPE TABLE OF gty_vbfa,                                             "I-WMR-280617-3000007333
      lt_vbfa1       TYPE TABLE OF gty_vbfa,                                             "I-WMR-280617-3000007333
*      lth_fecab      TYPE HASHED TABLE OF zostb_fecab WITH UNIQUE KEY zzt_nrodocsap      "I-WMR-280617-3000007333
*                                                                   zzt_numeracion,    "I-WMR-280617-3000007333
      lth_docexposca TYPE HASHED TABLE OF zostb_docexposca                             "I-WMR-161219-3000013055
                     WITH UNIQUE KEY bukrs zz_nrodocsap zz_numeracion,                 "I-WMR-161219-3000013055
      lth_vbrk       TYPE HASHED TABLE OF gty_vbrk WITH UNIQUE KEY vbeln,                "I-WMR-280617-3000007333
      lth_lotno      TYPE HASHED TABLE OF zostb_lotno WITH UNIQUE KEY lotno,
      lt_lips        TYPE gtt_lips,

      "WA
*    ls_likp        TYPE gty_likp,                                                "-NTP010323-3000019645
      ls_kna1        TYPE gty_kna1,
      ls_t001        TYPE t001,
      ls_tvst        TYPE gty_tvst,
      ls_vbpa        TYPE gty_vbpa,
      ls_t001w       LIKE LINE OF gth_t001w,                                             "I-NTP180918-3000010450
      ls_twlad       LIKE LINE OF gth_twlad,                                             "I-041219-NTP-3000013055
      ls_t001z       LIKE LINE OF gth_t001z,                                             "I-NTP180918-3000010450
      ls_vbak        LIKE LINE OF gth_vbak,                                              "I-NTP180918-3000010450
      ls_lips        LIKE LINE OF et_lips,

      l_ind          TYPE i,
      l_posnr        TYPE likp-vbeln,                                                    "I-WMR-080119-3000011134
      l_from         TYPE string,                                                     "I-WMR-27112020-3000014557
      l_where        TYPE string.                                                     "I-WMR-27112020-3000014557

    DATA: l_tipo   TYPE string,                                                     "I-WMR-190918-3000009765
          l_serie  TYPE string,                                                     "I-WMR-190918-3000009765
          l_sercor TYPE zostb_felog-zzt_numeracion.                                 "I-WMR-190918-3000009765

    DATA: lr_adrnr TYPE RANGE OF lfa1-adrnr,
          ls_adrnr LIKE LINE OF lr_adrnr VALUE 'IEQ'.
    DATA: lt_select TYPE TABLE OF edpline,                                          "I-WMR-051218-3000009770
          ls_select LIKE LINE OF lt_select,                                         "I-WMR-051218-3000009770
          lo_error  TYPE REF TO cx_root.                                            "I-WMR-051218-3000009770

    FIELD-SYMBOLS: <fs_vbfa>   TYPE gty_vbfa,                                         "I-WMR-280617-3000007333
                   <fs_vbrk>   TYPE gty_vbrk,
                   <fs_lips>   LIKE LINE OF et_lips,
                   <fs_likp>   LIKE LINE OF et_likp,                                  "+NTP010323-3000019645
                   <fs_torite> LIKE LINE OF gt_torite.                                "+NTP010323-3000019645

    "Facturas
    IF i_entrega IS NOT INITIAL.

* Entrega

*{  BEGIN OF DELETE WMR-051218-3000009770
*    SELECT vbeln xblnr bzirk vkorg kunnr kunag
*           lfart vstel tddat btgew anzpk gewei
*           ntgew
*           wadat_ist                                                                  "I-WMR-191018-3000009770
*           spe_wauhr_ist                                                              "I-WMR-191018-3000009770
*      INTO CORRESPONDING FIELDS OF TABLE et_likp                                      "I-WMR-191018-3000009770
**      INTO TABLE et_likp                                                              "E-WMR-191018-3000009770
*      FROM likp
*      WHERE vbeln = i_entrega.
*}  END OF DELETE WMR-051218-3000009770

*{  BEGIN OF INSERT WMR-051218-3000009770
      CLEAR ls_select.  ls_select = 'VBELN XBLNR BZIRK VKORG KUNNR KUNAG'.
      APPEND ls_select TO lt_select.
      CLEAR ls_select.  ls_select = 'LFART VSTEL TDDAT BTGEW ANZPK GEWEI'.
      APPEND ls_select TO lt_select.
      CLEAR ls_select.  ls_select = 'NTGEW WADAT_IST WADAT SPE_WAUHR_IST ERDAT'. "+011022-NTP-3000018956 "+081122-NTP-3000020296
      APPEND ls_select TO lt_select.
      CLEAR ls_select.  ls_select = 'VBTYP BOLNR XABLN TRATY TRAID ERNAM'. "+011022-NTP-3000018956
      APPEND ls_select TO lt_select.
      CLEAR ls_select.  ls_select = 'ERZET'. APPEND ls_select TO lt_select.         "I-PBM210922-3000020039
      CLEAR ls_select.  ls_select = 'VSBED'. APPEND ls_select TO lt_select.         "I-PBM081222-3000019824

      CASE gs_process-license.
        WHEN '0020311006'   " AIB
          OR '0020863116'.  " AIB CLOUD
          CLEAR ls_select.  ls_select = 'ZZKVGR2'. APPEND ls_select TO lt_select.
          CLEAR ls_select.  ls_select = 'ZZTOTBLT'. APPEND ls_select TO lt_select.  "I-041219-NTP-3000013055
          CLEAR ls_select.  ls_select = 'ZZTOTBLT_C'. APPEND ls_select TO lt_select.  "I-PBM180520-3000013745
*{+NTP010423-3000020188
          CLEAR ls_select.  ls_select = 'ZZTRSMOD_H'. APPEND ls_select TO lt_select.
          CLEAR ls_select.  ls_select = 'ZZTRSMOT_H'. APPEND ls_select TO lt_select.
          CLEAR ls_select.  ls_select = 'ZZTRSDEN'.   APPEND ls_select TO lt_select.
*}+NTP010423-3000020188
      ENDCASE.

      TRY .
          SELECT (lt_select)
            INTO CORRESPONDING FIELDS OF TABLE et_likp
            FROM likp
            WHERE vbeln = i_entrega.

        CATCH cx_root INTO lo_error.
*          MESSAGE s000 WITH lo_error->get_text( ) RAISING no_data.
      ENDTRY.
*}  END OF INSERT WMR-051218-3000009770

      IF et_likp IS NOT INITIAL.
        IF is_options-noverif_xblnr EQ abap_false.                                        "I-WMR-270517-3000007333
*   Filtro de Pila para no aceptar GR Fisicas
          SELECT * INTO TABLE lth_lotno FROM zostb_lotno.

          LOOP AT et_likp ASSIGNING <fs_likp>.
            l_ind = sy-tabix.
*          READ TABLE lth_lotno WITH TABLE KEY lotno = ls_likp-xblnr+4(4) TRANSPORTING NO FIELDS.  "E-WMR-190918-3000009765
            split_xblnr( EXPORTING i_xblnr = <fs_likp>-xblnr                       "I-WMR-190918-3000009765
                         IMPORTING e_serie = l_serie                               "I-WMR-190918-3000009765
                                   e_tipo  = l_tipo ).                             "+NTP010323-3000019645
            READ TABLE lth_lotno WITH TABLE KEY lotno = l_serie TRANSPORTING NO FIELDS. "I-WMR-190918-3000009765
            IF sy-subrc <> 0.
              DELETE et_likp INDEX l_ind.
              CONTINUE.                                                                 "+NTP010323-3000019645
            ENDIF.

*{+NTP010323-3000019645
            IF l_tipo = gc_guia-transportista.
              <fs_likp>-is_gr_transportista = abap_on.
            ENDIF.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = <fs_likp>-bolnr
              IMPORTING
                output = <fs_likp>-tor_id.

            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = <fs_likp>-vbeln
              IMPORTING
                output = <fs_likp>-btd_id.
*}+NTP010323-3000019645
          ENDLOOP.

          "Sino referencia no esta registrada
          IF et_likp IS INITIAL.
            MESSAGE s000 WITH TEXT-s01 RAISING no_pila_aceptada.
          ENDIF.
        ENDIF.                                                                            "I-WMR-270517-3000007333

* Doc. Comercial Status y Gestion
        lt_likp1[] = et_likp[].
        SORT lt_likp1 BY xblnr.
        DELETE lt_likp1 WHERE xblnr IS INITIAL.
        IF lt_likp1[] IS NOT INITIAL.

          SELECT vbeln wbstk
            INTO TABLE gth_vbuk
            FROM vbuk
            FOR ALL ENTRIES IN lt_likp1
            WHERE vbeln = lt_likp1-vbeln
              AND wbstk = 'C'.
        ENDIF.

        SELECT vbeln posnr lfimg vrkme matnr arktx
               matkl lgort meins werks charg vgbel
               uecha brgew gewei
               ntgew                                                                "I-WMR-021118-3000010833
               vgtyp                                                                "I-WMR-221019-3000013105
               ean11                                                    "INSERT @003
               pstyv                                                    "+081122-NTP-3000020296
               vgpos                                                    "I-PBM160123-3000020028
               kdmat                                                    "I-PBM190423-3000020600
          INTO CORRESPONDING FIELDS OF TABLE et_lips
          FROM lips
           FOR ALL ENTRIES IN et_likp
         WHERE vbeln = et_likp-vbeln.
*           AND lfimg > 0.                                              "-NTP010423-3000020188
        SORT et_lips BY posnr ASCENDING.

*{  BEGIN OF INSERT WMR-050717-3000007333
        " Interlocutores de Entrega
        SELECT vbeln posnr parvw kunnr lifnr pernr adrnr
               xcpdk                                     "+081122-NTP-3000020296
               land1                                     "PBM190423-3000020600
          INTO TABLE gt_vbpa
          FROM vbpa
          FOR ALL ENTRIES IN et_likp
          WHERE vbeln = et_likp-vbeln.

        SORT gt_vbpa BY vbeln ASCENDING parvw ASCENDING.
        DELETE ADJACENT DUPLICATES FROM gt_vbpa COMPARING vbeln parvw.
*}  END OF INSERT WMR-050717-3000007333
*{+081122-NTP-3000020296
        " Interlocutores de Entrega
        SELECT * INTO TABLE gt_vbpa3
          FROM vbpa3
          FOR ALL ENTRIES IN et_likp
          WHERE vbeln = et_likp-vbeln.
*}+081122-NTP-3000020296

* Transporte
        SELECT *
          INTO CORRESPONDING FIELDS OF TABLE lt_vttp
          FROM vttp
          FOR ALL ENTRIES IN et_likp
          WHERE vbeln = et_likp-vbeln.

        SORT lt_vttp BY vbeln.
        DELETE ADJACENT DUPLICATES FROM lt_vttp COMPARING vbeln.
        gth_vttp = lt_vttp.
        IF lt_vttp[] IS NOT INITIAL.
          SELECT *
            INTO CORRESPONDING FIELDS OF TABLE gth_vttk
            FROM vttk
            FOR ALL ENTRIES IN lt_vttp
            WHERE tknum = lt_vttp-tknum.

*{I-PBM120321-3000016404
          "Interlocutores de Transporte
          SELECT vbeln posnr parvw kunnr lifnr pernr adrnr
                 xcpdk                                     "+081122-NTP-3000020296
                 land1                                     "PBM190423-3000020600
            APPENDING CORRESPONDING FIELDS OF TABLE gt_vbpa
            FROM vtpa
            FOR ALL ENTRIES IN gth_vttk
            WHERE vbeln EQ gth_vttk-tknum.

          " Interlocutores de Entrega
          SELECT * APPENDING TABLE gt_vbpa3
            FROM vbpa3
            FOR ALL ENTRIES IN gth_vttk
            WHERE vbeln EQ gth_vttk-tknum.
*}I-PBM120321-3000016404

          SELECT *
            INTO CORRESPONDING FIELDS OF TABLE gth_vtts
            FROM vtts
            FOR ALL ENTRIES IN gth_vttk
            WHERE tknum = gth_vttk-tknum.
        ENDIF.

* Proveedores
        lt_likp1[] = et_likp[].
        SORT lt_likp1 BY kunnr.
        DELETE ADJACENT DUPLICATES FROM lt_likp1 COMPARING kunnr.
        IF lt_likp1[] IS NOT INITIAL.
          SELECT kunnr stcd1 stcdt xcpdk adrnr
                 name1 name2 name3 name4 stkzn
                 stcd2                                                              "+081122-NTP-3000020296
                 werks                                                              "I-PBM061222-3000020028
            INTO TABLE lt_kna1
            FROM kna1
            FOR ALL ENTRIES IN lt_likp1
            WHERE kunnr = lt_likp1-kunnr.
        ENDIF.

        lt_vttk1 = gth_vttk.
        SORT lt_vttk1 BY tdlnr.
        DELETE ADJACENT DUPLICATES FROM lt_vttk1 COMPARING tdlnr.
        IF lt_vttk1[] IS NOT INITIAL.
          SELECT lifnr AS kunnr stcd1 stcdt xcpdk adrnr
                 name1 name2 name3 name4 stkzn
                 stcd2                                                              "+081122-NTP-3000020296
                 werks                                                              "I-PBM061222-3000020028
*          APPENDING TABLE lt_kna1                                                 "E-WMR-190918-3000009765
            APPENDING TABLE lt_lfa1                                                 "I-WMR-190918-3000009765
            FROM lfa1
            FOR ALL ENTRIES IN lt_vttk1
            WHERE lifnr = lt_vttk1-tdlnr.
        ENDIF.

*{  BEGIN OF INSERT WMR-260517-3000007333
        " Interlocutor de Transporte
        lt_vbpa = gt_vbpa. DELETE lt_vbpa WHERE kunnr IS INITIAL.
        SORT lt_vbpa BY kunnr.
        DELETE ADJACENT DUPLICATES FROM lt_vbpa COMPARING kunnr.
        IF lt_vbpa[] IS NOT INITIAL.
          SELECT kunnr stcd1 stcdt xcpdk adrnr
                 name1 name2 name3 name4 stkzn
                 stcd2
                 werks                                                              "I-PBM061222-3000020028
            APPENDING TABLE lt_kna1
            FROM kna1
            FOR ALL ENTRIES IN lt_vbpa
            WHERE kunnr = lt_vbpa-kunnr.
        ENDIF.
        lt_vbpa = gt_vbpa. DELETE lt_vbpa WHERE lifnr IS INITIAL.
        SORT lt_vbpa BY lifnr.
        DELETE ADJACENT DUPLICATES FROM lt_vbpa COMPARING lifnr.
        IF lt_vbpa[] IS NOT INITIAL.
          SELECT lifnr AS kunnr stcd1 stcdt xcpdk adrnr
                 name1 name2 name3 name4 stkzn
                 stcd2
                 werks                                                              "I-PBM061222-3000020028
*          APPENDING TABLE lt_kna1                                                 "E-WMR-190918-3000009765
            APPENDING TABLE lt_lfa1                                                 "I-WMR-190918-3000009765
            FROM lfa1
            FOR ALL ENTRIES IN lt_vbpa
            WHERE lifnr = lt_vbpa-lifnr.
        ENDIF.

        " Interlocutor de transporte - modulo oil
*{+3000018956-010722-NTP
        SELECT * INTO CORRESPONDING FIELDS OF TABLE gt_oigsi
          FROM oigsi
          FOR ALL ENTRIES IN et_likp
          WHERE doc_number = et_likp-vbeln.
        IF sy-subrc = 0.
          SELECT * INTO CORRESPONDING FIELDS OF TABLE gt_oigsv
            FROM oigsv
            FOR ALL ENTRIES IN gt_oigsi
            WHERE shnumber = gt_oigsi-shnumber.
          IF sy-subrc = 0.
            SELECT lifnr AS kunnr stcd1 stcdt xcpdk adrnr
                   name1 name2 name3 name4 stkzn
              APPENDING TABLE lt_lfa1
              FROM lfa1
              FOR ALL ENTRIES IN gt_oigsv
              WHERE lifnr = gt_oigsv-carrier.
          ENDIF.
        ENDIF.
*}+3000018956-010722-NTP

        " Factura
        SELECT vbelv posnv vbeln posnn vbtyp_n
          INTO TABLE lt_vbfa
          FROM vbfa
          FOR ALL ENTRIES IN et_likp
          WHERE vbelv EQ et_likp-vbeln
            AND vbtyp_n EQ 'M'.

        SORT lt_vbfa BY vbelv ASCENDING vbeln ASCENDING.
        DELETE ADJACENT DUPLICATES FROM lt_vbfa COMPARING vbelv vbeln.
        lt_vbfa1[] = lt_vbfa[].
        SORT lt_vbfa1 BY vbeln ASCENDING.
        DELETE ADJACENT DUPLICATES FROM lt_vbfa1 COMPARING vbeln.

        IF lt_vbfa1[] IS NOT INITIAL.
          SELECT vbeln xblnr
                 bukrs                                                              "I-WMR-161219-3000013055
            INTO CORRESPONDING FIELDS OF TABLE lth_vbrk
            FROM vbrk
            FOR ALL ENTRIES IN lt_vbfa1
            WHERE vbeln EQ lt_vbfa1-vbeln
              AND fksto EQ ''
              AND sfakn EQ ''.
          IF lth_vbrk[] IS NOT INITIAL.
            LOOP AT lth_vbrk ASSIGNING <fs_vbrk>.
*            <fs_vbrk>-tipdo = <fs_vbrk>-xblnr(2).                                 "E-WMR-190918-3000009765
*            <fs_vbrk>-numer = <fs_vbrk>-xblnr+4.                                  "E-WMR-190918-3000009765
              split_xblnr( EXPORTING i_xblnr  = <fs_vbrk>-xblnr                     "I-WMR-190918-3000009765
                           IMPORTING e_tipo   = l_tipo                              "I-WMR-190918-3000009765
                                     e_sercor = l_sercor ).                         "I-WMR-190918-3000009765
              <fs_vbrk>-tipdo = l_tipo.                                             "I-WMR-190918-3000009765
              <fs_vbrk>-numer = l_sercor.                                           "I-WMR-190918-3000009765
            ENDLOOP.
*{  BEGIN OF DELETE WMR-161219-3000013055
**          SELECT zzt_nrodocsap zzt_numeracion zzt_tipodoc INTO CORRESPONDING FIELDS OF TABLE lth_fecab
**            FROM zostb_fecab
**            FOR ALL ENTRIES IN lth_vbrk
**            WHERE zzt_nrodocsap  EQ lth_vbrk-vbeln
**              AND zzt_numeracion EQ lth_vbrk-numer
**              AND zzt_tipodoc    EQ lth_vbrk-tipdo.
*}  END OF DELETE WMR-161219-3000013055
*{  BEGIN OF INSERT WMR-161219-3000013055
            SELECT bukrs zz_nrodocsap zz_numeracion zz_tipodoc INTO CORRESPONDING FIELDS OF TABLE lth_docexposca
              FROM zostb_docexposca
             FOR ALL ENTRIES IN lth_vbrk
              WHERE bukrs         = lth_vbrk-bukrs
                AND zz_nrodocsap  = lth_vbrk-vbeln
                AND zz_numeracion = lth_vbrk-numer
                AND zz_tipodoc    = lth_vbrk-tipdo.
*}  END OF INSERT WMR-161219-3000013055
          ENDIF.
        ENDIF.
        FREE lt_vbfa1.
        LOOP AT lt_vbfa ASSIGNING <fs_vbfa>.
          l_ind = sy-tabix.
          READ TABLE lth_vbrk ASSIGNING <fs_vbrk> WITH TABLE KEY vbeln = <fs_vbfa>-vbeln.
          IF sy-subrc EQ 0.
*{  BEGIN OF DELETE WMR-161219-3000013055
**          READ TABLE lth_fecab TRANSPORTING NO FIELDS
**               WITH TABLE KEY zzt_nrodocsap  = <fs_vbrk>-vbeln
**                              zzt_numeracion = <fs_vbrk>-numer.
*}  END OF DELETE WMR-161219-3000013055
*{  BEGIN OF INSERT WMR-161219-3000013055
            READ TABLE lth_docexposca TRANSPORTING NO FIELDS
                 WITH TABLE KEY bukrs         = <fs_vbrk>-bukrs
                                zz_nrodocsap  = <fs_vbrk>-vbeln
                                zz_numeracion = <fs_vbrk>-numer.
*}  END OF INSERT WMR-161219-3000013055
            IF sy-subrc EQ 0.
              <fs_vbfa>-xblnr = <fs_vbrk>-xblnr.
            ELSE.
              DELETE lt_vbfa INDEX l_ind.
            ENDIF.
          ELSE.
            DELETE lt_vbfa INDEX l_ind.
          ENDIF.
        ENDLOOP.
        SORT lt_vbfa BY vbelv ASCENDING vbeln ASCENDING.
        DELETE ADJACENT DUPLICATES FROM lt_vbfa COMPARING vbelv.
        gth_vbfa[] = lt_vbfa[].
        FREE: lt_vbfa, lth_vbrk.", lth_fecab.
*}  END OF INSERT WMR-260517-3000007333

*{I-NTP180918-3000010450
        "Centro
        lt_lips = et_lips.
        SORT lt_lips BY werks.
        DELETE ADJACENT DUPLICATES FROM lt_lips COMPARING werks.
        IF lt_lips IS NOT INITIAL.
          SELECT werks stras adrnr bukrs
            INTO TABLE gth_t001w
            FROM t001w AS a INNER JOIN t001k AS b ON a~werks = b~bwkey
            FOR ALL ENTRIES IN lt_lips
            WHERE werks = lt_lips-werks.
        ENDIF.

*{I-041219-NTP-3000013055
        "Almacen
        lt_lips = et_lips.
        SORT lt_lips BY werks lgort.
        DELETE ADJACENT DUPLICATES FROM lt_lips COMPARING werks lgort.
        IF lt_lips IS NOT INITIAL.
          SELECT * INTO TABLE gth_twlad FROM twlad
            FOR ALL ENTRIES IN lt_lips
            WHERE werks = lt_lips-werks
              AND lgort = lt_lips-lgort
              AND lfdnr = zconst-ptoe_lfdnr.
        ENDIF.
*}I-041219-NTP-3000013055

*{I-PBM190423-3000020600
        "Material
        lt_lips = et_lips.
        SORT lt_lips BY matnr.
        DELETE lt_lips WHERE matnr IS INITIAL.
        DELETE ADJACENT DUPLICATES FROM lt_lips COMPARING matnr.
        IF lt_lips IS NOT INITIAL.
          SELECT matnr normt
          INTO CORRESPONDING FIELDS OF TABLE gth_mara
          FROM mara
          FOR ALL ENTRIES IN lt_lips
           WHERE matnr EQ lt_lips-matnr.
        ENDIF.
        "Material del cliente
        LOOP AT et_lips ASSIGNING <fs_lips> WHERE kdmat IS NOT INITIAL.
          CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
            EXPORTING
              input  = <fs_lips>-kdmat
            IMPORTING
              output = <fs_lips>-kdmat_matnr.
        ENDLOOP.
        lt_lips = et_lips.
        SORT lt_lips BY kdmat_matnr.
        DELETE lt_lips WHERE kdmat_matnr IS INITIAL.
        DELETE ADJACENT DUPLICATES FROM lt_lips COMPARING kdmat_matnr.
        IF lt_lips IS NOT INITIAL.
          SELECT matnr normt
          APPENDING CORRESPONDING FIELDS OF TABLE gth_mara
          FROM mara
          FOR ALL ENTRIES IN lt_lips
           WHERE matnr EQ lt_lips-kdmat_matnr.
        ENDIF.
*}I-PBM190423-3000020600

        "Obtener pedido
        lt_lips = et_lips.
        SORT lt_lips BY vgbel.
        DELETE ADJACENT DUPLICATES FROM lt_lips.
        DELETE lt_lips WHERE vgbel IS INITIAL.
        IF lt_lips IS NOT INITIAL.
          SELECT vbeln vtweg
                 kvgr2                                                              "I-WMR-021018-3000010605
                 augru                                                              "I-PBM060722-3000019552
                 kvgr1                                                              "+081122-NTP-3000020296
            INTO CORRESPONDING FIELDS OF TABLE gth_vbak
            FROM vbak
            FOR ALL ENTRIES IN lt_lips
            WHERE vbeln = lt_lips-vgbel.

*{I-PBM060722-3000019552
          IF gth_vbak[] IS NOT INITIAL.
            "Documento de venta: Motivo de pedido: Textos
            SELECT augru bezei INTO TABLE gt_tvaut
              FROM tvaut
              FOR ALL ENTRIES IN gth_vbak
              WHERE spras EQ sy-langu
                AND augru EQ gth_vbak-augru.
          ENDIF.

          "Documento de ventas: Datos comerciales
          SELECT vbeln posnr bstkd
                 inco1 inco2                                                        "+NTP010323-3000019645
            INTO TABLE gt_vbkd
            FROM vbkd
            FOR ALL ENTRIES IN lt_lips
            WHERE vbeln EQ lt_lips-vgbel.
*}I-PBM060722-3000019552
*{I-PBM160123-3000020028
          SELECT ebeln ebelp txz01 INTO TABLE gt_ekpo
          FROM ekpo
          FOR ALL ENTRIES IN lt_lips
          WHERE ebeln = lt_lips-vgbel.
*}I-PBM160123-3000020028
        ENDIF.

        CASE gw_license.
          WHEN '0020886706'. "Piramide
            READ TABLE et_likp ASSIGNING <fs_likp> INDEX 1.
            READ TABLE et_lips INTO ls_lips INDEX 1.
            READ TABLE gth_t001w INTO ls_t001w WITH TABLE KEY werks = ls_lips-werks.
            IF sy-subrc = 0.                                                        "I-WMR-250918-3000010450
              " Punto Emisión                                                       "I-WMR-250918-3000010450
              ls_adrnr-low = ls_t001w-adrnr. APPEND ls_adrnr TO lr_adrnr.           "I-WMR-250918-3000010450
            ENDIF.                                                                  "I-WMR-250918-3000010450

            IF <fs_likp>-lfart IN zpiramide-r_lfart.

              "Solicitante
              zpiramide-s_soli-kunnr = ls_t001w-werks.
              zpiramide-s_soli-adrnr = ls_t001w-adrnr.
              ls_adrnr-low = zpiramide-s_soli-adrnr. APPEND ls_adrnr TO lr_adrnr.   "I-WMR-051018-3000010624
              zpiramide-s_soli-zzpardir = ls_t001w-stras.
              READ TABLE gth_t001z INTO ls_t001z WITH TABLE KEY bukrs = ls_t001w-bukrs.
              IF sy-subrc = 0.
                zpiramide-s_soli-stcd1 = ls_t001z-paval.
                zpiramide-s_soli-stcdt = '6'.
              ENDIF.

              "Destinatario
              READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = <fs_likp>-kunnr.
              IF sy-subrc = 0.
                MOVE-CORRESPONDING ls_kna1 TO zpiramide-s_desti.
              ENDIF.

            ELSE.

              READ TABLE gth_vbak INTO ls_vbak WITH TABLE KEY vbeln = ls_lips-vgbel.
              IF sy-subrc = 0.

                "Solicitante
                zpiramide-s_soli-zzpardir = ls_t001w-stras.

                SELECT SINGLE c~kunnr c~stcd1 c~stcdt c~xcpdk c~adrnr
                  INTO CORRESPONDING FIELDS OF zpiramide-s_soli
                  FROM vbak AS a INNER JOIN knvp AS b ON a~kunnr = b~kunnr
                                 INNER JOIN kna1 AS c ON c~kunnr = b~kunn2
                  WHERE a~vbeln = ls_vbak-vbeln
                    AND b~parvw IN zpiramide-r_parvw_soli.


                IF zpiramide-s_soli IS NOT INITIAL.
                  MOVE-CORRESPONDING zpiramide-s_soli TO ls_kna1.
                  APPEND ls_kna1 TO lt_kna1.
                  ls_adrnr-low = zpiramide-s_soli-adrnr. APPEND ls_adrnr TO lr_adrnr. "I-WMR-051018-3000010624
                ENDIF.


                "Destinatario
                IF ls_vbak-vtweg <> zpiramide-vtweg_30 AND
                   ls_vbak-vtweg <> space.
                  SELECT SINGLE b~kunnr b~stcd1 b~stcdt b~xcpdk b~adrnr
                    INTO CORRESPONDING FIELDS OF zpiramide-s_desti
                    FROM vbpa AS a INNER JOIN kna1 AS b ON a~kunnr = b~kunnr
                    WHERE a~vbeln EQ ls_vbak-vbeln
                      AND a~parvw EQ zpiramide-parvw_we.
                ELSE.
                  SELECT SINGLE b~kunnr b~stcd1 b~stcdt b~xcpdk b~adrnr
                    INTO CORRESPONDING FIELDS OF zpiramide-s_desti
                    FROM vbpa AS a INNER JOIN kna1 AS b ON a~kunnr = b~kunnr
                    WHERE a~vbeln EQ ls_vbak-vbeln
                      AND a~parvw IN zpiramide-r_parvw_desti.
                ENDIF.

                IF zpiramide-s_desti IS NOT INITIAL.
                  MOVE-CORRESPONDING zpiramide-s_desti TO ls_kna1.
                  APPEND ls_kna1 TO lt_kna1.
                ENDIF.
              ENDIF.
            ENDIF.
        ENDCASE.
*}I-NTP180918-3000010450

*{I-PBM081222-3000019824
* Datos TM
        READ TABLE et_likp ASSIGNING <fs_likp> INDEX 1.
        IF <fs_likp>-is_gr_transportista = abap_on.
          SELECT a~db_key a~parent_key a~btd_tco a~btd_id b~tor_type b~tor_id b~tspid
            INTO CORRESPONDING FIELDS OF TABLE gt_tordrf
            FROM ('/scmtms/d_tordrf AS a INNER JOIN /scmtms/d_torrot AS b ON a~parent_key EQ b~db_key')
           WHERE a~btd_tco    EQ '73'
             AND b~tor_id     EQ <fs_likp>-tor_id
             AND b~tor_cat    EQ 'TO'
             AND b~delete_ind EQ 'X'.
        ELSE.
          SELECT COUNT(*) FROM dd02l WHERE tabname = '/SCMTMS/D_TORDRF'.
          IF sy-subrc = 0.
            SELECT a~db_key a~parent_key a~btd_tco a~btd_id b~tor_type b~tor_id b~tspid
              INTO CORRESPONDING FIELDS OF TABLE gt_tordrf
              FROM ('/scmtms/d_tordrf AS a INNER JOIN /scmtms/d_torrot AS b ON a~parent_key EQ b~db_key')
             WHERE a~btd_tco EQ '73'
               AND a~btd_id  EQ <fs_likp>-btd_id
               AND b~tor_cat EQ 'TO'
               AND b~delete_ind EQ 'X'.
          ENDIF.
        ENDIF.

        IF gt_tordrf IS NOT INITIAL.
          SELECT lifnr AS kunnr stcd1 stcdt xcpdk adrnr
                 name1 name2 name3 name4 stkzn
                 stcd2
                 werks
            APPENDING TABLE lt_lfa1
            FROM lfa1
            FOR ALL ENTRIES IN gt_tordrf
            WHERE lifnr = gt_tordrf-tspid.

          SELECT * INTO CORRESPONDING FIELDS OF TABLE gt_torite
            FROM ('/scmtms/d_torite')
            FOR ALL ENTRIES IN gt_tordrf
            WHERE parent_key EQ gt_tordrf-parent_key.

          LOOP AT gt_torite ASSIGNING <fs_torite>.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = <fs_torite>-base_btd_id
              IMPORTING
                output = <fs_torite>-vbeln.
          ENDLOOP.

          IF gt_torite IS NOT INITIAL.
            SELECT res_type tmsresuuid qualitype qualivalue
              INTO TABLE gt_restmssk
              FROM ('/scmb/restmssk')
              FOR ALL ENTRIES IN gt_torite
              WHERE tmsresuuid EQ gt_torite-res_key.

            SELECT a~db_key a~host_key b~root_key b~text
              INTO CORRESPONDING FIELDS OF TABLE gt_txcroot
              FROM /bobf/d_txcroot AS a INNER JOIN /bobf/d_txccon AS b ON ( b~root_key = a~db_key )
              FOR ALL ENTRIES IN gt_torite
                WHERE a~host_key EQ gt_torite-db_key.

            SELECT * INTO TABLE gt_cab_his
              FROM zostb_fegrcab
              FOR ALL ENTRIES IN gt_torite
              WHERE zznrosap = gt_torite-vbeln.

            SORT gt_cab_his BY zznrosap zznrosun DESCENDING.
            DELETE ADJACENT DUPLICATES FROM gt_cab_his COMPARING zznrosap.
          ENDIF.
        ENDIF.
*}I-PBM081222-3000019824

*{  BEGIN OF INSERT WMR-190918-3000009765
        " Clientes: Tomar N° NIF de Business Partner
        s4_completar_datos_nif( EXPORTING ip_type = 'C'         " Cliente
                                CHANGING  ct_kna1 = lt_kna1 ).
        " Proveedores: Tomar N° NIF de Business Partner
        s4_completar_datos_nif( EXPORTING ip_type = 'P'         " Proveedor
                                CHANGING  ct_kna1 = lt_lfa1 ).

        APPEND LINES OF lt_lfa1 TO lt_kna1.
        FREE lt_lfa1.
*}  END OF INSERT WMR-190918-3000009765

        SORT lt_kna1 BY kunnr.
        DELETE ADJACENT DUPLICATES FROM lt_kna1 COMPARING kunnr.
        gth_kna1 = lt_kna1.

*{-010922-NTP-3000018956
** Org Vtas - Sociedad
*        lt_likp1[] = et_likp[].
*        SORT lt_likp1 BY vkorg.
*        DELETE ADJACENT DUPLICATES FROM lt_likp1 COMPARING vkorg.
*        IF lt_likp1[] IS NOT INITIAL.
*
*          SELECT vkorg bukrs
*            INTO TABLE gth_tvko
*            FROM tvko
*            FOR ALL ENTRIES IN lt_likp1
*            WHERE vkorg = lt_likp1-vkorg.
*
*          lt_tvko1 = gth_tvko.
*          SORT lt_tvko1 BY bukrs.
*          DELETE ADJACENT DUPLICATES FROM lt_tvko1 COMPARING bukrs.
*        ENDIF.
*}-010922-NTP-3000018956

* Pto Expedicion
        lt_likp1[] = et_likp[].
        SORT lt_likp1 BY vstel.
        DELETE ADJACENT DUPLICATES FROM lt_likp1 COMPARING vstel.
        IF lt_likp1[] IS NOT INITIAL.

          SELECT vstel adrnr
            INTO TABLE gth_tvst
            FROM tvst
            FOR ALL ENTRIES IN lt_likp1
            WHERE vstel = lt_likp1-vstel.
        ENDIF.

* Direcciones
        LOOP AT lt_kna1 INTO ls_kna1.
          ls_adrnr-low = ls_kna1-adrnr.
          APPEND ls_adrnr TO lr_adrnr.
        ENDLOOP.
        LOOP AT gth_t001 INTO ls_t001.
          ls_adrnr-low = ls_t001-adrnr.
          APPEND ls_adrnr TO lr_adrnr.
        ENDLOOP.
        LOOP AT gth_tvst INTO ls_tvst.
          ls_adrnr-low = ls_tvst-adrnr.
          APPEND ls_adrnr TO lr_adrnr.
        ENDLOOP.
*{  BEGIN OF INSERT WMR-050717-3000007333
        LOOP AT gt_vbpa INTO ls_vbpa.
          ls_adrnr-low = ls_vbpa-adrnr.
          APPEND ls_adrnr TO lr_adrnr.
        ENDLOOP.
*}  END OF INSERT WMR-050717-3000007333
*{I-041219-NTP-3000013055
        LOOP AT gth_twlad INTO ls_twlad.
          ls_adrnr-low = ls_twlad-adrnr.
          APPEND ls_adrnr TO lr_adrnr.
        ENDLOOP.
*}I-041219-NTP-3000013055

        IF lr_adrnr[] IS NOT INITIAL.
          get_direcciones( EXPORTING ir_adrnr      = lr_adrnr
                           IMPORTING eth_direccion = gth_dire ).
        ENDIF.
      ENDIF.
    ENDIF.

*{  BEGIN OF INSERT WMR-080119-3000011134
    CASE gs_process-license.
      WHEN '0021061097'.  " CMH
        " No considerar material Pallets
        LOOP AT et_lips INTO ls_lips.
          l_ind = sy-tabix.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
            EXPORTING
              input  = ls_lips-posnr
            IMPORTING
              output = l_posnr.
          IF l_posnr+0(1) = '9' AND ( strlen( l_posnr ) > 3 ).
            DELETE et_lips INDEX l_ind. CONTINUE.
          ENDIF.
        ENDLOOP.
    ENDCASE.
*}  END OF INSERT WMR-080119-3000011134

*{  BEGIN OF INSERT WMR-27112020-3000014557
    " Validar TM Activo por entrega
    CLEAR: l_from, l_where.
    l_from = 'TMS_C_SHP'. " TM: Determination of Integration Relevance SHP
    l_where = 'VSTEL = <FS_LIKP>-VSTEL AND LFART = <FS_LIKP>-LFART AND VSBED = <FS_LIKP>-VSBED'.
    LOOP AT et_likp ASSIGNING <fs_likp>.
      l_ind = 0.
      TRY .
          SELECT COUNT( * ) INTO l_ind
            FROM (l_from)
            WHERE (l_where).
          IF l_ind > 0.
            <fs_likp>-tm_active = abap_on.
          ENDIF.
        CATCH cx_root INTO lo_error.
      ENDTRY.
    ENDLOOP.
*}  END OF INSERT WMR-27112020-3000014557

    IF et_likp[] IS INITIAL.
      MESSAGE s000 WITH TEXT-s02 RAISING no_data.
    ENDIF.

    get_data_rem_cust( i_entrega = i_entrega ).

  ENDMETHOD.


  METHOD get_data_rem_cust.
  ENDMETHOD.


  METHOD get_data_rem_oil.
  ENDMETHOD.


  METHOD get_data_rem_z.
*{+NTP010423-3000020188
    DATA: lt_kna1   TYPE TABLE OF gty_kna1,
          lt_lfa1   TYPE TABLE OF gty_kna1,
          lth_lotno TYPE HASHED TABLE OF zostb_lotno WITH UNIQUE KEY lotno,

          "WA
          ls_likp   LIKE LINE OF et_likp,
          ls_lips   LIKE LINE OF et_lips,
          ls_vbpa   LIKE LINE OF gt_vbpa,
          ls_kna1   LIKE LINE OF lt_kna1,
          ls_t001   LIKE LINE OF gth_t001,
          ls_tvst   LIKE LINE OF gth_tvst,
          ls_t001w  LIKE LINE OF gth_t001w,
          ls_twlad  LIKE LINE OF gth_twlad,
          ls_t001z  LIKE LINE OF gth_t001z,
          ls_det    LIKE LINE OF is_cab-t_det,

          "VAR
          l_ind     TYPE i,
          l_tipo    TYPE string,
          l_serie   TYPE string,
          l_sercor  TYPE zostb_felog-zzt_numeracion.

    DATA: lr_adrnr TYPE RANGE OF lfa1-adrnr,
          ls_adrnr LIKE LINE OF lr_adrnr VALUE 'IEQ',
          lr_werks TYPE RANGE OF werks_d,
          ls_werks LIKE LINE OF lr_werks VALUE 'IEQ'.

    FIELD-SYMBOLS: <fs_likp> LIKE LINE OF et_likp,
                   <fs_lfa1> LIKE LINE OF lt_lfa1.


    MOVE-CORRESPONDING is_cab TO ls_likp.
    ls_likp-vbeln = is_cab-zznrosap.

    ls_likp-lfart = abap_on.
    APPEND ls_likp TO et_likp.

    LOOP AT is_cab-t_det INTO ls_det.
      ls_lips-vbeln = is_cab-zznrosap.
      MOVE-CORRESPONDING ls_det TO ls_lips.
      APPEND ls_lips TO et_lips.
    ENDLOOP.

    "Filtro de Pila para no aceptar GR Fisicas
    IF is_options-test IS INITIAL.
      SELECT * INTO TABLE lth_lotno FROM zostb_lotno.

      LOOP AT et_likp ASSIGNING <fs_likp>.
        l_ind = sy-tabix.
        split_xblnr( EXPORTING i_xblnr = <fs_likp>-xblnr
                     IMPORTING e_serie = l_serie
                               e_tipo  = l_tipo ).
        READ TABLE lth_lotno WITH TABLE KEY lotno = l_serie TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          DELETE et_likp INDEX l_ind.
          CONTINUE.
        ENDIF.
      ENDLOOP.
      IF et_likp IS INITIAL.
        MESSAGE e000 WITH TEXT-s01 RAISING no_pila_aceptada.
      ENDIF.
    ENDIF.

    " Interlocutores
    SELECT * INTO CORRESPONDING FIELDS OF TABLE gt_vbpa FROM vbpa WHERE vbeln = is_cab-zznrosap.

    "Destino
    IF is_cab-kunnr IS NOT INITIAL.
      ls_vbpa-vbeln = ls_likp-vbeln.
      ls_vbpa-parvw = gc_parvw_ag.
      ls_vbpa-kunnr = is_cab-kunnr.
      SELECT SINGLE adrnr INTO ls_vbpa-adrnr FROM kna1 WHERE kunnr = is_cab-kunnr.
      APPEND ls_vbpa TO gt_vbpa.
    ENDIF.
    IF is_cab-lifnr IS NOT INITIAL.
      ls_vbpa-vbeln = ls_likp-vbeln.
      ls_vbpa-parvw = gc_parvw_ag.
      ls_vbpa-lifnr = is_cab-lifnr.
      SELECT SINGLE adrnr INTO ls_vbpa-adrnr FROM lfa1 WHERE lifnr = is_cab-lifnr.
      APPEND ls_vbpa TO gt_vbpa.
    ENDIF.

    "Llegada
    IF is_cab-zztralif IS NOT INITIAL.
      ls_vbpa-vbeln = ls_likp-vbeln.
      ls_vbpa-parvw = 'SP'.
      ls_vbpa-lifnr = is_cab-zztralif.
      SELECT SINGLE adrnr INTO ls_vbpa-adrnr FROM lfa1 WHERE lifnr = is_cab-zztralif.
      APPEND ls_vbpa TO gt_vbpa.
    ENDIF.
    IF is_cab-zzllekun IS NOT INITIAL.
      ls_vbpa-vbeln = ls_likp-vbeln.
      ls_vbpa-parvw = 'WE'.
      ls_vbpa-kunnr = is_cab-zzllekun.
      SELECT SINGLE adrnr INTO ls_vbpa-adrnr FROM kna1 WHERE kunnr = is_cab-zzllekun.
      APPEND ls_vbpa TO gt_vbpa.
    ENDIF.
    IF is_cab-zzllelif IS NOT INITIAL.
      ls_vbpa-vbeln = ls_likp-vbeln.
      ls_vbpa-parvw = 'WE'.
      ls_vbpa-lifnr = is_cab-zzllelif.
      SELECT SINGLE adrnr INTO ls_vbpa-adrnr FROM lfa1 WHERE lifnr = is_cab-zzllelif.
      APPEND ls_vbpa TO gt_vbpa.
    ENDIF.

    "Proveedores
    SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_kna1 FROM kna1 WHERE kunnr = is_cab-kunnr.
    SELECT * APPENDING CORRESPONDING FIELDS OF TABLE lt_kna1 FROM kna1 WHERE kunnr = is_cab-zzllekun.

    SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_lfa1 FROM lfa1 WHERE lifnr = is_cab-lifnr.
    SELECT * APPENDING CORRESPONDING FIELDS OF TABLE lt_lfa1 FROM lfa1 WHERE lifnr = is_cab-zzparlif.
    SELECT * APPENDING CORRESPONDING FIELDS OF TABLE lt_lfa1 FROM lfa1 WHERE lifnr = is_cab-zztralif.
    SELECT * APPENDING CORRESPONDING FIELDS OF TABLE lt_lfa1 FROM lfa1 WHERE lifnr = is_cab-zzllelif.

    "Partida
    IF is_cab-vstel IS NOT INITIAL.
      ls_werks-low = is_cab-vstel.
      COLLECT ls_werks INTO lr_werks.
    ENDIF.
    IF is_cab-zzparwer IS NOT INITIAL.
      ls_werks-low = is_cab-zzparwer.
      COLLECT ls_werks INTO lr_werks.
    ENDIF.
    IF is_cab-zzdstwer IS NOT INITIAL.
      ls_werks-low = is_cab-zzdstwer.
      COLLECT ls_werks INTO lr_werks.
    ENDIF.
    IF lr_werks IS NOT INITIAL.
      SELECT * INTO CORRESPONDING FIELDS OF TABLE gth_t001w FROM t001w WHERE werks IN lr_werks.
      SELECT * INTO TABLE gth_twlad FROM twlad WHERE werks IN lr_werks AND lfdnr = 01.
    ENDIF.

    " Clientes: Tomar N° NIF de Business Partner
    s4_completar_datos_nif( EXPORTING ip_type = 'C'         " Cliente
                            CHANGING  ct_kna1 = lt_kna1 ).
    " Proveedores: Tomar N° NIF de Business Partner
    LOOP AT lt_lfa1 ASSIGNING <fs_lfa1>.
      <fs_lfa1>-kunnr = <fs_lfa1>-lifnr.
    ENDLOOP.
    s4_completar_datos_nif( EXPORTING ip_type = 'P'         " Proveedor
                            CHANGING  ct_kna1 = lt_lfa1 ).

    APPEND LINES OF lt_lfa1 TO lt_kna1.
    FREE lt_lfa1.

    SORT lt_kna1 BY kunnr.
    DELETE ADJACENT DUPLICATES FROM lt_kna1 COMPARING kunnr.
    gth_kna1 = lt_kna1.

    "Pto Expedicion
    SELECT * INTO CORRESPONDING FIELDS OF TABLE gth_tvst FROM tvst WHERE vstel = is_cab-vstel.

    "Direcciones
    LOOP AT lt_kna1 INTO ls_kna1.
      ls_adrnr-low = ls_kna1-adrnr.
      APPEND ls_adrnr TO lr_adrnr.
    ENDLOOP.
    LOOP AT gth_t001 INTO ls_t001.
      ls_adrnr-low = ls_t001-adrnr.
      APPEND ls_adrnr TO lr_adrnr.
    ENDLOOP.
    LOOP AT gth_tvst INTO ls_tvst.
      ls_adrnr-low = ls_tvst-adrnr.
      APPEND ls_adrnr TO lr_adrnr.
    ENDLOOP.
    LOOP AT gt_vbpa INTO ls_vbpa.
      ls_adrnr-low = ls_vbpa-adrnr.
      APPEND ls_adrnr TO lr_adrnr.
    ENDLOOP.
    LOOP AT gth_t001w INTO ls_t001w.
      ls_adrnr-low = ls_t001w-adrnr.
      APPEND ls_adrnr TO lr_adrnr.
    ENDLOOP.
    LOOP AT gth_twlad INTO ls_twlad.
      ls_adrnr-low = ls_twlad-adrnr.
      APPEND ls_adrnr TO lr_adrnr.
    ENDLOOP.

    IF lr_adrnr[] IS NOT INITIAL.
      get_direcciones( EXPORTING ir_adrnr      = lr_adrnr
                       IMPORTING eth_direccion = gth_dire ).
    ENDIF.
*}+NTP010423-3000020188
  ENDMETHOD.


  METHOD get_data_tm_delivery.

    DATA: ls_lips    LIKE LINE OF it_lips,

          l_type_out TYPE string VALUE 'ZOSES_DATOS_GUIA',
          l_type_obj TYPE string VALUE 'ZOSTM_UTILITIES',
          l_method   TYPE string VALUE 'GET_DATA_GUIA_REMISION',

          lo_data    TYPE REF TO data,
          lo_object  TYPE REF TO object,
          lo_error   TYPE REF TO cx_root.

    FIELD-SYMBOLS: <fs_data>    TYPE any,
                   <fs_value>   TYPE any,
                   <fs_asgtnhr> LIKE LINE OF gth_asgtnhr.

    CASE gs_process-license.
      WHEN '0021154274'.  " ILENDER

        TRY .
*        READ TABLE it_lips INTO ls_lips WITH KEY vbeln = is_likp-vbeln.
*        CHECK ls_lips-vgbel IS NOT INITIAL.

            " 1.- Instanciar Clase
            CREATE OBJECT lo_object TYPE (l_type_obj).
            " 2.- Crear estructura de respuesta
            CREATE DATA lo_data TYPE (l_type_out).  ASSIGN lo_data->* TO <fs_data>.
            " 3.- Invocar método
            CALL METHOD lo_object->(l_method)
              EXPORTING
*               i_vbeln      = ls_lips-vgbel
                i_entrega    = is_likp-vbeln
              IMPORTING
                e_datos_guia = <fs_data>.

            IF <fs_data> IS INITIAL.
              RAISE no_found.
            ENDIF.
            " 4.- Pasar datos
*        MOVE-CORRESPONDING <fs_data> TO es_data.

            "Indicador de transbordo programado
            cs_cab_gre-zzindtnb = abap_off.
            "Fecha de inicio de traslado
            UNASSIGN <fs_value>.  ASSIGN COMPONENT 'FEC_INICIO_TRAS' OF STRUCTURE <fs_data> TO <fs_value>.
            IF <fs_value> IS ASSIGNED.
              cs_cab_gre-zztrafec = <fs_value>.
            ENDIF.
            "Hora inicio de traslado
            UNASSIGN <fs_value>.  ASSIGN COMPONENT 'HORA_INICIO_TRAS' OF STRUCTURE <fs_data> TO <fs_value>.
            IF <fs_value> IS ASSIGNED.
              cs_cab_gre-zztrahor = <fs_value>.
            ENDIF.
            "Modalidad de traslado
            UNASSIGN <fs_value>.  ASSIGN COMPONENT 'MODALIDAD_TRAS' OF STRUCTURE <fs_data> TO <fs_value>.
            IF <fs_value> IS ASSIGNED.
              cs_cab_gre-zztrsmod_h = <fs_value>.
            ENDIF.

**        CASE cs_cab_gre-zztrsmod_h.
**          WHEN gc_modtras_publico.
            "Número de RUC transportista
            UNASSIGN <fs_value>.  ASSIGN COMPONENT 'DOC_TRANSP' OF STRUCTURE <fs_data> TO <fs_value>.
            IF <fs_value> IS ASSIGNED.
              cs_cab_gre-zztranro = <fs_value>.
            ENDIF.
            UNASSIGN <fs_value>.  ASSIGN COMPONENT 'ID_TIPO_DOC_TRANSP' OF STRUCTURE <fs_data> TO <fs_value>.
            IF <fs_value> IS ASSIGNED.
              READ TABLE gth_asgtnhr ASSIGNING <fs_asgtnhr> WITH TABLE KEY taxtype = <fs_value>.
              IF sy-subrc = 0.
                cs_cab_gre-zztratpd_h = <fs_asgtnhr>-stcdt.
              ENDIF.
            ENDIF.
            "Apellidos y nombres o denominación o razón social del transportista
            UNASSIGN <fs_value>.  ASSIGN COMPONENT 'NOMBRE_TRANSP' OF STRUCTURE <fs_data> TO <fs_value>.
            IF <fs_value> IS ASSIGNED.
              cs_cab_gre-zztraden = <fs_value>.
            ENDIF.
            "N° Contancia Inscripción
            UNASSIGN <fs_value>.  ASSIGN COMPONENT 'CERT_INSCRIPCION' OF STRUCTURE <fs_data> TO <fs_value>.
            IF <fs_value> IS ASSIGNED.
              cs_cab_gre-zztranci = <fs_value>.
            ENDIF.
            "Marca
            UNASSIGN <fs_value>.  ASSIGN COMPONENT 'MARCA' OF STRUCTURE <fs_data> TO <fs_value>.
            IF <fs_value> IS ASSIGNED.
              cs_cab_gre-zztramar = <fs_value>.
            ENDIF.
            "Número de placa del vehículo
            UNASSIGN <fs_value>.  ASSIGN COMPONENT 'PLACA' OF STRUCTURE <fs_data> TO <fs_value>.
            IF <fs_value> IS ASSIGNED.
              cs_cab_gre-zzplaveh = <fs_value>.
            ENDIF.
            "Chofer
            UNASSIGN <fs_value>.  ASSIGN COMPONENT 'NOMBRE_CONDUCTOR' OF STRUCTURE <fs_data> TO <fs_value>.
            IF <fs_value> IS ASSIGNED.
              cs_cab_gre-zzconden = <fs_value>.
            ENDIF.
            "N° Brevete
            UNASSIGN <fs_value>.  ASSIGN COMPONENT 'LICENCIA' OF STRUCTURE <fs_data> TO <fs_value>.
            IF <fs_value> IS ASSIGNED.
              cs_cab_gre-zztrabvt = <fs_value>.
            ENDIF.

**          WHEN gc_modtras_privado.
**            "Número de placa del vehículo
**            UNASSIGN <fs_value>.  ASSIGN COMPONENT 'PLACA' OF STRUCTURE <fs_data> TO <fs_value>.
**            IF <fs_value> IS ASSIGNED.
**              cs_cab_gre-zzplaveh = <fs_value>.
**            ENDIF.
            "CONDUCTOR (Transporte privado)
            "Número de documento de identidad del conductor
            UNASSIGN <fs_value>.  ASSIGN COMPONENT 'DOC_CONDUCTOR' OF STRUCTURE <fs_data> TO <fs_value>.
            IF <fs_value> IS ASSIGNED.
              cs_cab_gre-zzconnro = <fs_value>.
            ENDIF.
            UNASSIGN <fs_value>.  ASSIGN COMPONENT 'ID_TIPO_DOC_CONDUCTOR' OF STRUCTURE <fs_data> TO <fs_value>.
            IF <fs_value> IS ASSIGNED.
              READ TABLE gth_asgtnhr ASSIGNING <fs_asgtnhr> WITH TABLE KEY taxtype = <fs_value>.
              IF sy-subrc = 0.
                cs_cab_gre-zzcontpd_h = <fs_asgtnhr>-stcdt.
              ENDIF.
            ENDIF.

            "Vehiculo
            UNASSIGN <fs_value>.  ASSIGN COMPONENT 'VEHICULO' OF STRUCTURE <fs_data> TO <fs_value>.
            IF <fs_value> IS ASSIGNED.
              cs_cab_gre-zztrancv = <fs_value>.
            ENDIF.
**        ENDCASE.

          CATCH cx_root INTO lo_error.

        ENDTRY.

    ENDCASE.


  ENDMETHOD.


  METHOD get_direcciones.

    TYPES: BEGIN OF ty_adrc,
             adrnr        TYPE  adrc-addrnumber,   "Nro
             country      TYPE  adrc-country,      "Pais
             region       TYPE  adrc-region,       "Departamento
             street       TYPE  adrc-street,       "Dirección
             house_num1   TYPE  adrc-house_num1,   "Dirección
             str_suppl1   TYPE  adrc-str_suppl1,   "Dirección "Urbanización
             str_suppl2   TYPE  adrc-str_suppl2,   "Dirección
             str_suppl3   TYPE  adrc-str_suppl3,   "Dirección
             city1        TYPE  adrc-city1,        "Provincia
             city2        TYPE  adrc-city2,        "Distrito
             location     TYPE  adrc-location,
             cityp_code   TYPE  adrc-cityp_code,   "Ubigeo
             name1        TYPE  adrc-name1,
             name2        TYPE  adrc-name2,
             name3        TYPE  adrc-name3,
             name4        TYPE  adrc-name4,
             tel_number   TYPE  ad_tlnmbr1,
             fax_number   TYPE  ad_fxnmbr1,
*{  BEGIN OF INSERT WMR-010716
             city_code    TYPE  adrc-city_code,   " Codificación de Provincia
*}  END OF INSERT WMR-010716
             langu        TYPE  adrc-langu, "Idioma                                   "I-WMR-050717-3000007333
             regiogroup   TYPE adrc-regiogroup,                                     "+081122-NTP-3000020296
             po_box       TYPE adrc-po_box,                                         "+081122-NTP-3000020296
             po_box_lobby TYPE adrc-po_box_lobby,                                   "+081122-NTP-3000020296
             post_code1   TYPE adrc-post_code1,                                     "+011222-NTP-3000019824
           END OF ty_adrc,

           BEGIN OF ty_t005u,
             land1 TYPE  t005u-land1,      " Clave de país
             bland TYPE  t005u-bland,      " Departamento
             bezei TYPE  t005u-bezei,      " Denominación
           END OF ty_t005u,

           BEGIN OF ty_adr6,
             adrnr     TYPE adrnr,
             persnum   TYPE adr6-persnumber,
             datefrom  TYPE adr6-date_from,
             consnumb  TYPE adr6-consnumber,
             smtp_addr TYPE adr6-smtp_addr,
           END OF ty_adr6 .

    DATA: lt_adrc      TYPE TABLE OF ty_adrc,
          lt_adrct     TYPE TABLE OF adrct,                                         "+NTP280223_3000020702
          lt_adrc1     TYPE TABLE OF ty_adrc,
          lt_t005u     TYPE HASHED TABLE OF ty_t005u WITH UNIQUE KEY land1 bland,
          lt_adr6      TYPE TABLE OF ty_adr6,
          lt_direccion TYPE TABLE OF gty_direccion,
*{  BEGIN OF INSERT WMR-010716
          lr_city_code TYPE RANGE OF adrcityt-city_code,
          lt_split     TYPE TABLE OF string,
*}  END OF INSERT WMR-010716

          "WA
          ls_adrc      TYPE ty_adrc,
          ls_adrct     LIKE LINE OF lt_adrct,                                       "+NTP280223_3000020702
          ls_t005u     TYPE ty_t005u,
          ls_adr6      TYPE ty_adr6,
          ls_direccion TYPE gty_direccion,
*{  BEGIN OF INSERT WMR-010716
          ls_city_code LIKE LINE OF lr_city_code,
          ls_split     LIKE LINE OF lt_split,
*}  END OF INSERT WMR-010716

          l_ubigeo     TYPE c LENGTH 6.                                             "I-WMR-280817-3000007333

    CHECK ir_adrnr[] IS NOT INITIAL.

    SELECT addrnumber country region street house_num1
           str_suppl1 str_suppl2 str_suppl3
           city1 city2 location cityp_code
           name1 name2 name3 name4 tel_number fax_number
*{  BEGIN OF INSERT WMR-010716
           city_code
*}  END OF INSERT WMR-010716
           langu                                                                    "I-WMR-050717-3000007333
           regiogroup po_box_lobby po_box                                           "+081122-NTP-3000020296
           post_code1                                                               "+011222-NTP-3000019824
      FROM adrc
      INTO TABLE lt_adrc
        WHERE addrnumber IN ir_adrnr
          AND date_from  EQ gc_00010101
          AND nation     IS NOT NULL.

*{+NTP280223_3000020702
    SELECT * FROM adrct INTO TABLE lt_adrct
      WHERE addrnumber IN ir_adrnr
        AND date_from  EQ gc_00010101
        AND nation     IS NOT NULL.

    DELETE lt_adrct WHERE remark IS INITIAL.
    SORT lt_adrct BY addrnumber langu.
*}+NTP280223_3000020702

    IF lt_adrc[] IS NOT INITIAL.
      SORT lt_adrc BY adrnr ASCENDING.

      lt_adrc1[] = lt_adrc[].
      SORT lt_adrc1 BY country ASCENDING region ASCENDING.
      DELETE ADJACENT DUPLICATES FROM lt_adrc1 COMPARING country region.
      IF lt_adrc1[] IS NOT INITIAL.
        SELECT land1 bland bezei
          INTO TABLE lt_t005u
          FROM t005u
          FOR ALL ENTRIES IN lt_adrc1
          WHERE spras EQ sy-langu
            AND land1 EQ lt_adrc1-country
            AND bland EQ lt_adrc1-region.
      ENDIF.

      SELECT addrnumber persnumber date_from consnumber smtp_addr
        INTO TABLE lt_adr6
        FROM adr6
        FOR ALL ENTRIES IN lt_adrc
        WHERE addrnumber EQ lt_adrc-adrnr
*{  BEGIN OF INSERT WMR-090816-3000005457
          AND flgdefault EQ abap_true.
*}  END OF INSERT WMR-090816-3000005457
      SORT lt_adr6 BY adrnr.

      LOOP AT lt_adrc INTO ls_adrc.
*{  BEGIN OF INSERT WMR-010716
        CLEAR: lr_city_code, lt_split.
*}  END OF INSERT WMR-010716
        MOVE-CORRESPONDING ls_adrc TO ls_direccion. "+081122-NTP-3000020296

        ls_direccion-adrnr  = ls_adrc-adrnr.

        " Nombre
        CASE gw_license.
          WHEN '0020886706'.  "PIRAMIDE
            ls_direccion-name  = ls_adrc-name1.
          WHEN OTHERS.
            CONCATENATE ls_adrc-name1 ls_adrc-name2 ls_adrc-name3 ls_adrc-name4 INTO ls_direccion-name SEPARATED BY space.
        ENDCASE.
        " Nombre 1
        ls_direccion-name1  = ls_adrc-name1.
        " Nombre 2
        ls_direccion-name2  = ls_adrc-name2.
        " Nombre 3
        ls_direccion-name3  = ls_adrc-name3.
        " Nombre 4
        ls_direccion-name4  = ls_adrc-name4.
        " Teléfono
        ls_direccion-tel_number = ls_adrc-tel_number.
        " Fax
*        ls_direccion-fax_number = ls_adrc-fax_number.
        " Nombre de Avenida/ Calle/ Jirón
        ls_direccion-street = ls_adrc-street.
        " Número
        ls_direccion-stnumb = ls_adrc-house_num1.
        " Urbanización
        ls_direccion-str_suppl1 = ls_adrc-str_suppl1.
        ls_direccion-str_suppl2 = ls_adrc-str_suppl2.
        ls_direccion-str_suppl3 = ls_adrc-str_suppl3.
        " País
        TRANSLATE ls_adrc-country TO UPPER CASE.                                    "+NTP02022023-3000019902
        ls_direccion-pais   = ls_adrc-country.

        " Departamento
        READ TABLE lt_t005u INTO ls_t005u
                   WITH TABLE KEY land1 = ls_adrc-country
                                  bland = ls_adrc-region.
        IF sy-subrc EQ 0.
*          ls_direccion-depart = ls_t005u-bezei.
          TRANSLATE ls_t005u-bezei TO UPPER CASE.                                   "+NTP02022023-3000019902
          ls_direccion-depmto = ls_t005u-bezei.                                     "I-WMR-070318-3000008769
        ENDIF.
        " Provincia
        TRANSLATE ls_adrc-city1 TO UPPER CASE.                                      "+081122-NTP-3000020296
        ls_direccion-provin = ls_adrc-city1.
        " Distrito
        TRANSLATE ls_adrc-city2 TO UPPER CASE.                                      "+081122-NTP-3000020296
        ls_direccion-distri = ls_adrc-city2.
        " Ubigeo
*        ls_direccion-ubigeo = ls_adrc-post_code1.                                   "+011222-NTP-3000019824
        IF ls_direccion-ubigeo IS INITIAL.                                          "+011222-NTP-3000019824
*{+081122-NTP-3000020296
          CASE gw_license.
            WHEN '0020767991'. "Inka
              DATA: BEGIN OF ls_ubigeo,
                      ccdd TYPE string,
                      ccpv TYPE string,
                      ccdi TYPE string,
                    END OF ls_ubigeo.

              SELECT SINGLE ('ccdd ccpv ccdi')
                INTO ls_ubigeo
                FROM ('zubigeos')
                WHERE ('departamento EQ ls_t005u-bezei AND provincia EQ ls_adrc-city1 AND distrito EQ ls_adrc-city2').
              IF sy-subrc = 0.
                CONCATENATE ls_ubigeo-ccdd ls_ubigeo-ccpv ls_ubigeo-ccdi INTO ls_direccion-ubigeo.
              ENDIF.

            WHEN OTHERS.
*}+081122-NTP-3000020296
*{  BEGIN OF INSERT WMR-010716
              IF ls_adrc-cityp_code IS INITIAL.
                IF ls_adrc-city_code IS INITIAL.
                  CASE gw_license.
                    WHEN '0020241712' OR  "Aib
                         '0020673876' OR  "Beta
                         '0020974592'.    "Danper
                      SPLIT ls_adrc-city1 AT ' - ' INTO TABLE lt_split.
                      IF lines( lt_split ) EQ 3.
                        " Leer Departamento
                        READ TABLE lt_split INTO ls_split INDEX 2.
                        IF sy-subrc EQ 0.
                          TRANSLATE ls_split TO UPPER CASE.
                          SELECT city_code AS low
                            INTO CORRESPONDING FIELDS OF TABLE lr_city_code
                            FROM adrcityt
                            WHERE langu     EQ sy-langu
                              AND country   EQ ls_adrc-country
                              AND city_name EQ ls_split.
                          IF lr_city_code[] IS NOT INITIAL.
                            LOOP AT lt_split INTO ls_split.
                              TRANSLATE ls_split TO UPPER CASE.
                              CASE sy-tabix.
                                WHEN 2.
                                  " Provincia
                                  ls_direccion-provin = ls_adrc-city1 = ls_split.
                                WHEN 3.
                                  " Distrito
                                  ls_direccion-distri = ls_adrc-city2 = ls_split.
                              ENDCASE.
                            ENDLOOP.
                          ENDIF.
                        ENDIF.
                      ELSE.

                        " Obtener Códigos de Provincia
                        TRANSLATE ls_adrc-city1 TO UPPER CASE.
                        SELECT city_code AS low
                          INTO CORRESPONDING FIELDS OF TABLE lr_city_code
                          FROM adrcityt
                          WHERE langu     EQ sy-langu
                            AND country   EQ ls_adrc-country
                            AND city_name EQ ls_adrc-city1.
                      ENDIF.

                    WHEN OTHERS.
                      " Obtener Códigos de Provincia
                      TRANSLATE ls_adrc-city1 TO UPPER CASE.
                      SELECT city_code AS low
                        INTO CORRESPONDING FIELDS OF TABLE lr_city_code
                        FROM adrcityt
                        WHERE langu     EQ sy-langu
                          AND country   EQ ls_adrc-country
                          AND city_name EQ ls_adrc-city1.
                  ENDCASE.

                  LOOP AT lr_city_code INTO ls_city_code.
                    ls_city_code-sign = 'I'. ls_city_code-option = 'EQ'.
                    MODIFY lr_city_code FROM ls_city_code INDEX sy-tabix.
                  ENDLOOP.
                ELSE.
                  CONCATENATE 'IEQ' ls_adrc-city_code INTO ls_city_code.
                  APPEND ls_city_code TO lr_city_code.
                ENDIF.
                IF lr_city_code[] IS NOT INITIAL.
                  " Buscar en código postales de Distritos
                  TRANSLATE ls_adrc-city2 TO UPPER CASE.
                  SELECT SINGLE cityp_code
                    INTO ls_adrc-cityp_code
                    FROM adrcityprt
                    WHERE country   EQ ls_adrc-country
                      AND city_code IN lr_city_code
                      AND city_part EQ ls_adrc-city2.
                ENDIF.
              ENDIF.
*}  END OF INSERT WMR-010716
              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                EXPORTING
                  input  = ls_adrc-cityp_code
                IMPORTING
                  output = ls_adrc-cityp_code.
*{  BEGIN OF REPLACE WMR-280817-3000007333
              ""        ls_direccion-ubigeo = ls_adrc-cityp_code.
              CLEAR l_ubigeo.
              IF ls_adrc-cityp_code IS NOT INITIAL.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = ls_adrc-cityp_code
                  IMPORTING
                    output = l_ubigeo.
                ls_direccion-ubigeo = l_ubigeo.
              ENDIF.
*}  END OF REPLACE WMR-280817-3000007333
          ENDCASE.
        ENDIF.

        " Correo
        LOOP AT lt_adr6 INTO ls_adr6 WHERE adrnr = ls_adrc-adrnr.
          IF ls_direccion-smtp_addr IS INITIAL.
            ls_direccion-smtp_addr = ls_adr6-smtp_addr.
          ELSE.
            CONCATENATE ls_direccion-smtp_addr ls_adr6-smtp_addr INTO ls_direccion-smtp_addr SEPARATED BY ';'.
          ENDIF.
        ENDLOOP.

        " Idioma                                                                    "I-WMR-050717-3000007333
        ls_direccion-langu = ls_adrc-langu.                                         "I-WMR-050717-3000007333

*{+NTP280223_3000020702
        " Comentarios
        READ TABLE lt_adrct INTO ls_adrct WITH KEY addrnumber = ls_adrc-adrnr langu = ls_adrc-langu BINARY SEARCH.
        IF sy-subrc <> 0.
          READ TABLE lt_adrct INTO ls_adrct WITH KEY addrnumber = ls_adrc-adrnr BINARY SEARCH.
        ENDIF.
        IF sy-subrc = 0.
          ls_direccion-remark = ls_adrct-remark.
        ENDIF.
*}+NTP280223_3000020702

*{I-111219-NTP-3000013055
        ls_direccion-direccion = ls_direccion-street.
        IF ls_direccion-stnumb IS NOT INITIAL.
          CONCATENATE ls_direccion-direccion ls_direccion-stnumb INTO ls_direccion-direccion SEPARATED BY space.
        ENDIF.
        IF ls_direccion-str_suppl1 IS NOT INITIAL.
          CONCATENATE ls_direccion-direccion ls_direccion-str_suppl1 INTO ls_direccion-direccion SEPARATED BY space.
        ENDIF.
        IF ls_direccion-str_suppl2 IS NOT INITIAL.
          CONCATENATE ls_direccion-direccion ls_direccion-str_suppl2 INTO ls_direccion-direccion SEPARATED BY space.
        ENDIF.
        IF ls_direccion-str_suppl3 IS NOT INITIAL.
          CONCATENATE ls_direccion-direccion ls_direccion-str_suppl3 INTO ls_direccion-direccion SEPARATED BY space.
        ENDIF.
        IF ls_direccion-depmto IS NOT INITIAL.
          CONCATENATE ls_direccion-direccion ls_direccion-depmto INTO ls_direccion-direccion SEPARATED BY space.
        ENDIF.
        IF ls_direccion-provin IS NOT INITIAL.
          CONCATENATE ls_direccion-direccion ls_direccion-provin INTO ls_direccion-direccion SEPARATED BY space.
        ENDIF.
        IF ls_direccion-distri IS NOT INITIAL.
          CONCATENATE ls_direccion-direccion ls_direccion-distri INTO ls_direccion-direccion SEPARATED BY space.
        ENDIF.
*}I-111219-NTP-3000013055
*{+010922-NTP-3000018956
        CONCATENATE ls_direccion-str_suppl1
                    ls_direccion-str_suppl2
                    ls_direccion-str_suppl3
                    INTO ls_direccion-urbanizacion SEPARATED BY space.
*}+010922-NTP-3000018956

        APPEND ls_direccion TO lt_direccion.
        CLEAR ls_direccion.
      ENDLOOP.

      eth_direccion = lt_direccion.
    ENDIF.

  ENDMETHOD.


  METHOD get_format_text_type_paragraph.

    DATA: lt_text   TYPE TABLE OF tline,
          lt_stream TYPE TABLE OF tdline,
          lt_lines  TYPE TABLE OF tline,
          ls_stream LIKE LINE OF lt_stream,
          ls_lines  TYPE  tline.

    FIELD-SYMBOLS <fs_text> LIKE LINE OF lt_text.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = is_thead-tdid
        language                = is_thead-tdspras
        name                    = is_thead-tdname
        object                  = is_thead-tdobject
      TABLES
        lines                   = lt_text
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc EQ 0.
      " Convertir texto con caracteres especiales a texto original
      LOOP AT lt_text ASSIGNING <fs_text>.
        REPLACE ALL OCCURRENCES OF ',,' IN <fs_text>-tdline WITH '~'.  " Separador de Tab
        CLEAR: lt_lines, ls_lines, lt_stream.
        ls_lines = <fs_text>.
        APPEND ls_lines TO lt_lines.
        CALL FUNCTION 'CONVERT_ITF_TO_STREAM_TEXT'
          TABLES
            itf_text    = lt_lines
            text_stream = lt_stream.

        READ TABLE lt_stream INTO ls_stream INDEX 1.
        IF sy-subrc EQ 0.
          <fs_text>-tdline = ls_stream.
        ENDIF.
      ENDLOOP.

      LOOP AT lt_text ASSIGNING <fs_text>.
        REPLACE ALL OCCURRENCES OF ',,' IN <fs_text>-tdline WITH '~'.  " Separador de Tab
        CASE sy-tabix.
          WHEN 1.
            r_text = <fs_text>-tdline.
          WHEN OTHERS.
            CONCATENATE r_text <fs_text>-tdline INTO r_text SEPARATED BY '#'.
        ENDCASE.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD get_interlocutor.

    DATA: ls_const LIKE LINE OF gt_const,
          lr_parvw TYPE RANGE OF parvw,
          ls_parvw LIKE LINE OF lr_parvw,
          ls_vbpa  LIKE LINE OF gt_vbpa,
          ls_vbpa3 LIKE LINE OF gt_vbpa3.

    CLEAR: es_kna1, es_dire.

    IF i_parvw IS NOT INITIAL.
      CONCATENATE 'IEQ' i_parvw INTO ls_parvw.
      APPEND ls_parvw TO lr_parvw.
    ENDIF.

    IF i_campo IS NOT INITIAL.
      LOOP AT gt_const INTO ls_const WHERE campo = i_campo.
        ls_parvw-sign   = ls_const-signo.
        ls_parvw-option = ls_const-opcion.
        IF ls_parvw-sign IS INITIAL.
          ls_parvw = 'IEQ'.
        ENDIF.
        ls_parvw-low    = ls_const-valor1.
        APPEND ls_parvw TO lr_parvw.
      ENDLOOP.
    ENDIF.

    IF lr_parvw IS NOT INITIAL.
      LOOP AT gt_vbpa INTO ls_vbpa WHERE vbeln = i_vbeln
                                     AND parvw IN lr_parvw.
        "Interlocutor
        IF ls_vbpa-lifnr IS NOT INITIAL.
          READ TABLE gth_kna1 INTO es_kna1 WITH TABLE KEY kunnr = ls_vbpa-lifnr.
        ELSE.
          READ TABLE gth_kna1 INTO es_kna1 WITH TABLE KEY kunnr = ls_vbpa-kunnr.
        ENDIF.
        IF sy-subrc = 0.
          "Apellidos y nombres, denominación o razón social, Ubigeo y Dirección del Interlocutor
          READ TABLE gth_dire INTO es_dire WITH TABLE KEY adrnr = ls_vbpa-adrnr.
          es_kna1-adrnr = ls_vbpa-adrnr.
        ENDIF.
*{+081122-NTP-3000020296
        IF ls_vbpa-xcpdk = abap_on.
          READ TABLE gt_vbpa3 INTO ls_vbpa3 WITH KEY vbeln = ls_vbpa-vbeln parvw = ls_vbpa-parvw.
          IF sy-subrc = 0.
            es_kna1-stcd1 = ls_vbpa3-stcd1.
            es_kna1-stcdt = ls_vbpa3-stcdt.
*}+081122-NTP-3000020296
          ENDIF.
        ENDIF.
        EXIT.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD get_material_codigo_cubso.

    DATA: l_codigo TYPE zostb_asgcubsosg-codigo,
          l_field  TYPE fieldname,
          l_matnr  TYPE mara-matnr.

    DATA: lo_error  TYPE REF TO   cx_root.

    CLEAR r_material_sunat.

    l_codigo = is_lips-matnr.

    CASE gs_process-license.
      WHEN '0021225088'. "Resemin
        l_matnr = is_lips-matnr.
        IF l_matnr IS INITIAL.
          l_matnr = is_lips-kdmat_matnr.
        ENDIF.
        TRY .
            l_field = 'ZZCUBSO'.
            SELECT SINGLE (l_field) INTO r_material_sunat
              FROM mara
              WHERE matnr = l_matnr.
          CATCH cx_root INTO lo_error.
        ENDTRY.

        r_material_sunat = r_material_sunat(8).
      WHEN OTHERS.
        SELECT SINGLE cubsosg INTO r_material_sunat
          FROM zostb_asgcubsosg
          WHERE gjahr = is_likp-wadat(4)
            AND tipasg = '99'
            AND codigo = l_codigo.
    ENDCASE.

    "Si no hay, buscar en las constantes código genérico
    IF r_material_sunat IS INITIAL.
      READ TABLE gt_const INTO ls_const WITH KEY campo = 'CODCUB_GEN'.
      IF sy-subrc = 0.
        r_material_sunat = ls_const-valor1.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_sunat_resolution.

    r_resol = TEXT-w02.
    REPLACE '&1' WITH gs_consextsun-zz_resol INTO r_resol.

  ENDMETHOD.


  METHOD move_corresponding.
    DATA: lo_type TYPE REF TO cl_abap_structdescr,
          ls_comp LIKE LINE OF lo_type->components.
    FIELD-SYMBOLS: <fs>  TYPE any,
                   <fs2> TYPE any.

    lo_type ?= cl_abap_structdescr=>describe_by_data( cs_data ).
    LOOP AT lo_type->components INTO ls_comp.
      ASSIGN COMPONENT ls_comp-name OF STRUCTURE cs_data TO <fs>.
      IF <fs> IS INITIAL.
        ASSIGN COMPONENT ls_comp-name OF STRUCTURE is_data TO <fs2>.
        IF <fs2> IS ASSIGNED.
          IF <fs2> IS NOT INITIAL.
            <fs> = <fs2>.
          ENDIF.
          UNASSIGN <fs2>.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD read_text.

    DATA: lt_lines TYPE tline_tab,
          ls_lines TYPE tline.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
*       CLIENT                  = SY-MANDT
        id                      = is_thead-tdid
        language                = is_thead-tdspras
        name                    = is_thead-tdname
        object                  = is_thead-tdobject
*       ARCHIVE_HANDLE          = 0
*       LOCAL_CAT               = ' '
*   IMPORTING
*       HEADER                  =
*       OLD_LINE_COUNTER        =
      TABLES
        lines                   = lt_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.

    LOOP AT lt_lines INTO ls_lines.
      IF e_string IS INITIAL.
        e_string = ls_lines-tdline.
      ELSE.
        CONCATENATE e_string ls_lines-tdline INTO e_string SEPARATED BY space.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD read_text_vbbk_zconst.

    DATA: ls_const LIKE LINE OF gt_const,
          ls_thead TYPE thead.

    READ TABLE gt_const INTO ls_const WITH KEY campo = i_campo.
    IF sy-subrc = 0.
      IF i_posnr IS INITIAL.
        ls_thead-tdobject = 'VBBK'.
        ls_thead-tdname   = i_vbeln.
      ELSE.
        ls_thead-tdobject = 'VBBP'.
        CONCATENATE i_vbeln i_posnr INTO ls_thead-tdname.
      ENDIF.
      ls_thead-tdid     = ls_const-valor1.

      CASE i_compress.
        WHEN '#'.
          ls_thead-tdspras  = sy-langu.
          e_string = get_format_text_type_paragraph( is_thead = ls_thead ).
        WHEN OTHERS.
          SELECT SINGLE spras INTO ls_thead-tdspras FROM kna1 WHERE kunnr = i_kunnr.
          e_string = read_text( ls_thead ).
          IF e_string IS INITIAL.
            ls_thead-tdspras  = sy-langu.
            e_string = read_text( ls_thead ).
          ENDIF.
      ENDCASE.
    ENDIF.

*{ BEGIN OF INSERT WMR-21012021-3000016148
    CASE gs_process-license.
      WHEN '0021154274'.  " ILENDER
        IF i_fulltext IS INITIAL.
          IF strlen( e_string ) > 75.  e_string = e_string(75).  ENDIF.  " Tomar como máximo 75 caracteres
        ENDIF.
    ENDCASE.
*} END OF INSERT WMR-21012021-3000016148

  ENDMETHOD.


  METHOD read_text_vbbk_zconst2.

    DATA: ls_const LIKE LINE OF gt_const,
          ls_thead TYPE thead,
          ls_line  LIKE LINE OF et_line,
          l_val    TYPE string.

    READ TABLE gt_const INTO ls_const WITH KEY campo = i_campo.
    IF sy-subrc = 0.
      IF i_posnr IS INITIAL.
        ls_thead-tdobject = 'VBBK'.
        ls_thead-tdname   = i_vbeln.
      ELSE.
        ls_thead-tdobject = 'VBBP'.
        CONCATENATE i_vbeln i_posnr INTO ls_thead-tdname.
      ENDIF.
      ls_thead-tdid       = ls_const-valor1.

      SELECT SINGLE spras INTO ls_thead-tdspras FROM kna1 WHERE kunnr = i_kunnr.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id       = ls_thead-tdid
          language = ls_thead-tdspras
          name     = ls_thead-tdname
          object   = ls_thead-tdobject
        TABLES
          lines    = et_line
        EXCEPTIONS
          OTHERS   = 1.
      IF et_line IS INITIAL.
        ls_thead-tdspras  = sy-langu.

        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id       = ls_thead-tdid
            language = ls_thead-tdspras
            name     = ls_thead-tdname
            object   = ls_thead-tdobject
          TABLES
            lines    = et_line
          EXCEPTIONS
            OTHERS   = 1.
      ENDIF.

      LOOP AT et_line INTO ls_line.
        SEARCH ls_line-tdline FOR ':'.
        IF sy-subrc = 0.
          SPLIT ls_line-tdline AT ':' INTO ls_line-tdline l_val.
        ELSE.
          l_val = ls_line-tdline.
        ENDIF.
        CONDENSE l_val.
        CASE sy-tabix.
          WHEN 1. e_val1 = l_val.
          WHEN 2. e_val2 = l_val.
          WHEN 3. e_val3 = l_val.
          WHEN 4. e_val4 = l_val.
          WHEN 5. e_val5 = l_val.
          WHEN 6. e_val5 = l_val.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD s4_completar_datos_nif.

    DATA: lt_bus_part  TYPE TABLE OF gty_bus_part.

    FIELD-SYMBOLS: <fs_kna1>     LIKE LINE OF ct_kna1,
                   <fs_bus_part> LIKE LINE OF lt_bus_part,
                   <fs_asgtnhr>  LIKE LINE OF gth_asgtnhr,
                   <fs_fldnif>   TYPE any.                                              "I-WMR-310119-3000011180

    CHECK gs_process-s4core = abap_on.

    CHECK ct_kna1[] IS NOT INITIAL.

    " Tomar N° NIF de Business Partner
    CASE ip_type.
      WHEN 'C'. " Cliente
        SELECT l~customer t~partner t~taxtype t~taxnum
*               t~taxnumxl                                                               "I-WMR-310119-3000011180
               t~taxnumxl                                                                "I-KAR-300323-3000019645
          INTO TABLE lt_bus_part
          FROM cvi_cust_link AS l
          INNER JOIN but000 AS b ON ( l~partner_guid = b~partner_guid )
          LEFT JOIN dfkkbptaxnum AS t ON ( t~partner = b~partner )
          FOR ALL ENTRIES IN ct_kna1
          WHERE l~customer = ct_kna1-kunnr.
      WHEN 'P'. " Proveedor
        SELECT l~vendor t~partner t~taxtype t~taxnum
*               t~taxnumxl                                                               "I-WMR-310119-3000011180
               t~taxnumxl                                                                "I-KAR-300323-3000019645
          INTO TABLE lt_bus_part
          FROM cvi_vend_link AS l
          INNER JOIN but000 AS b ON ( l~partner_guid = b~partner_guid )
          LEFT JOIN dfkkbptaxnum AS t ON ( t~partner = b~partner )
          FOR ALL ENTRIES IN ct_kna1
          WHERE l~vendor = ct_kna1-kunnr.
*{+NTP010323-3000019645
      WHEN 'I'. " Interlocutor
        SELECT t~partner t~partner t~taxtype t~taxnum
               t~taxnumxl                                                                "I-KAR-300323-3000019645
          INTO TABLE lt_bus_part
          FROM but000 AS b LEFT JOIN dfkkbptaxnum AS t ON ( t~partner = b~partner )
          FOR ALL ENTRIES IN ct_kna1
          WHERE b~partner = ct_kna1-kunnr.
*}+NTP010323-3000019645
    ENDCASE.

    LOOP AT ct_kna1 ASSIGNING <fs_kna1> WHERE stcd1 = space OR stcdt = space.
      LOOP AT lt_bus_part ASSIGNING <fs_bus_part> WHERE kunnr = <fs_kna1>-kunnr.
*{  BEGIN OF DELETE WMR-310119-3000011180
**        <fs_kna1>-stcd1 = <fs_bus_part>-taxnum.
**        IF <fs_kna1>-stcdt IS INITIAL.
**          READ TABLE gth_asgtnhr ASSIGNING <fs_asgtnhr>
**               WITH TABLE KEY taxtype = <fs_bus_part>-taxtype.
**          IF sy-subrc = 0.
**            <fs_kna1>-stcdt = <fs_asgtnhr>-stcdt.
**          ENDIF.
**        ENDIF.
*}  END OF DELETE WMR-310119-3000011180
*{  BEGIN OF INSERT WMR-310119-3000011180
        READ TABLE gth_asgtnhr ASSIGNING <fs_asgtnhr>
             WITH TABLE KEY taxtype = <fs_bus_part>-taxtype.
        IF sy-subrc = 0.
          IF <fs_kna1>-stcdt IS INITIAL.
            <fs_kna1>-stcdt = <fs_asgtnhr>-stcdt.
          ENDIF.
          CHECK <fs_asgtnhr>-fldtaxnum IS NOT INITIAL.
          UNASSIGN <fs_fldnif>.
          ASSIGN COMPONENT <fs_asgtnhr>-fldtaxnum OF STRUCTURE <fs_bus_part> TO <fs_fldnif>.
          IF ( <fs_fldnif> IS ASSIGNED ) AND ( <fs_kna1>-stcd1 <> <fs_fldnif> ).
            <fs_kna1>-stcd1 = <fs_fldnif>.
          ENDIF.
        ENDIF.
*}  END OF INSERT WMR-310119-3000011180
        EXIT.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.


  METHOD serialize_json.

    DATA: lt_string TYPE trext_string.

    serialize_json_recursive( EXPORTING i_tabname = i_tabname
                                        i_data = data
                              CHANGING ct_string = lt_string ) .

    CONCATENATE LINES OF lt_string INTO json.

  ENDMETHOD.


  METHOD serialize_json_recursive.

    DATA: lv_type  TYPE c,
          lv_comps TYPE i,
          lv_lines TYPE i,
          lv_index TYPE i,
          lv_value TYPE string.
    CONSTANTS: lc_comma TYPE char01 VALUE ',',
               lc_colon TYPE char01 VALUE ':'.
    FIELD-SYMBOLS: <itab> TYPE ANY TABLE,
                   <comp> TYPE any.


    DESCRIBE FIELD i_data TYPE lv_type COMPONENTS lv_comps.

    "------------------------------------------------------------------*
    " Table
    "------------------------------------------------------------------*
    IF lv_type = cl_abap_typedescr=>typekind_table .
* itab -> array
      APPEND '[' TO ct_string .
      ASSIGN i_data TO <itab> .
      lv_lines = lines( <itab> ) .
      LOOP AT <itab> ASSIGNING <comp> .
        ADD 1 TO lv_index .
        serialize_json_recursive( EXPORTING i_data = <comp>
                                            i_recursive_call = abap_on
                                  CHANGING ct_string = ct_string ) .
        IF lv_index < lv_lines .
          APPEND lc_comma TO ct_string .
        ENDIF .
      ENDLOOP .
      APPEND ']' TO ct_string .
    ELSE .
      "------------------------------------------------------------------*
      " If components are initial and method called from serialize we *
      " are working with a single standalone scarlarfield without name *
      " we only know the data type, not the field name. Therefore the *
      " datatype is used as the fieldname since an JSON object must have *
      " an object name and must be surrounded by brackets *
      "{"name":"value"}. Scalar fields are allways single field values, *
      " nor part of a structure or tabletype. *
      "If components are initial and method is called recursive from *
      "serial_recursive, the scarlar field is part of an object or array *
      " and there by have a name.
      "------------------------------------------------------------------*
      IF lv_comps IS INITIAL .
* field -> scalar
* todo: format
        lv_value = serialize_json_replace( i_data ).
        IF i_recursive_call IS INITIAL.
          IF i_tabname IS NOT INITIAL.
            CONCATENATE '{"' i_tabname '":' '"' lv_value '"' '}'
            INTO lv_value.
          ELSE.
            CASE lv_type.
              WHEN cl_abap_typedescr=>typekind_num.
                CONCATENATE '{"num":' '"' lv_value '"' '}' INTO lv_value.
              WHEN cl_abap_typedescr=>typekind_date.
                CONCATENATE '{"date":' '"' lv_value '"' '}' INTO lv_value.
              WHEN cl_abap_typedescr=>typekind_packed.
                CONCATENATE '{"packed":' '"' lv_value '"' '}' INTO lv_value.
              WHEN cl_abap_typedescr=>typekind_time.
                CONCATENATE '{"time":' '"' lv_value '"' '}' INTO lv_value.
              WHEN cl_abap_typedescr=>typekind_char.
                CONCATENATE '{"char":' '"' lv_value '"' '}' INTO lv_value.
              WHEN cl_abap_typedescr=>typekind_hex.
                CONCATENATE '{"hex":' '"' lv_value '"' '}' INTO lv_value.
              WHEN cl_abap_typedescr=>typekind_float.
                CONCATENATE '{"float":' '"' lv_value '"' '}' INTO lv_value.
              WHEN cl_abap_typedescr=>typekind_int.
                CONCATENATE '{"int":' '"' lv_value '"' '}' INTO lv_value.
              WHEN cl_abap_typedescr=>typekind_int1.
                CONCATENATE '{"int1":' '"' lv_value '"' '}' INTO lv_value.
              WHEN cl_abap_typedescr=>typekind_int2.
                CONCATENATE '{"int2":' '"' lv_value '"' '}' INTO lv_value.
              WHEN cl_abap_typedescr=>typekind_w.
                CONCATENATE '{"Wide":' '"' lv_value '"' '}' INTO lv_value.
              WHEN cl_abap_typedescr=>typekind_oref.
                CONCATENATE '{"Object reference, not supported":'(j01) '"'
                lv_value '"' '}' INTO lv_value.
              WHEN cl_abap_typedescr=>typekind_string.
                CONCATENATE '{"string":' '"' lv_value '"' '}' INTO lv_value.
              WHEN cl_abap_typedescr=>typekind_xstring.
                CONCATENATE '{"xtring":' '"' lv_value '"' '}' INTO lv_value.
              WHEN cl_abap_typedescr=>typekind_dref.
                CONCATENATE '{"Data reference, not supported":'(j02) '"'
                lv_value '"' '}' INTO lv_value.
              WHEN cl_abap_typedescr=>typekind_class.
                CONCATENATE '{"Class reference, not supported":'(j03) '"'
                lv_value '"' '}' INTO lv_value.
              WHEN cl_abap_typedescr=>typekind_intf.
                CONCATENATE '{"Class reference, not supported":'(j04) '"'
                lv_value '"' '}' INTO lv_value.
              WHEN cl_abap_typedescr=>typekind_any.
                CONCATENATE '{"Type Any, not supported":'(j05) '"'
                lv_value '"' '}' INTO lv_value.
              WHEN cl_abap_typedescr=>typekind_data.
                CONCATENATE '{"Type data, not supported":'(j06) '"'
                lv_value '"' '}' INTO lv_value.
              WHEN cl_abap_typedescr=>typekind_simple.
                CONCATENATE '{"Type clike, not supported":'(j07) '"'
                lv_value '"' '}' INTO lv_value.
              WHEN cl_abap_typedescr=>typekind_csequence.
                CONCATENATE '{"Type csequence, not supported":'(j08) '"'
                lv_value '"' '}' INTO lv_value.
              WHEN cl_abap_typedescr=>typekind_xsequence.
                CONCATENATE '{"Type xsequence, not supported":'(j09) '"'
                lv_value '"' '}' INTO lv_value.
              WHEN cl_abap_typedescr=>typekind_numeric.
                CONCATENATE '{"numeric":' '"' lv_value '"' '}' INTO lv_value .
              WHEN cl_abap_typedescr=>typekind_iref.
                CONCATENATE '{"Instance reference, not supported":'(j10) '"'
                lv_value '"' '}' INTO lv_value.
              WHEN OTHERS.
                CONCATENATE '{"NOT SUPPORTED":'(j11) '"' lv_value '"' '}'
                INTO lv_value.
            ENDCASE.
          ENDIF.
        ELSE.
          CONCATENATE '"' lv_value '"' INTO lv_value.
        ENDIF.
        CONDENSE lv_value.
        APPEND lv_value TO ct_string.
      ELSE .
        "------------------------------------------------------------------*
        " Structure
        "------------------------------------------------------------------*
        DATA: lv_typedescr TYPE REF TO cl_abap_structdescr,
              l_string     TYPE string.
        FIELD-SYMBOLS <abapcomp> TYPE abap_compdescr.
        APPEND '{' TO ct_string.
        lv_typedescr ?= cl_abap_typedescr=>describe_by_data( i_data ).

        LOOP AT lv_typedescr->components ASSIGNING <abapcomp>.
          lv_index = sy-tabix .
          CONCATENATE '"' <abapcomp>-name '"' lc_colon INTO lv_value.
          TRANSLATE lv_value TO LOWER CASE.
          APPEND lv_value TO ct_string.

          ASSIGN COMPONENT <abapcomp>-name OF STRUCTURE i_data TO <comp>.

          "Tipo de Variable
          CASE <abapcomp>-type_kind.
            WHEN 'P' OR 'I'.
              "Para montos negativos
              IF <comp> < 0.
                l_string = <comp>.
                REPLACE '-' INTO l_string WITH space.
                CONCATENATE '-' l_string INTO l_string.
                CONDENSE l_string.
                ASSIGN l_string TO <comp>.
              ENDIF.
            WHEN OTHERS.
          ENDCASE.

          serialize_json_recursive( EXPORTING i_data           = <comp>
                                              i_recursive_call = abap_on
                                    CHANGING ct_string         = ct_string
          ).

          IF lv_index < lv_comps.
            APPEND lc_comma TO ct_string.
          ENDIF.
        ENDLOOP.
        APPEND '}' TO ct_string.
      ENDIF .
    ENDIF .

  ENDMETHOD.


  METHOD serialize_json_replace.

    r_data = i_data.

    REPLACE ALL OCCURRENCES OF '\'  IN r_data WITH '\\'.
*    REPLACE ALL OCCURRENCES OF '''' IN r_data WITH '\'''.    "I-PBM010419-3000011101
    REPLACE ALL OCCURRENCES OF '"'  IN r_data WITH '\"'.
*    REPLACE ALL OCCURRENCES OF '&'  IN r_data WITH '\&'.     "I-PBM280319-3000011101
    REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf           IN r_data WITH '\r\n' .
    REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>newline         IN r_data WITH '\n' .
    REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>horizontal_tab  IN r_data WITH '\t' .
    REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>backspace       IN r_data WITH '\b'.
    REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>form_feed       IN r_data WITH '\f'.

  ENDMETHOD.


  METHOD set_aditional_text_pos.

    DATA: lt_text  TYPE TABLE OF string,

          ls_text  TYPE string,
          ls_thead TYPE thead,

          lt_lips  TYPE gtt_lips,
          l_lifmg  TYPE string,
          l_lotes  TYPE string.

    FIELD-SYMBOLS: <fs_lips>  LIKE LINE OF it_lips.

    CASE gs_process-license.
      WHEN '0021061097'.  " CMH
        lt_lips[] = it_lips[].
        DELETE lt_lips WHERE uecha <> is_lips-posnr.

        " 1.- Lotes
        CLEAR ls_text.
        IF lt_lips[] IS NOT INITIAL.
          SORT lt_lips BY posnr ASCENDING.
          LOOP AT lt_lips ASSIGNING <fs_lips> WHERE lfimg <> 0.
            CLEAR: l_lotes, l_lifmg.
            l_lifmg = <fs_lips>-lfimg.  CONDENSE l_lifmg NO-GAPS.
            CONCATENATE <fs_lips>-charg '=' l_lifmg INTO l_lotes SEPARATED BY space.
            IF ls_text IS INITIAL.
              ls_text = l_lotes.
            ELSE.
              CONCATENATE ls_text l_lotes INTO ls_text SEPARATED BY ';'.
            ENDIF.
          ENDLOOP.
          IF ls_text IS NOT INITIAL.
            APPEND ls_text TO lt_text.
          ENDIF.
        ELSE.                                                                       "I-WMR-160519-3000011134
          IF is_lips-charg IS NOT INITIAL.                                          "I-WMR-160519-3000011134
            ls_text = is_lips-charg.                                                "I-WMR-160519-3000011134
            APPEND ls_text TO lt_text.                                              "I-WMR-160519-3000011134
          ENDIF.                                                                    "I-WMR-160519-3000011134
        ENDIF.

        " 2.- Observación de Embalaje
        CLEAR: ls_thead, ls_text.
        ls_thead-tdobject = 'VBBP'.
        ls_thead-tdid     = '0003'.
        CONCATENATE is_lips-vbeln is_lips-posnr INTO ls_thead-tdname.
        SELECT SINGLE spras INTO ls_thead-tdspras FROM kna1 WHERE kunnr = is_likp-kunag.
        ls_text = read_text( ls_thead ).
        IF ls_text IS INITIAL.
          ls_thead-tdspras = sy-langu.
          ls_text = read_text( ls_thead ).
        ENDIF.
        IF ls_text IS NOT INITIAL.
          APPEND ls_text TO lt_text.
        ENDIF.

        " 3.- Nota de Posición
        CLEAR: ls_thead, ls_text.
        ls_thead-tdobject = 'VBBP'.
        ls_thead-tdid     = '0002'.
        CONCATENATE is_lips-vbeln is_lips-posnr INTO ls_thead-tdname.
        SELECT SINGLE spras INTO ls_thead-tdspras FROM kna1 WHERE kunnr = is_likp-kunag.
        ls_text = read_text( ls_thead ).
        IF ls_text IS INITIAL.
          ls_thead-tdspras = sy-langu.
          ls_text = read_text( ls_thead ).
        ENDIF.
        IF ls_text IS NOT INITIAL.
          APPEND ls_text TO lt_text.
        ENDIF.

        " 4.- Texto de Ventas
        CLEAR: ls_thead, ls_text.
        ls_thead-tdobject = 'VBBP'.
        ls_thead-tdid     = '0001'.
        CONCATENATE is_lips-vbeln is_lips-posnr INTO ls_thead-tdname.
        SELECT SINGLE spras INTO ls_thead-tdspras FROM kna1 WHERE kunnr = is_likp-kunag.
        ls_text = read_text( ls_thead ).
        IF ls_text IS INITIAL.
          ls_thead-tdspras = sy-langu.
          ls_text = read_text( ls_thead ).
        ENDIF.
        IF ls_text IS NOT INITIAL.
          APPEND ls_text TO lt_text.
        ENDIF.

    ENDCASE.

    LOOP AT lt_text INTO ls_text.
      IF r_textpos IS INITIAL.
        r_textpos = ls_text.
      ELSE.
        CONCATENATE r_textpos ls_text INTO r_textpos SEPARATED BY '#'.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD set_data_rem.

    DATA: ls_likp LIKE LINE OF it_likp,
          ls_lips LIKE LINE OF it_lips,
          ls_vbfa TYPE gty_vbfa,
          ls_cab  LIKE LINE OF et_cab.
    DATA: l_tipo   TYPE string,                                                   "I-WMR-190918-3000009765
          l_sercor TYPE zostb_felog-zzt_numeracion.                               "I-WMR-190918-3000009765

    FIELD-SYMBOLS: <fs_lips> LIKE LINE OF it_lips.

    "Procesamiento
    LOOP AT it_likp INTO ls_likp.

      "Campos SAP
      MOVE-CORRESPONDING ls_likp TO ls_cab. "+NTP010423-3000020188
      ls_cab-zznrosap = ls_likp-vbeln.      "+NTP010423-3000020188

*{I-PBM081222-3000019824
      IF ls_likp-vbtyp EQ 'T'. "Devoluciones
        ls_cab-is_devolucion = abap_on.
      ENDIF.
*}I-PBM081222-3000019824

      split_xblnr( EXPORTING i_xblnr  = ls_likp-xblnr                             "I-WMR-190918-3000009765
                   IMPORTING e_tipo   = l_tipo                                    "I-WMR-190918-3000009765
                             e_sercor = l_sercor ).                               "I-WMR-190918-3000009765

      ""    ls_cab-zzverubl = gs_consextsun-zz_verubl.  "Version del UBL                "E-WMR-260517-3000007333
*{R-PBM170123-3000020386
**    ls_cab-zzverubl = '2.1'.  "Version del UBL                                  "I-WMR-260517-3000007333
**    ls_cab-zzverstr = gs_consextsun-zz_verestrdoc.  "Versión de la estructura del documento
      SELECT SINGLE zz_verubl zz_verestrdoc INTO ( ls_cab-zzverubl,ls_cab-zzverstr )
      FROM zosfetb_ubl
      WHERE tpproc = 'GR'
        AND begda <= ls_likp-erdat
        AND endda >= ls_likp-erdat.
*}R-PBM170123-3000020386
*    ls_cab-zznrosun = ls_likp-xblnr+4.                                          "E-WMR-190918-3000009765
      ls_cab-zznrosun = l_sercor.                                                 "I-WMR-190918-3000009765
      ls_cab-zznrosun = ls_cab-zznrosun. "Numeración, conformada por serie y número correlativo
*{I-PBM061222-3000020028
      CASE zconst-zzhoremi.
        WHEN '' OR 'I'.
          ls_cab-zzhoremi = ls_likp-erzet.     "Hora de emisión
        WHEN 'II'.
          ls_cab-zzhoremi = ls_likp-spe_wauhr_ist.
      ENDCASE.
*}I-PBM061222-3000020028
*{+081122-NTP-3000020296
      CASE zconst-zzfecemi.
        WHEN '' OR 'I'.
          ls_cab-zzfecemi = ls_likp-wadat_ist.
          IF ls_cab-zzfecemi IS INITIAL.
            ls_cab-zzfecemi = ls_likp-wadat.
          ENDIF.
        WHEN 'II'.
          ls_cab-zzfecemi = ls_likp-tddat.     "Fecha de emisión
      ENDCASE.
*}+081122-NTP-3000020296
*    CASE gw_license.                                                                  "I-WMR-021118-3000010833 "-071122-NTP-3000020296
*      WHEN '0020886706'   " PIRAMIDE                                                  "I-WMR-021118-3000010833 "-071122-NTP-3000020296
*        OR '0021061097'.  " CMH                                                       "I-WMR-080119-3000011134 "-071122-NTP-3000020296
*        " Fecha emisión = Fecha real SM                                               "I-WMR-021118-3000010833 "-071122-NTP-3000020296
*        ls_cab-zzfecemi = ls_likp-wadat_ist.                                          "I-WMR-021118-3000010833 "-071122-NTP-3000020296
*    ENDCASE.                                                                          "I-WMR-021118-3000010833 "-071122-NTP-3000020296
*    ls_cab-zztipgui = ls_likp-xblnr(2).  "Tipo de documento (Guía)              "E-WMR-190918-3000009765
      ls_cab-zztipgui = l_tipo.            "Tipo de documento (Guía)              "I-WMR-190918-3000009765

*{+010922-NTP-3000018956
      "Tipo
      READ TABLE it_lips INTO ls_lips WITH KEY vbeln = ls_likp-vbeln.
*      ls_cab-werks = ls_lips-werks.
      IF ls_lips-vgtyp = 'V'.
*        ls_cab-is_pedidomm = abap_on.
      ENDIF.

      set_data_rem_observacion( EXPORTING ls_likp = ls_likp CHANGING ls_cab = ls_cab ).
      set_data_rem_consignacion( EXPORTING ls_likp = ls_likp CHANGING ls_cab = ls_cab ).
      set_data_rem_remitente( EXPORTING ls_likp = ls_likp it_lips = it_lips CHANGING ls_cab = ls_cab ).
      set_data_rem_traslado_mot( EXPORTING ls_likp = ls_likp it_lips = it_lips CHANGING ls_cab = ls_cab ).

      "Datos del Establecimiento del Tercero (cuando se ingrese)
      "Aquel interlocutor en donde el cliente nos indica que debemos dejar la mercadería.
*    ls_cab-zzetrnro = . "Numero de documento de identidad
*    ls_cab-zzetrtpd = . "Tipo de documento de identidad
*    ls_cab-zzetrden = . "Apellidos y nombres, denominación o razón social

      set_data_rem_traslado_mod( EXPORTING ls_likp = ls_likp it_lips = it_lips CHANGING ls_cab = ls_cab ).
*}+010922-NTP-3000018956

      "Si es Harina o Aceite
      IF ls_likp-btgew IS INITIAL.
        "Peso bruto total de los bienes
*        LOOP AT it_lips INTO ls_lips WHERE vbeln = ls_cab-vbeln.   "-NTP010423-3000020188
        LOOP AT it_lips INTO ls_lips WHERE vbeln = ls_cab-zznrosap. "+NTP010423-3000020188
          ADD ls_lips-lfimg TO ls_cab-zzpesbru.
        ENDLOOP.
        "Unidad de medida del peso bruto
        "ls_cab-zzundmed_h = ls_lips-meins. "-NTP010423-3000020188
        ls_cab-zzundmed_h = ls_lips-vrkme.  "+NTP010423-3000020188
      ELSE.
        "Peso bruto total de los bienes
        ls_cab-zzpesbru = ls_likp-btgew.
        "Unidad de medida del peso bruto
        ls_cab-zzundmed_h = ls_likp-gewei.
      ENDIF.
      CASE gw_license.                                                              "I-WMR-211118-3000010936
        WHEN '0020886706'.  " PIRAMIDE                                              "I-WMR-211118-3000010936
          " Peso Neto Total en Toneladas                                            "I-WMR-211118-3000010936
          ls_cab-zzpesbru = ls_likp-ntgew / 1000.                                   "I-WMR-211118-3000010936
          "Unidad de medida del peso neto                                           "I-WMR-211118-3000010936
          ls_cab-zzundmed_h = 'TO'.                                                 "I-WMR-211118-3000010936
      ENDCASE.                                                                      "I-WMR-211118-3000010936

      "Datos del contenedor (Motivo Importación)
*    ls_cab-zzcntnro = .  "Número de contenedor
      ls_cab-zzcntnro = read_text_vbbk_zconst( i_campo = 'ZZCNTNRO' i_vbeln = ls_likp-vbeln i_kunnr = ls_likp-kunag ). "I-PBM190423-3000020600
      "Puerto o Aeropuerto de embarque/desembarque
*    ls_cab-zzptocod = . "Código del Puerto

*{I-PBM081222-3000019824: CÓDIGO TEST
*    	ls_cab-zzcntnro = .  "Número de contenedor
*}I-PBM081222-3000019824

*{+010922-NTP-3000018956
      IF ls_likp-tabname IS INITIAL.
        set_data_rem_emision_partida( EXPORTING ls_likp = ls_likp it_lips = it_lips CHANGING ls_cab = ls_cab ).
        set_data_rem_destino_llegada( EXPORTING ls_likp = ls_likp it_lips = it_lips CHANGING ls_cab = ls_cab ).
      ELSE.
        set_data_rem_emision_partida_z( EXPORTING ls_likp = ls_likp it_lips = it_lips CHANGING ls_cab = ls_cab ).
        set_data_rem_destino_llegada_z( EXPORTING ls_likp = ls_likp it_lips = it_lips CHANGING ls_cab = ls_cab ).
      ENDIF.
      set_data_rem_solicitante( EXPORTING ls_likp = ls_likp CHANGING ls_cab = ls_cab ).
      set_data_rem_pallet( EXPORTING ls_likp = ls_likp it_lips = it_lips CHANGING ls_cab = ls_cab ).
*}+010922-NTP-3000018956

      " Tipo y Número de Comprobante
      READ TABLE gth_vbfa INTO ls_vbfa WITH TABLE KEY vbelv = ls_likp-vbeln.
      IF sy-subrc EQ 0.
        ls_cab-zztpnrcp = ls_vbfa-xblnr.
      ENDIF.
*}  END OF INSERT WMR-260517-3000007333

      ls_cab-zztotblt = ls_likp-zztotblt. "I-111219-NTP-3000013055

*{I-PBM180520-3000013745
      CASE gw_license.
        WHEN '0020311006'  " AIB
          OR '0020863116'. " AIB CLOUD
          ls_cab-zztotblt_c = ls_likp-zztotblt_c.
      ENDCASE.
*}I-PBM180520-3000013745

*{I-011221-NTP-3000018115
      " Comprobante anterior en caso de reenumeracion
      SELECT SINGLE xblnr INTO ls_cab-zzsercor_ant
        FROM zostb_felog AS a INNER JOIN likp AS b ON a~zzt_nrodocsap = b~vbeln
        WHERE a~zzt_nrodocsap = ls_likp-vbeln
          AND ( a~zzt_status_cdr = gc_statuscdr_1 OR a~zzt_status_cdr = gc_statuscdr_4 ).
*}I-011221-NTP-3000018115

*{I-PBM210922-3000020039
      DATA: ls_thead TYPE thead,
            ls_const LIKE LINE OF gt_const.
      "Número de Documento Relacionado (DAM)
      CLEAR ls_thead.
      ls_thead-tdobject = 'VBBK'.
      ls_thead-tdname   = ls_likp-vbeln.
      READ TABLE gt_const INTO ls_const WITH KEY campo = 'TDID_NDOCR'.
      IF sy-subrc = 0.
        ls_thead-tdid     = ls_const-valor1.
        SELECT SINGLE spras INTO ls_thead-tdspras FROM kna1 WHERE kunnr = ls_likp-kunag.
        ls_cab-zzdamnro = read_text( ls_thead ).
        IF ls_cab-zzdamnro IS INITIAL.
          ls_thead-tdspras  = sy-langu.
          ls_cab-zzdamnro = read_text( ls_thead ).
        ENDIF.
      ENDIF.
      "Datos de envío
      READ TABLE gt_const INTO ls_const WITH KEY campo = 'DATENV_T'.
      IF sy-subrc = 0.
        ls_cab-zzdatenv = ls_const-valor1.
      ENDIF.
*}I-PBM210922-3000020039

      set_data_rem_gr_transportista( EXPORTING is_likp = ls_likp it_lips = it_lips CHANGING cs_cab = ls_cab ).

**********************************************************************
*   2. POSICION
**********************************************************************
      set_data_rem_item( EXPORTING ls_likp = ls_likp it_lips = it_lips ls_cab = ls_cab IMPORTING et_det = et_det ). "+010922-NTP-3000018956

      LOOP AT it_lips INTO ls_lips WHERE vgbel IS NOT INITIAL.                          "I-WMR-021118-3000010837
        EXIT.                                                                           "I-WMR-021118-3000010837
      ENDLOOP.                                                                          "I-WMR-021118-3000010837
      IF sy-subrc = 0.                                                                  "I-WMR-021118-3000010837
        " Pedido SAP                                                                    "I-WMR-021118-3000010837
        ls_cab-vgbel = ls_lips-vgbel.
        " Número pedido de cliente                                                      "I-WMR-060318-3000008769
        SELECT SINGLE bstkd INTO ls_cab-bstkd FROM vbkd WHERE vbeln = ls_cab-vgbel      "I-WMR-060318-3000008769
                                                          AND posnr = 0.                "I-WMR-060318-3000008769
        CASE gw_license.
          WHEN '0021154274'. "Ilender
            ls_cab-zzrecep  = read_text_vbbk_zconst( i_campo = 'TXT_RECEP' i_vbeln  = ls_lips-vgbel i_fulltext = 'X' ).  "I-180221-NTP-3000016078
            REPLACE ALL OCCURRENCES OF '@ ' IN ls_cab-zzrecep WITH '#'.
        ENDCASE.
      ENDIF.                                                                            "I-WMR-021118-3000010837

      " Texto final del documento
*{  BEGIN OF INSERT WMR-070318-3000008769
      CASE gw_license.
        WHEN '0020886706'.  " PIRAMIDE
          ls_cab-zztxtffd = TEXT-901.
      ENDCASE.
*}  END OF INSERT WMR-070318-3000008769

      set_data_rem_anulado( EXPORTING ls_likp = ls_likp CHANGING ls_cab = ls_cab ). "+010922-NTP-3000018956

*{I-PBM060722-3000019552
      DATA: ls_vbkd  LIKE LINE OF gt_vbkd,
            ls_vbak  LIKE LINE OF gth_vbak,
            ls_tvaut LIKE LINE OF gt_tvaut.

      READ TABLE gt_vbkd INTO ls_vbkd WITH KEY vbeln = ls_cab-vgbel.
      IF sy-subrc = 0.
*        ls_cab-zznpedcli = ls_vbkd-bstkd. "Nº de pedido Cliente
      ENDIF.

      READ TABLE gth_vbak INTO ls_vbak WITH TABLE KEY vbeln = ls_cab-vgbel.
      IF sy-subrc = 0.
*        ls_cab-zzcodmotped = ls_vbak-augru. "Motivo de pedido
        READ TABLE gt_tvaut INTO ls_tvaut WITH KEY augru = ls_vbak-augru.
        IF sy-subrc = 0.
*          ls_cab-zzmotped = ls_tvaut-bezei. "Denominación motivo de pedido
        ENDIF.
      ENDIF.
*}I-PBM060722-3000019552
*+{KAR
      READ TABLE gt_const INTO ls_const WITH KEY campo = 'NRO_TUCE'.
      IF sy-subrc = 0.
        ls_cab-zztranci = ls_const-valor1.
      ENDIF.
*+}KAR
      APPEND ls_cab TO et_cab.
      CLEAR ls_cab.
    ENDLOOP.

  ENDMETHOD.


  METHOD set_data_rem_anulado.
    DATA: lt_cdhdr   TYPE TABLE OF cdhdr,
          lt_updates TYPE TABLE OF gty_updates,
          ls_updates LIKE LINE OF lt_updates,
          l_tipo     TYPE string,
          l_sercor   TYPE zostb_felog-zzt_numeracion.

    FIELD-SYMBOLS: <fs_cdhdr>   LIKE LINE OF lt_cdhdr,
                   <fs_updates> LIKE LINE OF lt_updates.

*{I-NTP180918-3000010450
*{  BEGIN OF INSERT WMR-130819-3000010823
    " GRE dada de baja
    CLEAR: lt_cdhdr, lt_updates.
    CASE gs_process-license.
      WHEN '0020262397'.  " ARTESCO
        " Buscar N° Sunat anterior
        CONCATENATE sy-mandt ls_likp-vbeln INTO ls_updates-tabkey.
        SELECT objectclas objectid changenr udate utime tcode
          INTO CORRESPONDING FIELDS OF TABLE lt_cdhdr FROM cdhdr
          WHERE objectclas = 'LIEFERUNG'
            AND objectid   = ls_likp-vbeln
            AND tcode      = 'IDCP'.
        IF lt_cdhdr[] IS NOT INITIAL.
          SELECT objectclas objectid changenr tabname tabkey fname chngind
                 value_new value_old
            INTO CORRESPONDING FIELDS OF TABLE lt_updates
            FROM cdpos
            FOR ALL ENTRIES IN lt_cdhdr
            WHERE objectclas = lt_cdhdr-objectclas
              AND objectid   = lt_cdhdr-objectid
              AND changenr   = lt_cdhdr-changenr
              AND tabname    = 'LIKP'
              AND tabkey     = ls_updates-tabkey
              AND fname      = 'XBLNR'
              AND chngind    = 'U'
              AND value_new  = ls_likp-xblnr.
          LOOP AT lt_updates ASSIGNING <fs_updates>.
            READ TABLE lt_cdhdr ASSIGNING <fs_cdhdr> WITH KEY objectclas = <fs_updates>-objectclas
                                                              objectid   = <fs_updates>-objectid
                                                              changenr   = <fs_updates>-changenr.
            IF sy-subrc = 0.
              <fs_updates>-udate = <fs_cdhdr>-udate.
              <fs_updates>-utime = <fs_cdhdr>-utime.
              <fs_updates>-tcode = <fs_cdhdr>-tcode.
            ENDIF.
          ENDLOOP.
          FREE: lt_cdhdr.
        ENDIF.
        " El N° Sunat más actual
        SORT lt_updates BY udate DESCENDING utime DESCENDING.
        IF lt_updates[] IS NOT INITIAL.
          READ TABLE lt_updates ASSIGNING <fs_updates> INDEX 1.
          IF sy-subrc = 0.
            split_xblnr( EXPORTING i_xblnr  = <fs_updates>-value_old
                         IMPORTING e_tipo   = l_tipo
                                   e_sercor = l_sercor ).
            IF l_tipo = ls_cab-zztipgui AND l_sercor(1) = ls_cab-zznrosun(1).
              ls_cab-zztipguibaj = l_tipo.
              ls_cab-zznroguibaj = l_sercor.
              ls_cab-zzctdguibaj = 1.
            ENDIF.
          ENDIF.
        ENDIF.
    ENDCASE.
*}  END OF INSERT WMR-130819-3000010823

  ENDMETHOD.


  METHOD set_data_rem_consignacion.
    DATA: ls_vttk       TYPE gty_vttk,
          ls_vttp       TYPE gty_vttp,
          ls_thead      TYPE thead,
          l_text_consig TYPE string.

    CLEAR l_text_consig.                                                        "I-WMR-080119-3000011134
    CASE gs_process-license.                                                    "I-WMR-080119-3000011134
      WHEN '0021061097'.  " CMH                                                 "I-WMR-080119-3000011134
        CLEAR ls_thead.                                                         "I-WMR-080119-3000011134
        ls_thead-tdobject = 'VBBK'.                                             "I-WMR-080119-3000011134
        ls_thead-tdid     = 'ZE01'.                                             "I-WMR-080119-3000011134
        ls_thead-tdname   = ls_likp-vbeln.                                      "I-WMR-080119-3000011134
        SELECT SINGLE spras INTO ls_thead-tdspras                               "I-WMR-080119-3000011134
          FROM kna1 WHERE kunnr = ls_likp-kunag.                                "I-WMR-080119-3000011134
        l_text_consig = read_text( ls_thead ).                                  "I-WMR-080119-3000011134
        IF l_text_consig IS INITIAL.                                            "I-WMR-080119-3000011134
          ls_thead-tdspras  = sy-langu.                                         "I-WMR-080119-3000011134
          l_text_consig = read_text( ls_thead ).                                "I-WMR-080119-3000011134
        ENDIF.                                                                  "I-WMR-080119-3000011134
        IF l_text_consig IS NOT INITIAL.                                        "I-WMR-080119-3000011134
          ls_cab-zzcsgtxt = l_text_consig(1).                                   "I-WMR-080119-3000011134
          "Fecha de emisión                                                     "I-WMR-080119-3000011134
          READ TABLE gth_vttp INTO ls_vttp WITH TABLE KEY vbeln = ls_likp-vbeln."I-WMR-080119-3000011134
          IF sy-subrc = 0.                                                      "I-WMR-080119-3000011134
            READ TABLE gth_vttk INTO ls_vttk WITH TABLE KEY tknum = ls_vttp-tknum."I-WMR-080119-3000011134
            IF sy-subrc = 0.                                                    "I-WMR-080119-3000011134
              ls_cab-zzfecemi = ls_vttk-dalen.                                  "I-WMR-080119-3000011134
            ENDIF.                                                              "I-WMR-080119-3000011134
          ENDIF.                                                                "I-WMR-080119-3000011134
        ENDIF.                                                                  "I-WMR-080119-3000011134
    ENDCASE.                                                                    "I-WMR-080119-3000011134

  ENDMETHOD.


  METHOD set_data_rem_destino_llegada.
    DATA: ls_dire  TYPE gty_direccion,
          ls_lips  LIKE LINE OF it_lips,
          ls_kna1  LIKE LINE OF gth_kna1,
          ls_const LIKE LINE OF gt_const,
          ls_cat20 LIKE LINE OF gth_cat20,
          ls_vbpa  TYPE gty_vbpa,
*          l_dst_exportacion TYPE xfeld,              "-010922-NTP-3000018956
          lr_parvw TYPE RANGE OF vtpa-parvw,
          ls_parvw LIKE LINE OF lr_parvw.

    DATA: l_werks TYPE werks_d.                 "I-PBM061222-3000020028

    READ TABLE it_lips INTO ls_lips WITH KEY vbeln = ls_likp-vbeln.

    "Destinatario
*{I-NTP180918-3000010450
    CASE gw_license.
      WHEN '0020886706'. "Piramide
        "Numero de documento de identidad
        ls_cab-zzdstnro = zpiramide-s_desti-stcd1.
        ls_cab-zzdsttpd_h = zpiramide-s_desti-stcdt.

        "Dirección punto de llegada
        READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = zpiramide-s_desti-adrnr.
        IF sy-subrc = 0.
          "Apellidos y nombres, denominación o razón social del destinatario
          CONCATENATE zpiramide-s_desti-kunnr
                      abap_undefined
                      ls_dire-name
                      INTO ls_cab-zzdstden SEPARATED BY space.

          "Ubigeo
          ls_cab-zzlleubi = ls_dire-ubigeo.

          "Direccion completa                                                 "+NTP02022023-3000019902
          ls_cab-zzlledir = ls_dire-direccion.                                "+NTP02022023-3000019902
**          ls_cab-zzlledir2 = ls_dire-direccion.                               "+NTP02022023-3000019902
*{-NTP02022023-3000019902
**{I-3000010823-NTP110219
*          " Ubigeo
*          ls_cab-zzlleubi = ls_dire-ubigeo.
*          " Dirección completa
*          CONCATENATE ls_dire-street
*                      ls_dire-stnumb
*                      INTO ls_cab-zzlledir SEPARATED BY space.
*          CONDENSE ls_cab-zzlledir. TRANSLATE ls_cab-zzlledir TO UPPER CASE.
*          " Urbanización
*          CONCATENATE ls_dire-str_suppl1
*                      ls_dire-str_suppl2
*                      ls_dire-str_suppl3
*                      INTO ls_cab-zzlleurb SEPARATED BY space.
*          CONDENSE ls_cab-zzlleurb. TRANSLATE ls_cab-zzlleurb TO UPPER CASE.
*          " Distrito
*          ls_cab-zzlledis = ls_dire-distri.
*          CONDENSE ls_cab-zzlledis. TRANSLATE ls_cab-zzlledis TO UPPER CASE.
*          " Provincia
*          ls_cab-zzllepro = ls_dire-provin.
*          CONDENSE ls_cab-zzllepro. TRANSLATE ls_cab-zzllepro TO UPPER CASE.
*          " Departamento
*          ls_cab-zzlledep = ls_dire-depmto.
*          CONDENSE ls_cab-zzlledep. TRANSLATE ls_cab-zzlledep TO UPPER CASE.
*          " País
*          ls_cab-zzllepai = ls_dire-pais.
*          CONDENSE ls_cab-zzllepai. TRANSLATE ls_cab-zzllepai TO UPPER CASE.
**}I-3000010823-NTP110219
*}-NTP02022023-3000019902
        ENDIF.
*}I-NTP180918-3000010450

*{  BEGIN OF INSERT WMR-280819-3000010823
      WHEN '0020262397'.  " ARTESCO
        " Información del Destinatario (desde el destinatario de mercancías o solicitante)
        READ TABLE it_lips INTO ls_lips INDEX 1.
        CASE ls_lips-vgtyp.
          WHEN 'C'  " Pedido de ventas
            OR 'H'. " Devolución de ventas
            " Desde el solicitante
            READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_likp-kunag.
          WHEN OTHERS.
            " Desde el destinatario de mercancías
            READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_likp-kunnr.
        ENDCASE.
        IF sy-subrc = 0.
          "Numero de documento de identidad
          ls_cab-zzdstnro = ls_kna1-stcd1.
          "Tipo de N°doc. identidad
          ls_cab-zzdsttpd_h = ls_kna1-stcdt.

          READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_kna1-adrnr.
          IF sy-subrc = 0.
            "Apellidos y nombres, denominación o razón social del destinatario
            ls_cab-zzdstden = ls_dire-name.
*{  BEGIN OF INSERT WMR-13042020-3000014016
            IF ls_dire-pais <> 'PE'.
*{+NTP010423-3000020188
*              CLEAR: lr_parvw.
*              LOOP AT gt_const INTO ls_const WHERE campo = 'PARVW_EXP'.
*                CLEAR ls_parvw.
*                ls_parvw-sign   = ls_const-signo.
*                ls_parvw-option = ls_const-opcion.
*                ls_parvw-low    = ls_const-valor1.
*                ls_parvw-high   = ls_const-valor2.
*                APPEND ls_parvw TO lr_parvw.
*              ENDLOOP.
*              IF sy-subrc = 0.
*                LOOP AT gt_vbpa INTO ls_vbpa WHERE vbeln = ls_likp-vbeln
*                                               AND parvw IN lr_parvw.
*                  "Numero de documento de identidad del Interlocutor ZW del Transporte
*                  IF ls_vbpa-lifnr IS NOT INITIAL.
*                    READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_vbpa-lifnr.
*                  ELSE.
*                    READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_vbpa-kunnr.
*                  ENDIF.
*                  IF sy-subrc = 0.
*                    "Apellidos y nombres, denominación o razón social, Ubigeo y Dirección del Interlocutor Z3 del Transporte
*                    READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_vbpa-adrnr.
*                  ENDIF.
*                  EXIT.
*                ENDLOOP.
*              ENDIF.
*}+NTP010423-3000020188
              get_interlocutor( EXPORTING i_vbeln = ls_likp-vbeln i_campo = 'PARVW_EXP' IMPORTING es_kna1 = ls_kna1 es_dire = ls_dire ). "+NTP010423-3000020188
            ENDIF.
*}  END OF INSERT WMR-13042020-3000014016
            " Ubigeo
            ls_cab-zzdstubi = ls_dire-ubigeo.
            " Dirección completa
            CONCATENATE ls_dire-street
                        ls_dire-stnumb
                        INTO ls_cab-zzdstdir SEPARATED BY space.
            CONDENSE ls_cab-zzdstdir. TRANSLATE ls_cab-zzdstdir TO UPPER CASE.
            " Urbanización
            CONCATENATE ls_dire-str_suppl1
                        ls_dire-str_suppl2
                        ls_dire-str_suppl3
                        INTO ls_cab-zzdsturb SEPARATED BY space.
            CONDENSE ls_cab-zzdsturb. TRANSLATE ls_cab-zzdsturb TO UPPER CASE.
            " Distrito
            ls_cab-zzdstdis = ls_dire-distri.
            CONDENSE ls_cab-zzdstdis. TRANSLATE ls_cab-zzdstdis TO UPPER CASE.
            " Provincia
            ls_cab-zzdstpro = ls_dire-provin.
            CONDENSE ls_cab-zzdstpro. TRANSLATE ls_cab-zzdstpro TO UPPER CASE.
            " Departamento
            ls_cab-zzdstdep = ls_dire-depmto.
            CONDENSE ls_cab-zzdstdep. TRANSLATE ls_cab-zzdstdep TO UPPER CASE.
            " País
            ls_cab-zzdstpai = ls_dire-pais.
            CONDENSE ls_cab-zzdstpai. TRANSLATE ls_cab-zzdstpai TO UPPER CASE.
          ENDIF.
        ENDIF.

        " Dirección Punto de Llegada
        " Desde el destinatario de mercancías
        READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_likp-kunnr.
        IF sy-subrc = 0.
          READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_kna1-adrnr.
          IF sy-subrc = 0.
*{  BEGIN OF INSERT WMR-13042020-3000014016
            IF ls_dire-pais <> 'PE'.
*{-NTP010423-3000020188
*              CLEAR: lr_parvw.
*              LOOP AT gt_const INTO ls_const WHERE campo = 'PARVW_EXP'.
*                CLEAR ls_parvw.
*                ls_parvw-sign   = ls_const-signo.
*                ls_parvw-option = ls_const-opcion.
*                ls_parvw-low    = ls_const-valor1.
*                ls_parvw-high   = ls_const-valor2.
*                APPEND ls_parvw TO lr_parvw.
*              ENDLOOP.
*              IF sy-subrc = 0.
*                LOOP AT gt_vbpa INTO ls_vbpa WHERE vbeln = ls_likp-vbeln
*                                               AND parvw IN lr_parvw.
*                  "Numero de documento de identidad del Interlocutor ZW del Transporte
*                  IF ls_vbpa-lifnr IS NOT INITIAL.
*                    READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_vbpa-lifnr.
*                  ELSE.
*                    READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_vbpa-kunnr.
*                  ENDIF.
*                  IF sy-subrc = 0.
*                    "Apellidos y nombres, denominación o razón social, Ubigeo y Dirección del Interlocutor Z3 del Transporte
*                    READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_vbpa-adrnr.
*                  ENDIF.
*                  EXIT.
*                ENDLOOP.
*              ENDIF.
*}-NTP010423-3000020188
              get_interlocutor( EXPORTING i_vbeln = ls_likp-vbeln i_campo = 'PARVW_EXP' IMPORTING es_kna1 = ls_kna1 es_dire = ls_dire ). "+NTP010423-3000020188
            ENDIF.
*}  END OF INSERT WMR-13042020-3000014016
            " Ubigeo
            ls_cab-zzlleubi = ls_dire-ubigeo.
            " Dirección completa
            CONCATENATE ls_dire-street
                        ls_dire-stnumb
                        INTO ls_cab-zzlledir SEPARATED BY space.
            CONDENSE ls_cab-zzlledir. TRANSLATE ls_cab-zzlledir TO UPPER CASE.
            " Urbanización
            CONCATENATE ls_dire-str_suppl1
                        ls_dire-str_suppl2
                        ls_dire-str_suppl3
                        INTO ls_cab-zzlleurb SEPARATED BY space.
            CONDENSE ls_cab-zzlleurb. TRANSLATE ls_cab-zzlleurb TO UPPER CASE.
            " Distrito
            ls_cab-zzlledis = ls_dire-distri.
            CONDENSE ls_cab-zzlledis. TRANSLATE ls_cab-zzlledis TO UPPER CASE.
            " Provincia
            ls_cab-zzllepro = ls_dire-provin.
            CONDENSE ls_cab-zzllepro. TRANSLATE ls_cab-zzllepro TO UPPER CASE.
            " Departamento
            ls_cab-zzlledep = ls_dire-depmto.
            CONDENSE ls_cab-zzlledep. TRANSLATE ls_cab-zzlledep TO UPPER CASE.
            " País
            ls_cab-zzllepai = ls_dire-pais.
            CONDENSE ls_cab-zzllepai. TRANSLATE ls_cab-zzllepai TO UPPER CASE.
          ENDIF.
        ENDIF.

      WHEN OTHERS.

*{I-PBM081222-3000019824
        ls_cab-zzdstcod = ls_likp-kunag.
        IF ls_cab-is_devolucion IS NOT INITIAL.
          ls_cab-zzdstcod = ls_likp-vstel.
        ENDIF.
*}I-PBM081222-3000019824

*{+010922-NTP-3000018956: GR de traslado interno
        IF ls_cab-is_trasladointerno IS NOT INITIAL.
          ls_cab-kunag      = ls_cab-kunnr.
          "Destinatario
          ls_cab-zzdstnro   = ls_cab-zzremnro.
          ls_cab-zzdsttpd_h = ls_cab-zzremtpd_h.
          ls_cab-zzdstden   = ls_cab-zzremden.

          READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_likp-kunnr.
          IF sy-subrc = 0.
            READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_kna1-adrnr.
            IF sy-subrc = 0.
              ls_cab-zzdstubi = ls_dire-ubigeo.       "ubigeo
              ls_cab-zzdstdir = ls_dire-direccion.    "direccion
              ls_cab-zzdsturb = ls_dire-urbanizacion. "urbanizacion
              ls_cab-zzdstdis = ls_dire-distri.       "distrito
              ls_cab-zzdstpro = ls_dire-provin.       "provincia
              ls_cab-zzdstdep = ls_dire-depmto.       "departamento
              ls_cab-zzdstpai = ls_dire-pais.         "pais
            ENDIF.
          ENDIF.

          "Llegada
*{+011022-NTP-3000018956
          READ TABLE gt_const INTO ls_const WITH KEY campo = 'PTO_LLEGADA_PARVW_LFART' valor2 = ls_likp-lfart.
          IF sy-subrc = 0.
            get_interlocutor(
              EXPORTING
                i_vbeln = ls_likp-vbeln
                i_parvw = ls_const-valor1
              IMPORTING
                es_dire = ls_dire
            ).
          ENDIF.
*}+011022-NTP-3000018956
          ls_cab-zzlleubi   = ls_dire-ubigeo.
          ls_cab-zzlledir   = ls_dire-direccion.
          ls_cab-zzlleest   = ls_cab-zzparest.          "I-PBM300123-3000019824

          IF ls_cab-is_trasladointerno EQ 'X'.
            IF ls_cab-kunag(1) EQ 'C'.
              l_werks = ls_cab-kunag+1.
            ENDIF.
            get_codigo_estab_sunat( EXPORTING i_werks = l_werks
                                              ls_lips = ls_lips                     "I-PBM190423-3000020600
                                    CHANGING c_codest = ls_cab-zzlleest ).          "I-PBM061222-3000020028
          ENDIF.
        ELSE.
*}+010922-NTP-3000018956

*{-010922-NTP-3000018956
*          READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_likp-kunnr.
*          IF sy-subrc = 0.
*            "Numero de documento de identidad
*            ls_cab-zzdstnro = ls_kna1-stcd1.
*            ls_cab-zzdsttpd_h = ls_kna1-stcdt.
*
**{  BEGIN OF INSERT WMR-190918-3000009765
*            " En caso sea Sistema S/4 Hana
*            IF gs_process-s4core = abap_on.
*              " Tomar N° y Tipo de documento de Identidad del Remitente
*              IF ls_cab-zzdstnro IS INITIAL OR ls_cab-zzdsttpd_h IS INITIAL.
*                ls_cab-zzdstnro   = ls_cab-zzremnro.
*                ls_cab-zzdsttpd_h = ls_cab-zzremtpd_h.
*              ENDIF.
*            ENDIF.
**}  END OF INSERT WMR-190918-3000009765
**}-010922-NTP-3000018956
*            "Dirección punto de llegada
*            READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_kna1-adrnr.
*            IF sy-subrc = 0.
*
**    {  BEGIN OF INSERT WMR-260517-3000007333
*              CASE gw_license.
*                WHEN '0020974592'   " DANPER
*                  OR '0020311006'.  " AIB                                                   "I-WMR-191018-3000009770
**{E-111219-NTP-3000013055
**                 IF ls_dire-pais EQ 'PE'.
**                 ELSE.
**}E-111219-NTP-3000013055
*}-010922-NTP-3000018956
*{I-111219-NTP-3000013055
          CASE zconst-zzdstnro.
            WHEN '' OR 'I'.
              READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_likp-kunnr.
            WHEN 'II'.
              READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_likp-kunag.
          ENDCASE.
          IF sy-subrc = 0.

            "Dirección punto de llegada
            READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_kna1-adrnr.
            IF sy-subrc = 0.
              CASE gw_license.
*                WHEN '0020974592'.   " DANPER                                          "-010922-NTP-3000018956
*                  IF ls_dire-pais NE 'PE'.                                             "-010922-NTP-3000018956
*                    l_dst_exportacion = abap_on.                                       "-010922-NTP-3000018956
*                  ENDIF.                                                               "-010922-NTP-3000018956
                WHEN '0020311006'  " AIB
                  OR '0020863116'. " AIB CLOUD
                  IF ls_dire-pais NE 'PE' OR ( gw_license = '0020311006' AND ls_likp-zzkvgr2 = 'G' AND ls_likp-lfart = 'ZTRA' ).
                    ls_cab-zzexport = abap_on.
                  ENDIF.
                WHEN OTHERS.
*                      CLEAR l_dst_exportacion.                                         "-010922-NTP-3000018956
                  IF ls_dire-pais NE 'PE'.
                    ls_cab-zzexport = abap_on.
                  ENDIF.
              ENDCASE.
*}I-111219-NTP-3000013055

              IF ls_cab-zzexport = abap_on.
*{-NTP010423-3000020188
*                CLEAR: ls_kna1, ls_dire.
*                LOOP AT gt_const INTO ls_const WHERE campo = 'PARVW_EXP' AND valor1 <> space. "+010922-NTP-3000018956
*                  CLEAR ls_parvw.
*                  ls_parvw-sign   = ls_const-signo.
*                  ls_parvw-option = ls_const-opcion.
*                  ls_parvw-low    = ls_const-valor1.
*                  ls_parvw-high   = ls_const-valor2.
*                  APPEND ls_parvw TO lr_parvw.
*                ENDLOOP.
*                IF lr_parvw IS NOT INITIAL.
*                  LOOP AT gt_vbpa INTO ls_vbpa WHERE vbeln EQ ls_likp-vbeln
*                                                 AND parvw IN lr_parvw.
*                    "Numero de documento de identidad del Interlocutor Z3 del Transporte
*                    IF ls_vbpa-lifnr IS NOT INITIAL.
*                      READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_vbpa-lifnr.
*                    ELSE.
*                      READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_vbpa-kunnr.
*                    ENDIF.
*                    IF sy-subrc EQ 0.
*                      "Apellidos y nombres, denominación o razón social, Ubigeo y Dirección del Interlocutor Z3 del Transporte
*                      READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_vbpa-adrnr.
*                    ENDIF.
*                    EXIT.
*                  ENDLOOP.
*                ENDIF.
*}-NTP010423-3000020188
                get_interlocutor( EXPORTING i_vbeln = ls_likp-vbeln i_campo = 'PARVW_EXP' IMPORTING es_kna1 = ls_kna1 es_dire = ls_dire ). "+NTP010423-3000020188
              ENDIF.
*                ENDIF. "E-111219-NTP-3000013055

              "Destinatario nacional KUNNR, exportacion PARVW_EXP
              IF ls_kna1 IS NOT INITIAL.
                "Destinatario
                ls_cab-zzdstnro = ls_kna1-stcd1.
                ls_cab-zzdsttpd_h = ls_kna1-stcdt.
                IF ls_dire IS NOT INITIAL.
                  "Apellidos y nombres, denominación o razón social
                  CASE gw_license.                                                      "I-WMR-191018-3000009770
                    WHEN '0020311006'  " AIB                                            "I-WMR-191018-3000009770
                      OR '0020863116'. " AIB CLOUD                                      "I-WMR-191018-3000009770
                      CONCATENATE ls_kna1-kunnr                                         "I-WMR-191018-3000009770
                                  abap_undefined                                        "I-WMR-191018-3000009770
                                  ls_dire-name                                          "I-WMR-191018-3000009770
                                  INTO ls_cab-zzdstden SEPARATED BY space.              "I-WMR-191018-3000009770
                    WHEN OTHERS.                                                        "I-WMR-191018-3000009770
                      ls_cab-zzdstden = ls_dire-name.
                  ENDCASE.                                                              "I-WMR-191018-3000009770
*{+010922-NTP-3000018956
                  ls_cab-zzdstubi = ls_dire-ubigeo.       "ubigeo
                  ls_cab-zzdstdir = ls_dire-direccion.    "direccion
                  ls_cab-zzdsturb = ls_dire-urbanizacion. "urbanizacion
                  ls_cab-zzdstdis = ls_dire-distri.       "distrito
                  ls_cab-zzdstpro = ls_dire-provin.       "provincia
                  ls_cab-zzdstdep = ls_dire-depmto.       "departamento
                  ls_cab-zzdstpai = ls_dire-pais.         "pais
*}+010922-NTP-3000018956

                  "Llegada
*{+301222-NTP-3000020710
                  READ TABLE gt_const INTO ls_const WITH KEY campo = 'ZZLLEDIR_PARVW'.
                  IF sy-subrc = 0.
                    get_interlocutor(
                      EXPORTING
                        i_vbeln = ls_likp-vbeln
                        i_parvw = ls_const-valor1
                      IMPORTING
                        es_dire = ls_dire
                    ).
                  ENDIF.

                  READ TABLE gt_const INTO ls_const WITH KEY campo = 'ZZLLEDIR_EQ_ZZPARDIR_SHTYP' valor1 = ls_cab-shtyp.
                  IF sy-subrc = 0.
                    ls_cab-zzlleubi = ls_cab-zzparubi.
                    ls_cab-zzlledir = ls_cab-zzpardir.
                  ELSE.
*}+301222-NTP-3000020710
                    ls_cab-zzlleubi = ls_dire-ubigeo.
                    ls_cab-zzlledir = ls_dire-direccion.  "I-111219-NTP-3000013055

*{I-PBM061222-3000020028
                    "Código de establecimiento
                    CLEAR l_werks.
                    LOOP AT gt_vbpa INTO ls_vbpa WHERE vbeln EQ ls_likp-vbeln
                                                   AND parvw EQ 'WE'.
                      READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_vbpa-kunnr.
                      IF sy-subrc = 0.
                        l_werks = ls_kna1-werks.
                      ENDIF.
                      EXIT.
                    ENDLOOP.
                    get_codigo_estab_sunat( EXPORTING i_werks = l_werks
                                                      ls_lips = ls_lips                     "I-PBM190423-3000020600
                                            CHANGING c_codest = ls_cab-zzlleest ).          "I-PBM061222-3000020028
*}I-PBM061222-3000020028
                  ENDIF.
                ENDIF.

*{-010922-NTP-3000018956
*                WHEN OTHERS.
**    }  END OF INSERT WMR-260517-3000007333
*
*                  "Apellidos y nombres, denominación o razón social del destinatario
*                  ls_cab-zzdstden = ls_dire-name.
*
*                  "Ubigeo
*                  ls_cab-zzlleubi = ls_dire-ubigeo.
*
*                  "Dirección completa y detallada
*                  ls_cab-zzlledir = ls_dire-direccion.  "I-111219-NTP-3000013055
*
*              ENDCASE.
*}-010922-NTP-3000018956
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
    ENDCASE.

*{I-251220-NTP-3000014557
    " Destinatario intermedio 1
    CASE gw_license.
      WHEN '0021154274'. "Ilender
        " Desde el destinatario de mercancías
        READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_likp-kunnr.
        "Numero de documento de identidad
        ls_cab-zzdi1nro = ls_kna1-stcd1.
        "Tipo de N°doc. identidad
        ls_cab-zzdi1tpd_h = ls_kna1-stcdt.

        READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_kna1-adrnr.
        IF sy-subrc = 0.
          "Apellidos y nombres, denominación o razón social del destinatario
          ls_cab-zzdi1den = ls_dire-name.
          " Dirección completa
          ls_cab-zzdi1dir = ls_dire-direccion.
        ENDIF.

        " Nacional enviar si tiene interlocutor DI
        IF ls_cab-zzdstpai = 'PE'.
          READ TABLE gt_vbpa INTO ls_vbpa WITH KEY vbeln = ls_likp-vbeln
                                                   parvw = 'DI'.
          IF sy-subrc = 0.
            READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_vbpa-adrnr.
            IF sy-subrc = 0.
              ls_cab-zzdi1dir = ls_dire-direccion.
            ENDIF.
          ELSE.
            CLEAR: ls_cab-zzdi1nro, ls_cab-zzdi1den, ls_cab-zzdi1dir.
          ENDIF.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.
*}I-251220-NTP-3000014557

  ENDMETHOD.


  METHOD set_data_rem_destino_llegada_z.
    DATA: ls_dire  TYPE gty_direccion,
          ls_lips  LIKE LINE OF it_lips,
          ls_kna1  LIKE LINE OF gth_kna1,
          ls_twlad LIKE LINE OF gth_twlad,
          ls_t001w LIKE LINE OF gth_t001w.

    DATA: l_codigo TYPE lifnr,
          l_adrnr  TYPE adrnr.

    READ TABLE it_lips INTO ls_lips WITH KEY vbeln = ls_likp-vbeln.

    IF ls_cab-is_trasladointerno IS NOT INITIAL.
      "Destinatario
      ls_cab-zzdstnro   = ls_cab-zzremnro.
      ls_cab-zzdsttpd_h = ls_cab-zzremtpd_h.
      ls_cab-zzdstden   = ls_cab-zzremden.

      READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_likp-kunnr.
      IF sy-subrc = 0.
        READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_kna1-adrnr.
        IF sy-subrc = 0.
          ls_cab-zzdstubi = ls_dire-ubigeo.       "ubigeo
          ls_cab-zzdstdir = ls_dire-direccion.    "direccion
          ls_cab-zzdsturb = ls_dire-urbanizacion. "urbanizacion
          ls_cab-zzdstdis = ls_dire-distri.       "distrito
          ls_cab-zzdstpro = ls_dire-provin.       "provincia
          ls_cab-zzdstdep = ls_dire-depmto.       "departamento
          ls_cab-zzdstpai = ls_dire-pais.         "pais
        ENDIF.
      ENDIF.

      "Llegada
      ls_cab-zzlleubi   = ls_dire-ubigeo.
      ls_cab-zzlledir   = ls_dire-direccion.
      ls_cab-zzlleest   = ls_cab-zzparest.

      IF ls_cab-is_trasladointerno EQ 'X'.
*        get_codigo_estab_sunat( EXPORTING i_werks = ls_likp-zzparwer CHANGING c_codest = ls_cab-zzlleest ).
      ENDIF.
    ELSE.

      "Centro
      IF ls_likp-zzdstwer IS NOT INITIAL.
        "Destinatario
        ls_cab-zzdstnro   = ls_cab-zzremnro.
        ls_cab-zzdsttpd_h = ls_cab-zzremtpd_h.
        ls_cab-zzdstden   = ls_cab-zzremden.

        READ TABLE gth_twlad INTO ls_twlad WITH TABLE KEY werks = ls_likp-zzdstwer lgort = ls_likp-zzdstlgo.
        IF sy-subrc = 0.
          l_adrnr = ls_twlad-adrnr.
        ELSE.
          READ TABLE gth_t001w INTO ls_t001w WITH TABLE KEY werks = ls_likp-zzdstwer.
          IF sy-subrc = 0.
            l_adrnr = ls_t001w-adrnr.
          ENDIF.
        ENDIF.
        READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = l_adrnr.
        IF sy-subrc = 0.
          ls_cab-zzlleubi = ls_dire-ubigeo.     "ubigeo
          ls_cab-zzlledir = ls_dire-direccion.  "direccion
        ENDIF.

        get_codigo_estab_sunat( EXPORTING i_werks = ls_likp-zzdstwer
                                          ls_lips = ls_lips
                                CHANGING c_codest = ls_cab-zzlleest ).
      ELSE.
        IF ls_likp-lifnr IS NOT INITIAL.
          l_codigo = ls_likp-lifnr.
        ELSE.
          l_codigo = ls_likp-kunnr.
        ENDIF.

        "Cliente
        READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = l_codigo.
        IF sy-subrc = 0.

          "Dirección punto de llegada
          READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_kna1-adrnr.
          IF sy-subrc = 0.
            IF ls_dire-pais NE 'PE'.
              ls_cab-zzexport = abap_on.
            ENDIF.

            "Destinatario
            ls_cab-zzdstnro = ls_kna1-stcd1.
            ls_cab-zzdsttpd_h = ls_kna1-stcdt.
            ls_cab-zzdstden = ls_dire-name.
            ls_cab-zzdstubi = ls_dire-ubigeo.       "ubigeo
            ls_cab-zzdstdir = ls_dire-direccion.    "direccion
            ls_cab-zzdsturb = ls_dire-urbanizacion. "urbanizacion
            ls_cab-zzdstdis = ls_dire-distri.       "distrito
            ls_cab-zzdstpro = ls_dire-provin.       "provincia
            ls_cab-zzdstdep = ls_dire-depmto.       "departamento
            ls_cab-zzdstpai = ls_dire-pais.         "pais
          ENDIF.
        ENDIF.
      ENDIF.


      "Llegada
      READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_likp-zzllelif.
      IF sy-subrc = 0.
        READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_kna1-adrnr.
      ELSE.
        READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_likp-zzllekun.
        IF sy-subrc = 0.
          READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_kna1-adrnr.
        ENDIF.
      ENDIF.
      ls_cab-zzlleubi = ls_dire-ubigeo.
      ls_cab-zzlledir = ls_dire-direccion.
    ENDIF.

  ENDMETHOD.


  METHOD set_data_rem_emision_partida.

    DATA: ls_dire  TYPE gty_direccion,
          ls_lips  LIKE LINE OF it_lips,
          ls_t001w LIKE LINE OF gth_t001w,
          ls_twlad LIKE LINE OF gth_twlad,
          ls_tvst  TYPE gty_tvst,
          ls_const LIKE LINE OF gt_const. "+011022-NTP-3000018956

    READ TABLE it_lips INTO ls_lips WITH KEY vbeln = ls_likp-vbeln.

    CASE gw_license.
      WHEN '0020886706'. "Piramide
        "Dirección punto de partida
*        READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = zpiramide-s_soli-adrnr. "E-WMR-051018-3000010624
*        IF sy-subrc = 0.                                                          "E-WMR-051018-3000010624
*          "Ubigeo                                                                 "E-WMR-051018-3000010624
*          ls_cab-zzparubi = ls_dire-ubigeo.                                       "E-WMR-051018-3000010624

*          "Dirección completa y detallada                                         "E-WMR-051018-3000010624
*          ls_cab-zzpardir = zpiramide-s_soli-zzpardir.                            "E-WMR-051018-3000010624

        READ TABLE it_lips INTO ls_lips WITH KEY vbeln = ls_likp-vbeln.           "I-WMR-051018-3000010624
        IF sy-subrc = 0.                                                          "I-WMR-051018-3000010624
          READ TABLE gth_t001w INTO ls_t001w WITH TABLE KEY werks = ls_lips-werks."I-WMR-051018-3000010624
          IF sy-subrc = 0.                                                        "I-WMR-051018-3000010624
            READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_t001w-adrnr."I-WMR-051018-3000010624
            IF sy-subrc = 0.                                                      "I-WMR-051018-3000010624
              " Ubigeo                                                            "I-WMR-051018-3000010624
              ls_cab-zzparubi = ls_dire-ubigeo.                                   "I-WMR-051018-3000010624
              " Dirección completa                                                "I-WMR-051018-3000010624
              ls_cab-zzpardir = ls_dire-direccion.                                "+NTP02022023-3000019902
**              ls_cab-zzpardir2 = ls_dire-direccion.                               "+NTP02022023-3000019902
              CONCATENATE ls_dire-street                                          "I-WMR-051018-3000010624
                          ls_dire-stnumb                                          "I-WMR-051018-3000010624
                          INTO ls_cab-zzpardir SEPARATED BY space.                "I-WMR-051018-3000010624
              CONDENSE ls_cab-zzpardir. TRANSLATE ls_cab-zzpardir TO UPPER CASE.  "I-WMR-051018-3000010624
              " Urbanización                                                      "I-WMR-051018-3000010624
              CONCATENATE ls_dire-str_suppl1                                      "I-WMR-051018-3000010624
                          ls_dire-str_suppl2                                      "I-WMR-051018-3000010624
                          ls_dire-str_suppl3                                      "I-WMR-051018-3000010624
                          INTO ls_cab-zzparurb SEPARATED BY space.                "I-WMR-051018-3000010624
              CONDENSE ls_cab-zzparurb. TRANSLATE ls_cab-zzparurb TO UPPER CASE.  "I-WMR-051018-3000010624
              " Distrito                                                          "I-WMR-051018-3000010624
              ls_cab-zzpardis = ls_dire-distri.                                   "I-WMR-051018-3000010624
              CONDENSE ls_cab-zzpardis. TRANSLATE ls_cab-zzpardis TO UPPER CASE.  "I-WMR-051018-3000010624
              " Provincia                                                         "I-WMR-051018-3000010624
              ls_cab-zzparpro = ls_dire-provin.                                   "I-WMR-051018-3000010624
              CONDENSE ls_cab-zzparpro. TRANSLATE ls_cab-zzparpro TO UPPER CASE.  "I-WMR-051018-3000010624
              " Departamento                                                      "I-WMR-051018-3000010624
              ls_cab-zzpardep = ls_dire-depmto.                                   "I-WMR-051018-3000010624
              CONDENSE ls_cab-zzpardep. TRANSLATE ls_cab-zzpardep TO UPPER CASE.  "I-WMR-051018-3000010624
              " País                                                              "I-WMR-051018-3000010624
              ls_cab-zzparpai = ls_dire-pais.                                     "I-WMR-051018-3000010624
              CONDENSE ls_cab-zzparpai. TRANSLATE ls_cab-zzparpai TO UPPER CASE.  "I-WMR-051018-3000010624
            ENDIF.                                                                "I-WMR-051018-3000010624
          ENDIF.                                                                  "I-WMR-051018-3000010624
        ENDIF.

        " Punto de Emisión                                                        "I-WMR-250918-3000010450
        READ TABLE it_lips INTO ls_lips WITH KEY vbeln = ls_likp-vbeln.           "I-WMR-250918-3000010450
        IF sy-subrc = 0.                                                          "I-WMR-250918-3000010450
          READ TABLE gth_t001w INTO ls_t001w WITH TABLE KEY werks = ls_lips-werks."I-WMR-250918-3000010450
          IF sy-subrc = 0.                                                        "I-WMR-250918-3000010450
            READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_t001w-adrnr."I-WMR-250918-3000010450
            IF sy-subrc = 0.                                                      "I-WMR-250918-3000010450
              " Ubigeo                                                            "I-WMR-250918-3000010450
              ls_cab-zzpemubi = ls_dire-ubigeo.                                   "I-WMR-250918-3000010450
              " Dirección completa                                                "I-WMR-250918-3000010450
              ls_cab-zzpemdir = ls_dire-direccion.                                "+NTP02022023-3000019902
**              ls_cab-zzpemdir2 = ls_dire-direccion.                               "+NTP02022023-3000019902
              CONCATENATE ls_dire-street                                          "I-WMR-250918-3000010450
                          ls_dire-stnumb                                          "I-WMR-250918-3000010450
                          INTO ls_cab-zzpemdir SEPARATED BY space.                "I-WMR-250918-3000010450
              CONDENSE ls_cab-zzpemdir. TRANSLATE ls_cab-zzpemdir TO UPPER CASE.  "I-WMR-250918-3000010450
              " Urbanización                                                      "I-WMR-250918-3000010450
              CONCATENATE ls_dire-str_suppl1                                      "I-WMR-250918-3000010450
                          ls_dire-str_suppl2                                      "I-WMR-250918-3000010450
                          ls_dire-str_suppl3                                      "I-WMR-250918-3000010450
                          INTO ls_cab-zzpemurb SEPARATED BY space.                "I-WMR-250918-3000010450
              CONDENSE ls_cab-zzpemurb. TRANSLATE ls_cab-zzpemurb TO UPPER CASE.  "I-WMR-250918-3000010450
              " Distrito                                                          "I-WMR-250918-3000010450
              ls_cab-zzpemdis = ls_dire-distri.                                   "I-WMR-250918-3000010450
              CONDENSE ls_cab-zzpemdis. TRANSLATE ls_cab-zzpemdis TO UPPER CASE.  "I-WMR-250918-3000010450
              " Provincia                                                         "I-WMR-250918-3000010450
              ls_cab-zzpempro = ls_dire-provin.                                   "I-WMR-250918-3000010450
              CONDENSE ls_cab-zzpempro. TRANSLATE ls_cab-zzpempro TO UPPER CASE.  "I-WMR-250918-3000010450
              " Departamento                                                      "I-WMR-250918-3000010450
              ls_cab-zzpemdep = ls_dire-depmto.                                   "I-WMR-250918-3000010450
              CONDENSE ls_cab-zzpemdep. TRANSLATE ls_cab-zzpemdep TO UPPER CASE.  "I-WMR-250918-3000010450
              " País                                                              "I-WMR-250918-3000010450
              ls_cab-zzpempai = ls_dire-pais.                                     "I-WMR-250918-3000010450
              CONDENSE ls_cab-zzpempai. TRANSLATE ls_cab-zzpempai TO UPPER CASE.  "I-WMR-250918-3000010450
            ENDIF.                                                                "I-WMR-250918-3000010450
          ENDIF.                                                                  "I-WMR-250918-3000010450
        ENDIF.                                                                    "I-WMR-250918-3000010450
*}I-NTP180918-3000010450

*{I-041219-NTP-3000013055
      WHEN '0020311006'  "AIB
        OR '0020863116'. "AIB CLOUD
        LOOP AT it_lips INTO ls_lips WHERE vbeln = ls_likp-vbeln AND lgort IS NOT INITIAL.
          EXIT.
        ENDLOOP.
        READ TABLE gth_twlad INTO ls_twlad WITH TABLE KEY werks = ls_lips-werks lgort = ls_lips-lgort.
        IF sy-subrc = 0.
          READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_twlad-adrnr.
          IF sy-subrc = 0.
            "Ubigeo
            ls_cab-zzparubi = ls_dire-ubigeo.

            "Dirección completa y detallada
            ls_cab-zzpardir = ls_dire-direccion.
          ENDIF.
        ENDIF.
*}I-041219-NTP-3000013055

      WHEN OTHERS.

*{+011022-NTP-3000018956
        READ TABLE gt_const INTO ls_const WITH KEY campo = 'PTO_PARTIDA_PARVW_LFART' valor2 = ls_likp-lfart.
        IF sy-subrc = 0.
          get_interlocutor(
            EXPORTING
              i_vbeln = ls_likp-vbeln
              i_parvw = ls_const-valor1
            IMPORTING
              es_dire = ls_dire
          ).
        ELSE.
*}+011022-NTP-3000018956
          READ TABLE gth_tvst INTO ls_tvst WITH TABLE KEY vstel = ls_likp-vstel.
          IF sy-subrc = 0.
            READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_tvst-adrnr.
*            IF sy-subrc = 0.                                                       "-011022-NTP-3000018956
          ENDIF.                                                                    "+011022-NTP-3000018956
        ENDIF.                                                                      "+011022-NTP-3000018956
        IF ls_dire IS NOT INITIAL.                                                  "+011022-NTP-3000018956
          "Ubigeo
          ls_cab-zzparubi = ls_dire-ubigeo.

          "Dirección completa y detallada
          CONCATENATE ls_dire-street
                      ls_dire-stnumb
                      ls_dire-str_suppl1
                      ls_dire-str_suppl2
                      ls_dire-str_suppl3
                      ls_dire-depmto
                      ls_dire-provin
                      ls_dire-distri INTO ls_cab-zzpardir SEPARATED BY space.
          ls_cab-zzpardir = ls_dire-direccion.                                     "+NTP02022023-3000019902
**          ls_cab-zzpardir2 = ls_dire-direccion.                                    "+NTP02022023-3000019902
          "Código de establecimiento
          get_codigo_estab_sunat( EXPORTING i_werks = ls_likp-vstel
                                            ls_lips = ls_lips                       "I-PBM190423-3000020600
                                  CHANGING c_codest = ls_cab-zzparest ).            "I-PBM061222-3000020028
        ENDIF.
*        ENDIF.                                                                     "-011022-NTP-3000018956
*        ENDIF.                                                                     "-011022-NTP-3000018956

    ENDCASE.

  ENDMETHOD.


  METHOD set_data_rem_emision_partida_z.

    DATA: ls_kna1  LIKE LINE OF gth_kna1,
          ls_dire  TYPE gty_direccion,
          ls_lips  LIKE LINE OF it_lips,
          ls_twlad LIKE LINE OF gth_twlad,
          ls_t001w LIKE LINE OF gth_t001w,

          l_adrnr  TYPE adrnr.

    READ TABLE it_lips INTO ls_lips WITH KEY vbeln = ls_likp-vbeln.

    "Centro
    IF ls_likp-zzparwer IS NOT INITIAL.
      READ TABLE gth_twlad INTO ls_twlad WITH TABLE KEY werks = ls_likp-zzparwer lgort = ls_likp-zzparlgo.
      IF sy-subrc = 0.
        l_adrnr = ls_twlad-adrnr.
      ELSE.
        READ TABLE gth_t001w INTO ls_t001w WITH TABLE KEY werks = ls_likp-zzparwer.
        IF sy-subrc = 0.
          l_adrnr = ls_t001w-adrnr.
        ENDIF.
      ENDIF.
      READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = l_adrnr.
      IF sy-subrc = 0.
        ls_cab-zzparubi = ls_dire-ubigeo.
        ls_cab-zzpardir = ls_dire-direccion.
      ENDIF.

      get_codigo_estab_sunat( EXPORTING i_werks = ls_likp-zzparwer
                                        ls_lips = ls_lips
                              CHANGING c_codest = ls_cab-zzparest ).
    ELSE.

      "Proveedor
      READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_likp-zzparlif.
      IF sy-subrc = 0.
        READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_kna1-adrnr.
        IF sy-subrc = 0.
          ls_cab-zzparubi = ls_dire-ubigeo.
          ls_cab-zzpardir = ls_dire-direccion.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD set_data_rem_gr_transportista.

    DATA: ls_lips       LIKE LINE OF it_lips,
          ls_const      LIKE LINE OF gt_const,
          lt_but000     TYPE TABLE OF gty_kna1,
          ls_but000     LIKE LINE OF lt_but000,
          ls_cab_his    LIKE LINE OF gt_cab_his,
          ls_grt_docrel LIKE LINE OF cs_cab-grt_docrel.

    CHECK is_likp-is_gr_transportista IS NOT INITIAL.

    "1. Documentos relacionados: transportados
    LOOP AT gt_cab_his INTO ls_cab_his.
      ls_grt_docrel-zznrosun = ls_cab_his-zznrosun.
      ls_grt_docrel-zztipdoc = ls_cab_his-zztipgui.
      ls_grt_docrel-zzremnro = ls_cab_his-zzremnro.
      ls_grt_docrel-zzremtpd_h = ls_cab_his-zzremtpd_h.
      APPEND ls_grt_docrel TO cs_cab-grt_docrel.
    ENDLOOP.

    "1. Traslado: Indicadores de envio sunat
    cs_cab-zzindenv_tp = gc_no.
    cs_cab-zzindenv_rv = gc_no.
    cs_cab-zzindenv_rve = gc_no.
    cs_cab-zzindenv_ts = gc_no.
    cs_cab-zzindenv_pft = gc_no.

    LOOP AT it_lips INTO ls_lips WHERE vbeln = is_likp-vbeln.
      LOOP AT gt_const INTO ls_const WHERE valor1 = ls_lips-matnr.
        CASE ls_const-campo.
          WHEN 'MATNR_INDENV_TRANSBORDO_PROG'.
            cs_cab-zzindenv_tp = gc_si.
          WHEN 'MATNR_INDENV_RETORNOVACIO'.
            cs_cab-zzindenv_rv = gc_si.
          WHEN 'MATNR_INDENV_RETORNOVACIO_ENVA'.
            cs_cab-zzindenv_rve = gc_si.
          WHEN 'MATNR_INDENV_SUBCONTRATADO'.
            cs_cab-zzindenv_ts = gc_si.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    READ TABLE gt_const INTO ls_const WITH KEY campo = 'IS_INDENV_FLETE_TERCERO'.
    IF ls_const-valor1 IS NOT INITIAL.
      cs_cab-zzindenv_pft = 'OTRO (Tercero)'.
    ENDIF.

    "2. Pagador flete
    IF is_likp-bolnr IS NOT INITIAL.
      "2.1 Pagador flete registrado por usuario
      SELECT partner AS kunnr name_first AS name1 name_last AS name2
        INTO CORRESPONDING FIELDS OF TABLE lt_but000
        FROM but000
        WHERE partner EQ is_likp-bolnr.

      s4_completar_datos_nif( EXPORTING ip_type = 'I' CHANGING  ct_kna1 = lt_but000 ).
      READ TABLE lt_but000 INTO ls_but000 WITH KEY kunnr = is_likp-bolnr.
      IF sy-subrc = 0.
        cs_cab-zzgrt_pftnro   = ls_but000-stcd1.
        cs_cab-zzgrt_pfttpd_h = ls_but000-stcdt.
        CONCATENATE ls_but000-name1 ls_but000-name2 INTO cs_cab-zzgrt_pftden SEPARATED BY space.
      ENDIF.
    ELSE.
      "2.2 Pagador flete - solicitante de gr remitente
      READ TABLE gt_cab_his INTO ls_cab_his INDEX 1.
      IF sy-subrc = 0.
        cs_cab-zzgrt_pftnro   = ls_cab_his-zzslcnro.
        cs_cab-zzgrt_pfttpd_h = ls_cab_his-zzslctpd_h.
        cs_cab-zzgrt_pftden   = ls_cab_his-zzslcnro.
      ENDIF.
    ENDIF.


  ENDMETHOD.


  METHOD set_data_rem_item.

    DATA: ls_lips  LIKE LINE OF it_lips,
          ls_lips1 LIKE LINE OF it_lips,
          ls_det   LIKE LINE OF et_det,
          ls_const LIKE LINE OF gt_const,
          ls_mara  LIKE LINE OF gth_mara.                         "I-PBM190423-3000020600

    DATA: l_text   TYPE string,                   "I-PBM081222-3000019824
          ls_thead TYPE thead.                    "I-PBM081222-3000019824
    DATA: ls_ekpo  LIKE LINE OF gt_ekpo.     "I-PBM160123-3000020028

    LOOP AT it_lips INTO ls_lips WHERE vbeln = ls_likp-vbeln
                                   AND uecha IS INITIAL.

      "Campos SAP Standard
*      ls_det-vbeln = ls_lips-vbeln.      "-NTP010423-3000020188
      ls_det-zznrosap = ls_cab-zznrosap.  "+NTP010523-3000020188
      ls_det-zzgjahr  = ls_cab-zzgjahr.   "+NTP010523-3000020188
      ls_det-posnr = ls_lips-posnr.
      ls_det-matnr = ls_lips-matnr.
      ls_det-arktx = ls_lips-arktx.
      ls_det-matkl = ls_lips-matkl.
      ls_det-werks = ls_lips-werks.
      ls_det-lgort = ls_lips-lgort.
      ls_det-charg = ls_lips-charg.
      ls_det-lfimg = ls_lips-lfimg.
      ls_det-meins = ls_lips-meins.
      ls_det-vrkme = ls_lips-vrkme.
      ls_det-brgew = ls_lips-brgew.
      ls_det-gewei = ls_lips-gewei.

      "Campos Guia Remisión
      ls_det-zznrosun = ls_cab-zznrosun.
      ls_det-zzitepos = ls_lips-posnr.    "Número de orden del ítem
      ls_det-zzitedes = read_text_vbbk_zconst( i_campo = 'TDID_D_MAT' i_vbeln = ls_det-zznrosap i_posnr = ls_det-posnr i_kunnr = ls_likp-kunag ). "I-3000013055-NTP-031219
      IF ls_det-zzitedes IS INITIAL.
        READ TABLE gt_ekpo INTO ls_ekpo WITH KEY ebeln = ls_lips-vgbel                "I-PBM160123-3000020028
                                                 ebelp = ls_lips-vgpos.               "I-PBM160123-3000020028
        IF sy-subrc = 0.                                                              "I-PBM160123-3000020028
          ls_det-zzitedes = ls_ekpo-txz01.                                            "I-PBM160123-3000020028
        ELSE.                                                                         "I-PBM160123-3000020028
          ls_det-zzitedes = ls_lips-arktx.    "Descripción detallada del ítem
        ENDIF.                                                                        "I-PBM160123-3000020028
      ENDIF.

*{+081122-NTP-3000020296
      "Adicionar texto const a descripcion
      CASE gw_license.
        WHEN '0020767991'. "inka
          READ TABLE zconst-pstyv_zzitedes_add_text INTO ls_const WITH KEY valor1 = ls_lips-pstyv.
          IF sy-subrc = 0.
            CONCATENATE ls_det-zzitedes ls_const-valor2 INTO ls_det-arktx SEPARATED BY space.
          ENDIF.
*{I-PBM081222-3000019824
        WHEN '0021274341'. "LIFE
          "Descripción Maestro Material
          CLEAR: ls_thead, l_text.
          ls_thead-tdobject = 'MATERIAL'.
          ls_thead-tdid     = 'GRUN'.
          ls_thead-tdname   = ls_lips-matnr.
          SELECT SINGLE spras INTO ls_thead-tdspras FROM kna1 WHERE kunnr = ls_likp-kunag.
          l_text = read_text( ls_thead ).
          IF l_text IS INITIAL.
            ls_thead-tdspras = sy-langu.
            l_text = read_text( ls_thead ).
          ENDIF.

          "Descripción Maestro Material + Lote
          CONCATENATE l_text ls_lips-charg INTO l_text.
          ls_det-zzitedes = l_text.
          IF ls_det-zzitedes IS INITIAL.
            ls_det-zzitedes = ls_lips-arktx.    "Descripción detallada del ítem
          ENDIF.
*}I-PBM081222-3000019824
      ENDCASE.
*}+081122-NTP-3000020296

*{  BEGIN OF REPLACE WMR-260517-3000007333
      ""      ls_det-zzitecod = ls_lips-matnr.    "Código del ítem
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
        EXPORTING
          input  = ls_lips-matnr
        IMPORTING
          output = ls_det-zzitecod.
*}  END OF REPLACE WMR-260517-3000007333
*{I-PBM190423-3000020600
      IF ls_det-zzitecod IS INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
          EXPORTING
            input  = ls_lips-kdmat_matnr
          IMPORTING
            output = ls_det-zzitecod.
      ENDIF.
*}I-PBM190423-3000020600

*{+3000018956-010722-NTP
      "Si no hay, buscar en las constantes código genérico
      IF ls_det-zzitecod_h IS INITIAL.
        READ TABLE gt_const INTO ls_const WITH KEY campo = 'CODCUB_GEN'.
        IF sy-subrc = 0.
          ls_det-zzitecod_h = ls_const-valor1.
        ENDIF.
      ENDIF.
*}+3000018956-010722-NTP

      ls_det-zziteqty = ls_lips-lfimg.    "Cantidad del ítem
      ls_det-zziteund_h = ls_lips-vrkme.  "Unidad de medida del ítem

      CASE gw_license.                                                            "I-WMR-211118-3000010936
        WHEN '0020886706'.  " PIRAMIDE                                            "I-WMR-211118-3000010936
          ls_det-zzitepbt = ls_lips-ntgew.       "Peso neto                       "I-WMR-211118-3000010936
        WHEN OTHERS.                                                              "I-WMR-211118-3000010936
          ls_det-zzitepbt = ls_lips-brgew.       "Peso bruto total
      ENDCASE.                                                                    "I-WMR-211118-3000010936
      ls_det-zziteunp = ls_lips-gewei.       "Unidad de peso

      LOOP AT it_lips INTO ls_lips1 WHERE uecha = ls_lips-posnr.
        ADD ls_lips1-lfimg TO ls_det-zziteqty.  "Cantidad del ítem
        CASE gw_license.                                                          "I-WMR-211118-3000010936
          WHEN '0020886706'.  " PIRAMIDE                                          "I-WMR-211118-3000010936
            ADD ls_lips1-ntgew TO ls_det-zzitepbt.  "Peso neto                    "I-WMR-211118-3000010936
          WHEN OTHERS.                                                            "I-WMR-211118-3000010936
            ADD ls_lips1-brgew TO ls_det-zzitepbt.  "Peso bruto total
        ENDCASE.                                                                  "I-WMR-211118-3000010936
      ENDLOOP.
*{E-3000009770-NTP180119
*      IF sy-subrc = 0.
*        ls_det-zziteund_h = ls_lips1-meins.  "Unidad de medida del ítem
*        ls_det-zziteunp   = ls_lips1-gewei.  "Unidad de peso
*      ENDIF.
*}E-3000009770-NTP180119

*{  BEGIN OF INSERT WMR-260517-3000007333
      " Unidad de Medida de Impresión PDF
      READ TABLE gt_const INTO ls_const WITH KEY campo = 'UNMEDSAP'.
      IF ( sy-subrc EQ 0 AND ls_const-valor1 EQ abap_true ).
        CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
          EXPORTING
            input          = ls_det-zziteund_h
          IMPORTING
            output         = ls_det-zziteund
          EXCEPTIONS
            unit_not_found = 1
            OTHERS         = 2.
      ELSE.
        ls_det-zziteund = ls_det-zziteund_h.
      ENDIF.
*}  END OF INSERT WMR-260517-3000007333

*{  BEGIN OF REPLACE WMR-030717-3000007333
      ""      IF ls_det-lfimg IS NOT INITIAL.
      ""        ls_det-zzitepbr = ls_lips-brgew / ls_lips-lfimg. "Peso bruto x Item
      ""      ENDIF.
      "Peso bruto x Item
      IF ls_det-zziteqty IS NOT INITIAL.
        ls_det-zzitepbr = ls_det-zzitepbt / ls_det-zziteqty.
      ENDIF.
*}  END OF REPLACE WMR-030717-3000007333

      ls_det-zztxtpos = set_aditional_text_pos( is_likp = ls_likp                     "I-WMR-080119-3000011134
                                                is_lips = ls_lips                     "I-WMR-080119-3000011134
                                                it_lips = it_lips ).                  "I-WMR-080119-3000011134

*{I-PBM190423-3000020600
      READ TABLE gth_mara INTO ls_mara WITH TABLE KEY matnr = ls_lips-matnr.
      IF sy-subrc <> 0.
        READ TABLE gth_mara INTO ls_mara WITH TABLE KEY matnr = ls_lips-kdmat_matnr.
      ENDIF.
      IF sy-subrc = 0.
        ls_det-zz_normt = ls_mara-normt.   "Número de Parte
      ENDIF.

      "Cubso
      get_material_codigo_cubso( EXPORTING is_likp = ls_likp is_lips = ls_lips RECEIVING r_material_sunat = ls_det-zz_material_sunat ).
*}I-PBM190423-3000020600

      APPEND ls_det TO et_det.
      CLEAR ls_det.
    ENDLOOP.

  ENDMETHOD.


  METHOD set_data_rem_observacion.

    DATA: ls_const LIKE LINE OF gt_const,
          ls_thead TYPE thead.

    ls_thead-tdobject = 'VBBK'.
***{  BEGIN OF INSERT WMR-290118-3000008769
**    CASE gw_license.
**      WHEN '0020886706'   " PIRAMIDE
**        OR '0020311006'   " AIB                                                       "I-WMR-191018-3000009770
**        OR '0021061097'.  " CMH                                                       "I-WMR-071218-3000009765
**        READ TABLE gt_const INTO ls_const WITH KEY campo = 'GRTXTOBS'.
**        IF sy-subrc EQ 0.
**          ls_thead-tdid = ls_const-valor1.
**        ENDIF.
**      WHEN '0020974592'.  " DANPER
**        ls_thead-tdid     = 'Z021'.
**    ENDCASE.
***}  END OF INSERT WMR-290118-3000008769
*{+071122-NTP-3000020296
    LOOP AT gt_const INTO ls_const WHERE campo = 'GRTXTOBS' OR campo = 'ZZOBSERV'.
      ls_thead-tdid = ls_const-valor1.
    ENDLOOP.
    IF ls_thead-tdid IS NOT INITIAL.

*{+081122-NTP-3000020296
      CASE gw_license.
        WHEN '0020767991'. "inka
          DATA: ls_vttp LIKE LINE OF gth_vttp.

          ls_thead-tdobject = 'VTTK'.
          ls_thead-tdspras  = sy-langu.
          READ TABLE gth_vttp INTO ls_vttp WITH TABLE KEY vbeln = ls_likp-vbeln.
          IF sy-subrc = 0.
            ls_thead-tdname = ls_vttp-tknum.
            ls_cab-zzobserv = read_text( ls_thead ).
          ENDIF.

        WHEN OTHERS.
*}+081122-NTP-3000020296
          ls_thead-tdname   = ls_likp-vbeln.
          SELECT SINGLE langu INTO ls_thead-tdspras   " Tomar Idioma del Dato maestro
            FROM vbpa AS v INNER JOIN adrc AS a
            ON v~adrnr EQ a~addrnumber
            WHERE vbeln EQ ls_likp-vbeln
              AND posnr EQ 0
              AND parvw EQ 'WE'.
          ls_cab-zzobserv = read_text( ls_thead ).
          IF ls_cab-zzobserv IS INITIAL.
            ls_thead-tdspras  = sy-langu.
            ls_cab-zzobserv = read_text( ls_thead ).
          ENDIF.
      ENDCASE.
    ENDIF.

  ENDMETHOD.


  METHOD set_data_rem_pallet.

    DATA: lt_vekp  TYPE TABLE OF vekp,
          lt_vekp1 TYPE TABLE OF vekp,
          lt_vepo  TYPE TABLE OF vepo,
          lt_ausp  TYPE TABLE OF ausp,
          lr_atinn TYPE RANGE OF ausp-atinn,
          ls_atinn LIKE LINE OF lr_atinn,
          ls_const LIKE  LINE OF gt_const,
          ls_vepo  TYPE vepo,
          ls_thead TYPE thead,
          l_text   TYPE string,
          lo_error TYPE REF TO cx_root,
          lc_klart TYPE ausp-klart VALUE '001',
          ls_ausp  TYPE ausp,
          ls_vbfa  TYPE vbfa,             "+011022-NTP-3000018956
          lt_preci TYPE TABLE OF string,  "+011022-NTP-3000018956
          ls_preci LIKE LINE OF lt_preci, "+011022-NTP-3000018956
          ls_vekp  LIKE LINE OF lt_vekp,  "I-PBM081222-3000019824
          ls_lips  LIKE LINE OF it_lips.
*          LS_PACKING    TYPE ZOSTB_PACKING,    "+@KAR
*          LS_DB_REFDOC  TYPE /SCDL/DB_REFDOC,  "+@KAR
*          LS_DB_PROCH_O TYPE /SCDL/DB_PROCH_O. "+@KAR

    "Número de bultos o pallets
    ls_cab-zzpalnum = ls_likp-anzpk.

*{  BEGIN OF INSERT WMR-260517-3000007333
    CASE gw_license.
      WHEN '0020974592'.  " DANPER
        LOOP AT gt_const INTO ls_const.
          CASE ls_const-campo.
            WHEN 'ATINN_PRES'.  " Presentación: Código de característica
              CLEAR ls_atinn.
              ls_atinn-sign   = ls_const-signo.
              ls_atinn-option = ls_const-opcion.
              CALL FUNCTION 'CONVERSION_EXIT_ATINN_INPUT'
                EXPORTING
                  input  = ls_const-valor1
                IMPORTING
                  output = ls_atinn-low.
              CALL FUNCTION 'CONVERSION_EXIT_ATINN_INPUT'
                EXPORTING
                  input  = ls_const-valor2
                IMPORTING
                  output = ls_atinn-high.
              APPEND ls_atinn TO lr_atinn.
          ENDCASE.
        ENDLOOP.
    ENDCASE.
*}  END OF INSERT WMR-260517-3000007333

    CASE gw_license.
      WHEN '0020974592'.  " DANPER
        CLEAR: lt_vekp, lt_vekp1, lt_vepo.
        SELECT venum vpobj vpobjkey uevel packvorschr
          INTO CORRESPONDING FIELDS OF TABLE lt_vekp1
          FROM vekp
          WHERE vpobj    EQ '01'
            AND vpobjkey EQ ls_likp-vbeln.

        " Paletas
        lt_vekp[] = lt_vekp1[].
        DELETE lt_vekp WHERE uevel IS INITIAL.
        ls_cab-zzpalnum = lines( lt_vekp ).

        " Total de Unidades
        lt_vekp[] = lt_vekp1[].
        DELETE lt_vekp WHERE uevel IS NOT INITIAL.
        IF lt_vekp[] IS NOT INITIAL.
          SELECT venum vepos matnr vemng
            INTO CORRESPONDING FIELDS OF TABLE lt_vepo
            FROM vepo
            FOR ALL ENTRIES IN lt_vekp
            WHERE venum EQ lt_vekp-venum.
          READ TABLE lt_vepo INTO ls_vepo INDEX 1.
          IF sy-subrc EQ 0.
            SELECT objek atinn atzhl mafid klart adzhl atwrt
              INTO CORRESPONDING FIELDS OF TABLE lt_ausp
              FROM ausp
              WHERE objek EQ ls_vepo-matnr
                AND atinn IN lr_atinn
                AND klart EQ lc_klart.
            IF lt_ausp[] IS NOT INITIAL.
              " Total de Unidades
              LOOP AT lt_vepo INTO ls_vepo.
                ADD ls_vepo-vemng TO ls_cab-zzundtot.
              ENDLOOP.
              " Descripción de Unidades
              READ TABLE lt_ausp INTO ls_ausp INDEX 1.
              IF sy-subrc EQ 0.
                ls_cab-zzunddes = ls_ausp-atwrt.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
        " Precintos Otros
        CLEAR: ls_thead, l_text.
        ls_thead-tdobject = 'VBBK'.
        ls_thead-tdid     = 'Z020'.
        ls_thead-tdname   = ls_likp-vbeln.
        SELECT SINGLE langu INTO ls_thead-tdspras   " Tomar Idioma del Dato maestro
          FROM vbpa AS v INNER JOIN adrc AS a
          ON v~adrnr EQ a~addrnumber
          WHERE vbeln EQ ls_likp-vbeln
            AND posnr EQ 0
            AND parvw EQ 'WE'.
        l_text = get_format_text_type_paragraph( ls_thead ).
        IF l_text IS INITIAL.
          ls_thead-tdspras  = sy-langu.
          l_text = get_format_text_type_paragraph( ls_thead ).
        ENDIF.
        ls_cab-zzprecin = l_text.

*{  BEGIN OF INSERT WMR-080119-3000011134
      WHEN '0021061097'.  " CMH
        " Total de Bultos
        CLEAR: ls_thead, l_text, lt_vekp, lt_vekp1.
        ls_thead-tdobject = 'VBBK'.
        ls_thead-tdid     = 'ZE02'.
        ls_thead-tdname   = ls_likp-vbeln.
        SELECT SINGLE spras INTO ls_thead-tdspras FROM kna1 WHERE kunnr = ls_likp-kunag.
        l_text = read_text( ls_thead ).
        IF l_text IS INITIAL.
          ls_thead-tdspras = sy-langu.
          l_text = read_text( ls_thead ).
        ENDIF.
        IF l_text IS NOT INITIAL.
          TRY .
              ls_cab-zzpalnum = l_text.
            CATCH cx_root INTO lo_error.
          ENDTRY.
        ELSE.
          SELECT venum vpobj vpobjkey uevel packvorschr
            INTO CORRESPONDING FIELDS OF TABLE lt_vekp1
            FROM vekp
            WHERE vpobj    EQ '01'
              AND vpobjkey EQ ls_likp-vbeln.

          lt_vekp[] = lt_vekp1[].
          DELETE lt_vekp WHERE uevel IS INITIAL.
          ls_cab-zzpalnum = lines( lt_vekp ).
        ENDIF.
*}  END OF INSERT WMR-080119-3000011134

*{+011022-NTP-3000018956
      WHEN '0021252402'. "zeus
*        IF gt_oigsi IS NOT INITIAL.
        SELECT SINGLE *
          INTO ls_vbfa
          FROM vbfa
          WHERE vbelv = ls_likp-vbeln
            AND vbtyp_n = 'r'.
        IF sy-subrc = 0.
          SELECT ('PRECI')
            INTO TABLE lt_preci
            FROM ('ZOSTB_PRECINTOS')
            WHERE ('TKNUM = LS_VBFA-VBELN AND ESTAD = `1`').

          LOOP AT lt_preci INTO ls_preci.
            CASE sy-tabix.
              WHEN 1.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                  EXPORTING
                    input  = ls_preci
                  IMPORTING
                    output = ls_cab-zzprecin.

              WHEN 2.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                  EXPORTING
                    input  = ls_preci
                  IMPORTING
                    output = ls_cab-zzprecin2.
            ENDCASE.
          ENDLOOP.
        ENDIF.
*        ENDIF.
*}+011022-NTP-3000018956
*{I-PBM190423-3000020600
      WHEN '0021225088'.  " Resemin
        "Precintos
        ls_cab-zzprecin = read_text_vbbk_zconst( i_campo = 'ZZPRECIN' i_vbeln = ls_likp-vbeln i_kunnr = ls_likp-kunag ).
*}I-PBM190423-3000020600
      WHEN '0021154274'. "Ilender
        ls_cab-zzprecin = read_text_vbbk_zconst( i_campo = 'TXT_PRECIN' i_vbeln  = ls_likp-vbeln i_fulltext = 'X' ). "I-180221-NTP-3000016078
        REPLACE ALL OCCURRENCES OF '@ ' IN ls_cab-zzprecin WITH '#'.
*{I-PBM081222-3000019824
      WHEN '0021274341'. " LIFE
        CLEAR lt_vekp.
        SELECT venum vhart vpobj vpobjkey uevel
        INTO CORRESPONDING FIELDS OF TABLE lt_vekp
        FROM vekp
         WHERE vpobjkey EQ ls_likp-vbeln.

        " Paletas
        lt_vekp1[] = lt_vekp[].
        DELETE lt_vekp1 WHERE vhart <> 'PT05'.
        ls_cab-zzpalnum = lines( lt_vekp1 ).

        "Nro. De Cajas
        lt_vekp1[] = lt_vekp[].
        DELETE lt_vekp1 WHERE vhart <> 'PT06'.
        ls_cab-zznrocaja = lines( lt_vekp1 ).
*}I-PBM081222-3000019824
*+{@KAR
      WHEN '0021279031'.  "BJR
        READ TABLE it_lips INTO ls_lips WITH KEY vbeln = ls_likp-vbeln.
        IF sy-subrc EQ 0.
*          CASE LS_LIPS-VGTYP.
*            WHEN 'C'.
*              SELECT SINGLE *
*                FROM ZOSTB_PACKING
*                INTO LS_PACKING
*               WHERE PEDIDO EQ LS_LIPS-VGBEL.
*
*              IF SY-SUBRC EQ 0.
*                LS_CAB-ZZPALNUM = LS_PACKING-CANTCAJAS + LS_PACKING-CANTPAQUETES + LS_PACKING-CANTCAJAMULT + LS_PACKING-CANTATADO.
*              ENDIF.
*            WHEN 'V'.
*              SELECT SINGLE *
*                FROM /SCDL/DB_REFDOC
*                INTO LS_DB_REFDOC
*               WHERE REFDOCCAT EQ 'ERP'
*                 AND REFDOCNO  EQ LS_LIKP-VBELN
*                 AND REFITEMNO NE ''.
*
*              IF SY-SUBRC EQ 0.
*                SELECT SINGLE *
*                  FROM /SCDL/DB_PROCH_O
*                  INTO LS_DB_PROCH_O
*                 WHERE DOCID EQ LS_DB_REFDOC-DOCID.
*
*                IF SY-SUBRC EQ 0.
*                  SELECT SINGLE *
*                    FROM ZOSTB_PACKING
*                    INTO LS_PACKING
*                   WHERE DOCNO_H EQ LS_DB_PROCH_O-DOCNO.
*
*                  IF SY-SUBRC EQ 0.
*                    LS_CAB-ZZPALNUM = LS_PACKING-CANTCAJAS + LS_PACKING-CANTPAQUETES + LS_PACKING-CANTCAJAMULT + LS_PACKING-CANTATADO.
*                  ENDIF.
*                ENDIF.
*
*              ENDIF.
*            WHEN OTHERS.
*          ENDCASE.
        ENDIF.
*+}@KAR
    ENDCASE.

  ENDMETHOD.


  METHOD set_data_rem_remitente.

    DATA: ls_t001w     LIKE LINE OF gth_t001w,
          ls_t001z     LIKE LINE OF gth_t001z,
          lv_adrnr     TYPE adrc-addrnumber,
          lv_tel_numbe TYPE ad_tlnmbr1,
          lw_adr12     TYPE adr12,
          lw_adr6      TYPE adr6,
          ls_kna1      LIKE LINE OF gth_kna1,
          ls_dire      LIKE LINE OF gth_dire.

*{+010922-NTP-3000018956
*      READ TABLE gth_t001w INTO ls_t001w WITH TABLE KEY werks = ls_cab-werks.
*      IF sy-subrc = 0.
*        ls_cab-bukrs = ls_t001w-bukrs.
*}+010922-NTP-3000018956

    "Numero de documento de identidad
*      READ TABLE gth_tvko INTO ls_tvko WITH TABLE KEY vkorg = ls_likp-vkorg.   "-010922-NTP-3000018956
    READ TABLE gth_t001z INTO ls_t001z WITH TABLE KEY bukrs = g_bukrs. "ls_cab-bukrs.
    IF sy-subrc = 0.
      ls_cab-bukrs    = ls_t001z-bukrs.
      ls_cab-zzremnro = ls_t001z-paval.
      ls_cab-zzremden = gs_consextsun-zz_ncomercial.                          "+010922-NTP-3000018956
*        ls_cab-zzremtpd_h = '06'.                                               "E-WMR-111218-3000009765
      SELECT SINGLE stcdt INTO ls_cab-zzremtpd_h                              "I-WMR-111218-3000009765
        FROM zostb_catahomo06 WHERE zz_codigo_sunat = '6'.  " RUC             "I-WMR-111218-3000009765
    ENDIF.

    SELECT SINGLE adrnr
      FROM t001
      INTO lv_adrnr
     WHERE bukrs EQ ls_cab-bukrs.

    IF sy-subrc EQ 0.
      SELECT SINGLE *
        INTO lw_adr6 "LS_CAB-ZZ_EMI_EMAIL
        FROM adr6
        WHERE addrnumber EQ lv_adrnr
          AND date_from  EQ gc_00010101
          AND flgdefault EQ abap_true.

      IF sy-subrc EQ 0.
        ls_cab-zz_emi_email = lw_adr6-smtp_addr.
      ENDIF.

      SELECT SINGLE *
        INTO lw_adr12 "LS_CAB-ZZ_WEB_PAGE
        FROM adr12
        WHERE addrnumber EQ lv_adrnr
          AND date_from  EQ gc_00010101
          AND flgdefault EQ abap_true.

      IF sy-subrc EQ 0.
        ls_cab-zz_web_page = lw_adr12-uri_addr.
      ENDIF.
    ENDIF.
*    ENDIF.
  ENDMETHOD.


  METHOD set_data_rem_solicitante.
    DATA: ls_dire  TYPE gty_direccion,
          ls_kna1  LIKE LINE OF gth_kna1,
          ls_const LIKE LINE OF gt_const,
          ls_vbpa  TYPE gty_vbpa.

*{I-NTP180918-3000010450
    CASE gw_license.
      WHEN '0020886706'. "Piramide
        READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = zpiramide-s_soli-adrnr.
        IF sy-subrc = 0.
          " Número de documento de identidad del solicitante
          ls_cab-zzslcnro   = zpiramide-s_soli-stcd1.
          ls_cab-zzslctpd_h = zpiramide-s_soli-stcdt.
          " Apellidos y nombres, denominación o razón social del Solicitante
          CONCATENATE zpiramide-s_soli-kunnr
                      abap_undefined
                      ls_dire-name
                      INTO ls_cab-zzslcden SEPARATED BY space.
        ENDIF.
      WHEN OTHERS.
*}I-NTP180918-3000010450
*{+NTP010523-3000020188
        IF ls_cab-is_trasladointerno = abap_on.
          ls_cab-zzslcnro   = ls_cab-zzdstnro.
          ls_cab-zzslctpd_h = ls_cab-zzdsttpd_h.
          ls_cab-zzslcden   = ls_cab-zzdstden.
        ELSE.
*}+NTP010523-3000020188
          READ TABLE gt_vbpa INTO ls_vbpa WITH KEY vbeln = ls_likp-vbeln
                                                   parvw = gc_parvw_ag.
          IF sy-subrc <> 0.
            READ TABLE gt_vbpa INTO ls_vbpa WITH KEY kunnr = ls_likp-kunnr.
          ENDIF.
          IF sy-subrc = 0.
            READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_vbpa-adrnr.
            IF sy-subrc = 0.
              READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_vbpa-kunnr.
              IF sy-subrc = 0.
                " Número de documento de identidad del solicitante
                ls_cab-zzslcnro   = ls_kna1-stcd1.
                ls_cab-zzslctpd_h = ls_kna1-stcdt.
                " Apellidos y nombres, denominación o razón social del Solicitante
                ls_cab-zzslcden   = ls_dire-name.  "+NTP010323-3000019645
*{-NTP010323-3000019645
*              CONCATENATE ls_kna1-kunnr
*                          abap_undefined
*                          ls_dire-name
*                          INTO ls_cab-zzslcden SEPARATED BY space.
*}-NTP010323-3000019645
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
    ENDCASE.
*}  END OF INSERT WMR-060318-3000008769

*{  BEGIN OF INSERT WMR-051018-3000010624
    CASE gw_license.
      WHEN '0020886706'. "Piramide
        " Tomar N° y Tipo documento de identidad Destinatario a partir del Solicitante
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = zpiramide-s_desti-kunnr
          IMPORTING
            output = zpiramide-s_desti-kunnr.
        READ TABLE gt_const INTO ls_const WITH KEY campo  = 'GR_DES_SOL'
                                                   valor1 = zpiramide-s_desti-kunnr.
        IF sy-subrc = 0.
          ls_cab-zzdstnro   = ls_cab-zzslcnro.
          ls_cab-zzdsttpd_h = ls_cab-zzslctpd_h.
        ENDIF.
    ENDCASE.
*}  END OF INSERT WMR-051018-3000010624

  ENDMETHOD.


  METHOD set_data_rem_traslado_mod.

*{+3000018956-010722-NTP
    TYPES: BEGIN OF ty_oigd,
             drivercode TYPE oigd-drivercode,
             first_name TYPE oigd-first_name,
             last_name  TYPE oigd-last_name,
             perscode   TYPE oigd-perscode,
             licenseno  TYPE oigdl-licenseno,
           END OF ty_oigd.
*}+3000018956-010722-NTP

    DATA: ls_vttp  LIKE LINE OF gth_vttp,
          l_tabix  TYPE i,
          ls_vttk  LIKE LINE OF gth_vttk,
          ls_hom18 LIKE LINE OF gth_hom18,
          ls_kna1  LIKE LINE OF gth_kna1,
          ls_dire  TYPE gty_direccion,
          ls_lips  LIKE LINE OF it_lips,
          ls_vbpa  LIKE LINE OF gt_vbpa,
          ls_thead TYPE thead,
          ls_cab1  LIKE ls_cab,
          l_text   TYPE string,
          abap_on  TYPE abap_bool,
          abap_off TYPE abap_bool,
          ls_oigsi LIKE LINE OF gt_oigsi, "+3000018956-010722-NTP
          ls_oigsv LIKE LINE OF gt_oigsv, "+3000018956-010722-NTP
          lt_oigd  TYPE TABLE OF ty_oigd, "+3000018956-010722-NTP
          ls_oigd  LIKE LINE OF lt_oigd.  "+3000018956-010722-NTP

*{+081122-NTP-3000020296
    CASE gw_license.
      WHEN '0020767991'. "inka
        set_data_rem_traslado_mod_inka( EXPORTING ls_likp = ls_likp ls_lips = ls_lips CHANGING ls_cab = ls_cab ).
        EXIT.
*{ BEGIN OF INSERT WMR-27112020-3000014557
      WHEN '0021154274'. "Ilender
        ls_cab-zztmactive = ls_likp-tm_active.  " TM activo?
        IF ls_cab-zztmactive = abap_true. " TM Activo
          get_data_tm_delivery( EXPORTING is_likp = ls_likp it_lips = it_lips
                                CHANGING  cs_cab_gre = ls_cab
                                EXCEPTIONS no_found   = 1
                                           OTHERS     = 2 ).
          IF sy-subrc = 0.
            EXIT.
          ENDIF.
        ENDIF.
*} BEGIN OF INSERT WMR-27112020-3000014557
    ENDCASE.
*}+081122-NTP-3000020296

    READ TABLE gth_vttp INTO ls_vttp WITH TABLE KEY vbeln = ls_likp-vbeln.
    IF sy-subrc = 0.
      " Transporte                                                                    "I-WMR-060318-3000008769
      ls_cab-tknum = ls_vttp-tknum.                                                   "I-WMR-060318-3000008769

      "Indicador de transbordo programado
      l_tabix = 0.
      LOOP AT gth_vtts TRANSPORTING NO FIELDS WHERE tknum = ls_vttp-vbeln.
        ADD 1 TO l_tabix.
      ENDLOOP.
      IF l_tabix > 1.
        ls_cab-zzindtnb = abap_on.
      ELSE.
        ls_cab-zzindtnb = abap_off.
      ENDIF.

      READ TABLE gth_vttk INTO ls_vttk WITH TABLE KEY tknum = ls_vttp-tknum.
      IF sy-subrc = 0.

*{+081122-NTP-3000020296
*        "Fecha de inicio de traslado
*        ls_cab-zztrafec = ls_vttk-datbg.
*        "Hora inicio de traslado
*        ls_cab-zztrahor = ls_vttk-uatbg.                                          "I-WMR-261018-3000010720
*        CASE gs_process-license.                                                  "I-WMR-080119-3000011134
*          WHEN '0021061097'.  " CMH                                               "I-WMR-080119-3000011134
*            "Fecha de inicio de traslado                                          "I-WMR-080119-3000011134
*            ls_cab-zztrafec = ls_vttk-dtabf.                                      "I-WMR-080119-3000011134
*            "Hora inicio de traslado                                              "I-WMR-080119-3000011134
*            ls_cab-zztrahor = ls_vttk-uzabf.                                      "I-WMR-080119-3000011134
*        ENDCASE.                                                                  "I-WMR-080119-3000011134
*}+081122-NTP-3000020296
*{+081122-NTP-3000020296
        CASE zconst-zztrafec.
          WHEN '' OR 'I'.
            ls_cab-zztrafec = ls_vttk-datbg.
            ls_cab-zztrahor = ls_vttk-uatbg.
          WHEN 'II'.
            ls_cab-zztrafec = ls_vttk-dtabf.
            ls_cab-zztrahor = ls_vttk-uzabf.
          WHEN 'III'.
            ls_cab-zztrafec = ls_cab-zzfecemi.
            ls_cab-zztrahor = ls_cab-zzhoremi.
        ENDCASE.
*}+081122-NTP-3000020296
        "Modalidad de traslado
        READ TABLE gth_hom18 INTO ls_hom18 WITH TABLE KEY shtyp    = ls_vttk-shtyp       "I-NTP-070616
                                                          lfart    = space               "I-WMR-191018-3000009770
                                                          tor_type = space.              "+@KAR
        IF sy-subrc = 0.
          ls_cab-zztrsmod_h = ls_vttk-shtyp.

          CASE ls_hom18-zz_codigo_sunat.
            WHEN gc_modtras_publico.
              "Transportista (Transporte Público)
              READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_vttk-tdlnr.
              IF sy-subrc = 0.

                "Número de RUC transportista
                ls_cab-zztranro = ls_kna1-stcd1.
                ls_cab-zztratpd_h = ls_kna1-stcdt.

                "Apellidos y nombres o denominación o razón social del transportista
                READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_kna1-adrnr.
                IF sy-subrc = 0.
                  ls_cab-zztraden = ls_dire-name.
                  ls_cab-zztradir = ls_dire-direccion.
                ENDIF.

*{  BEGIN OF INSERT WMR-260517-3000007333
                CASE gw_license.
                  WHEN '0020974592'.  " DANPER
                    "N° Brevete
                    ls_cab-zztrabvt = ls_vttk-exti2.
                    "N° Contancia Inscripción
                    ls_cab-zztranci = ls_vttk-text3.
                    "Marca
                    ls_cab-zztramar = ls_vttk-tpbez.
                    "Número de placa del vehículo
                    ls_cab-zzplaveh = ls_vttk-signi.
                    "Chofer
                    ls_cab-zzconden = ls_vttk-text2.
*{ I-ACZ250118-3000008769: Agregar campos para PIRAMIDE
                  WHEN '0020886706'.  "PIRAMIDE
                    "N° Brevete
                    ls_cab-zztrabvt = ls_vttk-exti1.
                    "N° Contancia Inscripción
                    LOOP AT it_lips INTO ls_lips WHERE vbeln = ls_likp-vbeln.
                      CLEAR ls_thead.
                      ls_thead-tdobject = 'VBBP'.
                      CONCATENATE ls_lips-vbeln ls_lips-posnr INTO ls_thead-tdname.
                      SELECT SINGLE valor1 INTO ls_thead-tdid
                        FROM zostb_constantes
                        WHERE modulo     = 'SD'
                          AND aplicacion = 'CERTIF_VEHICULAR'
                          AND programa   = 'MV50AFZ1'
                          AND campo      = 'TDID'.
                      IF ls_thead-tdid IS INITIAL.  CONTINUE. ENDIF.
                      ls_thead-tdspras  = sy-langu.
                      ls_cab-zztranci = read_text( ls_thead ).
                      IF ls_cab-zztranci IS NOT INITIAL.  EXIT. ENDIF.
                    ENDLOOP.
                    "Marca
                    ls_cab-zztramar = ls_vttk-exti2.
                    "Número de placa del vehículo
                    ls_cab-zzplaveh = ls_vttk-tndr_trkid.
                    "Chofer
                    ls_cab-zzconden = ls_vttk-signi.
*} I-ACZ250118-3000008769
*{+30012023-NTP-3000020786
                    get_interlocutor( EXPORTING i_vbeln = ls_vttk-tknum i_campo = 'PARVW_TRA_CONDUCTOR' IMPORTING es_kna1 = ls_kna1 es_dire = ls_dire ).
                    IF ls_kna1 IS NOT INITIAL.
                      CONCATENATE ls_kna1-name1 ls_kna1-name2 INTO ls_cab-zzconden SEPARATED BY space. "Chofer
                      ls_cab-zzconnro = ls_kna1-stcd1.    "Conductor nro
                      ls_cab-zzcontpd_h = ls_kna1-stcdt.  "Conductor tipdoc
                      ls_cab-zztrabvt = ls_kna1-stcd2.    "N° Brevete
                    ENDIF.
*}+30012023-NTP-3000020786
*{+04022023-JBO-3000020786
                    IF ls_cab-zzplaveh IS NOT INITIAL.
**                      get_mtc( EXPORTING i_placa = ls_cab-zzplaveh IMPORTING es_mtc = ls_cab-zztramtc ).
                    ENDIF.
*}+04022023-JBO-3000020786
*{  BEGIN OF INSERT WMR-071218-3000009765
                  WHEN '0021061097' OR  " CMH
                       '0021225088'.    " Resemin
                    "N° Brevete
                    ls_cab-zztrabvt = ls_vttk-/bev1/rpfar1.
                    "Marca y Número de placa del vehículo
                    "Certificado vehicular                                        "I-WMR-080119-3000011134
                    SELECT SINGLE e~herst f~license_num
                                  f~key_num f~fleet_num                           "I-WMR-080119-3000011134
                      INTO (ls_cab-zztramar, ls_cab-zzplaveh,
                            ls_cab-zztrancv, ls_cab-zztramtc)                     "I-WMR-080119-3000011134
                      FROM equi AS e
                      INNER JOIN fleet AS f ON e~objnr = f~objnr
                      WHERE e~equnr = ls_vttk-/bev1/rpmowa.
*{  BEGIN OF INSERT WMR-080119-3000011134
                    " Marca, Número de placa del vehículo y
                    " Certificado vehicular del Remolque
                    IF ls_vttk-/bev1/rpanhae IS NOT INITIAL.
                      SELECT SINGLE e~herst f~license_num f~key_num f~fleet_num
                        INTO (ls_cab1-zztramar, ls_cab1-zzplaveh, ls_cab1-zztrancv, ls_cab-zztramtc)
                        FROM equi AS e
                        INNER JOIN fleet AS f ON e~objnr = f~objnr
                        WHERE e~equnr = ls_vttk-/bev1/rpanhae.
                      IF ls_cab1-zztramar IS NOT INITIAL.
                        CONCATENATE ls_cab-zztramar '/' ls_cab1-zztramar
                          INTO ls_cab-zztramar SEPARATED BY space.
                      ENDIF.
                      IF ls_cab1-zzplaveh IS NOT INITIAL.
                        CONCATENATE ls_cab-zzplaveh '/' ls_cab1-zzplaveh
                          INTO ls_cab-zzplaveh SEPARATED BY space.
                      ENDIF.
                      IF ls_cab1-zztrancv IS NOT INITIAL.
                        CONCATENATE ls_cab-zztrancv '/' ls_cab1-zztrancv
                          INTO ls_cab-zztrancv SEPARATED BY space.
                      ENDIF.
                    ENDIF.
*}  END OF INSERT WMR-080119-3000011134
                    "Chofer
                    CLEAR l_text.
                    SELECT SINGLE b~name_first b~name_last
                      INTO (ls_cab-zzconden, l_text)
                      FROM cvi_cust_link AS l
                      INNER JOIN but000 AS b ON l~partner_guid = b~partner_guid
                      WHERE l~customer = ls_vttk-/bev1/rpfar1.
                    IF l_text IS NOT INITIAL.
                      CONCATENATE ls_cab-zzconden l_text INTO ls_cab-zzconden SEPARATED BY space.
                    ENDIF.
                    CONDENSE ls_cab-zzconden. TRANSLATE ls_cab-zzconden TO UPPER CASE.

                    " Número de autorización MTC
                    SELECT SINGLE profs INTO  ls_cab-zztramtc
                    FROM lfa1 WHERE lifnr EQ ls_vttk-tdlnr.

                    IF ls_cab-zztramtc IS INITIAL.
                      CONCATENATE ls_vttk-exti1 ls_vttk-exti2  INTO ls_cab-zztramtc SEPARATED BY space.
                    ENDIF.
                    " Número DUA
                    ls_cab-zztradua  = ls_vttk-text4.
                ENDCASE.
*}  END OF INSERT WMR-071218-3000009765
*}  END OF INSERT WMR-260517-3000007333
*{I-PBM061222-3000020028
                SELECT SINGLE taxtype taxnum
                INTO (ls_cab-zzcontpd_h,            "Conductor tipdoc
                      ls_cab-zzconnro)              "Conductor nro
                FROM dfkkbptaxnum
                  WHERE partner = ls_vttk-/bev1/rpfar1.
*}I-PBM061222-3000020028
              ENDIF.
            WHEN gc_modtras_privado.
              "Vehículo (Transporte privado)
*{  BEGIN OF INSERT WMR-071218-3000009765
              CASE gs_process-license.
                WHEN '0021061097'.  " CMH
                  "Número de placa del vehículo
                  SELECT SINGLE f~license_num INTO ls_cab-zzplaveh
                    FROM vttk AS v
                    INNER JOIN equi AS e ON v~/bev1/rpmowa = e~equnr
                    INNER JOIN fleet AS f ON e~objnr = f~objnr
                    WHERE tknum = ls_vttk-tknum.

                  "CONDUCTOR (Transporte privado)
                  "Número de documento de identidad del conductor
                  ls_cab-zzconnro = ls_vttk-text3.
                  SELECT SINGLE stcdt INTO ls_cab-zzcontpd_h
                    FROM zostb_catahomo06 WHERE zz_codigo_sunat = '1'.  " DNI
                WHEN '0020886706'.  "PIRAMIDE
                  "N° Brevete
                  ls_cab-zztrabvt = ls_vttk-exti1.
                  "N° Contancia Inscripción
                  LOOP AT it_lips INTO ls_lips WHERE vbeln = ls_likp-vbeln.
                    CLEAR ls_thead.
                    ls_thead-tdobject = 'VBBP'.
                    CONCATENATE ls_lips-vbeln ls_lips-posnr INTO ls_thead-tdname.
                    SELECT SINGLE valor1 INTO ls_thead-tdid
                      FROM zostb_constantes
                      WHERE modulo     = 'SD'
                        AND aplicacion = 'CERTIF_VEHICULAR'
                        AND programa   = 'MV50AFZ1'
                        AND campo      = 'TDID'.
                    IF ls_thead-tdid IS INITIAL.  CONTINUE. ENDIF.
                    ls_thead-tdspras  = sy-langu.
                    ls_cab-zztranci = read_text( ls_thead ).
                    IF ls_cab-zztranci IS NOT INITIAL.  EXIT. ENDIF.
                  ENDLOOP.
                  "Marca
                  ls_cab-zztramar = ls_vttk-exti2.
                  "Número de placa del vehículo
                  ls_cab-zzplaveh = ls_vttk-tndr_trkid.
                  "Chofer
                  ls_cab-zzconden = ls_vttk-signi.

                  "CONDUCTOR (Transporte privado)
                  "Número de documento de identidad del conductor
                  READ TABLE gt_vbpa INTO ls_vbpa WITH KEY parvw = 'ZB'.
                  IF sy-subrc EQ '0'.
                    READ TABLE gth_kna1 INTO ls_kna1 WITH KEY kunnr = ls_vbpa-kunnr.
                    IF sy-subrc EQ '0'.
                      ls_cab-zzconnro = ls_kna1-stcd1.
                      ls_cab-zzcontpd_h = '1'.
                    ENDIF.
                  ENDIF.

*{+30012023-NTP-3000020786
                  get_interlocutor( EXPORTING i_vbeln = ls_vttk-tknum i_campo = 'PARVW_TRA_CONDUCTOR' IMPORTING es_kna1 = ls_kna1 es_dire = ls_dire ).
                  IF ls_kna1 IS NOT INITIAL.
                    CONCATENATE ls_kna1-name1 ls_kna1-name2 INTO ls_cab-zzconden SEPARATED BY space. "Chofer
                    ls_cab-zzconnro = ls_kna1-stcd1.    "Conductor nro
                    ls_cab-zzcontpd_h = ls_kna1-stcdt.  "Conductor tipdoc
                    ls_cab-zztrabvt = ls_kna1-stcd2.    "N° Brevete
                  ENDIF.
*}+30012023-NTP-3000020786
*{+04022023-JBO-3000020786
                  IF ls_cab-zzplaveh IS NOT INITIAL.
**                    get_mtc( EXPORTING i_placa = ls_cab-zzplaveh IMPORTING es_mtc = ls_cab-zztramtc ).
                  ENDIF.
*}+04022023-JBO-3000020786
                WHEN OTHERS.
*}  END OF INSERT WMR-071218-3000009765
                  "Número de placa del vehículo
                  ls_cab-zzplaveh = ls_vttk-signi.

                  "CONDUCTOR (Transporte privado)
                  "Número de documento de identidad del conductor
                  ls_cab-zzconnro = ls_vttk-text3.
                  ls_cab-zzcontpd_h = '1'.
              ENDCASE.

            WHEN OTHERS.
          ENDCASE.
        ENDIF.
      ENDIF.

*{+3000018956-010722-NTP
    ELSEIF gt_oigsi IS NOT INITIAL.

      "Fecha de inicio de traslado
      ls_cab-zztrafec = ls_likp-wadat_ist.
      "Hora inicio de traslado
      ls_cab-zztrahor = ls_likp-spe_wauhr_ist.

      "Modalidad de traslado
      READ TABLE gth_hom18 INTO ls_hom18 WITH TABLE KEY shtyp    = space
                                                        lfart    = ls_likp-lfart
                                                        tor_type = space.              "+@KAR
      IF sy-subrc = 0.
        ls_cab-zztrsmod_h = ls_likp-lfart.

        READ TABLE gt_oigsi INTO ls_oigsi WITH KEY doc_number = ls_likp-vbeln.
        IF sy-subrc = 0.
          READ TABLE gt_oigsv INTO ls_oigsv WITH KEY shnumber = ls_oigsi-shnumber.
          IF sy-subrc = 0.

            "TRANSPORTISTA
            READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_oigsv-carrier.
            IF sy-subrc = 0.
              "Número de RUC transportista
              ls_cab-zztranro = ls_kna1-stcd1.
              ls_cab-zztratpd_h = ls_kna1-stcdt.
              "Apellidos y nombres o denominación o razón social del transportista
              ls_cab-zztraden = ls_kna1-name1.
            ENDIF.

            CASE ls_hom18-zz_codigo_sunat.
              WHEN gc_modtras_publico.
                "Marca, Número de placa del vehículo, Placa semirremolque
*                SELECT SINGLE a~veh_mail b~veh_text "c~tu_number
*                  INTO ( ls_cab-zztramar, ls_cab-zzplaveh ) ", ls_cab-zzplaveh )
*                  FROM oigv AS a LEFT JOIN oigvt AS b ON b~vehicle = a~vehicle AND b~language = sy-langu
*                                 LEFT JOIN oigvtu AS c ON c~vehicle = a~vehicle
*                  WHERE a~vehicle = ls_oigsv-vehicle.
                "Chofer
                ls_cab-zzconden = read_text_vbbk_zconst( i_campo = 'TDID_CHOFE' i_vbeln = ls_likp-vbeln i_kunnr = ls_likp-kunag ).

              WHEN gc_modtras_privado.
                "Conductor
                SELECT a~drivercode b~first_name b~last_name b~perscode c~licenseno
                  INTO TABLE lt_oigd
                  FROM oigsvd AS a LEFT JOIN oigd AS b ON b~drivercode = a~drivercode
                                   LEFT JOIN oigdl AS c ON c~drivercode = a~drivercode
                  WHERE a~shnumber = ls_oigsv-shnumber.
                LOOP AT lt_oigd INTO ls_oigd.

                  "Apellidos y nombres o denominación o razón social del conductor
                  CONCATENATE ls_oigd-first_name ls_oigd-last_name INTO l_text SEPARATED BY space.
                  IF ls_cab-zzconden IS INITIAL.
                    ls_cab-zzconden = l_text.
                  ELSE.
                    CONCATENATE ls_cab-zzconden l_text INTO ls_cab-zzconden SEPARATED BY '\'.
                  ENDIF.

                  "Número de documento de identidad del conductor
                  ls_cab-zzconnro = ls_oigd-perscode.
                  "N° Brevete
                  ls_cab-zztrabvt = ls_oigd-licenseno.
                ENDLOOP.
            ENDCASE.
          ENDIF.
        ENDIF.
      ENDIF.
*}+3000018956-010722-NTP

*{I-PBM081222-3000019824: CÓDIGO TEST
    ELSEIF gt_tordrf[] IS NOT INITIAL.

*      TYPES:
*        BEGIN OF ty_torrot,
*          db_key TYPE /scmtms/d_torrot-db_key,
*          tspid  TYPE /scmtms/d_torrot-tspid,
*        END OF ty_torrot,
*
*        BEGIN OF ty_but000_tm,
*          partner    TYPE but000-partner,
*          name_org1  TYPE but000-name_org1,
*          name_org2  TYPE but000-name_org2,
*          name_first TYPE but000-name_first,
*          name_last  TYPE but000-name_last,
*        END OF ty_but000_tm.
*
*        BEGIN OF ty_torite,
*          db_key         TYPE /scmtms/d_torite-db_key,
*          parent_key     TYPE /scmtms/d_torite-parent_key,
*          item_type      TYPE /scmtms/d_torite-item_type,
*          item_cat       TYPE /scmtms/d_torite-item_type,
*          res_key        TYPE /scmtms/d_torite-res_key,
*          platenumber    TYPE /scmtms/d_torite-platenumber,
*          tracking_no    TYPE /scmtms/d_torite-tracking_no,
*          res_id         TYPE /scmtms/d_torite-res_id,
*          base_btd_id    TYPE /scmtms/d_torite-base_btd_id,
*          partner TYPE but0id-partner,
*        END OF ty_torite,
*
*        BEGIN OF ty_txcroot,
*          db_key   TYPE /bobf/d_txcroot-db_key,
*          host_key TYPE /bobf/d_txcroot-host_key,
*          root_key TYPE /bobf/d_txccon-root_key,
*          text     TYPE /bobf/d_txccon-text,
*        END OF ty_txcroot,
*
*        BEGIN OF ty_restmssk,
*          res_type   TYPE /scmb/restmssk-res_type,
*          tmsresuuid TYPE /scmb/restmssk-tmsresuuid,
*          qualitype  TYPE /scmb/restmssk-qualitype,
*          qualivalue TYPE /scmb/restmssk-qualivalue,
*        END OF ty_restmssk.

*      DATA: lt_torite    TYPE STANDARD TABLE OF ty_torite,
      DATA: ls_torite   LIKE LINE OF gt_torite,
            lt_but000   TYPE STANDARD TABLE OF gty_kna1,
            ls_but000   LIKE LINE OF lt_but000,
*            lt_torrot    TYPE STANDARD TABLE OF ty_torrot,
*            ls_torrot    LIKE LINE OF lt_torrot,
*            lt_txcroot   TYPE STANDARD TABLE OF ty_txcroot,
            ls_txcroot  LIKE LINE OF gt_txcroot,
*            lt_restmssk  TYPE STANDARD TABLE OF ty_restmssk,
            ls_restmssk LIKE LINE OF gt_restmssk,
*
            lt_but0id   TYPE TABLE OF but0id,
            ls_but0id   LIKE LINE OF lt_but0id,
*      DATA: lt_dfkkbptaxnum TYPE TABLE OF dfkkbptaxnum.
*      DATA: ls_dfkkbptaxnum LIKE LINE OF lt_dfkkbptaxnum.
*
*      DATA: lv_but000driver TYPE but000-partner,
*            lt_drivertaxnum TYPE TABLE OF dfkkbptaxnum,
*            ls_drivertaxnum LIKE LINE OF lt_dfkkbptaxnum.

            ls_tordrf   LIKE LINE OF gt_tordrf.
*            lv_btd_id TYPE /scmtms/btd_id.

*      FIELD-SYMBOLS <fs_torite> LIKE LINE OF gt_torite.

* Datos TM
*      SELECT db_key tspid
*      INTO CORRESPONDING FIELDS OF TABLE lt_torrot
*      FROM /scmtms/d_torrot
*      FOR ALL ENTRIES IN gt_tordrf
*       WHERE db_key EQ gt_tordrf-parent_key
*         AND tspid  NE space.
*
*      IF lt_torrot[] IS NOT INITIAL.
*
*        LOOP AT gt_tordrf ASSIGNING FIELD-SYMBOL(<fs_tordrf>).
*          READ TABLE lt_torrot TRANSPORTING NO FIELDS WITH KEY db_key = <fs_tordrf>-parent_key.
*          IF sy-subrc NE 0.
*            DELETE gt_tordrf WHERE parent_key = <fs_tordrf>-parent_key.
*          ENDIF.
*        ENDLOOP.
*
*        SELECT partner name_org1 name_org2 name_first name_last
*        INTO CORRESPONDING FIELDS OF TABLE lt_but000
*        FROM but000
*        FOR ALL ENTRIES IN lt_torrot
*         WHERE partner EQ lt_torrot-tspid.
*
*        SELECT * INTO TABLE lt_dfkkbptaxnum
*        FROM dfkkbptaxnum
*        FOR ALL ENTRIES IN lt_torrot
*         WHERE partner EQ lt_torrot-tspid.
*      ENDIF.
*
*      SELECT db_key parent_key item_type item_cat res_key platenumber tracking_no res_id base_btd_id
*      INTO CORRESPONDING FIELDS OF TABLE lt_torite
*      FROM /scmtms/d_torite
*      FOR ALL ENTRIES IN gt_tordrf
*       WHERE parent_key EQ gt_tordrf-parent_key.
*         AND item_cat  IN ( 'AVR', 'PVR', 'DRI' ).

      IF gt_torite[] IS NOT INITIAL.
*        SELECT res_type tmsresuuid qualitype qualivalue
*          INTO TABLE lt_restmssk
*          FROM /scmb/restmssk
*           FOR ALL ENTRIES IN gt_torite
*         WHERE tmsresuuid EQ gt_torite-res_key.
*
*        LOOP AT gt_torite ASSIGNING <fs_torite>.
*          <fs_torite>-partner = <fs_torite>-res_id.
*        ENDLOOP.
*
*        SELECT a~db_key a~host_key b~root_key b~text
*        INTO CORRESPONDING FIELDS OF TABLE lt_txcroot
*        FROM /bobf/d_txcroot AS a
*        INNER JOIN /bobf/d_txccon AS b ON ( b~root_key = a~db_key )
*        FOR ALL ENTRIES IN gt_torite
*         WHERE a~host_key EQ gt_torite-db_key.
*
        SELECT * FROM but0id INTO TABLE lt_but0id
        FOR ALL ENTRIES IN gt_torite
         WHERE partner EQ gt_torite-res_id(10).
*
*        SELECT * APPENDING TABLE lt_dfkkbptaxnum
*          FROM dfkkbptaxnum
*           FOR ALL ENTRIES IN gt_torite
*         WHERE partner EQ gt_torite-partner.
*
        SELECT partner AS kunnr name_first AS name1 name_last AS name2
          INTO CORRESPONDING FIELDS OF TABLE lt_but000
          FROM but000
          FOR ALL ENTRIES IN gt_torite
          WHERE partner EQ gt_torite-res_id(10).

        s4_completar_datos_nif( EXPORTING ip_type = 'I' CHANGING  ct_kna1 = lt_but000 ).
      ENDIF.
*      lv_btd_id = |{ ls_likp-vbeln ALPHA = IN }|.

*      READ TABLE gt_tordrf INTO ls_tordrf WITH KEY btd_id = lv_btd_id. "ls_likp-vbeln.
      READ TABLE gt_tordrf INTO ls_tordrf WITH KEY btd_id = ls_likp-btd_id.
      IF sy-subrc <> 0.
        READ TABLE gt_tordrf INTO ls_tordrf WITH KEY tor_id = ls_likp-tor_id.
      ENDIF.
      IF sy-subrc = 0.
*       "Fecha de inicio de traslado
        ls_cab-zztrafec = ls_likp-wadat_ist.
        IF ls_cab-zztrafec IS INITIAL.
          ls_cab-zztrafec = ls_likp-wadat.
        ENDIF.
        READ TABLE gth_kna1 INTO ls_kna1 WITH KEY kunnr = ls_tordrf-tspid.
        IF sy-subrc = 0.
          ls_cab-zztranro   = ls_kna1-stcd1.
          ls_cab-zztratpd_h = ls_kna1-stcdt.
          READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_kna1-adrnr.
          IF sy-subrc = 0.
            ls_cab-zztraden = ls_dire-name.
          ENDIF.
        ENDIF.
*        READ TABLE lt_torrot INTO ls_torrot WITH KEY db_key = ls_tordrf-parent_key.
*        IF sy-subrc = 0.
*          READ TABLE lt_but000 INTO ls_but000 WITH KEY partner = ls_torrot-tspid.
*          IF sy-subrc = 0.
*            "Nombre o razón social del transportista(Dato de TM)
*            CONCATENATE ls_but000-name_org1
*                        ls_but000-name_org2
*                        ls_but000-name_first
*                        ls_but000-name_last
*                       INTO ls_cab-zztraden SEPARATED BY space.
*          ENDIF.
*
*          READ TABLE lt_dfkkbptaxnum INTO ls_dfkkbptaxnum WITH KEY partner = ls_torrot-tspid.
*          IF sy-subrc = 0.
*            SELECT SINGLE stcdt
*               INTO @DATA(lv_stcdt)
*               FROM lfa1
*             WHERE lifnr = @ls_torrot-tspid.
*
*            "Número de RUC transportista (Dato de TM)
*            IF ls_dfkkbptaxnum-taxnumxl IS NOT INITIAL.
*              ls_cab-zztranro   = ls_dfkkbptaxnum-taxnumxl.
*              ls_cab-zztratpd_h = lv_stcdt.
*            ELSEIF ls_dfkkbptaxnum-taxnum IS NOT INITIAL.
*              ls_cab-zztranro   = ls_dfkkbptaxnum-taxnum.
*              ls_cab-zztratpd_h = lv_stcdt.
*            ENDIF.
*          ENDIF.
*        ENDIF.

        READ TABLE gt_torite INTO ls_torite WITH KEY parent_key = ls_tordrf-parent_key
                                                     item_cat  = 'AVR'. "Recurso de vehículo
        IF sy-subrc = 0.
          "Número de placa del vehículo (Dato de TM)
          ls_cab-zzplaveh = ls_torite-tracking_no.
          IF ls_cab-zzplaveh IS INITIAL.
            ls_cab-zzplaveh = ls_torite-res_id.
          ENDIF.

          READ TABLE gt_txcroot INTO ls_txcroot WITH KEY host_key = ls_torite-db_key.
          IF sy-subrc = 0.
            "N° Brevete (Dato de TM)
            ls_cab-zztrabvt = ls_txcroot-text.
          ENDIF.
          "Marca
          READ TABLE gt_restmssk INTO ls_restmssk WITH KEY tmsresuuid = ls_torite-res_key
                                                           qualitype = 'ZCERTIFICADO'.
          IF sy-subrc = 0.
            ls_cab-zztramtc = ls_restmssk-qualivalue.
          ENDIF.
          READ TABLE gt_restmssk INTO ls_restmssk WITH KEY tmsresuuid = ls_torite-res_key
                                                           qualitype = 'ZMARCA'.
          IF sy-subrc = 0.
            ls_cab-zztramar = ls_restmssk-qualivalue.
          ENDIF.

        ENDIF.

        READ TABLE gt_torite INTO ls_torite WITH KEY parent_key = ls_tordrf-parent_key
                                                     item_cat  = 'DRI'. "Conductor
        IF sy-subrc = 0.
          READ TABLE lt_but0id INTO ls_but0id WITH KEY partner = ls_torite-res_id(10).
          IF sy-subrc = 0.
            "N° Brevete (Datos TM)
            ls_cab-zztrabvt = ls_but0id-partner.
          ENDIF.

          READ TABLE lt_but000 INTO ls_but000 WITH KEY kunnr = ls_torite-res_id(10).
          IF sy-subrc = 0.
            ls_cab-zzconnro = ls_but000-stcd1.
            ls_cab-zzcontpd_h = ls_but000-stcdt.
            CONCATENATE ls_but000-name1 ls_but000-name2 INTO ls_cab-zzconden SEPARATED BY space.
            ls_cab-zzconden = ls_cab-zzconden.

            IF ls_but000-stcdt IS NOT INITIAL.
              SELECT SINGLE text30
                FROM j_1atodct
                INTO ls_cab-zzdentpd_h
               WHERE spras    EQ sy-langu
                 AND j_1atodc EQ ls_but000-stcdt.
            ENDIF.
            IF ls_cab-zzdentpd_h IS NOT INITIAL.
              ls_cab-zzdentpd_h = ls_cab-zzdentpd_h+4.
            ENDIF.
          ENDIF.

*          READ TABLE lt_but000 INTO ls_but000 WITH KEY partner = ls_torite-partner(10).
*          IF sy-subrc = 0.
*            "Nombre o razón social del conductor(Dato de TM)
*            CONCATENATE ls_but000-name_first
*                        ls_but000-name_last
*                       INTO ls_cab-zzconden SEPARATED BY space.
*
*            ls_cab-zzconden = ls_cab-zzconden.
*          ENDIF.
*
*          READ TABLE lt_dfkkbptaxnum INTO ls_dfkkbptaxnum WITH KEY partner = ls_torite-res_id(10).
*          IF sy-subrc = 0.
*            "Número de RUC de Conductor (Dato de TM)
*            IF ls_dfkkbptaxnum-taxnumxl IS NOT INITIAL.
*              ls_cab-zzconnro = ls_dfkkbptaxnum-taxnumxl.
*            ELSEIF ls_dfkkbptaxnum-taxnum IS NOT INITIAL.
*              ls_cab-zzconnro = ls_dfkkbptaxnum-taxnum.
*            ENDIF.
*          ENDIF.
*
*          SELECT SINGLE stcdt
*            FROM zosfetb_asgtnhr
*            INTO ls_cab-zzcontpd_h
*           WHERE taxtype EQ ls_dfkkbptaxnum-taxtype.
        ENDIF.

        READ TABLE gt_torite INTO ls_torite WITH KEY parent_key = ls_tordrf-parent_key
                                                     item_cat  = 'PVR'. "Recurs vehículo pasivo
        IF sy-subrc = 0.
          ls_cab-zzplapas = ls_torite-tracking_no.
          IF ls_cab-zzplapas IS INITIAL.
            ls_cab-zzplapas = ls_torite-res_id.
          ENDIF.
        ENDIF.

        ls_cab-zztrsmod_h = ls_tordrf-tor_type.  "+@KAR
      ELSE.
        "No tiene transporte o Recojo de cliente(02)
        IF ( ls_likp-vsbed EQ '02' ).
          "Número de placa del vehículo
          ls_cab-zzplaveh = read_text_vbbk_zconst( i_campo = 'TDID_PLVEH' i_vbeln = ls_likp-vbeln i_kunnr = ls_likp-kunag ).
          "N° Brevete
          ls_cab-zztrabvt = read_text_vbbk_zconst( i_campo = 'TDID_NRCND' i_vbeln = ls_likp-vbeln i_kunnr = ls_likp-kunag ).
        ENDIF.

        "Transportista
        get_interlocutor( EXPORTING i_vbeln = ls_likp-vbeln i_campo = 'PARVW_TRA' IMPORTING es_kna1 = ls_kna1 es_dire = ls_dire ).
        "Número de RUC transportista
        IF ls_cab-zztranro IS INITIAL. ls_cab-zztranro = ls_kna1-stcd1. ENDIF.
        IF ls_cab-zztratpd_h IS INITIAL. ls_cab-zztratpd_h = ls_kna1-stcdt. ENDIF.
        "Apellidos y nombres o denominación o razón social del transportista
        IF ls_cab-zztraden IS INITIAL. ls_cab-zztraden = ls_dire-name. ENDIF.

        "Conductor
        get_interlocutor( EXPORTING i_vbeln = ls_likp-vbeln i_campo = 'PARVW_TRA_CONDUCTOR' IMPORTING es_kna1 = ls_kna1 es_dire = ls_dire ).
        "Conductor nro
        IF ls_cab-zzconnro IS INITIAL. ls_cab-zzconnro = ls_kna1-stcd1. ENDIF.
        "Conductor tipdoc
        IF ls_cab-zzcontpd_h IS INITIAL. ls_cab-zzcontpd_h = '01'. ENDIF.
        "Chofer
        IF ls_cab-zzconden IS INITIAL. ls_cab-zzconden = ls_dire-name. ENDIF.
        "N° Brevete
        IF ls_cab-zztrabvt IS INITIAL. ls_cab-zztrabvt = ls_dire-po_box_lobby. ENDIF.

        "Vehiculo
        get_interlocutor( EXPORTING i_vbeln = ls_likp-vbeln i_campo = 'PARVW_TRA_VEHICLE' IMPORTING es_kna1 = ls_kna1 es_dire = ls_dire ).
        "Número de placa del vehículo
        IF ls_cab-zzplaveh IS INITIAL. ls_cab-zzplaveh = ls_dire-name. ENDIF.
        "Marca
        IF ls_cab-zztramar IS INITIAL. ls_cab-zztramar = ls_dire-po_box. ENDIF.
        "Constancia Inscripción / Configuracion Vehicular
        IF ls_cab-zztrancv IS INITIAL. ls_cab-zztrancv = ls_dire-regiogroup. ENDIF.
        "MTC
        IF ls_cab-zztramtc IS INITIAL. ls_cab-zztramtc = ls_dire-location. ENDIF.

        ls_cab-zztrsmod_h = ls_likp-lfart.  "+@KAR
      ENDIF.
*}I-PBM081222-3000019824
*{  BEGIN OF INSERT WMR-191018-3000009770
    ELSE.

*{I-PBM081222-3000019824
      "No tiene transporte o Recojo de cliente(02)
      IF ( ls_likp-vsbed EQ '02' ).
        "Número de placa del vehículo
        ls_cab-zzplaveh = read_text_vbbk_zconst( i_campo = 'TDID_PLVEH' i_vbeln = ls_likp-vbeln i_kunnr = ls_likp-kunag ).
        "N° Brevete
        ls_cab-zztrabvt = read_text_vbbk_zconst( i_campo = 'TDID_NRCND' i_vbeln = ls_likp-vbeln i_kunnr = ls_likp-kunag ).
      ENDIF.
*}I-PBM081222-3000019824

      " EN CASO QUE NO SE MANEJEN TRANSPORTES

      "Indicador de transbordo programado
      ls_cab-zzindtnb = abap_off.

      CASE zconst-zztrafec.
        WHEN '' OR 'I' OR 'II'.
          "Fecha de inicio de traslado
          ls_cab-zztrafec = ls_likp-wadat_ist.
          IF ls_cab-zztrafec IS INITIAL.
            ls_cab-zztrafec = ls_likp-wadat.
          ENDIF.
          CASE gs_process-license.                                                        "I-WMR-130619-3000010823
            WHEN '0020262397'.  " ARTESCO                                                 "I-WMR-130619-3000010823
              IF ls_likp-vbtyp = 'T'. " Entrega de devolución                             "I-WMR-130619-3000010823
                ls_cab-zztrafec = ls_likp-erdat.  " Tomar fecha de creación               "I-WMR-130619-3000010823
              ENDIF.                                                                      "I-WMR-130619-3000010823
          ENDCASE.                                                                        "I-WMR-130619-3000010823
          "Hora inicio de traslado
          ls_cab-zztrahor = ls_likp-spe_wauhr_ist.
*{+NTP230223_3000020723
        WHEN 'III'.
          ls_cab-zztrafec = ls_cab-zzfecemi.
          ls_cab-zztrahor = ls_cab-zzhoremi.
      ENDCASE.
*}+NTP230223_3000020723

      "Modalidad de traslado
      IF ls_cab-zztrsmod_h IS INITIAL.                                                "+NTP010423-3000020188
        READ TABLE gth_hom18 INTO ls_hom18 WITH TABLE KEY shtyp    = space
                                                          lfart    = ls_likp-lfart
                                                          tor_type = space.              "+@KAR
*{+NTP010423-3000020188
        IF sy-subrc = 0.
          ls_cab-zztrsmod_h = ls_hom18-zz_codigo_sunat.
        ELSE.
          IF ls_cab-is_trasladointerno IS NOT INITIAL.
            ls_cab-zztrsmod_h = '02'.
          ELSE.
            ls_cab-zztrsmod_h = '01'.
          ENDIF.
        ENDIF.
      ENDIF.
      IF ls_cab-zztrsmod_h IS NOT INITIAL.
*}+NTP010423-3000020188
*{+081122-NTP-3000020296
        "TRANSPORTISTA
        get_interlocutor( EXPORTING i_vbeln = ls_likp-vbeln i_campo = 'PARVW_TRA' IMPORTING es_kna1 = ls_kna1 es_dire = ls_dire ).
        "Número de RUC transportista
        ls_cab-zztranro = ls_kna1-stcd1.
        ls_cab-zztratpd_h = ls_kna1-stcdt.
        "Apellidos y nombres o denominación o razón social del transportista
        ls_cab-zztraden = ls_dire-name.
        ls_cab-zztradir = ls_dire-direccion.                                      "I-PBM190423-3000020600
        "MTC
        ls_cab-zztramtc = ls_dire-remark. "+NTP280223_3000020702

        CASE gw_license.
          WHEN '0020262397'. "artesco
            "set_data_rem_traslado_mod_arte( ).

          WHEN OTHERS.
*{+NTP010323_3000019645
            read_text_vbbk_zconst2(
              EXPORTING
                i_campo = 'TDID_CONDUCTOR'
                i_vbeln = ls_likp-vbeln
                i_kunnr = ls_likp-kunnr
              IMPORTING
                e_val1  = ls_cab-zzplaveh   "Número de placa del vehículo
                e_val2  = ls_cab-zztrancv   "Constancia inscripcion
                e_val3  = ls_cab-zzcontpd_h "Conductor tipdoc
                e_val4  = ls_cab-zzconnro   "Conductor nro documento
                e_val5  = ls_cab-zzconden   "Conductor nombres y apellidos
                e_val6  = ls_cab-zztrabvt   "Brevete
            ).
*}+NTP010323_3000019645

*{+081122-NTP-3000020296
            "TRANSPORTISTA
            CASE ls_cab-zztrsmod_h.
              WHEN gc_modtras_publico.
                "Número de autorización MTC
                ls_cab-zztramtc = read_text_vbbk_zconst( i_campo = 'TDID_MTC' i_vbeln = ls_likp-vbeln i_kunnr = ls_likp-kunag ).          "I-PBM190423-3000020600
            ENDCASE.

            "PRINCIPAL vehiculo
            "Número de placa del vehículo
            ls_cab-zzplaveh = read_text_vbbk_zconst( i_campo = 'TDID_PLVEH' i_vbeln = ls_likp-vbeln i_kunnr = ls_likp-kunag ).
            "N° Contancia Inscripción
            ls_cab-zztranci = read_text_vbbk_zconst( i_campo = 'TDID_CEVEH' i_vbeln = ls_likp-vbeln i_kunnr = ls_likp-kunag ).
            "Marca
            ls_cab-zztramar = read_text_vbbk_zconst( i_campo = 'TDID_MAVEH' i_vbeln = ls_likp-vbeln i_kunnr = ls_likp-kunag ).
            "Configuracion vehicular
            ls_cab-zztrancv = read_text_vbbk_zconst( i_campo = 'TDID_TRACV' i_vbeln = ls_likp-vbeln i_kunnr = ls_likp-kunag ).

            "PRINCIPAL conductor
            "Conductor nro
            ls_cab-zzconnro = read_text_vbbk_zconst( i_campo = 'TDID_CONNRO' i_vbeln = ls_likp-vbeln i_kunnr = ls_likp-kunag ).
            "Conductor tipdoc
            ls_cab-zzcontpd_h = read_text_vbbk_zconst( i_campo = 'TDID_CONTPD_H' i_vbeln = ls_likp-vbeln i_kunnr = ls_likp-kunag ).
            IF ls_cab-zzcontpd_h IS INITIAL. ls_cab-zzcontpd_h = '01'. ENDIF.
            "Conductor
            ls_cab-zzconden = read_text_vbbk_zconst( i_campo = 'TDID_CHOFE' i_vbeln = ls_likp-vbeln i_kunnr = ls_likp-kunag ).
            "N° Brevete
            ls_cab-zztrabvt = read_text_vbbk_zconst( i_campo = 'TDID_NRCND' i_vbeln = ls_likp-vbeln i_kunnr = ls_likp-kunag ).

            "Datos adicionales
            ls_cab-zztdadi1 = read_text_vbbk_zconst( i_campo = 'TDID_D_AD1' i_vbeln = ls_likp-vbeln i_kunnr = ls_likp-kunag i_compress = '#' ).

            "SECUNDARIO vehiculo hasta 2
            "SECUNDARIO conductores hasta 2
        ENDCASE.
*{-081122-NTP-3000020296
**{I-3000010823-NTP-060819
*      ELSE.
*        CASE gw_license.
*          WHEN '0020262397'. "artesco
*            "Privado
*            IF ls_likp-bolnr IS NOT INITIAL AND ls_likp-xabln IS NOT INITIAL.
*              "Privado
*              "Número de RUC transportista
*              ls_cab-zztranro = ls_likp-xabln.
*              ls_cab-zztratpd_h = ls_likp-traty.
*              "Apellidos y nombres o denominación o razón social del transportista
*              ls_cab-zztraden = ls_likp-bolnr.
*              "Número de placa del vehículo
*              ls_cab-zzplaveh = ls_likp-traid.
*            ELSE.
*              "Publico
*              "TRANSPORTISTA
*              get_interlocutor( EXPORTING i_vbeln = ls_likp-vbeln i_campo = 'PARVW_TRA' IMPORTING es_kna1 = ls_kna1 es_dire = ls_dire ).
*              "Número de RUC transportista
*              ls_cab-zztranro = ls_kna1-stcd1.
*              ls_cab-zztratpd_h = ls_kna1-stcdt.
*              "Apellidos y nombres o denominación o razón social del transportista
*              ls_cab-zztraden = ls_dire-name.
*            ENDIF.
*          WHEN OTHERS.
*        ENDCASE.
**}I-3000010823-NTP-060819
*}-081122-NTP-3000020296
      ENDIF.
*}  END OF INSERT WMR-191018-3000009770
    ENDIF.

  ENDMETHOD.


  METHOD set_data_rem_traslado_mod_inka.

    DATA: ls_vttp  LIKE LINE OF gth_vttp,
          l_tabix  TYPE i,
          ls_vttk  LIKE LINE OF gth_vttk,
          ls_hom18 LIKE LINE OF gth_hom18,
          ls_kna1  LIKE LINE OF gth_kna1,
          ls_dire  TYPE gty_direccion.


    READ TABLE gth_vttp INTO ls_vttp WITH TABLE KEY vbeln = ls_likp-vbeln.
    IF sy-subrc = 0.
      " Transporte
      ls_cab-tknum = ls_vttp-tknum.

      "Indicador de transbordo programado
      l_tabix = 0.
      LOOP AT gth_vtts TRANSPORTING NO FIELDS WHERE tknum = ls_vttp-vbeln.
        ADD 1 TO l_tabix.
      ENDLOOP.
      IF l_tabix > 1.
        ls_cab-zzindtnb = abap_on.
      ELSE.
        ls_cab-zzindtnb = abap_off.
      ENDIF.

      READ TABLE gth_vttk INTO ls_vttk WITH TABLE KEY tknum = ls_vttp-tknum.
      IF sy-subrc = 0.

        ls_cab-zztrafec = ls_vttk-datbg.
        ls_cab-zztrahor = ls_vttk-uatbg.
        ls_cab-shtyp    = ls_vttk-shtyp. "+301222-NTP-3000020710

        "Modalidad de traslado
        READ TABLE gth_hom18 INTO ls_hom18 WITH TABLE KEY shtyp    = ls_vttk-shtyp
                                                          lfart    = space
                                                          tor_type = space.              "+@KAR
        IF sy-subrc = 0.
          ls_cab-zztrsmod_h = ls_vttk-shtyp.
          "Transportista (Transporte Público)
          get_interlocutor( EXPORTING i_vbeln = ls_vttp-tknum i_campo = 'PARVW_TRA' IMPORTING es_kna1 = ls_kna1 es_dire = ls_dire ).
          IF ls_dire IS INITIAL.
            READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_vttk-tdlnr.
            IF sy-subrc = 0.
              READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_kna1-adrnr.
            ENDIF.
          ENDIF.
          IF sy-subrc = 0.

            "Número de RUC transportista
            ls_cab-zztranro = ls_kna1-stcd1.
            ls_cab-zztratpd_h = ls_kna1-stcdt.

            "Apellidos y nombres o denominación o razón social del transportista
            ls_cab-zztraden = ls_dire-name.
          ENDIF.
          "Marca
          SELECT SINGLE bezei INTO ls_cab-zztramar FROM vtadd01t WHERE add_info = ls_vttk-add01 AND spras = sy-langu.
          "Número de placa del vehículo
          ls_cab-zzplaveh = ls_vttk-tpbez.
          "Conductor nro
          ls_cab-zzconnro = ls_vttk-text2.
          "Conductor tipdoc
          ls_cab-zzcontpd_h = '01'.
          "Chofer
          ls_cab-zzconden = ls_vttk-text3.
          "N° Brevete
          ls_cab-zztrabvt = ls_vttk-text1.
          "Constancia Inscripción / Configuracion Vehicular
          SELECT SINGLE bezei INTO ls_cab-zztrancv FROM vtadd02t WHERE add_info = ls_vttk-add02 AND spras = sy-langu.
          "MTC
          ls_cab-zztramtc = ls_vttk-signi.
        ENDIF.
      ENDIF.
    ELSE.
      "Indicador de transbordo programado
      ls_cab-zzindtnb = abap_off.
    ENDIF.

    "Fecha de inicio de traslado
    ls_cab-zztrafec = ls_likp-wadat_ist.
    IF ls_cab-zztrafec IS INITIAL.
      ls_cab-zztrafec = ls_likp-wadat.
    ENDIF.

    "Transportista
    get_interlocutor( EXPORTING i_vbeln = ls_likp-vbeln i_campo = 'PARVW_TRA' IMPORTING es_kna1 = ls_kna1 es_dire = ls_dire ).
    "Número de RUC transportista
    IF ls_cab-zztranro IS INITIAL. ls_cab-zztranro = ls_kna1-stcd1. ENDIF.
    IF ls_cab-zztratpd_h IS INITIAL. ls_cab-zztratpd_h = ls_kna1-stcdt. ENDIF.
    "Apellidos y nombres o denominación o razón social del transportista
    IF ls_cab-zztraden IS INITIAL. ls_cab-zztraden = ls_dire-name. ENDIF.

    "Conductor
    get_interlocutor( EXPORTING i_vbeln = ls_likp-vbeln i_campo = 'PARVW_TRA_CONDUCTOR' IMPORTING es_kna1 = ls_kna1 es_dire = ls_dire ).
    "Conductor nro
    IF ls_cab-zzconnro IS INITIAL. ls_cab-zzconnro = ls_kna1-stcd1. ENDIF.
    "Conductor tipdoc
    IF ls_cab-zzcontpd_h IS INITIAL. ls_cab-zzcontpd_h = '01'. ENDIF.
    "Chofer
    IF ls_cab-zzconden IS INITIAL. ls_cab-zzconden = ls_dire-name. ENDIF.
    "N° Brevete
    IF ls_cab-zztrabvt IS INITIAL. ls_cab-zztrabvt = ls_dire-po_box_lobby. ENDIF.

    "Vehiculo
    get_interlocutor( EXPORTING i_vbeln = ls_likp-vbeln i_campo = 'PARVW_TRA_VEHICLE' IMPORTING es_kna1 = ls_kna1 es_dire = ls_dire ).
    "Número de placa del vehículo
    IF ls_cab-zzplaveh IS INITIAL. ls_cab-zzplaveh = ls_dire-name. ENDIF.
    "Marca
    IF ls_cab-zztramar IS INITIAL. ls_cab-zztramar = ls_dire-po_box. ENDIF.
    "Constancia Inscripción / Configuracion Vehicular
    IF ls_cab-zztrancv IS INITIAL. ls_cab-zztrancv = ls_dire-regiogroup. ENDIF.
    "MTC
    IF ls_cab-zztramtc IS INITIAL. ls_cab-zztramtc = ls_dire-location. ENDIF.

  ENDMETHOD.


  METHOD set_data_rem_traslado_mot.

    DATA: ls_lips  LIKE LINE OF it_lips,
          ls_vbak  LIKE LINE OF gth_vbak,
          ls_hom20 LIKE LINE OF gth_hom20,
          ls_cat20 LIKE LINE OF gth_cat20,
          l_kvgr1  TYPE zostb_catahomo20-kvgr1, "+081122-NTP-3000020296
          l_kvgr2  TYPE zostb_catahomo20-kvgr2. "+081122-NTP-3000020296

*{+010922-NTP-3000018956
    "Motivo del traslado
    CASE gw_license.
      WHEN '0020886706'.  "Piramide
        READ TABLE it_lips INTO ls_lips WITH KEY vbeln = ls_likp-vbeln.
        IF sy-subrc = 0.
          READ TABLE gth_vbak INTO ls_vbak WITH TABLE KEY vbeln = ls_lips-vgbel.
          IF sy-subrc = 0.
            l_kvgr2 = ls_vbak-kvgr2.
          ENDIF.
        ENDIF.

      WHEN '0020262397'.  " ARTESCO
        l_kvgr2 = ls_likp-zzkvgr2.

*{+081122-NTP-3000020296
      WHEN '0020767991'.  "Inka
        READ TABLE it_lips INTO ls_lips WITH KEY vbeln = ls_likp-vbeln.
        IF sy-subrc = 0.
          READ TABLE gth_vbak INTO ls_vbak WITH TABLE KEY vbeln = ls_lips-vgbel.
          IF sy-subrc = 0.
            l_kvgr1 = ls_vbak-kvgr1.
          ENDIF.
        ENDIF.
*}+081122-NTP-3000020296
*{I-PBM190423-3000020600
**      WHEN '0021225088'.   "Resemin
**        set_data_rem_traslado_mot_rese( EXPORTING ls_likp = ls_likp it_lips = it_lips CHANGING ls_cab = ls_cab ).
**        IF ls_cab-zztrsden IS NOT INITIAL.
**          EXIT.
**        ENDIF.
*}I-PBM190423-3000020600
    ENDCASE.

    IF ls_cab-zztrsmot_h IS INITIAL. "+NTP010423-3000020188
      READ TABLE gth_hom20 INTO ls_hom20 WITH KEY lfart = ls_likp-lfart kvgr1 = l_kvgr1 kvgr2 = l_kvgr2.
      IF sy-subrc <> 0.
        IF l_kvgr1 IS NOT INITIAL OR l_kvgr2 IS NOT INITIAL.
          READ TABLE gth_hom20 INTO ls_hom20 WITH KEY lfart = space kvgr1 = l_kvgr1 kvgr2 = l_kvgr2.
        ENDIF.
        IF sy-subrc <> 0 AND ls_likp-lfart IS NOT INITIAL.
          READ TABLE gth_hom20 INTO ls_hom20 WITH KEY lfart = ls_likp-lfart.
        ENDIF.
      ENDIF.
      IF sy-subrc = 0.
        ls_cab-zztrsmot_h = ls_hom20-zz_codigo_sunat.
        ls_cab-zztrsden   = ls_hom20-zz_desc_cod_suna.
      ENDIF.
    ENDIF.
    READ TABLE gth_cat20 INTO ls_cat20 WITH TABLE KEY zz_codigo_sunat = ls_cab-zztrsmot_h.
    IF sy-subrc = 0.
      ls_cab-is_trsden_cust     = ls_cat20-is_desc_cust.
      IF ls_cab-is_trsden_cust IS INITIAL.
        ls_cab-zztrsden         = ls_cat20-zz_desc_cod_suna.
      ENDIF.
      ls_cab-is_trasladointerno = ls_cat20-is_trasladointerno.
    ENDIF.
*}+010922-NTP-3000018956

*{-010922-NTP-3000018956
*    "Motivo del traslado
*    ls_cab-zztrsmot_h = ls_likp-lfart.
**{  BEGIN OF INSERT WMR-021018-3000010605
*    CASE gw_license.
*      WHEN '0020886706'   "Piramide
*        OR '0020311006'.  " AIB
*        READ TABLE it_lips INTO ls_lips WITH KEY vbeln = ls_likp-vbeln.
*        IF sy-subrc = 0.
*          READ TABLE gth_vbak INTO ls_vbak WITH TABLE KEY vbeln = ls_lips-vgbel.
*          IF sy-subrc = 0.
*            READ TABLE gth_hom20 INTO ls_hom20 WITH KEY lfart = space
*                                                              kvgr2 = ls_vbak-kvgr2.
*            IF sy-subrc = 0.
*              ls_cab-zztrsmot_h   = ls_hom20-zz_codigo_sunat.
*              IF ls_hom20-zz_desc_cod_suna IS NOT INITIAL.
*                ls_cab-zztrsden = ls_hom20-zz_desc_cod_suna.
*              ELSE.
*                READ TABLE gth_cat20 INTO ls_cat20 WITH TABLE KEY zz_codigo_sunat = ls_cab-zztrsmot_h.
*                IF sy-subrc = 0.
*                  ls_cab-zztrsden = ls_cat20-zz_desc_cod_suna.
*                ENDIF.
*              ENDIF.
*            ENDIF.
*          ENDIF.
*        ENDIF.
*
**{  BEGIN OF INSERT WMR-051218-3000009770
*      WHEN '0020311006'   " AIB
*        OR '0020262397'.  " ARTESCO                                               "I-WMR-230419-3000010823
*        READ TABLE gth_hom20 INTO ls_hom20 WITH KEY lfart = space
*                                                          kvgr2 = ls_likp-zzkvgr2.
*        IF sy-subrc = 0.
*          ls_cab-zztrsmot_h   = ls_hom20-zz_codigo_sunat.
*          IF ls_hom20-zz_desc_cod_suna IS NOT INITIAL.
*            ls_cab-zztrsden = ls_hom20-zz_desc_cod_suna.
*          ELSE.
*            READ TABLE gth_cat20 INTO ls_cat20 WITH TABLE KEY zz_codigo_sunat = ls_cab-zztrsmot_h.
*            IF sy-subrc = 0.
*              ls_cab-zztrsden = ls_cat20-zz_desc_cod_suna.
*            ENDIF.
*          ENDIF.
*        ENDIF.
**}  END OF INSERT WMR-051218-3000009770
*    ENDCASE.
**}  END OF INSERT WMR-021018-3000010605
*}-010922-NTP-3000018956

  ENDMETHOD.


  METHOD set_homo_cli.

    DATA: ls_cab     LIKE LINE OF pi_cab,
          ls_kna1    TYPE gty_kna1,
          ls_dire    TYPE gty_direccion,
          ls_cliente LIKE LINE OF pe_cli.

*   Lectura de la Tabla lt_vbrk y creacion de Clientes
    LOOP AT pi_cab INTO ls_cab.

*      ls_cliente-zzt_nrodocsap  = ls_cab-vbeln.    "-NTP010423-3000020188
      ls_cliente-zzt_nrodocsap  = ls_cab-zznrosap.  "+NTP010423-3000020188
      ls_cliente-zzt_gjahr      = ls_cab-zzgjahr.   "+NTP010423-3000020188
      ls_cliente-zzt_numeracion = ls_cab-zznrosun.

      READ TABLE gth_kna1 INTO ls_kna1 WITH TABLE KEY kunnr = ls_cab-kunnr.
      IF sy-subrc = 0.
        "RUC
        ls_cliente-ruc = ls_cab-kunnr.

        READ TABLE gth_dire INTO ls_dire WITH TABLE KEY adrnr = ls_kna1-adrnr.
        IF sy-subrc = 0.
          "Telefono
          ls_cliente-telefono = ls_dire-tel_number.
          "Razon Social
          ls_cliente-razon_social = ls_dire-name.
          "Dirección
          CONCATENATE ls_dire-street
                      ls_dire-stnumb
                      ls_dire-str_suppl1
                      ls_dire-str_suppl2
                      ls_dire-str_suppl3
                      ls_dire-distri
                      ls_dire-provin
                      ls_dire-depmto
                      INTO ls_cliente-direccion SEPARATED BY space.
          CONDENSE ls_cliente-direccion.
          TRANSLATE ls_cliente-direccion TO UPPER CASE.
          "Email
          SPLIT ls_dire-smtp_addr AT ';' INTO ls_cliente-email ls_dire-smtp_addr.

*{+3000018956-010722-NTP
          "Ubigeo
          ls_cliente-zz_ubigeo = ls_dire-ubigeo.
          "Urbanización
          ls_cliente-zz_urbani = ls_dire-str_suppl1.
          "País
          ls_cliente-zz_pais   = ls_dire-pais.
          "Departamento
          ls_cliente-zz_depart = ls_dire-depmto.
          "Provincia
          ls_cliente-zz_provin = ls_dire-provin.
          "Distrito
          ls_cliente-zz_distri = ls_dire-distri.
*}+3000018956-010722-NTP
        ENDIF.
      ENDIF.

*     Adicionar registro
      APPEND ls_cliente TO pe_cli.
      CLEAR ls_cliente.
    ENDLOOP.

  ENDMETHOD.                    "set_cli


  METHOD set_homo_json_and_send_ws.
*{+NTP010523-3000020188
    DATA: lt_cab_json TYPE gtt_fegrcab_json,
          lt_det_json TYPE gtt_fegrdet_json.

    IF is_options-only_syncstat IS INITIAL.
* Formar Datos Cabecera
      set_homo_rem( CHANGING ct_cab = lt_cab
                             ct_det = lt_det ).

* Formar Datos Cliente
      set_homo_cli( EXPORTING pi_cab = lt_cab
                    IMPORTING pe_cli = lt_cli ).

      es_datanojson-t_header = lt_cab. es_datanojson-t_detail = lt_det.  es_datanojson-t_shipto = lt_cli.
      es_datanojson-s_ubl = gs_ubl.
      es_datanojson-s_consextsun = gs_consextsun.
      IF is_options-only_datanojs EQ abap_true.
        EXIT.
      ENDIF.

* Verificar Homologación
      check_homo_rem( EXPORTING  pi_cab     = lt_cab
                                 pi_det     = lt_det
                                 is_options = is_options
                      IMPORTING  et_return  = et_return
                      EXCEPTIONS error      = 1 ).
      IF sy-subrc <> 0.
        RAISE error.
      ENDIF.
      IF is_options-test EQ abap_on.
        EXIT.
      ENDIF.
    ENDIF.

* Setear valores JSon
    set_json_rem( EXPORTING pi_cab      = lt_cab
                            pi_det      = lt_det
                  IMPORTING pe_cab_json = lt_cab_json
                            pe_det_json = lt_det_json ).

* Actualizar tabla Z
    IF is_options-only_syncstat IS INITIAL.
      upd_tabla_rem( it_cab = lt_cab
                     it_det = lt_det
                     it_cli = lt_cli
                     it_cab_json = lt_cab_json
                     it_det_json = lt_det_json ).
    ENDIF.

* Enviar via WS
    call_is_gre( EXPORTING  i_bukrs        = g_bukrs
                            i_fkdat        = g_fecdoc
                            it_cab         = lt_cab_json
                            it_det         = lt_det_json
                            it_cli         = lt_cli
                            is_nojson_data = es_datanojson
                            is_options     = is_options
                 IMPORTING  pe_message     = et_return
                 EXCEPTIONS error          = 1 ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.
*}+NTP010523-3000020188
  ENDMETHOD.


  METHOD set_homo_rem.

    DATA: ls_hom06   TYPE zostb_catahomo06,
          ls_hom18   TYPE zostb_catahomo18,
          ls_hom20   TYPE zostb_catahomo20,
          ls_cat18   LIKE LINE OF gth_cat18,                        "+NTP010523-3000020188
          ls_asgtnhr LIKE LINE OF gth_asgtnhr.                      "I-PBM061222-3000020028

    FIELD-SYMBOLS: <fs_cab> LIKE LINE OF ct_cab,
                   <fs_det> LIKE LINE OF ct_det.


    "Procesamiento
    LOOP AT ct_cab ASSIGNING <fs_cab>.

      "Unidad de medida del peso bruto
      SELECT SINGLE isocode INTO <fs_cab>-zzundmed_h FROM t006 WHERE msehi = <fs_cab>-zzundmed_h.
      IF sy-subrc <> 0.
        CLEAR <fs_cab>-zzundmed_h.
      ENDIF.

      "Remitente - Tipo de documento de identidad
      READ TABLE gth_hom06 INTO ls_hom06 WITH TABLE KEY stcdt = <fs_cab>-zzremtpd_h.
      IF sy-subrc = 0.
        <fs_cab>-zzremtpd_h = ls_hom06-zz_codigo_sunat.
      ELSE.
        CLEAR <fs_cab>-zzremtpd_h.
      ENDIF.

      "Destinatario - Tipo de documento de identidad
      READ TABLE gth_hom06 INTO ls_hom06 WITH TABLE KEY stcdt = <fs_cab>-zzdsttpd_h.
      IF sy-subrc <> 0.
        READ TABLE gth_hom06 INTO ls_hom06 WITH KEY zz_codigo_sunat = <fs_cab>-zzdsttpd_h.
      ENDIF.
      IF sy-subrc = 0.
        <fs_cab>-zzdsttpd_h = ls_hom06-zz_codigo_sunat.
*{  BEGIN OF INSERT WMR-070318-3000008769
        CASE gw_license.
          WHEN '0020886706'.  " PIRAMIDE
*            OR '0020311006'   " AIB                                                     "I-WMR-191018-3000009770
*            OR '0020863116'.  " AIB CLOUD
            CASE <fs_cab>-zzdsttpd_h.
              WHEN '1'. CONCATENATE 'DNI' <fs_cab>-zzdstnro INTO <fs_cab>-zzdstnro SEPARATED BY space.
              WHEN '6'. CONCATENATE 'RUC' <fs_cab>-zzdstnro INTO <fs_cab>-zzdstnro SEPARATED BY space.
            ENDCASE.
        ENDCASE.
*}  END OF INSERT WMR-070318-3000008769
      ELSE.
        CLEAR <fs_cab>-zzdsttpd_h.
      ENDIF.

*{-010922-NTP-3000018956
*      "Datos de envío
**{  BEGIN OF INSERT WMR-021018-3000010605
*      CASE gw_license.
*        WHEN '0020886706'  "Piramide
*          OR '0020311006'   " AIB
*          OR '0020863116'.  " AIB CLOUD
*        WHEN OTHERS.
**}  END OF INSERT WMR-021018-3000010605
*          READ TABLE gth_hom20 INTO ls_hom20 WITH TABLE KEY lfart = <fs_cab>-zztrsmot_h
*                                                            kvgr2 = space.          "I-WMR-021018-3000010605
*          IF sy-subrc = 0.
*            "Motivo del traslado
*            <fs_cab>-zztrsmot_h = ls_hom20-zz_codigo_sunat.
*          ELSE.
*            CLEAR <fs_cab>-zztrsmot_h.
*          ENDIF.
**{  BEGIN OF INSERT WMR-021018-3000010605
*      ENDCASE.
**}  END OF INSERT WMR-021018-3000010605
*}-010922-NTP-3000018956

      "Modalidad de traslado
*{  BEGIN OF REPLACE WMR-191018-3000009770
**    READ TABLE gth_hom18 INTO ls_hom18 WITH TABLE KEY shtyp = <fs_cab>-zztrsmod_h.
*      IF <fs_cab>-tknum IS NOT INITIAL.
      READ TABLE gth_hom18 INTO ls_hom18 WITH TABLE KEY shtyp    = <fs_cab>-zztrsmod_h
                                                        lfart    = space
                                                        tor_type = space.
      IF sy-subrc NE 0.
        READ TABLE gth_hom18 INTO ls_hom18 WITH TABLE KEY shtyp    = space
                                                          lfart    = space
                                                          tor_type = <fs_cab>-zztrsmod_h.
        IF sy-subrc NE 0.
          READ TABLE gth_hom18 INTO ls_hom18 WITH TABLE KEY shtyp    = space
                                                            lfart    = <fs_cab>-zztrsmod_h
                                                            tor_type = space.
          IF sy-subrc <> 0.
            READ TABLE gth_cat18 INTO ls_cat18 WITH KEY zz_codigo_sunat = <fs_cab>-zztrsmod_h.
            ls_hom18-zz_codigo_sunat = ls_cat18-zz_codigo_sunat.
          ENDIF.
        ENDIF.
      ENDIF.
*      ELSE.
*      ENDIF.
*}  END OF REPLACE WMR-191018-3000009770
      IF sy-subrc = 0.
        <fs_cab>-zztrsmod_h = ls_hom18-zz_codigo_sunat.
      ELSE.
        CLEAR <fs_cab>-zztrsmod_h.
      ENDIF.

      "Tipo de documento de identidad del conductor
      READ TABLE gth_hom06 INTO ls_hom06 WITH TABLE KEY stcdt = <fs_cab>-zzcontpd_h.
*{+NTP010423-3000020188
      IF sy-subrc <> 0.
        READ TABLE gth_hom06 INTO ls_hom06 WITH KEY zz_codigo_sunat = <fs_cab>-zzcontpd_h.
      ENDIF.
*}+NTP010423-3000020188
      IF sy-subrc = 0.
        <fs_cab>-zzcontpd_h = ls_hom06-zz_codigo_sunat.
      ELSE.
        READ TABLE gth_asgtnhr INTO ls_asgtnhr WITH KEY taxtype = <fs_cab>-zzcontpd_h.        "I-PBM061222-3000020028
        IF sy-subrc = 0.                                                                      "I-PBM061222-3000020028
          <fs_cab>-zzcontpd_h = ls_asgtnhr-stcdt.                                             "I-PBM061222-3000020028
        ELSE.                                                                                 "I-PBM061222-3000020028
          CLEAR <fs_cab>-zzcontpd_h.
        ENDIF.                                                                                "I-PBM061222-3000020028
      ENDIF.

      "Transportista (Transporte Público) - Tipo de documento del transportista
      READ TABLE gth_hom06 INTO ls_hom06 WITH TABLE KEY stcdt = <fs_cab>-zztratpd_h.
      IF sy-subrc <> 0.
        READ TABLE gth_hom06 INTO ls_hom06 WITH KEY zz_codigo_sunat = <fs_cab>-zztratpd_h.
      ENDIF.
      IF sy-subrc = 0.
        <fs_cab>-zztratpd_h = ls_hom06-zz_codigo_sunat.
      ELSE.
*{I-PBM061222-3000020028
        READ TABLE gth_asgtnhr INTO ls_asgtnhr WITH KEY taxtype = <fs_cab>-zztratpd_h.
        IF sy-subrc = 0.
          READ TABLE gth_hom06 INTO ls_hom06 WITH TABLE KEY stcdt = ls_asgtnhr-stcdt.
          IF sy-subrc = 0.
            <fs_cab>-zztratpd_h = ls_hom06-zz_codigo_sunat.
          ENDIF.
        ENDIF.
        IF sy-subrc <> 0.
          CLEAR <fs_cab>-zztratpd_h.
        ENDIF.
*}I-PBM061222-3000020028
      ENDIF.

*{  BEGIN OF INSERT WMR-070318-3000008769
      " Solicitante - Tipo de documento de identidad
      READ TABLE gth_hom06 INTO ls_hom06 WITH TABLE KEY stcdt = <fs_cab>-zzslctpd_h.
      IF sy-subrc <> 0.
        READ TABLE gth_hom06 INTO ls_hom06 WITH KEY zz_codigo_sunat = <fs_cab>-zzslctpd_h.
      ENDIF.
      IF sy-subrc = 0.
        <fs_cab>-zzslctpd_h = ls_hom06-zz_codigo_sunat.
        CASE gw_license.
          WHEN '0020886706'.  " PIRAMIDE
*            OR '0020311006'   " AIB                                                     "I-WMR-191018-3000009770
*            OR '0020863116'.  " AIB CLOUD
            CASE <fs_cab>-zzslctpd_h.
              WHEN '1'. CONCATENATE 'DNI' <fs_cab>-zzslcnro INTO <fs_cab>-zzslcnro SEPARATED BY space.
              WHEN '6'. CONCATENATE 'RUC' <fs_cab>-zzslcnro INTO <fs_cab>-zzslcnro SEPARATED BY space.
            ENDCASE.
        ENDCASE.
      ELSE.
        READ TABLE gth_hom06 INTO ls_hom06 WITH KEY zz_codigo_sunat = <fs_cab>-zzslctpd_h.
        IF sy-subrc <> 0.
          CLEAR <fs_cab>-zzslctpd_h.
        ENDIF.
      ENDIF.
*}  END OF INSERT WMR-070318-3000008769
    ENDLOOP.

**********************************************************************
*   2. POSICION
**********************************************************************
    LOOP AT ct_det ASSIGNING <fs_det>.
      SELECT SINGLE codsun INTO <fs_det>-zziteund_h FROM zostb_catahomo03 WHERE meins = <fs_det>-zziteund_h. "Unidad de medida del ítem "I-PBM170123-3000020386
      IF sy-subrc <> 0.
        SELECT SINGLE isocode INTO <fs_det>-zziteund_h FROM t006 WHERE msehi = <fs_det>-zziteund_h.     "Unidad de medida del ítem
        IF sy-subrc <> 0.
          CLEAR <fs_det>-zziteund_h.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD set_json_cli.

    DATA: ls_cliente LIKE LINE OF pi_cli,
          ls_fecli   LIKE LINE OF pe_cli_json.

    LOOP AT pi_cli INTO ls_cliente.
      CLEAR ls_fecli.
      ls_fecli-zzt_nrodocsap  = ls_cliente-zzt_nrodocsap.
      ls_fecli-zzt_numeracion = ls_cliente-zzt_numeracion.
      ls_fecli-ruc            = ls_cliente-ruc.
      ls_fecli-razon_social   = ls_cliente-razon_social.
      ls_fecli-direccion      = ls_cliente-direccion.
      ls_fecli-telefono       = ls_cliente-telefono.
      ls_fecli-email          = ls_cliente-email.
      APPEND ls_fecli TO pe_cli_json.
    ENDLOOP.

  ENDMETHOD.


  METHOD set_json_rem.

    DATA: l_zzindtnb  TYPE char10,
          l_zzpesbru  TYPE char20,
          l_zziteqty  TYPE char20,
          l_zzitepbr  TYPE char20,
          l_zzitepbt  TYPE char20,
          l_zzpalnum  TYPE char20,
          l_zztotblt  TYPE char20,                                                  "I-051219-NTP-3000013055
          l_string    TYPE string,                                                  "I-WMR-260517-3000007333
          l_paletas   TYPE string,                                                  "I-WMR-260517-3000007333
          l_unidades  TYPE string,                                                  "I-WMR-260517-3000007333

          ls_trsmot   TYPE zostb_catalogo20,
          ls_trsmod   TYPE zostb_catalogo18,                                        "I-WMR-071218-3000009765
          ls_cat61    LIKE LINE OF gth_cat61,                                       "+NTP010323-3000019645
          ls_const    LIKE LINE OF gt_const,                                        "+NTP010323-3000019645
          ls_catacons LIKE LINE OF lt_catacons,
          ls_catacon2 LIKE LINE OF lt_catacons,                                     "+NTP010323-3000019645

          ls_cab      LIKE LINE OF pi_cab,
          ls_det      LIKE LINE OF pi_det,

          ls_cab_json LIKE LINE OF pe_cab_json,
          ls_det_json LIKE LINE OF pe_det_json,

          lt_const    LIKE gt_const.                                                "+NTP220323-3000000051

    LOOP AT pi_cab INTO ls_cab.

      MOVE-CORRESPONDING ls_cab TO ls_cab_json.

*   Limpiar
      CLEAR: ls_trsmot,
             ls_trsmod.                                                             "I-WMR-071218-3000009765

*   Preparar datos
      CASE ls_cab_json-zzindtnb.
        WHEN abap_on.  l_zzindtnb = gc_true.
        WHEN abap_off. l_zzindtnb = gc_false.
        WHEN OTHERS.
      ENDCASE.

*   Prepara montos
      l_zzpesbru = ls_cab_json-zzpesbru. CONDENSE l_zzpesbru.
      l_zzpalnum = ls_cab_json-zzpalnum. CONDENSE l_zzpalnum.
*{I-PBM180520-3000013745
      CASE gw_license.
        WHEN '0020311006'  " AIB
          OR '0020863116'. " AIB CLOUD
          IF ls_cab-zztotblt_c IS NOT INITIAL.
            ls_cab_json-zztotblt = ls_cab-zztotblt_c.
          ENDIF.
      ENDCASE.
*}I-PBM180520-3000013745
      l_zztotblt = ls_cab_json-zztotblt. CONDENSE l_zztotblt. "I-051219-NTP-3000013055

      IF l_zzpesbru = '0.0'. CLEAR l_zzpesbru. ENDIF.
      IF l_zzpalnum = '0.0'. CLEAR l_zzpalnum. ENDIF.

*{  BEGIN OF INSERT WMR-191018-3000009770
      CASE gw_license.
        WHEN '0020886706'   "Piramide
          OR '0020311006'   " AIB
          OR '0020863116'   " AIB CLOUD
          OR '0021061097'   " CMH                                                   "I-WMR-080119-3000011134
          OR '0021154274'.  " Ilender                                               "I-PBM250423-3000020285
          "Fecha/ Hora Inicio Traslado
          CONCATENATE '{"0":"' ls_cab-zztrafec '",' '"1":"'  ls_cab-zztrahor '"}' INTO ls_cab_json-zztrafec.
        WHEN OTHERS.
      ENDCASE.
*}  END OF INSERT WMR-191018-3000009770

*   Descripcion de catalogos sunat
      READ TABLE gth_cat20 INTO ls_trsmot WITH TABLE KEY zz_codigo_sunat = ls_cab_json-zztrsmot_h.
      READ TABLE gth_cat18 INTO ls_trsmod WITH TABLE KEY zz_codigo_sunat = ls_cab_json-zztrsmod_h.  "I-WMR-071218-3000009765

*   Armar Jason
      "Remitente - Sociedad
*{R-PBM210922-3000019902
*    CONCATENATE '{"0":"' ls_cab_json-zzremnro    '",' '"1":"'  ls_cab_json-zzremtpd_h     '"}' INTO ls_cab_json-zzremnro.
      READ TABLE lt_catacons INTO ls_catacons WITH KEY zz_catalogo = gc_cat-catalogo06.
      IF sy-subrc = 0.
        CONCATENATE '{"0":"' ls_cab_json-zzremnro          '",'
                    '"1":"'  ls_cab_json-zzremtpd_h        '",'
                    '"2":"'  ls_catacons-zz_tagagencyname  '",'
                    '"3":"'  ls_catacons-zz_tagname        '",'
                    '"4":"'  ls_catacons-zz_taguri         '",'
                    '"5":"'  ls_cab-zz_emi_email           '",'    "email    I-08032023-3000019645
                    '"6":"'  ls_cab-zz_web_page            '"}'    "website  I-08032023-3000019645
               INTO ls_cab_json-zzremnro.
      ENDIF.
*}R-PBM210922-3000019902
*    CONCATENATE '{"0":"' gs_consextsun-zz_ubigeo       '",'
*                 '"1":"' gs_consextsun-zz_direccion    '",'
*                 '"2":"' gs_consextsun-zz_urbanizacion '",'
*                 '"3":"' gs_consextsun-zz_distrito '",'
*                 '"4":"' gs_consextsun-zz_provincia '",'
*                 '"5":"' gs_consextsun-zz_departamento '",'
*                 '"6":"' gs_consextsun-zz_pais '"}"' INTO ls_cab_json-zzemidir.
*    CONCATENATE '{"0":"' ls_dire_buk-tel_number '",' '"1":"' ls_dire_buk-fax_number '"}"' INTO ls_cab_json-zzemitel.
*      ls_cab_json-zzremden = gs_consextsun-zz_ncomercial.  "-010922-NTP-3000018956

*{R-PBM210922-3000019902
*    CONCATENATE '{"0":"' ls_cab_json-zzdstnro   '",' '"1":"'  ls_cab_json-zzdsttpd_h     '"}' INTO ls_cab_json-zzdstnro. "Destinatario
      READ TABLE lt_catacons INTO ls_catacons WITH KEY zz_catalogo = gc_cat-catalogo06.
      IF sy-subrc = 0.
        CONCATENATE '{"0":"' ls_cab_json-zzdstnro          '",'
                    '"1":"'  ls_cab_json-zzdsttpd_h        '",'
                    '"2":"'  ls_catacons-zz_tagagencyname  '",'
                    '"3":"'  ls_catacons-zz_tagname        '",'
                    '"4":"'  ls_catacons-zz_taguri         '",'
                    '"5":"'  ls_cab-zzdstcod               '"}' INTO ls_cab_json-zzdstnro. "Destinatario        "I-PBM081222-3000019824
      ENDIF.
*}R-PBM210922-3000019902
      CONCATENATE '{"0":"' ls_cab_json-zzetrnro   '",' '"1":"'  ls_cab_json-zzetrtpd_h     '"}' INTO ls_cab_json-zzetrnro. "Tercero

*{I-251220-NTP-3000014557
      CONCATENATE '{"0":"' ls_cab-zzdi1nro    '",'
                  '"1":"'  ls_cab-zzdi1den    '",'
                  '"2":"'  ls_cab-zzdi1dir    '"}' INTO ls_cab_json-zzdi1nro.
*}I-251220-NTP-3000014557

*{  BEGIN OF INSERT WMR-021018-3000010605
      CASE gw_license.
        WHEN '0020886706'. "Piramide
          CONCATENATE '{"0":"' ls_cab_json-zztrsmot_h '",' '"1":"'  ls_cab_json-zztrsden '"}' INTO ls_cab_json-zztrsmot_h. "Motivo y Descripción de traslado
        WHEN OTHERS.
*}  END OF INSERT WMR-021018-3000010605
          CONCATENATE '{"0":"' ls_cab_json-zztrsmot_h '",' '"1":"'  ls_trsmot-zz_desc_cod_suna '"}' INTO ls_cab_json-zztrsmot_h. "Motivo y Descripción de traslado
*{  BEGIN OF INSERT WMR-021018-3000010605
      ENDCASE.
*}  END OF INSERT WMR-021018-3000010605
      CONCATENATE '{"0":"' l_zzpesbru             '",' '"1":"'  ls_cab_json-zzundmed_h     '"}' INTO ls_cab_json-zzpesbru. "Peso y Unidad
*{  BEGIN OF REPLACE WMR-260517-3000007333
      ""      CONCATENATE '{"0":"' ls_cab_json-zztranro   '",' '"1":"'  ls_cab_json-zztratpd_h     '"}' INTO ls_cab_json-zztranro. "Transportista
      " Transportista
      CONCATENATE '{"0":"' ls_cab_json-zztranro         '",'
                   '"1":"' ls_cab_json-zztratpd_h       '",'
                   '"2":"' ls_cab_json-zztrabvt         '",'  "Brevete conductor
                   '"3":"' ls_cab_json-zztranci        '",'   "Tarjeta Única de Circulación Electrónica o Certificado de Habilitación vehicular o Constancia de Inscripcion
                   '"4":"' ls_cab_json-zztramar         '",'  "Marca de Vehiculo
                   '"5":"' ls_cab_json-zzconden         '",'  "Apellidos y nombre del conductor                 "+NTP010523-3000020188
                   '"6":"' ls_cab_json-zztrancv         '",'  "Configuracion vehicular                          "I-051219-NTP-3000013055
                   '"7":"' ls_cab_json-zztramtc         '"}'  "Número de Registro MTC
                   INTO ls_cab_json-zztranro.
*}  END OF REPLACE WMR-260517-3000007333

*      CASE gs_process-license.                                                                                "I-WMR-071218-3000009765
*        WHEN '0021061097'.  " CMH                                                                             "I-WMR-071218-3000009765
*          CONCATENATE '{"0":"' ls_cab_json-zztrsmod_h     '",'  " Código Modalidad traslado                   "I-WMR-071218-3000009765
*                      '"1":"'  l_zzindtnb                 '",'  " Indicador transbordo                        "I-WMR-071218-3000009765
*                      '"2":"'  l_zzpalnum                 '",'  " Bultos                                      "I-WMR-071218-3000009765
*                      '"3":"'  ls_trsmod-zz_desc_cod_suna '"}'  " Descripción del Código Modalidad traslado   "I-WMR-071218-3000009765
*                      INTO ls_cab_json-zztrsmod_h.                                                            "I-WMR-071218-3000009765
*        WHEN OTHERS.                                                                                          "I-WMR-071218-3000009765
      CONCATENATE '{"0":"' ls_cab_json-zztrsmod_h       '",'  " Código Modalidad traslado
                  '"1":"'  l_zzindtnb                   '",'  " Indicador transbordo
                  '"2":"'  l_zzpalnum                   '",'  " Bultos
                  '"3":"'  ls_trsmod-zz_desc_cod_suna   '",'  " Descripción del Código Modalidad traslado   "+NTP010223_3000019645
                  '"4":"'  ls_cab_json-zztranci         '",'  " Número de TUCE o Certificado De Habilitación Vehicular.
                  '"5":"'  ls_cab_json-zztramtc         '"}'  " Autorización MTC (autorización especial)
                  INTO ls_cab_json-zztrsmod_h.
*      ENDCASE.                                                                                                "I-WMR-071218-3000009765

      CONCATENATE '{"0":"' ls_cab_json-zzplaveh         '",'  "Número de placa del vehículo
                  '"1":"'  ls_cab_json-zzconnro         '",'  "Número de documento de identidad del conductor
                  '"2":"'  ls_cab_json-zzcontpd_h       '",'  "Tipo de documento
                  '"3":"'  ls_cab_json-zzplapas         '",'  "Placa pasiva si el vehiculo tiene tracto
                  '"4":"'  ls_cab_json-zzconden         '",'  "Apellidos y nombres del conductor
                  '"5":"'  ls_cab-zzdentpd_h            '"}'  "Tipo de documento denominacion                  "I-KAR-300323-0021279031 todo
                  INTO ls_cab_json-zzplaveh.

*{I-3000010823-NTP110219
*    CONCATENATE '{"0":"' ls_cab_json-zzlleubi   '",' '"1":"'  ls_cab_json-zzlledir       '"}' INTO ls_cab_json-zzlleubi.  "Llegada
*{+02022023-NTP-3000019902
      READ TABLE lt_catacons INTO ls_catacons WITH KEY zz_catalogo = gc_cat-catalogo13.
      IF sy-subrc = 0.
*}+02022023-NTP-3000019902
        CONCATENATE '{"0":"' ls_cab-zzlleubi              '",'
                    '"1":"'  ls_cab-zzlledir              '",'
                    '"2":"'  ls_cab-zzlleurb              '",'
                    '"3":"'  ls_cab-zzlledis              '",'
                    '"4":"'  ls_cab-zzllepro              '",'
                    '"5":"'  ls_cab-zzlledep              '",'
                    '"6":"'  ls_cab-zzllepai              '",'
                    '"7":"'  ls_cab-zzlleest              '",'
                    '"8":"'  ls_catacons-zz_tagid         '",'                           "I-PBM300123-3000019824
                    '"9":"'  ls_catacons-zz_tagagencyname '",'                           "I-PBM300123-3000019824
                    '"10":"' ls_catacons-zz_tagname       '"}'                           "I-PBM300123-3000019824
                    INTO ls_cab_json-zzlleubi.                                           "I-PBM061222-3000020028
      ENDIF.
*}+02022023-NTP-3000019902
*}I-3000010823-NTP110219
*{  BEGIN OF INSERT WMR-051018-3000010624
      CASE gw_license.
        WHEN '0020886706'. "Piramide
          "Punto de Partida
          CONCATENATE '{"0":"' ls_cab-zzparubi          '",'
                      '"1":"'  ls_cab-zzpardir          '",'
                      '"2":"'  ls_cab-zzparurb          '",'
                      '"3":"'  ls_cab-zzpardis          '",'
                      '"4":"'  ls_cab-zzparpro          '",'
                      '"5":"'  ls_cab-zzpardep          '",'
                      '"6":"'  ls_cab-zzparpai          '"}' INTO ls_cab_json-zzparubi.
        WHEN OTHERS.
*{R-PBM210922-3000019902
*        CONCATENATE '{"0":"' ls_cab_json-zzparubi   '",' '"1":"'  ls_cab_json-zzpardir       '"}' INTO ls_cab_json-zzparubi.  "Partida
          READ TABLE lt_catacons INTO ls_catacon2 WITH KEY zz_catalogo = gc_cat-catalogo04.  "I-PBM300123-3000019824
          IF ls_cab-zzparest IS INITIAL. CLEAR ls_catacon2. ENDIF.                           "I-PBM300123-3000019824
          READ TABLE lt_catacons INTO ls_catacons WITH KEY zz_catalogo = gc_cat-catalogo13.
          IF sy-subrc = 0.
            CONCATENATE '{"0":"' ls_cab_json-zzparubi          '",'
                        '"1":"'  ls_cab_json-zzpardir          '",'
                        '"2":"'  ls_catacons-zz_tagagencyname  '",'
                        '"3":"'  ls_catacons-zz_tagname        '",'
                        '"4":"'  ls_catacons-zz_taguri         '",'
                        '"5":"'  ls_cab-zzparest               '",'
                        '"6":"'  ls_catacon2-zz_tagid          '",'                           "I-PBM300123-3000019824
                        '"7":"'  ls_catacon2-zz_tagagencyname  '",'                           "I-PBM300123-3000019824
                        '"8":"'  ls_catacon2-zz_tagname        '"}'                           "I-PBM300123-3000019824
                        INTO ls_cab_json-zzparubi.  "Partida                                  "I-PBM061222-3000020028
          ENDIF.
*}R-PBM210922-3000019902
      ENDCASE.
*}  END OF INSERT WMR-051018-3000010624
      CONCATENATE '{"0":"' ls_cab_json-zzcntnro   '",' '"1":"'  ls_cab_json-zzptocod       '"}' INTO ls_cab_json-zzcntnro.  "Num. De contenedor y Código de puerto
*{  BEGIN OF INSERT WMR-250918-3000010450
      "Punto de emisión
      CONCATENATE '{"0":"' ls_cab-zzpemubi    '",'
                  '"1":"'  ls_cab-zzpemdir    '",'
                  '"2":"'  ls_cab-zzpemurb    '",'
                  '"3":"'  ls_cab-zzpemdis    '",'
                  '"4":"'  ls_cab-zzpempro    '",'
                  '"5":"'  ls_cab-zzpemdep    '",'
                  '"6":"'  ls_cab-zzpempai    '"}' INTO ls_cab_json-zzpemdir.
*}  END OF INSERT WMR-250918-3000010450
*{  BEGIN OF INSERT WMR-260517-3000007333
      " Adicionales
      CLEAR: l_paletas, l_unidades.
      IF ls_cab-zzpalnum GT 0.
        l_paletas = ls_cab-zzpalnum. CONDENSE l_paletas NO-GAPS. CONCATENATE l_paletas 'PALETAS' INTO l_paletas SEPARATED BY space.
      ENDIF.
      IF ls_cab-zzundtot GT 0.
        l_unidades = ls_cab-zzundtot. CONDENSE l_unidades NO-GAPS. CONCATENATE l_unidades ls_cab-zzunddes INTO l_unidades SEPARATED BY space.
      ENDIF.
      CONCATENATE '{"0":"' l_paletas        '",'
                  '"1":"'  l_unidades       '",'
                  '"2":"'  ls_cab-zzprecin  '",'
                  '"3":"'  ls_cab-zzprecin2 '",'                                      "+011222-NTP-3000019824
                  '"4":"'  ls_cab-zznrocaja '",'                                      "I-PBM081222-3000019824
                  '"5":"'  ls_cab-zzrecep   '"}' INTO ls_cab_json-zztagadd.           "I-180221-NTP-3000016078

      " Referencias
      CONCATENATE ls_cab-zztipgui ls_cab-zznrosun INTO l_string SEPARATED BY abap_undefined.
*      CONCATENATE '{"0":"' ls_cab-vbeln   '",' "-NTP010423-3000020188
      CONCATENATE '{"0":"' ls_cab-zznrosap '",' "+NTP010423-3000020188
                  '"1":"'  ls_cab-vgbel   '",'
                  '"2":"'  l_string       '"}' INTO ls_cab_json-zzrefere.
*{  BEGIN OF INSERT WMR-080119-3000011134
      CASE gw_license.
        WHEN '0021061097'.  " CMH
          IF ls_cab-zzcsgtxt IS NOT INITIAL.
*            CONCATENATE '{"0":"' ls_cab-vbeln '-' ls_cab-zzcsgtxt   '",'   "-NTP010423-3000020188
            CONCATENATE '{"0":"' ls_cab-zznrosap '-' ls_cab-zzcsgtxt   '",' "+NTP010423-3000020188
                        '"1":"'  ls_cab-vgbel '",'
                        '"2":"'  l_string     '"}' INTO ls_cab_json-zzrefere.
          ENDIF.
      ENDCASE.
*}  END OF INSERT WMR-080119-3000011134

*{I-PBM210922-3000019902
      ls_cab_json-zztipgui2 = ls_cab-zztipgui.
      READ TABLE lt_catacons INTO ls_catacons WITH KEY zz_catalogo = gc_cat-catalogo01.
      IF sy-subrc = 0.
        CONCATENATE '{"0":"' ls_cab-zztipgui               '",'
                    '"1":"'  ls_catacons-zz_tagagencyname  '",'
                    '"2":"'  ls_catacons-zz_tagname        '",'
                    '"3":"'  ls_catacons-zz_taguri         '"}' INTO ls_cab_json-zztipgui.  "Tipo de documento (Guía)
      ENDIF.
*}I-PBM210922-3000019902

      " Tipo y N° Comprobante Pago
      ls_cab_json-zztpnrcp = ls_cab-zztpnrcp.

*}  END OF INSERT WMR-260517-3000007333

*{  BEGIN OF INSERT WMR-070318-3000008769
      CONCATENATE '{"0":"' ls_cab-tknum   '",' '"1":"'  ls_cab-bstkd '",' '"2":"'  ls_cab-zztradua '"}' INTO ls_cab_json-zzntrnpc. "transporte/ pedido cliente

      CONCATENATE '{"0":"' ls_cab_json-zzslcnro   '",' '"1":"'  ls_cab_json-zzslctpd_h     '"}' INTO ls_cab_json-zzslcnro. "Solicitante
      ls_cab_json-zzslcden = ls_cab-zzslcden.

*    ls_cab_json-zztxtffd = ls_cab-zztxtffd.  "E-051219-NTP-3000013055
*{I-051219-NTP-3000013055
      CONCATENATE '{"0":"' ls_cab-zztxtffd  '",'  "PiePagina  - Texto adicional     "Piramide
                  '"1":"'  ls_cab-zztdadi1  '"}'  "PieDetalle - Texto adicional 001 "Aib
                  INTO ls_cab_json-zztxtffd.
*}I-051219-NTP-3000013055
*}  END OF INSERT WMR-070318-3000008769

*{I-051219-NTP-3000013055
      CONCATENATE '{"0":"' l_zztotblt       '",'  "PieDetalle  - Total bultos       "Aib
                  '"1":"'                   '"}'  "Libre
                  INTO ls_cab_json-zzpietot_j.
*}I-051219-NTP-3000013055

*{+NTP010323-3000019645: Guia Transportista
      IF ls_cab-is_gr_transportista IS NOT INITIAL.
        DATA: ls_grt_docrel LIKE LINE OF ls_cab-grt_docrel,
              l_grt_docrel  TYPE string.

        LOOP AT ls_cab-grt_docrel INTO ls_grt_docrel.
          "Additioaldocumentreference
          READ TABLE lt_catacons INTO ls_catacons WITH KEY zz_catalogo = gc_cat-catalogo61.
          READ TABLE lt_catacons INTO ls_catacon2 WITH KEY zz_catalogo = gc_cat-catalogo06.
          READ TABLE gth_cat61 INTO ls_cat61 WITH KEY zz_codigo_sunat = ls_grt_docrel-zztipdoc.
          IF sy-subrc = 0.
            CONCATENATE '{"0":"' ls_grt_docrel-zznrosun        '",' "0 AdditionalDocumentReference-id
                        '"1":"'  ls_catacons-zz_tagagencyname  '",' "1 AdditionalDocumentReference-documenttypecode-listagencyname
                        '"2":"'  ls_catacons-zz_tagname        '",' "2 AdditionalDocumentReference-documenttypecode-listname
                        '"3":"'  ls_catacons-zz_taguri         '",' "3 AdditionalDocumentReference-documenttypecode-listuri
                        '"4":"'  ls_grt_docrel-zztipdoc        '",' "4 AdditionalDocumentReference-documenttypecode
                        '"5":"'  ls_cat61-zz_desc_cod_suna     '",' "5 AdditionalDocumentReference-documenttype
                        '"6":"'  ls_grt_docrel-zzremtpd_h      '",' "6 AdditionalDocumentReference-issuerparty-partyidentification-schemeid
                        '"7":"'  ls_catacon2-zz_tagagencyname  '",' "7 AdditionalDocumentReference-issuerparty-partyidentification-schemeagencyname
                        '"8":"'  ls_catacon2-zz_taguri         '",' "8 AdditionalDocumentReference-issuerparty-partyidentification-schemeuri
                        '"9":"'  ls_grt_docrel-zzremnro        '"}' "9 AdditionalDocumentReference-issuerparty-partyidentification-id
                        INTO l_grt_docrel.
          ENDIF.

          IF ls_cab_json-zzgrt_docrel IS INITIAL.
            ls_cab_json-zzgrt_docrel = l_grt_docrel.
          ELSE.
            CONCATENATE ls_cab_json-zzgrt_docrel l_grt_docrel INTO ls_cab_json-zzgrt_docrel SEPARATED BY ','.
          ENDIF.
        ENDLOOP.


        "SpecialInstructions
        IF ls_cab-zzindenv_tp = gc_no.
          CLEAR gc_traslado_indenv-transbordo_programado.
        ENDIF.
        CONCATENATE '{"0":"' ls_cab-zzindenv_tp                         '",'
                    '"1":"' gc_traslado_indenv-transbordo_programado 	  '"}'
                    INTO ls_cab_json-zzgrt_indenv_tp.

        IF ls_cab-zzindenv_rv = gc_no.
          CLEAR gc_traslado_indenv-retornovacio.
        ENDIF.
        CONCATENATE '{"0":"' ls_cab-zzindenv_rv                         '",'
                    '"1":"' gc_traslado_indenv-retornovacio             '"}'
                    INTO ls_cab_json-zzgrt_indenv_rv.

        IF ls_cab-zzindenv_rve = gc_no.
          CLEAR gc_traslado_indenv-retornovacio_envase.
        ENDIF.
        CONCATENATE '{"0":"' ls_cab-zzindenv_rve                        '",'
                    '"1":"' gc_traslado_indenv-retornovacio_envase      '"}'
                    INTO ls_cab_json-zzgrt_indenv_rve.

        IF ls_cab-zzindenv_ts = gc_no.
          CLEAR gc_traslado_indenv-transporte_subcontratado.
        ENDIF.
        CONCATENATE '{"0":"' ls_cab-zzindenv_ts                         '",'
                    '"1":"' gc_traslado_indenv-transporte_subcontratado '"}'
                    INTO ls_cab_json-zzgrt_indenv_ts.

        IF ls_cab-zzindenv_pft = gc_no.
          CLEAR gc_traslado_indenv-pagador_flete_tercero.
        ENDIF.
        CONCATENATE '{"0":"' ls_cab-zzindenv_pft                        '",'
                    '"1":"' gc_traslado_indenv-pagador_flete_tercero    '"}'
                    INTO ls_cab_json-zzgrt_indenv_pft.

        READ TABLE lt_catacons INTO ls_catacons WITH KEY zz_catalogo = gc_cat-catalogo06.
        IF sy-subrc = 0.
          CONCATENATE '{"0":"' ls_cab_json-zzgrt_pftnro      '",'
                      '"1":"'  ls_cab_json-zzgrt_pfttpd_h    '",'
                      '"2":"'  ls_catacons-zz_tagagencyname  '",'
                      '"3":"'  ls_catacons-zz_tagname        '",'
                      '"4":"'  ls_catacons-zz_taguri         '"}'
                 INTO ls_cab_json-zzgrt_pftnro.
        ENDIF.
      ENDIF.
*}+NTP010323-3000019645

      ls_cab_json-zzhoremi = ls_cab-zzhoremi.  " Hora emisión                                "I-PBM210922-3000020039
      ls_cab_json-zzdatenv = ls_cab-zzdatenv.  " Datos del envío                             "I-PBM210922-3000020039
      ls_cab_json-zzdamnro = ls_cab-zzdamnro.  " Número de Documento Relacionado (DAM)       "I-PBM210922-3000020039
      ls_cab_json-zztradir = ls_cab-zztradir.  " Direccion transportista
      APPEND ls_cab_json TO pe_cab_json.
    ENDLOOP.


    LOOP AT pi_det INTO ls_det.

      MOVE-CORRESPONDING ls_det TO ls_det_json.

*   Preparar montos
      l_zziteqty = ls_det_json-zziteqty. CONDENSE l_zziteqty.
      l_zzitepbr = ls_det_json-zzitepbr. CONDENSE l_zzitepbr.
      l_zzitepbt = ls_det_json-zzitepbt. CONDENSE l_zzitepbt.

      IF l_zziteqty = '0.0'. CLEAR l_zziteqty. ENDIF.
      IF l_zzitepbr = '0.0'. CLEAR l_zzitepbr. ENDIF.
      IF l_zzitepbt = '0.0'. CLEAR l_zzitepbt. ENDIF.

*   Armar Jason
*{  BEGIN OF REPLACE WMR-260517-3000007333
      ""      CONCATENATE '{"0":"' l_zziteqty '",' '"1":"' ls_det_json-zziteund_h '"}' INTO ls_det_json-zziteqty.  "Cantidad y unidad del item
      " Cantidad, Unidad medida Item y Unidad medida Item PDF
      CONCATENATE '{"0":"' l_zziteqty '",' '"1":"' ls_det_json-zziteund_h '",' '"2":"' ls_det_json-zziteund '"}' INTO ls_det_json-zziteqty.
*}  END OF REPLACE WMR-260517-3000007333
      CONCATENATE '{"0":"' l_zzitepbr '",' '"1":"' ls_det_json-zziteunp   '"}' INTO ls_det_json-zzitepbr.  "Peso bruto y unidad de peso
      CONCATENATE '{"0":"' l_zzitepbt '",' '"1":"' ls_det_json-zziteunp   '"}' INTO ls_det_json-zzitepbt.  "Peso bruto total y unidad de peso

*{I-PBM190423-3000020600
      READ TABLE lt_catacons INTO ls_catacons WITH KEY zz_catalogo = gc_cat-catalogo25.
      IF sy-subrc = 0.
        CONCATENATE '{"0":"'  ls_det-zzitecod               '",'
                     '"1":"'  ls_det-zz_normt               '",'
                     '"2":"'  ls_det-zz_material_sunat      '",'
                     '"3":"'  ls_catacons-zz_tagid          '",'
                     '"4":"'  ls_catacons-zz_tagagencyname  '",'
                     '"5":"'  ls_catacons-zz_tagname        '"}' INTO ls_det_json-zzitecod.
      ENDIF.
*}I-PBM190423-3000020600
      APPEND ls_det_json TO pe_det_json.
    ENDLOOP.

  ENDMETHOD.


  METHOD split_xblnr.

    CLEAR: e_tipo, e_serie, e_corre, e_sercor.

    SPLIT i_xblnr AT abap_undefined
      INTO e_tipo                                   " Tipo
           e_sercor.                                " Serie + Correlativo

    " Quitar ceros a la izquierda
    SHIFT e_sercor LEFT DELETING LEADING '0'.

    SPLIT e_sercor AT abap_undefined
      INTO e_serie                                  " Serie
           e_corre.                                 " Correlativo

  ENDMETHOD.


  METHOD string_to_xstring.
    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
      EXPORTING
        text   = input
      IMPORTING
        buffer = output
      EXCEPTIONS
        failed = 1
        OTHERS = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.


  METHOD sy_to_ret.

    rs_return-field = i_field.
    rs_return-row = i_row.

    MOVE: sy-msgv1 TO rs_return-message_v1,
          sy-msgv2 TO rs_return-message_v2,
          sy-msgv3 TO rs_return-message_v3,
          sy-msgv4 TO rs_return-message_v4,
          sy-msgid TO rs_return-id,
          sy-msgno TO rs_return-number,
          sy-msgty TO rs_return-type.

    CONCATENATE sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO rs_return-message SEPARATED BY space.

  ENDMETHOD.                    "GET_SY_TO_BAPIRET2


  METHOD ui_string_to_xstring_xml.
    DATA: lo_reader TYPE REF TO if_sxml_reader,
          lo_writer TYPE REF TO cl_sxml_string_writer.

    lo_reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( input ) ).
    lo_writer = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_xml10 ).

    TRY.
        lo_reader->next_node( ).
        lo_reader->skip_node( lo_writer ).
        output = lo_writer->get_output( ).
      CATCH cx_sxml_parse_error.
        MESSAGE e000 WITH 'Error al parsear xml' RAISING error.
    ENDTRY.
  ENDMETHOD.


  METHOD upd_tabla_rem.

*{+010922-NTP-3000018956
    DATA: lt_fegrcab TYPE TABLE OF zostb_fegrcab,
          lt_txt     TYPE gtt_fegrtxt,

          ls_fegrcab LIKE LINE OF lt_fegrcab,
          ls_cab     LIKE LINE OF it_cab,
          ls_txt     LIKE LINE OF lt_txt,
          l_string   TYPE string,
          ls_json    TYPE zosfetb_json.

    LOOP AT it_cab INTO ls_cab.
      MOVE-CORRESPONDING ls_cab TO ls_fegrcab.
      APPEND ls_fegrcab TO lt_fegrcab.

      lt_txt = fegrtxt_set( is_data = ls_cab ). "+NTP010523-3000021385
    ENDLOOP.
*}+010922-NTP-3000018956

    MODIFY zostb_fegrcab FROM TABLE lt_fegrcab. "it_cab. "+010922-NTP-3000018956
    MODIFY zostb_fegrdet FROM TABLE it_det.
    MODIFY zostb_fecli FROM TABLE it_cli.
    MODIFY zostb_fegrtxt FROM TABLE lt_txt. "+NTP010523-3000021385

**{I-PBM050121-3000014959
*    CASE gw_license.
*      WHEN '0020767991'. "INKA
*        DATA: lt_fegrcabt TYPE TABLE OF zostb_fegrcabt,
*              lt_fegrdett TYPE TABLE OF zostb_fegrdett,
*              ls_det      LIKE LINE OF it_det,
*              ls_cabt     LIKE LINE OF lt_fegrcabt,
*              ls_dett     LIKE LINE OF lt_fegrdett,
*              ls_felog    TYPE zostb_felog.
*
*        LOOP AT it_cab INTO ls_cab.
*          MOVE-CORRESPONDING ls_cab TO ls_cabt.
*
*          WRITE ls_cab-gewei TO ls_cabt-gewei.
*          WRITE ls_cab-btgew TO ls_cabt-btgew.
*          WRITE ls_cab-ntgew TO ls_cabt-ntgew.
*          WRITE ls_cab-zzpesbru TO ls_cabt-zzpesbru.
*          WRITE ls_cab-zzundtot TO ls_cabt-zzundtot.
*          APPEND ls_cabt TO lt_fegrcabt.
*        ENDLOOP.
*
*        LOOP AT it_det INTO ls_det.
*          MOVE-CORRESPONDING ls_det TO ls_dett.
*
*          WRITE ls_det-lfimg TO ls_dett-lfimg.
*          WRITE ls_det-meins TO ls_dett-meins.
*          WRITE ls_det-vrkme TO ls_dett-vrkme.
*          WRITE ls_det-brgew TO ls_dett-brgew.
*          WRITE ls_det-gewei TO ls_dett-gewei.
*          WRITE ls_det-zzitepos TO ls_dett-zzitepos.
*          WRITE ls_det-zziteqty TO ls_dett-zziteqty.
*          WRITE ls_det-zziteunp TO ls_dett-zziteunp.
*          WRITE ls_det-zzitepbr TO ls_dett-zzitepbr.
*          WRITE ls_det-zzitepbt TO ls_dett-zzitepbt.
*
*          APPEND ls_dett TO lt_fegrdett.
*        ENDLOOP.
*
*        "Data
*        MODIFY zostb_fegrcabt FROM TABLE lt_fegrcabt.
*        MODIFY zostb_fegrdett FROM TABLE lt_fegrdett.
*
*        "Log
*        ls_felog-zzt_nrodocsap  = ls_cab-zznrosap.
*        ls_felog-gjahr          = ls_cab-zzgjahr.
*        ls_felog-zzt_numeracion = ls_cab-zznrosun.
*        ls_felog-zzt_correlativ = 1.
*        ls_felog-zzt_fcreacion  = sy-datum.
*        ls_felog-zzt_hcreacion  = sy-uzeit.
*        ls_felog-zzt_ucreacion  = sy-uname.
*        ls_felog-bukrs          = ls_cab-bukrs.
*        ls_felog-zzt_tipodoc    = gc_tipdoc_gr.
*        ls_felog-zzt_status_cdr = gc_statuscdr_2.
*        MODIFY zostb_felog FROM ls_felog.
*
*      WHEN OTHERS.
**}I-PBM050121-3000014959
*{+010922-NTP-3000018956
    ls_json-bukrs          = ls_cab-bukrs.          "+NTP010323-3000019645
    ls_json-zzt_nrodocsap  = ls_cab-zznrosap.
    ls_json-gjahr          = ls_cab-zzgjahr.
    ls_json-zzt_numeracion = ls_cab-zznrosun.
    ls_json-zzt_tipdoc     = ls_cab-zztipgui.       "+NTP010323-3000019645

    l_string = serialize_json( data = it_cab_json ).
    ls_json-jsoncab = string_to_xstring( l_string ).
    l_string = serialize_json( data = it_det_json ).
    ls_json-jsondet = string_to_xstring( l_string ).
    l_string = serialize_json( data = it_cli ).
    ls_json-jsoncli = string_to_xstring( l_string ).

    MODIFY zosfetb_json FROM ls_json.
*}+010922-NTP-3000018956
*    ENDCASE.

  ENDMETHOD.


  METHOD xstring_to_string.
    DATA: l_length TYPE i,
          lt_bin   TYPE STANDARD TABLE OF x255.

    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer        = input
      IMPORTING
        output_length = l_length
      TABLES
        binary_tab    = lt_bin.

    CALL FUNCTION 'SCMS_BINARY_TO_STRING'
      EXPORTING
        input_length = l_length
      IMPORTING
        text_buffer  = output
      TABLES
        binary_tab   = lt_bin
      EXCEPTIONS
        failed       = 1.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
