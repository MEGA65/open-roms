// BASIC Cold start entry point
// Compute's Mapping the 64 p211

basic_cold_start:	
	// Setup BASIC vectors at $0300
	// Initialise interpretor
	// Print start up message

	// Print coloured part of the message
	// ldy #>startup_message
	// lda #<startup_message
	// jsr print_string

	jsr printf // XXX don't use printf, keep it for debug purposes only

startup_banner:

	TARGET_HOOK_BANNER()

	// Print PAL/NTSC
	ldx #30 // NTSC
	lda PALNTSC
	beq !+
	ldx #31 // PAL
!:
	jsr print_packed_message

	// Work out free bytes, and display
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

startup_message: // XXX this is probably not needed anymore
	// Clear the screen
	.byte $93
	// Vertical bars in different colours
	.byte $1C,$B4
	.byte $9E,$B5
	.byte $1E,$A1
	// <RVS><WHITE>MEGA<NORMAL>BASIC\r\r
	.byte $12,$05,$4D,$45,$47,$41,$92
	.byte $42,$41,$53,$49,$43
	.byte $20,$56,$32,$2e,$30,$2e,$30
	.byte $0D,$0D

	.byte 0
