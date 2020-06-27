// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE


hw_entry_irq:

	// The IRQ is a commonly messed with thing on the C64,
	// so we need to handle entry points that are commonly
	// relied upon, including:
	// $EA31 - Standard IRQ routine
	// $EA61 - Check keyboard, but do not update timer? https://github.com/cc65/cc65/issues/324
	// $EA81 - https://www.lemon64.com/forum/viewtopic.php?t=2112&sid=6ea01982b26da69783120a7923ca46fb
	// Also the $0314 vector is widely used (e.g., https://www.lemon64.com/forum/viewtopic.php?t=2112&sid=6ea01982b26da69783120a7923ca46fb)

	// Save registers, sequence according to Computes Mapping the Commodore 64, page 73
	pha
	phx_trash_a
	phy_trash_a

#if CONFIG_CPU_MOS_6502 && CONFIG_BCD_SAFE_INTERRUPTS
	cld // clear decimal flag to allow using it without disabling interrupts
#endif

	// Check if caused by BRK
	tsx
	lda $0104, x // get the pre-interrupt processor state
	and #$10
	bne irq_handler_brk

	// Not caused by BRK - call interrupt routine (only if initialised)
	lda CINV
	ora CINV+1
	beq !+
	jmp (CINV)
!:
	// Vector not initialized - call default interrupt routine
	jmp default_irq_handler

irq_handler_brk:

	// Store BRK adddress, to be displayed
	sec
	lda $0105, x
	sbc #$02
	sta CMP0+0
	lda $0106, x
	sbc #$00
	sta CMP0+1

	// Interrupt caused by BRK
	jmp (CBINV)
