
; Based on BSM (Bit Shifter's Monitor)


Mon_Compare:

	jsr  Get_Param_Range     ; Long_PC = source
	+bcs Mon_Error           ; Long_CT = count
	lda  #$00
    sta  Addr_Mode
	jsr  Get_Addr_To_LAC     ; Long_AC = target
	+beq Mon_Error

	lda  Src_Addr_Mode
	ora  Dst_Addr_Mode
	sta  Src_Addr_Mode

	lda  Addr_Mode
	sta  Dst_Addr_Mode

	jsr  Print_CR
	ldz  #0

@loop:

	lda  Dst_Addr_Mode
	sta  Addr_Mode
	jsr  Get_From_Memory_LAC
	sta  Byte_TMP

	lda  Src_Addr_Mode
	sta  Addr_Mode
	jsr  Get_From_Memory_LPC

	cmp  Byte_TMP
	beq  @laba
	jsr  Print_LPC_Addr

@laba:

	jsr  Inc_LAC
	jsr  Inc_LPC
	jsr  Dec_LCT
	bpl  @loop
	jmp  Main
