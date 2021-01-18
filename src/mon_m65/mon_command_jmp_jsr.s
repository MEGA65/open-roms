
; Based on BSM (Bit Shifter's Monitor)


Mon_JSR:


	lda  #$00
	sta  Addr_Mode

	jsr  Get_Val_To_LAC      ; Long_AC = jump address
	+beq Mon_Error

	; Push return addresses

	lda #>(Mon_JSR_ret-1)    ; XXX return routine should JSR, to store address 
	pha
	lda #<(Mon_JSR_ret-1)
	pha

	lda #>(monitor_jmpout_ret-1)
	pha
	lda #<(monitor_jmpout_ret-1)
	pha

	bra  Mon_Go_JSR_comon

Mon_Go:

	lda  #$00
	sta  Addr_Mode

	jsr  Get_Val_To_LAC      ; Long_AC = jump address
	+bne Mon_Go_JSR_comon

	lda  PCL                 ; use PC as jump address
	sta  Long_AC+0
	lda  PCH
	sta  Long_AC+0

	; FALLTROUGH

Mon_Go_JSR_comon:

	lda  Addr_Mode           ; only first 64KB is supported as target
	+bne Mon_Error

	lda  PCH                 ; push target address for RTS
	sta  Long_TMP+1
	lda  PCL
	sta  Long_TMP+0
	dew  Long_TMP+0

	lda  Long_TMP+1
	pha
	lda  Long_TMP+0
	pha

	; Prepare registers

	lda  SR
	pha
	lda  AC
	pha
	lda  BP
	pha
	lda  XR
	pha
	lda  YR
	pha
	lda  ZR
	pha

	jmp  monitor_jmpout

Mon_JSR_ret:

	; Retrieve registers
	; XXX address!

	pha
	php
	pla
	sta  SR
	pla
	sta  AC
	tba
	sta  BP
	stx  XR
	sty  YR
	stz  ZR  

	jmp  Mon_Register
