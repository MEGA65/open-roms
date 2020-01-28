// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


// BASIC Cold start entry point
// Computes Mapping the 64 p211

basic_cold_start:

#if !ROM_LAYOUT_M65                    // can be safely skipped in Mega65 ROM layout

	// Before doing anything, check if we have a compatible BASIC/KERNAL pair

	ldy #(__rom_revision_basic_end - rom_revision_basic - 1)
!:
	lda rom_revision_basic, y
	cmp rom_revision_kernal, y
	beq !+

	panic #P_ERR_ROM_MISMATCH

!:
	dey
	bpl !--

#endif

	// Remaining part would not fit here

	jmp basic_cold_start_internal
