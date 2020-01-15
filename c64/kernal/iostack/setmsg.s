// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmers Reference Guide   - page 298
// - [CM64] Computes Mapping the Commodore 64 - page 239
//
// CPU registers that has to be preserved (see [RG64]): .A, .X, .Y
//

SETMSG:

	sta MSGFLG
	rts
