
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 288
// - [CM64] Compute's Mapping the Commodore 64 - page 240
//
// CPU registers that has to be preserved (see [RG64]): .A
//

MEMTOP:

	bcc memtop_set
	
	ldy MEMSIZ+1
	ldx MEMSIZ+0
	rts

memtop_set:

	sty MEMSIZ+1
	stx MEMSIZ+0
	
	rts
