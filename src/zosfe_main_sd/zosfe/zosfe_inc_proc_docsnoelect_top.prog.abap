*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_PROC_DOCSNOELECT_TOP
*&---------------------------------------------------------------------*
TYPE-POOLS: slis.

TYPES:  BEGIN OF ty_parsel,
          vbeln TYPE  vbrk-vbeln,
          fkdat TYPE  vbrk-fkdat,
        END OF ty_parsel,

        BEGIN OF ty_vbrk,
          vbeln    TYPE vbrk-vbeln,
          fkart    TYPE vbrk-fkart,
          vbtyp    TYPE vbrk-vbtyp,
          fkdat    TYPE vbrk-fkdat,
          vkorg    TYPE vbrk-vkorg,
          vtweg    TYPE vbrk-vtweg,
          spart    TYPE vbrk-spart,
          rfbsk    TYPE vbrk-rfbsk,
          fksto    TYPE vbrk-fksto,
          sfakn    TYPE vbrk-sfakn,
          kunag    TYPE vbrk-kunag,
          kunrg    TYPE vbrk-kunrg,
          netwr    TYPE vbrk-netwr,
          mwsbk    TYPE vbrk-mwsbk,
          waerk    TYPE vbrk-waerk,
          xblnr    TYPE vbrk-xblnr,
          bukrs    TYPE vbrk-bukrs,
          awkey    TYPE bkpf-awkey,

          codsunat TYPE char02, " Tipo de comprobante Sunat
          updkz    TYPE updkz_d,
          selec    TYPE xfeld,
          process  TYPE char01,
          icon     TYPE icon_d,
        END OF ty_vbrk,

        BEGIN OF ty_bkpf,
          bukrs TYPE bkpf-bukrs,
          belnr TYPE bkpf-belnr,
          gjahr TYPE bkpf-gjahr,
          awtyp TYPE bkpf-awtyp,
          awkey TYPE bkpf-awkey,
        END OF ty_bkpf,

        BEGIN OF ty_log,
          vbeln TYPE vbrk-vbeln,
          icon  TYPE char01.
        INCLUDE TYPE bapiret2.
TYPES:
        END OF ty_log.

DATA:
  gt_vbrk TYPE STANDARD TABLE OF ty_vbrk,
  gt_log  TYPE STANDARD TABLE OF ty_log.

DATA:
  gw_proc   TYPE char01.

DATA:
  gs_constantes TYPE zostb_consextsun.

DATA:
  cl_extfac TYPE REF TO zossdcl_pro_extrac_fe.

DATA:
  gr_vbtyp TYPE RANGE OF vbrk-vbtyp,
  gr_tcsun TYPE RANGE OF char02.        " Tipos de comprobante Sunat

DATA:
  gc_char01 TYPE char02     VALUE '01',
  gc_char03 TYPE char02     VALUE '03',
  gc_char07 TYPE char02     VALUE '07',
  gc_char08 TYPE char02     VALUE '08',
  gc_chara  TYPE char01     VALUE 'A',
  gc_charc  TYPE char01     VALUE 'C',
  gc_chard  TYPE char01     VALUE 'D',
  gc_chare  TYPE char01     VALUE 'E',
  gc_charm  TYPE char01     VALUE 'M',   " Facturas, Boletas
  gc_charo  TYPE char01     VALUE 'O',   " NC
  gc_charp  TYPE char01     VALUE 'P',   " ND
  gc_chars  TYPE char01     VALUE 'S',
  gc_charx  TYPE char01     VALUE 'X'.
