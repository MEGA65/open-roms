// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmers Reference Guide   - page 297
// - [CM64] Computes Mapping the Commodore 64 - page 238
//
// CPU registers that has to be preserved (see [RG64]): .A, .X, .Y
//

SETFLS:

	// There are 6 sane ways to implement this routine,
	// I hope this one will not cause similarity to CBM code

	sta LA
	sty SA
	stx FA

	rts
