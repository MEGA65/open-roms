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

	// Print startup messages
	jsr INITMSG

	// jump into warm start loop
	jmp basic_warm_start
