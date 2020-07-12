// #LAYOUT# STD *       #TAKE
// #LAYOUT# M65 *       #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE



#if (!ROM_LAYOUT_M65 || SEGMENT_BASIC_0)

cmd_mem:

	// First perform the garbage collection - to be able to determine real values

	jsr varstr_garbage_collect

#endif // ROM layout

#if (ROM_LAYOUT_M65 && SEGMENT_BASIC_0)

	jsr     map_BASIC_1
	jsr_ind VB1__cmd_mem_cont
	jmp     map_NORMAL

#else

#if (ROM_LAYOUT_M65 && SEGMENT_BASIC_1)

cmd_mem_cont:

#endif

	// Print all the information, in a loop, in reverse order

	ldy #$04
!:
	// First print the information string

	ldx helper_mem_tab_str, y
	phy_trash_a
	jsr print_packed_misc_str

	// Fetch addresses of zeropage variables

#if HAS_OPCODES_65C02
	ply
	phy
#else
	pla
	pha
	tay
#endif

	ldx helper_mem_tab_x, y
	lda helper_mem_tab_y, y
	tay

	// Print difference between two zeropage variables

    sec
	lda $00, x
	sbc $0000, y
	pha
	inx
	iny
	lda $00, x
	sbc $0000, y

#if HAS_OPCODES_65C02
	plx
#else
	tay
	pla
	tax
	tya
#endif

	// Before printing, make sure the result is not negative

	bcc cmd_mem_error
	jsr print_integer

	// Check if more iterations needed

	ply_trash_a
	dey
	bpl !-

	// Finish

	jmp print_return


cmd_mem_error:

	jsr print_return
	jmp do_MEMORY_CORRUPT_error

#endif // ROM layout
