
setup_vicii:

	// Set up default IO values (Compute's Mapping the 64 p215)
	lda #$1B    // Enable text mode
	sta VIC_SCROLY
	lda #$C8    // 40 column etc
	sta VIC_SCROLX

	// Compute's Mapping the 64, p156
	// We use a different colour scheme of white text on all blue
	lda #$06
	sta VIC_EXTCOL
	sta VIC_BGCOL0

	// Turn off sprites (observed hanging around after running programs and resetting)
	lda #$00
	sta VIC_SPENA

	// FALLTROUGH
