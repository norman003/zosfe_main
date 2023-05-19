FUNCTION zosfe_process_00001420.
*"--------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     VALUE(I_BKPF) LIKE  BKPF STRUCTURE  BKPF
*"     VALUE(I_BSEG) LIKE  BSEG STRUCTURE  BSEG
*"     VALUE(I_AKTYP) LIKE  T020-AKTYP
*"  TABLES
*"      T_NOINPUT STRUCTURE  OFIBM
*"      T_INVISIBLE STRUCTURE  OFIBM
*"--------------------------------------------------------------------

  PERFORM amp02a_fb02_disablefiels IN PROGRAM zosfe_amp_formadepago
    USING i_bkpf i_aktyp CHANGING t_noinput[]. "I-060321-NTP-3000016407

ENDFUNCTION.
