*&---------------------------------------------------------------------*
*&  Include           ZOSFE_INC_CONFIG_TECNICA_F01
*&---------------------------------------------------------------------*

FORM user_command_0100 .

  DATA: lw_code   TYPE syucomm.

  lw_code = gw_okcode.
  CLEAR gw_okcode.

  CASE lw_code.
    WHEN '&AMB_SUNAT'. PERFORM _callview USING 'ZOSVA_ENVWSFE'.
  ENDCASE.

ENDFORM.
*--------------------------------------------------------------------*
*	Llamada a vista simple
*--------------------------------------------------------------------*
FORM _callview USING i_name TYPE dd02v-tabname.

  CALL FUNCTION 'VIEW_MAINTENANCE_CALL'
    EXPORTING
      action                       = 'S'      "S See, U Update
      view_name                    = i_name
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

ENDFORM.
