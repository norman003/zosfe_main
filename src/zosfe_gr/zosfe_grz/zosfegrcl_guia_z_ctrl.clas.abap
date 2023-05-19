CLASS zosfegrcl_guia_z_ctrl DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF gty_sel,
        ebeln_r      TYPE RANGE OF ekko-ebeln,

        mblnr_r      TYPE RANGE OF mkpf-mblnr,
        mjahr_r      TYPE RANGE OF mkpf-mjahr,

        vbeln_r      TYPE RANGE OF vbak-vbeln,

        aufnr_r      TYPE RANGE OF aufk-aufnr,
        rsnum_r      TYPE RANGE OF resb-rsnum,

        zznrosap_r   TYPE RANGE OF zostb_fegrcab-zznrosap,
        zznrosap     TYPE zostb_fegrcab-zznrosap,
        zzgjahr      TYPE zostb_fegrcab-zzgjahr,

        "Personalizacion de los clientes
        aib_nrguia_r TYPE RANGE OF char10,
        aib_gjahr_r  TYPE RANGE OF gjahr,

        "Lote
        bukrs        TYPE bkpf-bukrs,
        lotno        TYPE idcn_boma-lotno,
        bokno        TYPE idcn_boma-bokno,

        "Opciones
        impre        TYPE xfeld,
        reenu        TYPE xfeld,
        baja         TYPE xfeld,
      END OF gty_sel .

    DATA view TYPE REF TO zosfegrcl_guia_z_view .
    DATA model TYPE REF TO zosfegrcl_guia_z_mdl .
    DATA gr TYPE REF TO zossdcl_pro_extrac_fe_gr .
    DATA ui TYPE REF TO zosfegrcl_guia_z_util .

    DATA zsel TYPE gty_sel.
    DATA gt_cab TYPE TABLE OF zossdcl_pro_extrac_fe_gr=>gty_cab_z.
    DATA g_dynnr TYPE sy-dynnr.
    DATA g_aktyp TYPE aktyp VALUE 'H'.

    CONSTANTS gc_ver TYPE char1 VALUE 'V'.

    METHODS constructor.
ENDCLASS.



CLASS zosfegrcl_guia_z_ctrl IMPLEMENTATION.


  METHOD constructor.
    DATA: l_repid TYPE string,
          l_temp  TYPE string.

    IF model IS NOT BOUND.
      CREATE OBJECT: ui.

      SPLIT sy-repid AT '=' INTO l_repid l_temp.

      REPLACE 'CTRL' WITH 'MDL' INTO l_repid.
      zossdcl_pro_extrac_fe=>get_badi_object( EXPORTING i_classname = l_repid CHANGING co_obj = model ).

      REPLACE 'MDL' WITH 'VIEW' INTO l_repid.
      zossdcl_pro_extrac_fe=>get_badi_object( EXPORTING i_classname = l_repid CHANGING co_obj = view ).

      l_repid = 'ZOSSDCL_PRO_EXTRAC_FE_GR'.
      zossdcl_pro_extrac_fe=>get_badi_object( EXPORTING i_classname = l_repid CHANGING co_obj = gr ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
