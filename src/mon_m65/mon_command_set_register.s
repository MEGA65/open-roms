
; Based on BSM (Bit Shifter's Monitor)


Mon_Set_Register:

	; PC - 16 bit

	jsr  @helper_get_16_bit

	lda  Long_AC+0
	sta  PCL
	lda  Long_AC+1
	sta  PCH

	; SR / AC / XR / YR / ZR / BP - 8 bit each

	ldy  #$00

@lpreg:

	jsr  Get_Val_To_LAC
	beq  @exit
	jsr  Syntax_Byte_AC

	lda  Long_AC+0
	sta  SR,Y

	iny
	cpy  #$06
	bne  @lpreg

	; SP - 16 bit

	jsr  @helper_get_16_bit

	lda  Long_AC+0
	sta  SPL
	lda  Long_AC+1
	sta  SPH

	; Flags



	; XXX

@exit:

	jmp Main


@helper_get_16_bit:

	lda  #$00
	sta  Addr_Mode
	jsr  Get_Val_To_LAC
	beq  @exit
	lda  Addr_Mode
	+bne Mon_Error           ; only 16-bit value allowed

	rts
