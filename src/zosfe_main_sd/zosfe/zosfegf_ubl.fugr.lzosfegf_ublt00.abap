*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZOSFEVA_UBL.....................................*
TABLES: ZOSFEVA_UBL, *ZOSFEVA_UBL. "view work areas
CONTROLS: TCTRL_ZOSFEVA_UBL
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZOSFEVA_UBL. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZOSFEVA_UBL.
* Table for entries selected to show on screen
DATA: BEGIN OF ZOSFEVA_UBL_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZOSFEVA_UBL.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSFEVA_UBL_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZOSFEVA_UBL_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZOSFEVA_UBL.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSFEVA_UBL_TOTAL.

*.........table declarations:.................................*
TABLES: ZOSFETB_UBL                    .
