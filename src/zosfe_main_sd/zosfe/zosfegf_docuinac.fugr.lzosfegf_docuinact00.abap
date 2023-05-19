*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZOSFEVA_DOCUINAC................................*
TABLES: ZOSFEVA_DOCUINAC, *ZOSFEVA_DOCUINAC. "view work areas
CONTROLS: TCTRL_ZOSFEVA_DOCUINAC
TYPE TABLEVIEW USING SCREEN '0100'.
DATA: BEGIN OF STATUS_ZOSFEVA_DOCUINAC. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZOSFEVA_DOCUINAC.
* Table for entries selected to show on screen
DATA: BEGIN OF ZOSFEVA_DOCUINAC_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZOSFEVA_DOCUINAC.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSFEVA_DOCUINAC_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZOSFEVA_DOCUINAC_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZOSFEVA_DOCUINAC.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSFEVA_DOCUINAC_TOTAL.

*.........table declarations:.................................*
TABLES: ZOSFETB_DOCUINAC               .
