
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 297
// - [CM64] Compute's Mapping the Commodore 64 - page 238
//
// CPU registers that has to be preserved (see [RG64]): .A, .X, .Y
//

SETFLS:

	// There are 6 sane ways to implement this routine,
	// I hope this one won't cause similarity to CBM code

	sta LA
	sty SA
	stx FA

	rts
