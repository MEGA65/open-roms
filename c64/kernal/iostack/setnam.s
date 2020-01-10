#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmers Reference Guide   - page 298/299
// - [CM64] Computes Mapping the Commodore 64 - page 238
//
// CPU registers that has to be preserved (see [RG64]): .A, .X, .Y
//

SETNAM:

	// There are 6 sane ways to implement this routine,
	// I hope this one will not cause similarity to CBM code

	sta FNLEN
	sty FNADDR + 1
	stx FNADDR + 0

	rts


#endif // ROM layout
