// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// ROM mapping routines for Mega65
//

// Available memory maps:
// - NORMAL   - nothing mapped in
// - KERNAL_1 - for calling KERNAL_1 segment code


map_NORMAL:

	php
	pha
	phx
	phy
	phz

	lda #$00
	tax
	tay
	taz

	// FALLTROUGH

map_end:

	map
	eom

	plz
	ply
	plx
	pla
	plp

	rts


map_KERNAL_1:

	php
	pha
	phx
	phy
	phz

	lda #$00
	tay
	taz

	ldx #$42    // 0x4000 <- map 8KB from 0x20000

	bne map_end
