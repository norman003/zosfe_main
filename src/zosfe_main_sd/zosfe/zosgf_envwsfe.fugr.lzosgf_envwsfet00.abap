*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZOSVA_ENVWSFE...................................*
TABLES: ZOSVA_ENVWSFE, *ZOSVA_ENVWSFE. "view work areas
CONTROLS: TCTRL_ZOSVA_ENVWSFE
TYPE TABLEVIEW USING SCREEN '0100'.
DATA: BEGIN OF STATUS_ZOSVA_ENVWSFE. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZOSVA_ENVWSFE.
* Table for entries selected to show on screen
DATA: BEGIN OF ZOSVA_ENVWSFE_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZOSVA_ENVWSFE.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSVA_ENVWSFE_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZOSVA_ENVWSFE_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZOSVA_ENVWSFE.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOSVA_ENVWSFE_TOTAL.

*.........table declarations:.................................*
TABLES: ZOSTB_ENVWSFE                  .
