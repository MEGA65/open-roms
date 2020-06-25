// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

// XXX This can be any address - but definitely $E000 or above
// XXX TODO: extend build_segment tool to allow to specify placement range


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



shift_mem_up:

	// Move __memmove_size bytes from __memmove_src to __memmove_dst,
	// where __memmove_dst > __memmove_src
	// This means we have to copy from the back end down.
	// This routine assumes the pointers are already pointed
	// to the end of the areas, and that Y is correctly initialised
	// to allow the copy to begin.

	// Unmap BASIC lower ROM

	php

	lda #$26
	sta CPU_R6510

	// Perform the copying
!:	
	lda (__memmove_src),y
	sta (__memmove_dst),y
	dey
	bne !-
	dec __memmove_src+1
	dec __memmove_dst+1
	dec __memmove_size+1
	bne !-

#if HAS_OPCODES_65C02
	bra shift_mem_finalize
#else
	jmp shift_mem_finalize
#endif


shift_mem_down:

	// Move __memmove_size bytes from __memmove_src to __memmove_dst,
	// where __memmove_dst > __memmove_src
	// This means we have to copy from the back end down.
	// This routine assumes the pointers are already pointed
	// to the end of the areas, and that Y is correctly initialised
	// to allow the copy to begin.

	// Unmap BASIC lower ROM

	php

	lda #$26
	sta CPU_R6510

	// Perform the copying
!:
	lda (__memmove_src),y
	sta (__memmove_dst),y
	iny
	bne !-
	inc __memmove_src+1
	inc __memmove_dst+1
	dec __memmove_size+1
	bne !-
	// FALLTROUGH

shift_mem_finalize:

	// Restore memory mapping and quit

	lda #$27
	sta CPU_R6510
	
	plp

	rts


#endif
