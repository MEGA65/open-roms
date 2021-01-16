
; Based on BSM (Bit Shifter's Monitor)


Mon_Hunt:

	jsr  Get_Param_Range   ; Long_PC = start
	+bcs Mon_Error         ; Long_CT = count

	ldy  #$00
	jsr  Get_Char
	cmp  #KEY_APOSTROPHE
	bne  @bin
	jsr  Get_Char          ; string hunt
	cmp  #$00
	+beq Mon_Error         ; null string

@lpstr:

	sta  Mon_Data,Y
	iny
	jsr  Get_Char
	beq  @hunt
	cpy  #32               ; max string length
	bne  @lpstr
	bra  @hunt

@bin:

	jsr  Got_Addr_To_LAC
	jsr  Syntax_Byte_AC

@lpbin:

	lda  Long_AC
	sta  Mon_Data,Y
	iny
	jsr  Get_Addr_To_LAC
	beq  @hunt
	jsr  Syntax_Byte_AC

	cpy  #32               ; max data length
	bne  @lpbin

@hunt:

	sty  Long_DA           ; hunt length
	jsr  Print_CR

@lpstart:

	lda  Src_Addr_Mode
	ora  Dst_Addr_Mode
	sta  Addr_Mode         ; combined addressing mode

	ldy  #$00

@lpins:

	jsr  Fetch
	cmp  Mon_Data,Y
	bne  @next
	iny
	cpy  Long_DA
	bne  @lpins
	jsr  Print_LPC_Addr    ; match

@next:

	jsr  STOP
	+beq Main
	jsr  Inc_LPC
	jsr  Dec_LCT
	bpl  @lpstart
	jmp  Main
