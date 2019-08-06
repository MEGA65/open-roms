
default_brk_handler:

	;; Implemented according to Compute's Mapping the Commodore 64, pages 73-74

	jsr JRESTOR
	jsr JIOINIT
	jsr CINT_BRK

	jmp (IBASIC_WARM_START)

