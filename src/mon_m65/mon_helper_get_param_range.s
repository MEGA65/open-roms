
; Based on BSM (Bit Shifter's Monitor)


Get_Param_Range:

; read two (address) parameters

; Long_CT       - difference (2nd minus 1st parameter)
; Long_PC       - 1st parameter
; Src_Addr_Mode - 1st parameter addressing mode
; Long_DA       - 2nd parameter
; Dst_Addr_Mode - 2nd parameter addressing mode

; carry on exit - 2nd parameter lower than 1st one

	jsr  @get_helper
	sta  Src_Addr_Mode
	jsr  LAC_To_LPC             ; Long_PC - 1st address

	jsr  @get_helper
	sta  Dst_Addr_Mode
	jsr  LAC_To_LDA             ; Long_PC - 2nd address

    jsr  LAC_Minus_LPC          ; Long_CT = range
    bcc  @error
    clc
    rts

@error:

	sec
	rts

@get_helper:

	lda  #$00
	sta  Addr_Mode
	jsr  Get_Addr_To_LAC
	beq  @error
	lda  Addr_Mode
	rts
