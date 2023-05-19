*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZOSVA_LOTNO.....................................*
TABLES: ZOSVA_LOTNO, *ZOSVA_LOTNO. "view work areas
CONTROLS: TCTRL_ZOSVA_LOTNO
TYPE TABLEVIEW USING SCREEN '0100'.
DATA: BEGIN OF STATUS_ZOSVA_LOTNO. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZOSVA_LOTNO.
* Table for entries selected to show on screen
DATA: BEGIN OF ZOSVA_LOTNO_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZOSVA_LOTNO.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSVA_LOTNO_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZOSVA_LOTNO_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZOSVA_LOTNO.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSVA_LOTNO_TOTAL.

*.........table declarations:.................................*
TABLES: ZOSTB_LOTNO                    .
