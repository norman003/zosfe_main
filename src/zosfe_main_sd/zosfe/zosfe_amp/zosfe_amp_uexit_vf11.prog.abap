************************************************************************
*                         INFORMACION GENERAL
************************************************************************
* Programa...: ZOSFE_AMP_UEXIT_VF11
* Tipo.......: Include
* Módulo.....: HR
* Descripción: Ampliación User-Exit al Anular documento SD
* Autor......: Omnia Solution S.A.C.
* Fecha......: 10.11.2018
* Status.....: ACTIVA
* Origen.....: USER-EXIT RV60AFZZ
************************************************************************
REPORT zosfe_amp_uexit_vf11.

INCLUDE zosfe_inc_uexit_vf11_top.
INCLUDE zosfe_inc_uexit_vf11_f01.

*&---------------------------------------------------------------------*
*&      Form  AMP01_UE_NUMBER_RANGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IT_VBRK  text
*----------------------------------------------------------------------*
FORM amp01_ue_number_range  USING    it_vbrk  TYPE vbrkvb_t.

* Inicializa
  PERFORM amp01_inicializa.

* Valida
  "    CHECK zamp-is_edicion     = abap_on.
  "    CHECK zamp-is_sociedad    = abap_on.
  CHECK zamp-is_ampl_active = abap_on.

* Acción
  PERFORM ue_number_range USING it_vbrk.

ENDFORM.
