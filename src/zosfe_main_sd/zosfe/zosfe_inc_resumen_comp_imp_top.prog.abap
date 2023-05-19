*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_RESUMEN_COMP_IMP_TOP
*&---------------------------------------------------------------------*

*&--------------------------------------------------------------------&*
*&         T A B L A S   T R A N S P A R E N T E S                    &*
*&--------------------------------------------------------------------&*

 TABLES: vbrk.  "#EC NEEDED

*&--------------------------------------------------------------------&*
*&                     T Y P E   P O O L S                            &*
*&--------------------------------------------------------------------&*
 TYPE-POOLS: abap, sdydo.

*&--------------------------------------------------------------------&*
*&                 T I P O S   G L O B A L E S                        &*
*&--------------------------------------------------------------------&*

 TYPES: BEGIN OF ty_vbrp,
          knumv      TYPE vbrk-knumv,
          vbeln      TYPE vbrp-vbeln,
          posnr      TYPE vbrp-posnr,
          vgbel      TYPE vbrp-vgbel,
          vrkme      TYPE vbrp-vrkme,
          fkimg      TYPE vbrp-fkimg,
          arktx      TYPE vbrp-arktx,
          netwr      TYPE vbrp-netwr,
          mwsbp      TYPE vbrp-mwsbp,
          vgtyp      TYPE vbrp-vgtyp,
          autyp      TYPE vbrp-autyp,
          taxm1      TYPE vbrp-taxm1,
          aubel      TYPE vbrp-aubel,
          aupos      TYPE posnr_va,
          pstyv      TYPE vbrp-pstyv,
          matnr      TYPE vbrp-matnr,
          umvkz      TYPE vbrp-umvkz,
          kzwi1      TYPE vbrp-kzwi1,
          werks      TYPE vbrp-werks,
          meins      TYPE vbrp-meins,
          vkbur      TYPE vkbur,
          vgpos      TYPE vgpos,           "Núm.posición de la posición modelo
          augru_auft TYPE vbrp-augru_auft, " Motivo de pedido
          vkorg      TYPE vbrk-vkorg,      " Organización
          vtweg      TYPE vbrk-vtweg,      " Canal
          fkdat      TYPE vbrk-fkdat,      " Fecha factura
          kvgr1      TYPE vbrp-kvgr1,      " Grupo de clientes 1
          afect_igv  TYPE char01,          " Afecto (A), Exonerado (E) o Inafecto (I)
        END OF ty_vbrp.

 TYPES: BEGIN OF ty_reporte,
          box               TYPE char01,
          vbeln             TYPE vbrk-vbeln,
          motiv             TYPE zostb_motrescoim-id_mrcim,
          fecha_emisi       TYPE vbrk-fkdat,
          tipo_compr        TYPE char02,
          serie_compr       TYPE char04,
          numer_corre       TYPE char08,
          rango_ticke       TYPE char20,
          tipo_docum        TYPE kna1-stcdt,
          numer_docum       TYPE kna1-stcd1,
          razon_socia(60)   TYPE c,
""          total_opera_grava TYPE char20,  "vbrp-brtwr
""          total_opera_exone TYPE char20,  "vbrp-brtwr,
""          total_opera_inafe TYPE char20,  "vbrp-brtwr,
""          isc               TYPE char20,  "vbrp-brtwr,
""          igv               TYPE char20,  "vbrp-brtwr,
""          otros_tribu_cargo TYPE char20,  "vbrp-brtwr,
""          impte_total       TYPE char20,  "vbrp-brtwr,
          total_opera_grava TYPE vbrk-netwr,
          total_opera_exone TYPE vbrk-netwr,
          total_opera_inafe TYPE vbrk-netwr,
          isc               TYPE vbrk-netwr,
          igv               TYPE vbrk-netwr,
          otros_tribu_cargo TYPE vbrk-netwr,
          impte_total       TYPE vbrk-netwr,
          tipo_compr_modif  TYPE char02,
          serie_compr_modif TYPE char20,
          numer_compr_modif TYPE char20,
          waerk             TYPE vbrk-waerk,
        END OF ty_reporte.

 TYPES: BEGIN OF ty_archivo_txt,
