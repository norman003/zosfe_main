*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZOSVA_MATEXON...................................*
TABLES: ZOSVA_MATEXON, *ZOSVA_MATEXON. "view work areas
CONTROLS: TCTRL_ZOSVA_MATEXON
TYPE TABLEVIEW USING SCREEN '0100'.
DATA: BEGIN OF STATUS_ZOSVA_MATEXON. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZOSVA_MATEXON.
* Table for entries selected to show on screen
DATA: BEGIN OF ZOSVA_MATEXON_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZOSVA_MATEXON.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSVA_MATEXON_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZOSVA_MATEXON_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZOSVA_MATEXON.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSVA_MATEXON_TOTAL.

*.........table declarations:.................................*
TABLES: ZOSTB_MATEXON                  .
