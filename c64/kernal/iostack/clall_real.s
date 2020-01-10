#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmers Reference Guide   - page 281
// - [CM64] Computes Mapping the Commodore 64 - page 230
//
// CPU registers that has to be preserved (see [RG64]): .Y
//


clall_real:

	// Store .Y register
	phy_trash_a

	// Original routine probably just sets LDTND to 0, but this is not really safe,
	// so we actually close all the channels; at least IDE64 does the same for
	// its channels, see CLALL description in the IDE64 Users Guide
!:
	ldy LDTND
	beq !+
	dey
	lda LAT, y
	jsr JCLOSE
	jmp !-
!:
	// Restore .Y register
	ply_trash_a

	// 'C64 Programmers Reference Guide', page 281, claims it calls CLRCHN too
	jsr CLRCHN
	
	// Not sure whether original Kernal does so, but it seems sane to also clear possible errors
	jmp kernalstatus_reset


#endif // ROM layout
