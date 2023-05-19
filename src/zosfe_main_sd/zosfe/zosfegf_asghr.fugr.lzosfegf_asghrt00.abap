*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZOSFEVA_ASGTNHR.................................*
TABLES: ZOSFEVA_ASGTNHR, *ZOSFEVA_ASGTNHR. "view work areas
CONTROLS: TCTRL_ZOSFEVA_ASGTNHR
TYPE TABLEVIEW USING SCREEN '0100'.
DATA: BEGIN OF STATUS_ZOSFEVA_ASGTNHR. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZOSFEVA_ASGTNHR.
* Table for entries selected to show on screen
DATA: BEGIN OF ZOSFEVA_ASGTNHR_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZOSFEVA_ASGTNHR.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSFEVA_ASGTNHR_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZOSFEVA_ASGTNHR_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZOSFEVA_ASGTNHR.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSFEVA_ASGTNHR_TOTAL.

*.........table declarations:.................................*
TABLES: ZOSFETB_ASGTNHR                .
