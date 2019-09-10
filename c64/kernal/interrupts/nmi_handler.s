
nmi_handler:

	sei // don't allow IRQ to interfere, see https://www.c64-wiki.com/wiki/Interrupt

	// Call interrupt routine (only if initialised)
	pha
	lda NMINV
	ora NMINV+1
	beq !+
	pla
	jmp (NMINV)
!:
	// Vector not initialized - call default interrupt routine
	pla
	jmp default_nmi_handler


