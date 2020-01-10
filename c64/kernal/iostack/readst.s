#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmers Reference Guide   - page 292
// - [CM64] Computes Mapping the Commodore 64 - page 239
//
// CPU registers that has to be preserved (see [RG64]): .X, .Y
//

READST:

	// Check the current device number

	lda FA
	cmp #$02
	bne !+
	
	// This is RS-232 device - according to 'Computes Mapping the Commodore 64' page 239
	// it reads status from RSSTAT
	// XXX 'lda RSSTAT' not possible due to extended scnkey, fix it!
	lda #$FF
	rts
!:
	// According to 'Computes Mapping the Commodore 64' page 239, it usually retrieves
	// status from IOSTATUS
	
	// XXX is it always the case if device is not RS-232 ?

	lda IOSTATUS
	rts


#endif // ROM layout
