// Clear screen and initialise line link table
// (Compute's Mapping the 64 p215-216)

clear_screen_real:

	// XXX it is probably a good idea to hide cursor first

	// Clear line link table 
	// (Compute's Mapping the 64 p215)

	lda #$00
	ldy #24
clearscreen_l1:
	sta LDTBL,y
	dey
	bpl clearscreen_l1

	// Y now = #$FF

	// Clear screen RAM.
	// We should do this at HIBASE, which annoyingly
	// is no ZP, so we need to make a vector
	// (Compute's Mapping the 64 p216)
	// Get pointer to the screen into PNT
	// as it is the first appropriate place for it found when
	// searching through the ZP allocations listed in
	// Compute's Mapping the 64
	sta PNT+0
	lda HIBASE
	sta PNT+1
	ldx #$03		// countdown for pages to update
	iny 			// Y now = #$00
	lda #$20		// space character
clearscreen_l2:
	sta (PNT),y
	iny
	bne clearscreen_l2
	// To draw only 1000 bytes, add 250 to address each time
	lda PNT
	clc
	adc #<250
	sta PNT
	lda PNT+1
	adc #>250
	sta PNT+1
	lda #$20		// get space character again
	dex
	bpl clearscreen_l2

	// Clear colour RAM
	// (Compute's Mapping the 64 p216)
	lda COLOR
clearscreen_l3:	
	sta $d800,y
	sta $d900,y
	sta $da00,y
	sta $db00-24,y    	// so we only erase 1000 bytes
	iny
	bne clearscreen_l3

	// (Compute's Mapping the 64 p216)
	jmp cursor_home
