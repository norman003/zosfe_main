*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_CONFIG_GENERAL_TOP
*&---------------------------------------------------------------------*

TYPES: BEGIN OF ty_process,                                                     "I-WMR-190918-3000009765
         license TYPE string,            " N° Instalación SAP                   "I-WMR-190918-3000009765
         s4core  TYPE xfeld,             " S/4 Hana activo                      "I-WMR-190918-3000009765
       END OF ty_process.                                                       "I-WMR-190918-3000009765

DATA: gs_process  TYPE ty_process.                                              "I-WMR-190918-3000009765

DATA: gw_okcode   TYPE syucomm.

DATA: gc_component_s4core TYPE cvers-component  VALUE 'S4CORE'.                 "I-WMR-190918-3000009765
