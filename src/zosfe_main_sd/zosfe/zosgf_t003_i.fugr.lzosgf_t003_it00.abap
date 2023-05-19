*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZOSVA_T003_I....................................*
TABLES: ZOSVA_T003_I, *ZOSVA_T003_I. "view work areas
CONTROLS: TCTRL_ZOSVA_T003_I
TYPE TABLEVIEW USING SCREEN '0100'.
DATA: BEGIN OF STATUS_ZOSVA_T003_I. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZOSVA_T003_I.
* Table for entries selected to show on screen
DATA: BEGIN OF ZOSVA_T003_I_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZOSVA_T003_I.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSVA_T003_I_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZOSVA_T003_I_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZOSVA_T003_I.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSVA_T003_I_TOTAL.

*.........table declarations:.................................*
TABLES: DOCCLSS                        .
TABLES: DOCCLSST                       .
TABLES: T005                           .
TABLES: T005T                          .
TABLES: TVFK                           .
TABLES: TVFKT                          .
TABLES: ZOSTB_T003_I                   .
