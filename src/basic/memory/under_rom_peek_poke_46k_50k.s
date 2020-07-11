// #LAYOUT# STD *       #TAKE-HIGH
// #LAYOUT# *   BASIC_0 #TAKE-HIGH
// #LAYOUT# *   *       #IGNORE

// This has to go $E000 or above - as the routines below bank out the main BASIC ROM!


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

	lda (OLDTXT), y

#if HAS_OPCODES_65C02
	bra peek_under_roms_finalize
#else
	jmp peek_under_roms_finalize
#endif

peek_under_roms_via_VARPNT:

	// Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	// Retrieve value from under ROMs

	lda (VARPNT), y

#if HAS_OPCODES_65C02
	bra peek_under_roms_finalize
#else
	jmp peek_under_roms_finalize
#endif

peek_under_roms_via_DSCPNT:

	// Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	// Retrieve value from under ROMs

	lda (DSCPNT), y

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
