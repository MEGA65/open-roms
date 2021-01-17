
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
	sta  AC,Y

	iny
	cpy  #$05
	bne  @lpreg

	; SP - 16 bit

	jsr  @helper_get_16_bit

	lda  Long_AC+0
	sta  SPL
	lda  Long_AC+1
	sta  SPH

	; Flags

	jsr  Get_Glyph
	beq  @exit
	dec  Buf_Index

	lda  #%01111111          ; prepare helper values for bit set/clear
	sta  Long_TMP+0
	lda  #%10000000
	sta  Long_TMP+1

@lpflag:

	jsr  Get_Char
	beq  @exit

	cmp  #'-'
	beq  @bit_clr
	cmp  #'1'
	+bne Mon_Error

@bit_set:

	lda  SR
	ora  Long_TMP+1

	bra  @next

@bit_clr:

	lda  SR
	and  Long_TMP+0

@next:

	sta  SR

	sec
	ror  Long_TMP+0
	clc 
	ror  Long_TMP+1

	bne  @lpflag

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
