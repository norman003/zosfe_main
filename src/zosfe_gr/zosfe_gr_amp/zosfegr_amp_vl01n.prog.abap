*----------------------------------------------------------------------*
*                         INFORMACION GENERAL
*----------------------------------------------------------------------*
* Módulo      : FE
* Descripción : Campos para entregas
* Ticket      : Omnia Solution SAC
* Autor       : Norman Tinco
* Fecha       : 01.05.2023
*----------------------------------------------------------------------*
REPORT zosfegr_amp_vl01n.

*----------------------------------------------------------------------*
* Fuente : Uexit - MV50AFZ1
*
* Proceso: VL01n - campos z
*----------------------------------------------------------------------*
FORM vl01n_propose_and_check USING i_trtyp TYPE trtyp
                             CHANGING cs_xlikp TYPE likpvb
                                      c_fcode TYPE clike.
  zosfegrcl_amp=>a10_vl01n_check_catalogo(
    EXPORTING
      i_trtyp  = i_trtyp
    CHANGING
      cs_xlikp = cs_xlikp
      c_fcode  = c_fcode
  ).
ENDFORM.
