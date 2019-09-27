// BASIC Cold start entry point
// Compute's Mapping the 64 p211

basic_cold_start:

	// Setup vectors at $300
	ldy #$0B
!:
	lda basic_vector_defaults, y
	sta IERROR, y
	dey
	bpl !-

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
	lda basic_top_of_memory_ptr+0
	sec
	sbc basic_end_of_text_ptr+0
	tax
	lda basic_top_of_memory_ptr+1
	sbc basic_end_of_text_ptr+1

	jsr print_integer

	lda #$20
	jsr JCHROUT
	
	// Print the rest of the start up message
	ldx #34
	jsr print_packed_message

	// jump into warm start loop
	jmp basic_warm_start
