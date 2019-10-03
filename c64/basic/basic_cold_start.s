// BASIC Cold start entry point
// Compute's Mapping the 64 p211

basic_cold_start:

	// Setup vectors at $300
	ldy #$0B
!:
	lda basic_vector_defaults_1, y
	sta IERROR, y
	dey
	bpl !-

	// Setup misc vectors
	ldy #$04
!:
	lda basic_vector_defaults_2, y
	sta ADRAY1, y
	dey
	bpl !-

	// Setup USRPOK
	lda #$4C // JMP opcode
	sta USRPOK
	lda #<do_ILLEGAL_QUANTITY_error
	sta USRADD+0
	lda #>do_ILLEGAL_QUANTITY_error
	sta USRADD+1

	// Print startup banner
	jsr printf // XXX don't use printf, keep it for debug purposes only
	TARGET_HOOK_BANNER()

	// Print PAL/NTSC
	ldx #30 // NTSC
	lda TVSFLG
	beq !+
	ldx #31 // PAL
!:
	jsr print_packed_message

	// Work out free bytes, display them
	jsr basic_do_new
	lda MEMSIZ+0
	sec
	sbc TXTTAB+0
	tax
	lda MEMSIZ+1
	sbc TXTTAB+1

	jsr print_integer
	jsr print_space

	// Print the rest of the start up message
	ldx #34
	jsr print_packed_message

	// jump into warm start loop
	jmp basic_warm_start
