*----------------------------------------------------------------------*
***INCLUDE LZOSGF_CEACTSOCI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  SET_UPDATE_SECU  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_update_secu INPUT.

  zosva_ceactsoc-ernam = sy-uname.
  zosva_ceactsoc-erdat = sy-datum.
  zosva_ceactsoc-erzet = sy-uzeit.

ENDMODULE.