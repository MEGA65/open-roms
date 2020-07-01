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



shift_mem_up_internal:

	// Move memmove__size bytes from memmove__src to memmove__dst, where memmove__dst > memmove__src
	//
	// This means we have to copy from the back end down.
	// This routine assumes the pointers are already pointed to the end of the areas, and that .Y is correctly initialized

	// Unmap BASIC lower ROM

	php

	lda #$26
	sta CPU_R6510

	// Perform the copying
!:	
	lda (memmove__src),y
	sta (memmove__dst),y
	dey
	bne !-
	dec memmove__src+1
	dec memmove__dst+1
	dec memmove__size+1
	bne !-

#if HAS_OPCODES_65C02
	bra shift_mem_internal_finalize
#else
	jmp shift_mem_internal_finalize
#endif


shift_mem_down_internal:

	// Move memmove__size bytes from memmove__src to memmove__dst, where memmove__dst > memmove__src
	//
	// This means we have to copy from the back end down.
	// This routine assumes the pointers are already pointed to the end of the areas, and that .Y is correctly initialized

	// Unmap BASIC lower ROM

	php

	lda #$26
	sta CPU_R6510

	// Perform the copying
!:
	lda (memmove__src),y
	sta (memmove__dst),y
	iny
	bne !-
	inc memmove__src+1
	inc memmove__dst+1
	dec memmove__size+1
	bne !-

	// FALLTROUGH

shift_mem_internal_finalize:

	// Restore memory mapping and quit

	lda #$27
	sta CPU_R6510
	
	plp

	rts


#endif
