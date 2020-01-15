// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Disable UP9600 interface
//

// Based on UP9600 code by Daniel Dallman with Bo Zimmerman adaptations


#if CONFIG_RS232_UP9600


up9600_disable: // XXX adapt

	// XXX restore interrupt vectors and IRQ timer 

	sei
	lda CIA2_PRB // $DD01; DISABLE RTS
	and #$FD
	sta CIA2_PRB // $DD01
	lda #$7F
	sta CIA2_ICR // $DD0D ; DISABLE ALL CIA INTERRUPTS
	sta CIA1_ICR // $DC0D 
	lda #$41; QUICK (AND DIRTY) HACK TO SWITCH BACK
	sta CIA1_TIMAHI // $DC05 ; TO THE DEFAULT CIA1 CONFIGURATION
	lda #$81
	sta CIA1_ICR // $DC0D ; ENABLE TIMER1 (THIS IS DEFAULT)
	lda #<ORIGIRQ; RESTORE OLD IRQ-HANDLER
	sta IRQVECT
	lda #>ORIGIRQ
	sta IRQVECT+1
	lda #<ORIGNMI; RESTORE OLD NMI-HANDLER
	sta NMIVECT
	lda #>ORIGNMI
	sta NMIVECT+1
	cli
	pla
	tay
	pla
	tax
	pla


#endif // CONFIG_RS232_UP9600
