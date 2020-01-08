
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
