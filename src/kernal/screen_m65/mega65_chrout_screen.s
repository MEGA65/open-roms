// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// CHROUT routine - screen support (character output), MEGA65 native mode version
//


m65_chrout_screen:

	// XXX hide cursor if visible

	lda SCHAR
	tax

	// All the PETSCII control codes are within $0x, $1x, $8x, $9x, remaining
	// ones are always printable characters; separate away control codes

	and #$60
	beq_16 m65_chrout_screen_control
	txa

	// Literals - first convert PETSCII to screen code

	jsr chrout_to_screen_code

	// FALLTROUGH

m65_chrout_screen_literal: // entry point for m65_chrout_screen_quote

	// Write normal character on the screen

	tax                                // store screen code, we need .A for calculations

	// XXX continue the implementation




	rts
