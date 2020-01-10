#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// RS-232 IRQ handler part
//

// Based on UP9600 code by Daniel Dallman with Bo Zimmerman adaptations


#if CONFIG_RS232_UP9600


up9600_irq:

	lda CIA1_ICR // $DC0D

	lsr
	lsr                                // move bit 1 (timer B flag) into Carry
	and #$02                           // test SDR (shift register) status

	beq up9600_irq_continue

	ldx RINONE
	beq !+                             // skip if not waiting for empty SDR
	dex
	stx RINONE
!:
	bcc up9600_irq_end

up9600_irq_continue:

	rts

up9600_irq_end:

	pla
	pla
	jmp return_from_interrupt


#endif // CONFIG_RS232_UP9600


#endif // ROM layout
