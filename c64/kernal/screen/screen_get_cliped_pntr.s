#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Get PNTR value clipped to 0-39 range in .Y, sets flags to compare with 0, can trash .A
//

screen_get_clipped_PNTR:

	ldy PNTR
	cpy #40
	bcc !+
	tya
	sbc #40
	tay
!:
	cpy #$00
	rts


#endif // ROM layout