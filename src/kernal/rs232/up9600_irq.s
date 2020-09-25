;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; RS-232 IRQ handler part
;

; Based on UP9600 code by Daniel Dallman with Bo Zimmerman adaptations


!ifdef CONFIG_RS232_UP9600 {


up9600_irq:

	lda CIA1_ICR ; $DC0D

	lsr
	lsr                                ; move bit 1 (timer B flag) into Carry
	and #$02                           ; test SDR (shift register) status

	beq up9600_irq_continue

	ldx RINONE
	beq @1                             ; skip if not waiting for empty SDR
	dex
	stx RINONE
@1:
	bcc up9600_irq_end

up9600_irq_continue:

	rts

up9600_irq_end:

	pla
	pla
	jmp return_from_interrupt
}
