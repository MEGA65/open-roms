

DBG_print_PC_opcode:

	php
	pha
	phx
	phy
	phz

	pha

	jsr PRIMM
	!pet $0D, "PC: ", 0

	dew REG_PC
	lda REG_PC+1
	jsr DBGINT_print_hex_byte	
	lda REG_PC+0
	jsr DBGINT_print_hex_byte	
	inw REG_PC

	jsr PRIMM
	!pet " opcode: ", 0

	pla
	+beq MONITOR
	jsr DBGINT_print_hex_byte

	; FALLTROUGH

DBGINT_end:

	plz
	ply
	plx
	pla
	plp

	rts


DBG_print_hex:

	php
	pha
	phx
	phy
	phz

	pha
	lda #' '
	jsr CHROUT
	pla
	jsr DBGINT_print_hex_byte
	bra DBGINT_end


DBG_print_LOADCOUNT:

	php
	pha
	phx
	phy
	phz

	lda BIOS_LOADCOUNT+1
	jsr DBGINT_print_hex_byte
	lda BIOS_LOADCOUNT+0
	jsr DBGINT_print_hex_byte
	lda #$0D
	jsr CHROUT

	bra DBGINT_end


DBGINT_print_hex_byte:

	pha
	lsr
	lsr
	lsr
	lsr
	ora #$30
	cmp #$3A
	bcc @1
	adc #6
@1:	
	jsr CHROUT
	pla
	and #$0f
	ora #$30
	cmp #$3A
	bcc @2
	adc #6
@2:
	jmp CHROUT
