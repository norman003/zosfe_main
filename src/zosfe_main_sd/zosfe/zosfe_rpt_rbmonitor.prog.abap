*************************************************************************
*                         INFORMACION GENERAL
*************************************************************************
* Programa...: ZOSFE_RPT_RBMONITOR
* Tipo.......: Proceso
* Módulo.....: SD
* Descripción: Monitor de Resumen de Boletas - Facturación Electrónica
* Autor......: Omnia Solution
* Fecha......:
* Transacción:
*************************************************************************
REPORT zosfe_rpt_rbmonitor NO STANDARD PAGE HEADING MESSAGE-ID zosfe.

INCLUDE zosfe_inc_rbmonitor_top.
INCLUDE zosfe_inc_rbmonitor_sel.
INCLUDE zosfe_inc_rbmonitor_mai.
INCLUDE zosfe_inc_rbmonitor_f01.
