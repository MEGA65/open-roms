// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

// XXX extend build_segment tool to allow to specify placement range


#if CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K


peek_under_roms_via_TXTPTR:

	// Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	// Retrieve value from under ROMs

	lda (TXTPTR), y

	// FALLTROUGH

peek_under_roms_finalize:

	// Restore memory mapping

	pha
	lda #$27
	sta CPU_R6510
	pla

	// Quit

	rts

peek_under_roms_via_OLDTXT:

	// Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	// Retrieve value from under ROMs

	lda (TXTPTR), y

#if HAS_OPCODES_65C02
	bra peek_under_roms_finalize
#else
	jmp peek_under_roms_finalize
#endif

peek_under_roms_via_FAC1_PLUS_1:

	// Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	// Retrieve value from under ROMs

	lda (__FAC1 + 1), y

#if HAS_OPCODES_65C02
	bra peek_under_roms_finalize
#else
	jmp peek_under_roms_finalize
#endif


#endif
