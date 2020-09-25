;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE


default_irq_handler:

!ifdef CONFIG_RS232_UP9600 {

	jsr rs232_count_channels
	cpx #$00
	beq @1
	jsr up9600_irq
@1:
}


!ifdef CONFIG_MB_M65 {

	jsr M65_MODEGET
	bcs @2

	jsr m65_cursor_blink

	bra default_irq_handler_common
@2:
	jsr cursor_blink

default_irq_handler_common:

	jsr JSCNKEY
	jsr JUDTIM ; update jiffy clock

} else {

	jsr cursor_blink
	jsr JSCNKEY
	jsr JUDTIM ; update jiffy clock
}


!ifdef HAS_TAPE {

	; Turn tape motor on/off depending on the button state
	; For CAS1 (tape motor interlock) variable description, see Mapping the C64, page 7

	lda CPU_R6510
	and #$10
	beq @3                             ; branch if tape button pressed

	jsr tape_motor_off
	lda #$00
	sta CAS1
	beq @4                             ; branch always
@3:
	lda CAS1
	bne @4
	jsr tape_motor_on
@4:
}


!ifdef CONFIG_PLATFORM_COMMODORE_64 {

	; Acknowledge CIA interrupt and return
	jmp clear_cia1_interrupt_flag_and_return_from_interrupt

 } else {

	jmp return_from_interrupt
}
