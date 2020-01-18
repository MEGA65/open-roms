// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmers Reference Guide   - page 291
// - [CM64] Computes Mapping the Commodore 64 - page 232
//
// CPU registers that has to be preserved (see [RG64]): none
//

RDTIM:

	// Disable interrupts for the duration of the routine, to prevent
	// jiffy clock update while reeading its values
	sei

	// Store the jiffy clock state
	ldy TIME+0
	ldx TIME+1
	lda TIME+2

	// Enable interrupts. More elegant solution would be pha + sei + ... + pla,
	// but (checked by running a test program) original ROM routine always
	// leaves IRQs enabled.
	cli
	rts
