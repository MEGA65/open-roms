
; Based on BSM (Bit Shifter's Monitor)


; *******
Mon_Fill:
; *******

	jsr  Get_Param_Range   ; Long_PC = target
	+bcs Mon_Error         ; Long_CT = count

	jsr  Get_Addr_To_LAC   ; Long_AC = fill byte
	+beq Mon_Error
	jsr  Syntax_Byte_AC    ; only 1 fill byte allowed

	ldz  #$00

@loop:

	lda  Long_AC
	jsr  Put_To_Memory_LPC
	jsr  Inc_LPC
	jsr  Dec_LCT
	bpl  @loop

	jmp  Main
