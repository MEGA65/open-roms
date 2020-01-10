#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Home the cursor, described in:
//
// - [CM64] Computes Mapping the Commodore 64 - page 216
//


cursor_home:

	lda #$00
	sta PNTR                           // current column (logical)
	sta TBLX                           // current row

	// FALLTROUGH to the next routine


#endif // ROM layout
