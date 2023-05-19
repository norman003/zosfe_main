*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZOSVA_CATAHOMO59................................*
TABLES: ZOSVA_CATAHOMO59, *ZOSVA_CATAHOMO59. "view work areas
CONTROLS: TCTRL_ZOSVA_CATAHOMO59
TYPE TABLEVIEW USING SCREEN '0059'.
DATA: BEGIN OF STATUS_ZOSVA_CATAHOMO59. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZOSVA_CATAHOMO59.
* Table for entries selected to show on screen
DATA: BEGIN OF ZOSVA_CATAHOMO59_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZOSVA_CATAHOMO59.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSVA_CATAHOMO59_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZOSVA_CATAHOMO59_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZOSVA_CATAHOMO59.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSVA_CATAHOMO59_TOTAL.

*.........table declarations:.................................*
TABLES: ZOSTB_CATAHOMO59               .
TABLES: ZOSTB_CATALOGO59               .
