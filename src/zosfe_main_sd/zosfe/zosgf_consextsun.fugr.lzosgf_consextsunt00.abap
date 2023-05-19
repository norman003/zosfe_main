*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZOSVA_CONSEXTSUN................................*
TABLES: ZOSVA_CONSEXTSUN, *ZOSVA_CONSEXTSUN. "view work areas
CONTROLS: TCTRL_ZOSVA_CONSEXTSUN
TYPE TABLEVIEW USING SCREEN '0100'.
DATA: BEGIN OF STATUS_ZOSVA_CONSEXTSUN. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZOSVA_CONSEXTSUN.
* Table for entries selected to show on screen
DATA: BEGIN OF ZOSVA_CONSEXTSUN_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZOSVA_CONSEXTSUN.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSVA_CONSEXTSUN_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZOSVA_CONSEXTSUN_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZOSVA_CONSEXTSUN.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSVA_CONSEXTSUN_TOTAL.

*.........table declarations:.................................*
TABLES: ZOSTB_CONSEXTSUN               .
