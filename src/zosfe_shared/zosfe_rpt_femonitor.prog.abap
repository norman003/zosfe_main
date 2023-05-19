*************************************************************************
*                         INFORMACION GENERAL
*************************************************************************
* Programa...: ZOSFE_RPT_FEMONITOR
* Tipo.......: Proceso
* Módulo.....: SD
* Descripción: Monitor de Documentos Individuales - Facturación Electrónica
* Autor......: Omnia Solution
* Fecha......:
* Transacción:
*************************************************************************
REPORT zosfe_rpt_femonitor NO STANDARD PAGE HEADING MESSAGE-ID zosfe.

INCLUDE zosfe_inc_femonitor_top.
INCLUDE zosfe_inc_femonitor_sel.
INCLUDE zosfe_inc_femonitor_mai.
INCLUDE zosfe_inc_femonitor_f01.
INCLUDE zosfe_inc_femonitor_f02. "+010922-NTP-3000018956
INCLUDE zosfe_inc_femonitor_u01.
