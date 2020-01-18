// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 295
// - [CM64] Compute's Mapping the Commodore 64 - page 215
//
// CPU registers that has to be preserved (see [RG64]): .A
//


SCREEN:

	// There are only 2 sane ways to implement this routine,
	// I hope this one is different than what Commodore picked :)

	ldy #25 // 25 columns
	ldx #40 // 40 rows

	rts
