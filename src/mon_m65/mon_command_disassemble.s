
; Based on BSM (Bit Shifter's Monitor)

Mon_Disassemble:

	lda  Adr_Mode
	pha                      ; store addressing mode, in case no parameter is given
	lda  #$00
	sta  Adr_Mode            ; by default use C64-style addressing

	jsr  Get_Addr_To_LAC     ; get 1st parameter (start address)
	beq  @nopar
	pla                      ; drop previous addressing mode
	jsr  LAC_To_LPC          ; Long_PC = start address
	jsr  Get_Addr_To_LAC     ; get 2nd parameter (end address)
	beq  @norange
	jsr  LAC_Minus_LPC       ; Long_CT = range
	+bcc Mon_Error           ; -> negative
    bra  @loop

@nopar:

	pla                      ; retrieve old addressing mode
	sta  Adr_Mode

@norange:

	lda  #$20                ; by default disassemble 32 addresses
    sta  Long_CT+0
    lda  #$00
    sta  Long_CT+1
    sta  Long_CT+2
    sta  Long_CT+3

@loop:

	jsr  CR_Erase            ; prepare empty line
	jsr  STOP
	+beq Main
	jsr  Dis_Code            ; disassemble one line
	inc  Op_Size
	lda  Op_Size
	jsr  Add_LPC             ; advance address
	lda  Long_CT
	sec
	sbc  Op_Size
	sta  Long_CT
	bcs  @loop

	jmp  Main
