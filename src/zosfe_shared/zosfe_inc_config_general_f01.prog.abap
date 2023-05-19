*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_CONFIG_GENERAL_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  USER_COMMAND_0100
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM user_command_0100 .

  DATA: lw_code   TYPE syucomm,
        l_tabname TYPE tabname.

  lw_code = gw_okcode.
  CLEAR gw_okcode.

  CASE lw_code.
    WHEN '&ACTP'.
      CALL FUNCTION 'VIEW_MAINTENANCE_CALL'
        EXPORTING
          action                       = 'S'
          view_name                    = 'ZOSVA_CEACTSOC'
        EXCEPTIONS
          client_reference             = 1
          foreign_lock                 = 2
          invalid_action               = 3
          no_clientindependent_auth    = 4
          no_database_function         = 5
          no_editor_function           = 6
          no_show_auth                 = 7
          no_tvdir_entry               = 8
          no_upd_auth                  = 9
          only_show_allowed            = 10
          system_failure               = 11
          unknown_field_in_dba_sellist = 12
          view_not_found               = 13
          maintenance_prohibited       = 14
          OTHERS                       = 15.
      IF sy-subrc NE 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

    WHEN '&BUKRS'.
      CALL FUNCTION 'VIEW_MAINTENANCE_CALL'
        EXPORTING
          action                       = 'S'
          view_name                    = 'ZOSVA_CONSEXTSUN'
        EXCEPTIONS
          client_reference             = 1
          foreign_lock                 = 2
          invalid_action               = 3
          no_clientindependent_auth    = 4
          no_database_function         = 5
          no_editor_function           = 6
          no_show_auth                 = 7
          no_tvdir_entry               = 8
          no_upd_auth                  = 9
          only_show_allowed            = 10
          system_failure               = 11
          unknown_field_in_dba_sellist = 12
          view_not_found               = 13
          maintenance_prohibited       = 14
          OTHERS                       = 15.
      IF sy-subrc NE 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

    WHEN '&CATA'.
      CALL FUNCTION 'VIEWCLUSTER_MAINTENANCE_CALL'
        EXPORTING
          viewcluster_name             = 'ZOSVC_CATALOGO_FE'
          maintenance_action           = 'S'
        EXCEPTIONS
          client_reference             = 1
          foreign_lock                 = 2
          viewcluster_not_found        = 3
          viewcluster_is_inconsistent  = 4
          missing_generated_function   = 5
          no_upd_auth                  = 6
          no_show_auth                 = 7
          object_not_found             = 8
          no_tvdir_entry               = 9
          no_clientindep_auth          = 10
          invalid_action               = 11
          saving_correction_failed     = 12
          system_failure               = 13
          unknown_field_in_dba_sellist = 14
          missing_corr_number          = 15
          OTHERS                       = 16.
      IF sy-subrc NE 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

    WHEN '&HOMO'.
      CALL FUNCTION 'VIEWCLUSTER_MAINTENANCE_CALL'
        EXPORTING
          viewcluster_name             = 'ZOSVC_HOMOLOGACION_FE'
          maintenance_action           = 'S'
        EXCEPTIONS
          client_reference             = 1
          foreign_lock                 = 2
          viewcluster_not_found        = 3
          viewcluster_is_inconsistent  = 4
          missing_generated_function   = 5
          no_upd_auth                  = 6
          no_show_auth                 = 7
          object_not_found             = 8
          no_tvdir_entry               = 9
          no_clientindep_auth          = 10
          invalid_action               = 11
          saving_correction_failed     = 12
          system_failure               = 13
          unknown_field_in_dba_sellist = 14
          missing_corr_number          = 15
          OTHERS                       = 16.
      IF sy-subrc NE 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

    WHEN '&CONS'.
      CALL FUNCTION 'VIEWCLUSTER_MAINTENANCE_CALL'
        EXPORTING
          viewcluster_name             = 'ZOSVC_FLUJOVENTAS_FE'
          maintenance_action           = 'S'
        EXCEPTIONS
          client_reference             = 1
          foreign_lock                 = 2
          viewcluster_not_found        = 3
          viewcluster_is_inconsistent  = 4
          missing_generated_function   = 5
          no_upd_auth                  = 6
          no_show_auth                 = 7
          object_not_found             = 8
          no_tvdir_entry               = 9
          no_clientindep_auth          = 10
          invalid_action               = 11
          saving_correction_failed     = 12
          system_failure               = 13
          unknown_field_in_dba_sellist = 14
          missing_corr_number          = 15
          OTHERS                       = 16.
      IF sy-subrc NE 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

    WHEN '&LOTNO'.
      CALL FUNCTION 'VIEW_MAINTENANCE_CALL'
        EXPORTING
          action                       = 'S'
          view_name                    = 'ZOSVA_LOTNO'
        EXCEPTIONS
          client_reference             = 1
          foreign_lock                 = 2
          invalid_action               = 3
          no_clientindependent_auth    = 4
          no_database_function         = 5
          no_editor_function           = 6
          no_show_auth                 = 7
          no_tvdir_entry               = 8
          no_upd_auth                  = 9
          only_show_allowed            = 10
          system_failure               = 11
          unknown_field_in_dba_sellist = 12
          view_not_found               = 13
          maintenance_prohibited       = 14
          OTHERS                       = 15.
      IF sy-subrc NE 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

    WHEN '&CONST'.
      SUBMIT zosge_rpt_utilities USING SELECTION-SCREEN 1002 WITH viewname = 'ZOSTB_CONST_FE' AND RETURN. "+011022-NTP-3000018956
