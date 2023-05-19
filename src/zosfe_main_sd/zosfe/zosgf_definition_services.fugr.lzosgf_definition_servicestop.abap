FUNCTION-POOL ZOSGF_DEFINITION_SERVICES.    "MESSAGE-ID ..

* INCLUDE LZOSGF_DEFINITION_SERVICESD...     " Local class definition

DATA: gw_numera   TYPE  zosed_numeracion,
      gw_status   TYPE  zosed_status_cdr,
      gw_errorext TYPE  zosed_errorext,
      gw_iderrsun TYPE  zosed_iderrsun,
      gw_idcdr    TYPE  zosed_idcdr,
      gw_fecrec   TYPE  zosed_fecrec,
      gw_horrec   TYPE  zosed_horrec,
      gw_fecres   TYPE  zosed_fecres,
      gw_horres   TYPE  zosed_horres,
      gw_mensacdr TYPE  zosed_mensacdr,
      gw_obsercdr TYPE  zosed_obsercdr,
*{  BEGIN OF INSERT WMR-200715
      gw_bukrs    TYPE  t001-bukrs,
*}  END OF INSERT WMR-200715
*{  BEGIN OF INSERT WMR-170915
      gw_tipodoc  TYPE  zostb_felog-zzt_tipodoc.
*}  END OF INSERT WMR-170915

CONSTANTS: gc_status_1 TYPE zosed_status_cdr VALUE '1',
           gc_status_4 TYPE zosed_status_cdr VALUE '4',
           gc_status_8 TYPE zosed_status_cdr VALUE '8',
*{  BEGIN OF INSERT WMR-100118-3000008865
           gc_prefix_rb TYPE char02           VALUE 'RB',
           gc_version_1 TYPE zosed_versivigen VALUE '01',
           gc_version_2 TYPE zosed_versivigen VALUE '02'.
*}  END OF INSERT WMR-100118-3000008865
