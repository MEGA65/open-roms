
default_nmi_handler:

	;; Implemented according to Compute's Mapping the Commodore 64, page 74
	;; and to https://www.c64-wiki.com/wiki/Interrupt

	;; Save registers, sequence according to Compute's Mapping the Commodore 64, page 73
	pha
	txa
	pha
	tya
	pha

	;; XXX: RS-232 support is not implemented

	;; XXX if cartridge present, enter it through warm start vector

	;; According to C64 Wiki, if STOP key is pressed, the routine assumes warm start request

	jsr JSTOP
	bcs +
	jmp return_from_interrupt ; no STOP pressed
*
	jmp (CBINV) ; STOP + RESTORE

