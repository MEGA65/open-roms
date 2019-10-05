
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 290
// - [CM64] Compute's Mapping the Commodore 64 - page 215
//
// CPU registers that has to be preserved (see [RG64]): none
//

PLOT:
	bcs plot_get

	// Note: the 'set' part has to start from $E50C, as this is a known address
	// - https://www.lemon64.com/forum/viewtopic.php?t=3296&amp%3Bstart=15
	// - https://sys64738.org/2019/05/c64-bedtime-coding-eng-printing-08/
	// - 'Duotris' game calls $E50C during startup screen initialization

plot_set:
	sty TBLX
	stx PNTR

	// XXX handle cursor blink
	// XXX should we update some more variables?

	// FALLTROUGH to save one byte on RTS

plot_get:
	ldy TBLX
	ldx PNTR
	rts
