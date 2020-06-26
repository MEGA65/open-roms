// #LAYOUT# STD *        #TAKE
// #LAYOUT# X16 *        #IGNORE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE


// c64 prg p263

cartridge_check:

	ldx #$05
!:
	lda CART_SIG-1,x
	cmp cartridge_signature-1,x
	bne cartridge_check_end
	dex
	bne !-

	// FALLTROUGH

cartridge_check_end:

	rts
