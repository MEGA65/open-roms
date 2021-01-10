
; Based on BSM (Bit Shifter's Monitor)


Mon_Bits:

	lda  Adr_Mode
	pha                      ; store addressing mode, in case no parameter is given
	lda  #$00
	sta  Adr_Mode            ; by default use C64-style addressing

	jsr  Get_Addr_To_LAC     ; get 1st parameter (start address)
	beq  @nopar
	pla                      ; drop previous addressing mode
	jsr  LAC_To_LPC          ; Long_PC = start address
	bra  @start

@nopar:

	pla                      ; retrieve old addressing mode
	sta  Adr_Mode

@start:

	jsr  Print_CR
	ldx  #$08

@row:     

	phx
	jsr  Print_LPC_Addr
    
    ldz  #$00

@col:

	phx                      ; toggle bold attribute
	jsr Print_Attr_NoBold
	tza
	and #$08
	bne @lab
	jsr Print_Attr_Bold

@lab:

	plx

    jsr  Get_From_Memory
    jsr  Print_Bits
    clc
    tza
    adc  #$08
    taz
    cmp  #64
    bcc  @col
    jsr  Print_CR
    jsr  Inc_LPC
    plx
    dex
    bne  @row
    jmp  Main
