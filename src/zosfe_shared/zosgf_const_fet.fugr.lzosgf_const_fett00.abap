*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZOSVA_CONST_FET.................................*
TABLES: ZOSVA_CONST_FET, *ZOSVA_CONST_FET. "view work areas
CONTROLS: TCTRL_ZOSVA_CONST_FET
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZOSVA_CONST_FET. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZOSVA_CONST_FET.
* Table for entries selected to show on screen
DATA: BEGIN OF ZOSVA_CONST_FET_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZOSVA_CONST_FET.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSVA_CONST_FET_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZOSVA_CONST_FET_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZOSVA_CONST_FET.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSVA_CONST_FET_TOTAL.

*.........table declarations:.................................*
TABLES: ZOSTB_CONST_FET                .
