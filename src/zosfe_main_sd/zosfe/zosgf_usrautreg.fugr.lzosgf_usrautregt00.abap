*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZOSVA_USRAUTREG.................................*
TABLES: ZOSVA_USRAUTREG, *ZOSVA_USRAUTREG. "view work areas
CONTROLS: TCTRL_ZOSVA_USRAUTREG
TYPE TABLEVIEW USING SCREEN '0100'.
DATA: BEGIN OF STATUS_ZOSVA_USRAUTREG. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZOSVA_USRAUTREG.
* Table for entries selected to show on screen
DATA: BEGIN OF ZOSVA_USRAUTREG_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZOSVA_USRAUTREG.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSVA_USRAUTREG_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZOSVA_USRAUTREG_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZOSVA_USRAUTREG.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSVA_USRAUTREG_TOTAL.

*.........table declarations:.................................*
TABLES: ZOSTB_USRAUTREG                .
