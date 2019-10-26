
default_irq_handler:

	jsr cursor_blink
	jsr JSCNKEY
	jsr JUDTIM // update jiffy clock

	// Acknowledge CIA interrupt and return
	jmp clear_cia1_interrupt_flag_and_return_from_interrupt

