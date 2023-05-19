*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_FEMONITOR_SEL
*&---------------------------------------------------------------------*

*{I-NTP040717-3000006468
TYPES: BEGIN OF ty_param,
         fkdat TYPE vbrk-fkdat,
         gjahr TYPE bkpf-gjahr,
         zzt_nrodocsap TYPE zostb_felog-zzt_nrodocsap, "+NTP010423-3000020188
         zzt_fcreacion TYPE zostb_felog-zzt_fcreacion, "+NTP010423-3000020188
       END OF ty_param.

DATA ls_param TYPE ty_param.
*}I-NTP040717-3000006468

*&--------------------------------------------------------------------&*
*&            S E L E C T I O N - S C R E E N                         &*
*&--------------------------------------------------------------------&*
SELECTION-SCREEN: BEGIN OF BLOCK b03 WITH FRAME TITLE TEXT-b03.                     "I-WMR-14092020-3000014557
PARAMETERS: p_fbcd  RADIOBUTTON GROUP tcp DEFAULT 'X' USER-COMMAND tcp MODIF ID tcp,"I-WMR-14092020-3000014557
            p_gr    RADIOBUTTON GROUP tcp MODIF ID tcp.                             "I-WMR-14092020-3000014557
SELECTION-SCREEN: END OF BLOCK b03.                                                 "I-WMR-14092020-3000014557

SELECTION-SCREEN : BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-t01.
*{  BEGIN OF INSERT WMR-200715
PARAMETERS: p_bukrs  TYPE t001-bukrs OBLIGATORY MEMORY ID buk.
*SELECT-OPTIONS: s_gjahr FOR ls_param-gjahr NO INTERVALS NO-EXTENSION MODIF ID gj.   "I-3000010823-JPS-100519  "E-WMR-14092020-3000014557
SELECT-OPTIONS: s_gjahr FOR ls_param-gjahr NO-EXTENSION MODIF ID gj MEMORY ID gjr.                "I-WMR-14092020-3000014557
*}  END OF INSERT WMR-200715
SELECT-OPTIONS: s_vbeln FOR ls_param-zzt_nrodocsap,             "+NTP010423-3000020188
                s_fecha FOR ls_param-zzt_fcreacion MODIF ID r2, "+NTP010423-3000020188
                s_fkdat FOR ls_param-fkdat.   "I-NTP040717-3000006468
SELECTION-SCREEN : END OF BLOCK b01.

*{I-NTP040717-3000006468
SELECTION-SCREEN: BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-t02.
PARAMETERS: p_facpro RADIOBUTTON GROUP r1 DEFAULT 'X' USER-COMMAND g01,
            p_facpor RADIOBUTTON GROUP r1,
            p_facsin RADIOBUTTON GROUP r1.
SELECTION-SCREEN: END OF BLOCK b02.
*}I-NTP040717-3000006468
