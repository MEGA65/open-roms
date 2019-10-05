
default_brk_handler:

	// Implemented according to Compute's Mapping the Commodore 64, pages 73-74

	sei // disable IRQs, to be sure they won't interfere

	jsr JRESTOR
	jsr JIOINIT
	jsr cint_brk

	cli

	jmp (IBASIC_WARM_START)
