#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Clear screen and initialise line link table, described in:
//
// - [CM64] Computes Mapping the Commodore 64 - pages 215-216
//


clear_screen:

	// Clear the line link table - cheecked on original ROMs,
	// the highest bit set means that the line is NOT a logical
	// continuation of the previous one

	lda #$80
	ldy #24	
!:
	sta LDTBL,y
	dey
	bpl !-

	// Clear all the rows
	ldx #24
!:
	jsr screen_clear_line
	dex
	bpl !-

	// Fall to cursor home routine
	jmp cursor_home


#endif // ROM layout
