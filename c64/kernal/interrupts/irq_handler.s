
irq_handler:
	;; The IRQ is a commonly messed with thing on the C64,
	;; so we need to handle entry points that are commonly
	;; relied upon, including:
	;; $EA31 - Standard IRQ routine
	;; $EA61 - Check keyboard, but don't update timer? https://github.com/cc65/cc65/issues/324
	;; $EA81 - https://www.lemon64.com/forum/viewtopic.php?t=2112&sid=6ea01982b26da69783120a7923ca46fb
	;; Also the $0314 vector is widely used (e.g., https://www.lemon64.com/forum/viewtopic.php?t=2112&sid=6ea01982b26da69783120a7923ca46fb)

	;; Save registers, sequence according to Compute's Mapping the Commodore 64, page 73
	pha
	txa
	pha
	tya
	pha

	;; XXX check if caused by BRK, react accordingly

	;; Call interrupt routine (only if initialised)
	lda CINV
	ora CINV+1
	beq +
	jmp (CINV)
*
	;; Vector not initialized - call default interrupt routine
	jmp default_irq_handler