*{-011022-NTP-3000018956
*      CALL FUNCTION 'VIEW_MAINTENANCE_CALL'
*        EXPORTING
*          action                       = 'S'
*          view_name                    = 'ZOSVA_CONST_FE'
*        EXCEPTIONS
*          client_reference             = 1
*          foreign_lock                 = 2
*          invalid_action               = 3
*          no_clientindependent_auth    = 4
*          no_database_function         = 5
*          no_editor_function           = 6
*          no_show_auth                 = 7
*          no_tvdir_entry               = 8
*          no_upd_auth                  = 9
*          only_show_allowed            = 10
*          system_failure               = 11
*          unknown_field_in_dba_sellist = 12
*          view_not_found               = 13
*          maintenance_prohibited       = 14
*          OTHERS                       = 15.
*      IF sy-subrc NE 0.
*        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*      ENDIF.
*}-011022-NTP-3000018956

    WHEN '&RCI'.
      CALL FUNCTION 'VIEW_MAINTENANCE_CALL'
        EXPORTING
          action                       = 'S'
          view_name                    = 'ZOSVA_MOTRESCOIM'
        EXCEPTIONS
          client_reference             = 1
          foreign_lock                 = 2
          invalid_action               = 3
          no_clientindependent_auth    = 4
          no_database_function         = 5
          no_editor_function           = 6
          no_show_auth                 = 7
          no_tvdir_entry               = 8
          no_upd_auth                  = 9
          only_show_allowed            = 10
          system_failure               = 11
          unknown_field_in_dba_sellist = 12
          view_not_found               = 13
          maintenance_prohibited       = 14
          OTHERS                       = 15.
      IF sy-subrc NE 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

*{  BEGIN OF INSERT WMR-171018-3000009765
    WHEN '&HOMHR'.
      CALL FUNCTION 'VIEWCLUSTER_MAINTENANCE_CALL'
        EXPORTING
          viewcluster_name             = 'ZOSFEVC_HOMS4R3'
          maintenance_action           = 'S'
        EXCEPTIONS
          client_reference             = 1
          foreign_lock                 = 2
          viewcluster_not_found        = 3
          viewcluster_is_inconsistent  = 4
          missing_generated_function   = 5
          no_upd_auth                  = 6
          no_show_auth                 = 7
          object_not_found             = 8
          no_tvdir_entry               = 9
          no_clientindep_auth          = 10
          invalid_action               = 11
          saving_correction_failed     = 12
          system_failure               = 13
          unknown_field_in_dba_sellist = 14
          missing_corr_number          = 15
          OTHERS                       = 16.
      IF sy-subrc NE 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
*}  END OF INSERT WMR-171018-3000009765
*{I-PBM21118-3000010907
    WHEN '&CBANK'.
      CALL FUNCTION 'VIEW_MAINTENANCE_CALL'
        EXPORTING
          action                       = 'S'
          view_name                    = 'ZOSVA_FEBANK'
        EXCEPTIONS
          client_reference             = 1
          foreign_lock                 = 2
          invalid_action               = 3
          no_clientindependent_auth    = 4
          no_database_function         = 5
          no_editor_function           = 6
          no_show_auth                 = 7
          no_tvdir_entry               = 8
          no_upd_auth                  = 9
          only_show_allowed            = 10
          system_failure               = 11
          unknown_field_in_dba_sellist = 12
          view_not_found               = 13
          maintenance_prohibited       = 14
          OTHERS                       = 15.
      IF sy-subrc NE 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
*}I-PBM21118-3000010907

    WHEN '&UBL'.  PERFORM _callview USING 'ZOSFEVA_UBL'.                 "I-NTP250618-3000009651

