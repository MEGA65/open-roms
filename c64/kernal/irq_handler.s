irq_handler:
	;; The IRQ is a commonly messed with thing on the C64,
	;; so we need to handle entry points that are commonly
	;; relied upon, including:
	;; $EA31 - Standard IRQ routine
	;; $EA61 - Check keyboard, but don't update timer? https://github.com/cc65/cc65/issues/324
	;; $EA81 - https://www.lemon64.com/forum/viewtopic.php?t=2112&sid=6ea01982b26da69783120a7923ca46fb
	;; Also the $0314 vector is widely used (e.g., https://www.lemon64.com/forum/viewtopic.php?t=2112&sid=6ea01982b26da69783120a7923ca46fb)
	
	;; Save registers
	pha
	txa
	pha
	tya
	pha

	;; Acknowledge CIA interrupt
	lda $dc0d
	
	;; Call interrupt routine
	;; (but only if initialised)
	lda $0314
	ora $0315
	beq default_irq_handler
	jmp ($0314)
default_irq_handler:	

	jsr blink_cursor
	jsr scan_keyboard

	lda KeyQuantity
	sta $0400
	lda Buffer+0
	sta $0401
	lda Buffer+1
	sta $0402
	lda Buffer+2
	sta $0403
	
	jmp return_from_interrupt
