
default_brk_handler:

	// Implemented according to Compute's Mapping the Commodore 64, pages 73-74

	sei // disable IRQs, to be sure they won't interfere

	ldx #$00
	sta VIC_SCROLX // turn the display off - we want as little screen artifacts as possible

	cld // make sure this dangerous flag is disabled

	jsr JRESTOR
	jsr JIOINIT
	jsr setup_vicii // XXX should probably be a part of cint_brk
	jsr cint_brk

	cli

	jmp (IBASIC_WARM_START)
