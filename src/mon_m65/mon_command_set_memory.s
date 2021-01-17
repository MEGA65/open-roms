
; Based on BSM (Bit Shifter's Monitor)


Mon_Set_Memory:

 	jsr  Get_Val_To_LAC    ; get 1st. parameter
 	beq  @exit
 	jsr  LAC_To_LPC        ; Long_PC = row address
 	lda  Addr_Mode
 	sta  Dst_Addr_Mode

 	ldz  #$00

@loop: 

	jsr  Get_Glyph
    cmp  #KEY_COLON
    beq  @exit
	jsr  Got_Val_To_LAC
	beq  @exit
	jsr  Syntax_Byte_AC

	lda  Dst_Addr_Mode
 	sta  Addr_Mode

 	lda  Long_AC+0
 	jsr  Put_To_Memory_LPC

 	inz
 	bra  @loop

@exit:

	jsr  PRIMM
	!pet KEY_ESC, 'o', $91, $00
	jsr  Dump_Row
	jmp  Main
