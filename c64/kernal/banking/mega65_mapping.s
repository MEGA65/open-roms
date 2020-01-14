#if (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// ROM mapping routines for Mega65
//


map_NORMAL:

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

	rts


map_KERNAL_1:

	pha
	phx
	phy
	phz

	lda #$00
	tay
	taz

	ldx #$42    // XXX map 8KB from 0x20000 to 0x4000 - somehow does not seem to work

	bne map_end


#endif // ROM layout
