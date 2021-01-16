
; Monitor helper code - memory read and write

Get_From_Memory_LAC:

	jsr Exchange_LAC_LPC
	jsr Get_From_Memory_LPC
	jmp Exchange_LAC_LPC

Get_From_Memory_LDA:

	jsr Exchange_LDA_LPC
	jsr Get_From_Memory_LPC
	jmp Exchange_LDA_LPC

Get_From_Memory_LPC:

	phx
	phy
	phz

	; Copy PC + .Z to TMP, set .Z to 0

	jsr  Get_Put_Memory_Prepare

	; Check addressing mode

	bbs7  Addr_Mode, @mode_flat

@mode_64k:

	lda  #$00                          ; make sure this is 64K address
	sta  Long_TMP+2
	sta  Long_TMP+3

	lda  Long_TMP+1
	bne  @read_64k                     ; branch if no need to handle shadow memory (not zero page)
	lda  Long_TMP+0
	dec
	dec
	cmp  #$8E
	bcs  @read_64k                     ; branch if no need to handle shadow memory (0, 1, or above $8F)
@1:
	bra  @read_shadow

@mode_flat:

	lda  Long_TMP+3
	ora  Long_TMP+2
	ora  Long_TMP+1
	bne  @read_flat

	lda  Long_TMP+0
	dec
	dec
	cmp  #$8E
	bcs  @read_flat
	bra  @1

@read_64k:

	bbr7 Long_TMP+1, @read_flat        ; below $8000 we do not want to retrieve MAP/EOM banked memory
	bra  @read

@read_shadow:

	jsr  Get_Put_Memory_Prepare_Shadow

@read_flat:
	
	jsr  monitor_memread_helper
	bra  Get_Put_Memory_End

@read:

	lda  (Long_TMP),Z

	; FALLTROUGH

Get_Put_Memory_End: 

	plz
	ply
	plx

	rts

Get_Put_Memory_Prepare:

	; Copy PC + .Z to TMP, set .Z to 0

	clc
	tza
	adc  Long_PC+0
	sta  Long_TMP+0

	ldx  #$01
@1:
	lda  Long_PC+0,x
	adc  #$00
	sta  Long_TMP+0,x
	inx
	cpx  #$04
	bne  @1 

	ldz  #$00

	rts

Get_Put_Memory_Prepare_Shadow:

	sta  Long_TMP+0

	lda  #MEMCONF_SHADOW_BZP_1
	sta  Long_TMP+1
	lda  #MEMCONF_SHADOW_BZP_2
	sta  Long_TMP+2
	lda  #MEMCONF_SHADOW_BZP_3
	sta  Long_TMP+3

	rts




Put_To_Memory_LAC:

	jsr Exchange_LAC_LPC
	jsr Put_To_Memory_LPC
	jmp Exchange_LAC_LPC

Put_To_Memory_LPC:

	phx
	phy
	phz
	pha

	; Copy PC + .Z to TMP, set .Z to 0

	jsr Get_Put_Memory_Prepare

	; Check if address is related to shadow zeropage

	lda  Long_TMP+1
	ora  Long_TMP+2
	ora  Long_TMP+3
	bne  @write_flat

	lda  Long_TMP+0
	dec
	dec
	cmp  #$8E
	bcs  @write_flat

@write_shadow:

	jsr  Get_Put_Memory_Prepare_Shadow

@write_flat:

	pla
	jsr  monitor_memwrite_helper
	bra  Get_Put_Memory_End



Exchange_LDA_LPC:

	phx
	pha

	ldx  #$03

@loop:

	lda  Long_DA,X
	pha
	lda  Long_PC,X
	sta  Long_DA,X
	pla
	sta  Long_PC,X

	dex
	bpl  @loop

	pla
	plx
	rts

Exchange_LAC_LPC:

	phx
	pha

	ldx  #$03

@loop:

	lda  Long_AC,X
	pha
	lda  Long_PC,X
	sta  Long_AC,X
	pla
	sta  Long_PC,X

	dex
	bpl  @loop

	pla
	plx
	rts
