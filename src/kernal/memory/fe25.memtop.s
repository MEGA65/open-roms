// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmers Reference Guide   - page 288
// - [CM64] Computes Mapping the Commodore 64 - page 240
//
// CPU registers that has to be preserved (see [RG64]): .A
//

MEMTOP:

	bcc memtop_set
	
	ldy MEMSIZK+1
	ldx MEMSIZK+0

	// FALLTROUGH

memtop_set: // for compatibility reasons this has to start at $FE2D

	sty MEMSIZK+1
	stx MEMSIZK+0
	
	rts