*          campo TYPE char1500,     "E-NTP-140716
          campo TYPE hrtext500,     "I-NTP-140716
        END OF ty_archivo_txt.


 TYPES: tt_vbrp TYPE STANDARD TABLE OF ty_vbrp.

*&--------------------------------------------------------------------&*
*&                 C O N S T A N T E S                                &*
*&--------------------------------------------------------------------&*

 CONSTANTS: gc_container   TYPE sdydo_attribute  VALUE 'CC_CONTAINER',
            gc_style       TYPE sdydo_attribute  VALUE 'ALV_GRID',
            gc_save        TYPE char01           VALUE 'A',
            gc_top_of_page TYPE char30           VALUE 'TOP_OF_PAGE'.
 CONSTANTS: gc_aplic       TYPE zostb_const_fe-aplicacion VALUE 'EXTRACTOR',
            gc_prog        TYPE zostb_const_fe-programa   VALUE 'ZOSSD_PRO_EXTRAC'.
 CONSTANTS: gc_exoner_igv  TYPE char01           VALUE 'E',  "Exonerado del IGV
            gc_inafec_igv  TYPE char01           VALUE 'I',  "Inafecto al IGV
            gc_afecto_igv  TYPE char01           VALUE 'A'.  "Afecto al IGV
 CONSTANTS: gc_waers_pen   TYPE waers            VALUE 'PEN'.


*&--------------------------------------------------------------------&*
*&         T A B L A S   I N T E R N A S    G L O B A L E S           &*
*&--------------------------------------------------------------------&*

 DATA: gt_const       TYPE STANDARD TABLE OF zostb_const_fe.
 DATA: gt_reporte     TYPE STANDARD TABLE OF ty_reporte.
 DATA: gt_archivo_txt TYPE STANDARD TABLE OF ty_archivo_txt.
* ALV
 DATA: gt_fieldcat TYPE lvc_t_fcat.
 DATA: gt_exclude  TYPE ui_functions.


*&--------------------------------------------------------------------&*
*&                    W O R K   A R E A S                             &*
*&--------------------------------------------------------------------&*
* ALV
 DATA: gs_layout TYPE lvc_s_layo.
 DATA: gs_stable TYPE lvc_s_stbl.


*&--------------------------------------------------------------------&*
*&                F I E L D   -   S Y M B O L S                       &*
*&--------------------------------------------------------------------&*
* FIELD-SYMBOLS: <fs_return>  TYPE bapiret2.


*&--------------------------------------------------------------------&*
*&               R A N G O S   G L O B A L E S                        &*
*&--------------------------------------------------------------------&*
* RANGES: gr_fkart FOR vbrk-fkart.

*&--------------------------------------------------------------------&*
*&             V A R I A B L E S   G L O B A L E S                    &*
*&--------------------------------------------------------------------&*
 DATA: gw_ok_code TYPE sy-ucomm,
       gw_error   TYPE char01.                                                "I-WMR-130319-3000010823

*----------------------------------------------------------------------*
* CLASES
*----------------------------------------------------------------------*
 CLASS: lcl_event_handler DEFINITION DEFERRED.

*&--------------------------------------------------------------------&*
*&                 O B J E T O S   G L O B A L E S                    &*
*&--------------------------------------------------------------------&*
 DATA: go_grid        TYPE REF TO cl_gui_alv_grid,
       go_container   TYPE REF TO cl_gui_custom_container,
       go_handler     TYPE REF TO lcl_event_handler,
       go_dyndoc_top  TYPE REF TO cl_dd_document,
       go_parent_top  TYPE REF TO cl_gui_container, "#EC NEEDED
       go_parent_grid TYPE REF TO cl_gui_container,
       go_parent_html TYPE REF TO cl_gui_container,
       go_splitter    TYPE REF TO cl_gui_splitter_container,
       go_html_top    TYPE REF TO cl_gui_html_viewer.
