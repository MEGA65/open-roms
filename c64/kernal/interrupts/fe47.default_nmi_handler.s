
default_nmi_handler:

	// Implemented according to Compute's Mapping the Commodore 64, page 74
	// and to https://www.c64-wiki.com/wiki/Interrupt

	// Save registers, sequence according to Compute's Mapping the Commodore 64, page 73
	pha
#if CONFIG_CPU_MOS_6502
	txa
	pha
	tya
	pha
#else
	phx
	phy
#endif

	// XXX: RS-232 support is not implemented

	// XXX confirm NMIs from CIA, or no other NMI will arrive!

	jsr cartridge_check
	bne !+
	jmp (ICART_WARM_START)
!:

	// According to C64 Wiki, if STOP key is pressed, the routine assumes warm start request

	jsr JSTOP
	bcs !+
	jmp return_from_interrupt // no STOP pressed
!:
	// STOP + RESTORE - clean the address of the BRK instruction (it's not BRK) first
	lda #$00
	sta CMP0+0
	sta CMP0+1
	jmp (CBINV)
