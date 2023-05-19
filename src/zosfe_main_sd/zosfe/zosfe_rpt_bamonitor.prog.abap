*************************************************************************
*                         INFORMACION GENERAL
*************************************************************************
* Programa...: ZOSFE_RPT_RBMONITOR
* Tipo.......: Proceso
* Módulo.....: SD
* Descripción: Monitor de Comunicación de Bajas - Facturación Electrónica
* Autor......: Omnia Solution
* Fecha......:
* Transacción:
*************************************************************************
REPORT zosfe_rpt_bamonitor NO STANDARD PAGE HEADING MESSAGE-ID zosfe.

INCLUDE zosfe_inc_bamonitor_top.
INCLUDE zosfe_inc_bamonitor_sel.
INCLUDE zosfe_inc_bamonitor_mai.
INCLUDE zosfe_inc_bamonitor_f01.
