default_irq_handler:	

	jsr blink_cursor
	jsr scan_keyboard

	;; Acknowledge CIA interrupt and return
	jmp clear_cia1_interrupt_flag_and_return_from_interrupt:
