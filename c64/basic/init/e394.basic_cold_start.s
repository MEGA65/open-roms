#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_BASIC_0)


// BASIC Cold start entry point
// Computes Mapping the 64 p211

basic_cold_start:

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

	// Remaining part would not fit here

	jmp basic_cold_start_internal


#endif // ROM layout
