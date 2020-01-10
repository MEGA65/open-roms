#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)


hw_entry_nmi:

	sei // do not allow IRQ to interfere, see https://www.c64-wiki.com/wiki/Interrupt

#if CONFIG_CPU_MOS_6502 && CONFIG_BCD_SAFE_INTERRUPTS
	cld // clear decimal flag to allow using it without disabling interrupts
#endif

	// Call interrupt routine (only if initialised)
	pha
	lda NMINV
	ora NMINV+1
	beq !+
	pla
	jmp (NMINV)
!:
	// Vector not initialized - call default interrupt routine
	pla
	jmp default_nmi_handler


#endif // ROM layout
