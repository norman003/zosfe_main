*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZOSFEVA_ASGCODES................................*
TABLES: ZOSFEVA_ASGCODES, *ZOSFEVA_ASGCODES. "view work areas
CONTROLS: TCTRL_ZOSFEVA_ASGCODES
TYPE TABLEVIEW USING SCREEN '0100'.
DATA: BEGIN OF STATUS_ZOSFEVA_ASGCODES. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZOSFEVA_ASGCODES.
* Table for entries selected to show on screen
DATA: BEGIN OF ZOSFEVA_ASGCODES_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZOSFEVA_ASGCODES.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSFEVA_ASGCODES_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZOSFEVA_ASGCODES_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZOSFEVA_ASGCODES.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSFEVA_ASGCODES_TOTAL.

*.........table declarations:.................................*
TABLES: ZOSFETB_ASGCODES               .