*{I-3000012035-NTP-110619
    WHEN '&COD_EST_SUNAT'.

      CASE gs_process-license.
        WHEN '0020316164' "Modasa
          OR '0021061097' "CMH
          OR '0020744072' "Medrock
          OR '0020311006' "AIB
          OR '0020863116'."AIB CLOUD
          l_tabname = 'ZOSFEVA_ASGCODES'.
        WHEN '0020673876' "Beta     "tvst & adrc
          OR '0020729594'."Austral  "taxjurcode
        WHEN OTHERS.
          l_tabname = 'ZOSVA_CATALO_CES'.
      ENDCASE.

      PERFORM _callview USING l_tabname.
*}I-3000012035-NTP-110619

  ENDCASE.

ENDFORM.

*{I-NTP250618-3000009651
*--------------------------------------------------------------------*
*	Call view
*--------------------------------------------------------------------*
FORM _callview USING i_view TYPE clike.
  CHECK i_view IS NOT INITIAL.
  CALL FUNCTION 'VIEW_MAINTENANCE_CALL'
    EXPORTING
      action                       = 'S'
      view_name                    = i_view
    EXCEPTIONS
      client_reference             = 1
      foreign_lock                 = 2
      invalid_action               = 3
      no_clientindependent_auth    = 4
      no_database_function         = 5
      no_editor_function           = 6
      no_show_auth                 = 7
      no_tvdir_entry               = 8
      no_upd_auth                  = 9
      only_show_allowed            = 10
      system_failure               = 11
      unknown_field_in_dba_sellist = 12
      view_not_found               = 13
      maintenance_prohibited       = 14
      OTHERS                       = 15.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.

*--------------------------------------------------------------------*
*	Call cluster
*--------------------------------------------------------------------*
FORM _callcluster USING i_view TYPE clike.
  CALL FUNCTION 'VIEWCLUSTER_MAINTENANCE_CALL'
    EXPORTING
      viewcluster_name             = i_view
      maintenance_action           = 'S'
    EXCEPTIONS
      client_reference             = 1
      foreign_lock                 = 2
      viewcluster_not_found        = 3
      viewcluster_is_inconsistent  = 4
      missing_generated_function   = 5
      no_upd_auth                  = 6
      no_show_auth                 = 7
      object_not_found             = 8
      no_tvdir_entry               = 9
      no_clientindep_auth          = 10
      invalid_action               = 11
      saving_correction_failed     = 12
      system_failure               = 13
      unknown_field_in_dba_sellist = 14
      missing_corr_number          = 15
      OTHERS                       = 16.
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.
*}I-NTP250618-3000009651

*&---------------------------------------------------------------------*
*& Form INITIALIZATION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM initialization .

*{  BEGIN OF INSERT WMR-190918-3000009765
  DATA: ls_cvers TYPE cvers.

  CLEAR gs_process.

  " N° Instalación Sap
  CALL FUNCTION 'SLIC_GET_LICENCE_NUMBER'
    IMPORTING
      license_number = gs_process-license.
  " Verificar sistema S/4 Hana
  SELECT SINGLE component release extrelease comp_type
    INTO CORRESPONDING FIELDS OF ls_cvers
    FROM cvers
    WHERE component = gc_component_s4core.
  IF sy-subrc = 0.
    gs_process-s4core = abap_on.
  ENDIF.
*}  END OF INSERT WMR-190918-3000009765

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SHOW_HIDE_FIELDS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM show_hide_fields .

*{  BEGIN OF INSERT WMR-190918-3000009765
  IF gs_process-s4core = abap_off.
    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN 'S4H'.
          screen-input = 0.
          screen-output = 0.
          screen-active = 0.
          MODIFY SCREEN.
      ENDCASE.
    ENDLOOP.
  ENDIF.
*}  END OF INSERT WMR-190918-3000009765

ENDFORM.
