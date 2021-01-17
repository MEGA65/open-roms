
; Based on BSM (Bit Shifter's Monitor)


Mon_Transfer:

	jsr  Get_Param_Range     ; Long_PC = source
                             ; Long_CT = count

	jsr  Get_Val_To_LAC      ; Long_AC = target
	+beq Mon_Error

	lda  Src_Addr_Mode
	ora  Dst_Addr_Mode
	sta  Addr_Mode

	ldz  #0
	jsr  LAC_Compare_LPC     ; target - source
	bcc  @forward

	;        source < target: backward transfer

	jsr  LAC_Plus_LCT        ; Long_AC = end of target

@lpback:  

	jsr  Get_From_Memory_LDA ; backward copy
	jsr  Put_To_Memory_LAC
	jsr  Dec_LDA
	jsr  Dec_LAC
	jsr  Dec_LCT
	bpl  @lpback
	jmp  Main

@forward:

	jsr  Get_From_Memory_LPC ; forward copy
	jsr  Put_To_Memory_LAC
	jsr  Inc_LPC
	jsr  Inc_LAC
	jsr  Dec_LCT
	bpl  @forward
	jmp  Main
