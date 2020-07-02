// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE


#if CONFIG_MEMORY_MODEL_46K ||CONFIG_MEMORY_MODEL_50K


peek_under_roms_via_MEMUSS:

	// Store current memory mapping, unmap BASIC ROM

	lda CPU_R6510
	pha
	and #$FE
	sta CPU_R6510 

	// Retrieve value from under ROMs

	lda (MEMUSS), y

	// FALLTROUGH

peek_under_roms_finalize:

	// Store value in a safe place

	tax

	// Restore memory mapping

	pla
	sta CPU_R6510

	// Retrieve value and quit

	txa
	rts


peek_under_roms_via_FNADDR:

	// Store current memory mapping, unmap BASIC ROM

	lda CPU_R6510
	pha
	and #$FE
	sta CPU_R6510 

	// Retrieve value from under ROMs

	lda (FNADDR), y

	// Continue using common code

#if HAS_OPCODES_65C02
	bra peek_under_roms_finalize
#else
	jmp peek_under_roms_finalize
#endif


peek_under_roms_via_EAL:

	// Store current memory mapping, unmap BASIC ROM

	lda CPU_R6510
	pha
	and #$FE
	sta CPU_R6510 

	// Retrieve value from under ROMs

	lda (EAL), y

	// Continue using common code

#if HAS_OPCODES_65C02
	bra peek_under_roms_finalize
#else
	jmp peek_under_roms_finalize
#endif


#endif
