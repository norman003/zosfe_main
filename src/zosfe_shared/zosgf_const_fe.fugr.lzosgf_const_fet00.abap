*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZOSVA_CONST_FE..................................*
TABLES: ZOSVA_CONST_FE, *ZOSVA_CONST_FE. "view work areas
CONTROLS: TCTRL_ZOSVA_CONST_FE
TYPE TABLEVIEW USING SCREEN '0100'.
DATA: BEGIN OF STATUS_ZOSVA_CONST_FE. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZOSVA_CONST_FE.
* Table for entries selected to show on screen
DATA: BEGIN OF ZOSVA_CONST_FE_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZOSVA_CONST_FE.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSVA_CONST_FE_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZOSVA_CONST_FE_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZOSVA_CONST_FE.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSVA_CONST_FE_TOTAL.

*.........table declarations:.................................*
TABLES: ZOSTB_CONST_FE                 .
