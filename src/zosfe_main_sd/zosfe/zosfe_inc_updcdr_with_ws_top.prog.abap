*&---------------------------------------------------------------------*
*&  Include           ZOSSD_INC_UPDCDR_WITH_WS_TOP
*&---------------------------------------------------------------------*

TYPE-POOLS: abap, slis.

TYPES: BEGIN OF ty_parsel,
         bukrs   TYPE t001-bukrs,
         tipodoc TYPE zostb_felog-zzt_tipodoc,
         numero  TYPE zostb_felog-zzt_numeracion,
         fecha   TYPE zostb_felog-zzt_fcreacion,
         status  TYPE zostb_felog-zzt_status_cdr,
       END OF ty_parsel,

       BEGIN OF ty_felog.
*        INCLUDE TYPE zostb_felog.                                       "E-WMR-190419-3000010823
        INCLUDE TYPE zostb_cplog.                                       "I-WMR-190419-3000010823
TYPES:  selec    TYPE char01,
        semaforo TYPE icon_d,
        return   TYPE bapirettab,
        END OF ty_felog.

TYPES: tt_felog TYPE STANDARD TABLE OF ty_felog.

DATA: gt_felog TYPE tt_felog.
DATA: gt_const_fe TYPE TABLE OF zostb_consextsun.

DATA: gw_error TYPE char01.

DATA: gc_status_2 TYPE zostb_felog-zzt_status_cdr VALUE '2',
      gc_chara    TYPE char01                     VALUE 'A',
      gc_chare    TYPE char01                     VALUE 'E',
      gc_charw    TYPE char01                     VALUE 'W',
      gc_charx    TYPE char01                     VALUE 'X',
      gc_gris     TYPE char04                     VALUE '@EB@',
      gc_green    TYPE char04                     VALUE '@08@',
      gc_yellow   TYPE char04                     VALUE '@09@',
      gc_red      TYPE char04                     VALUE '@0A@',
      gc_resbol   TYPE char2 VALUE 'RC',
      gc_combaj   TYPE char2 VALUE 'RA',
      gc_revret   TYPE char2 VALUE 'RR',                                "I-WMR-230419-3000010823
      gc_revper   TYPE char2 VALUE 'RP',                                "I-WMR-230419-3000010823
      gc_stat_1   TYPE zosed_status_cdr VALUE '1',
      gc_stat_4   TYPE zosed_status_cdr VALUE '4',
      gc_stat_8   TYPE zosed_status_cdr VALUE '8'.

*{  BEGIN OF REPLACE WMR-160318-3000008769
CONSTANTS: gc_modul TYPE zostb_const_fe-modulo     VALUE 'FE',
           gc_aplic TYPE zostb_const_fe-aplicacion VALUE 'EXTRACTOR',
           gc_progr TYPE zostb_const_fe-programa   VALUE 'ZOSSD_PRO_EXTRAC'.
*}  END OF REPLACE WMR-160318-3000008769

*DATA: BEGIN OF zconst,                                                  "E-WMR-230419-3000010823
*        ws_clase  TYPE string,                                          "E-WMR-230419-3000010823
*        ws_metodo TYPE string,                                          "E-WMR-230419-3000010823
*      END OF zconst.                                                    "E-WMR-230419-3000010823

DATA: BEGIN OF zprocess,                                                "I-WMR-160318-3000008769
        ws_tpproc TYPE string VALUE 'CP', " Consulta Status Portal Web  "I-WMR-160318-3000008769
        ws_clase  TYPE string,                                          "I-WMR-160318-3000008769
        ws_metodo TYPE string,                                          "I-WMR-160318-3000008769
        envsun    TYPE zostb_envwsfe-envsun,                            "I-WMR-230419-3000010823
*        s_asgpse  TYPE zosfetb_asgpse,                                  "I-WMR-230419-3000010823
      END OF zprocess.                                                  "I-WMR-160318-3000008769
