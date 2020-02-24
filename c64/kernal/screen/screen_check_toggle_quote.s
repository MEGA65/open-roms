// #LAYOUT# STD *        #TAKE
// #LAYOUT# X16 *        #IGNORE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Helper routine - check character in .A, toggles quote flag if needed
//

screen_check_toggle_quote:

	cmp #$22
	bne !+

	lda QTSW
	eor #$80
	sta QTSW

	lda #$22                           // restore previous .A valuee
!:
	rts
