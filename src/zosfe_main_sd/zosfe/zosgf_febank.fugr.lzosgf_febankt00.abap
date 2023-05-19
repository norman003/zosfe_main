*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZOSVA_FEBANK....................................*
TABLES: ZOSVA_FEBANK, *ZOSVA_FEBANK. "view work areas
CONTROLS: TCTRL_ZOSVA_FEBANK
TYPE TABLEVIEW USING SCREEN '0100'.
DATA: BEGIN OF STATUS_ZOSVA_FEBANK. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZOSVA_FEBANK.
* Table for entries selected to show on screen
DATA: BEGIN OF ZOSVA_FEBANK_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZOSVA_FEBANK.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSVA_FEBANK_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZOSVA_FEBANK_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZOSVA_FEBANK.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSVA_FEBANK_TOTAL.

*.........table declarations:.................................*
TABLES: ZOSTB_FEBANK                   .
