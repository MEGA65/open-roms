
default_nmi_handler:

	;; XXX implement according to Compute's Mapping the Commodore 64, page 74

	;; XXX check if the source was RESTORE key, quit if it wasn't (no RS-232 support)
	;; XXX if cartridge present, enter it through warm start vector
	;; XXX if stop pressed, go to default_brk_handler

	inc $D020
	rti

