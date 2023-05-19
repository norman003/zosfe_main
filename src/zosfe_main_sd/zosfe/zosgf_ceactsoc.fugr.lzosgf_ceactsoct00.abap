*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZOSVA_CEACTSOC..................................*
TABLES: ZOSVA_CEACTSOC, *ZOSVA_CEACTSOC. "view work areas
CONTROLS: TCTRL_ZOSVA_CEACTSOC
TYPE TABLEVIEW USING SCREEN '0100'.
DATA: BEGIN OF STATUS_ZOSVA_CEACTSOC. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZOSVA_CEACTSOC.
* Table for entries selected to show on screen
DATA: BEGIN OF ZOSVA_CEACTSOC_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZOSVA_CEACTSOC.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSVA_CEACTSOC_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZOSVA_CEACTSOC_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZOSVA_CEACTSOC.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSVA_CEACTSOC_TOTAL.

*.........table declarations:.................................*
TABLES: T001                           .
TABLES: ZOSTB_CEACTSOC                 .
