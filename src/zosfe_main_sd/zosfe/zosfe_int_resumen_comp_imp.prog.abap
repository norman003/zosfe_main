*************************************************************************
*                         INFORMACION GENERAL
*************************************************************************
* Programa...: ZOSFE_INT_RESUMEN_COMP_IMP
* Tipo.......: Proceso
* Módulo.....: SD
* Descripción: Resumen de Comprobantes Impresos - Facturación Electrónica
* Autor......: Omnia Solution
* Fecha......:
* Transacción: ZOSFE006
*************************************************************************
REPORT zosfe_int_resumen_comp_imp.

INCLUDE zosfe_inc_resumen_comp_imp_top. "Declaraciones Globales
INCLUDE zosfe_inc_resumen_comp_imp_sel. "Parámetros de selección
INCLUDE zosfe_inc_resumen_comp_imp_mai. "Programa Principal
INCLUDE zosfe_inc_resumen_comp_imp_cla. "Clases
INCLUDE zosfe_inc_resumen_comp_imp_f01. "Subrutinas Principales
INCLUDE zosfe_inc_resumen_comp_imp_pbo. "PBO
INCLUDE zosfe_inc_resumen_comp_imp_pai. "PAI
