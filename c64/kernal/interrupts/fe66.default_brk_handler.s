
default_brk_handler:

	// Implemented according to Compute's Mapping the Commodore 64, pages 73-74

	sei // disable IRQs, to be sure they won't interfere

	ldx #$00
	sta VIC_SCROLX // turn the display off - we want as little screen artifacts as possible

	cld // make sure this dangerous flag is disabled

	jsr JRESTOR
	jsr JIOINIT

	// Original routine calls just a part of CINT - but I'm not sure which one. Most likely it
	// skips the PAL/NTSC check by calling $E518. I suspect bug in the original ROM, let's
	// call the whole CINT, just to be sure everything is initialized.

	jsr CINT

	cli

	jmp (IBASIC_WARM_START)
