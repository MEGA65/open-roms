// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE


default_irq_handler:

#if CONFIG_RS232_UP9600

	jsr rs232_count_channels
	cpx #$00
	beq !+
	jsr up9600_irq
!:

#endif // CONFIG_RS232_UP9600


	jsr cursor_blink
	jsr JSCNKEY
	jsr JUDTIM // update jiffy clock


#if CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO

	// Turn tape motor on/off depending on the button state
	// For CAS1 (tape motor interlock) variable description, see Mapping the C64, page 7

	lda CPU_R6510
	and #$10
	beq !+                             // branch if tape button pressed

	jsr tape_motor_off
	lda #$00
	sta CAS1
	beq default_irq_handler_end_tape   // branch always
!:
	lda CAS1
	bne default_irq_handler_end_tape
	jsr tape_motor_on

default_irq_handler_end_tape:

#endif // CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO


	// Acknowledge CIA interrupt and return
	jmp clear_cia1_interrupt_flag_and_return_from_interrupt
