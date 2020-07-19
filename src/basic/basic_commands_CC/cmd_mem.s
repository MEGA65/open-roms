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

	// Print header

	lda #$12
	jsr JCHROUT
	ldx #IDX__STR_MEM_HDR
	jsr print_packed_misc_str

	// Print all the information, in a loop, in reverse order

	ldy #$04

	// FALLTROUGH

cmd_mem_loop:

	// First print the information string

	ldx helper_mem_tab_str, y
	phy_trash_a
	jsr print_packed_misc_str

	// Print start address

	ldx #IDX__STR_MEM_1
	jsr print_packed_misc_str	

#if HAS_OPCODES_65C02
	ply
	phy
#else
	pla
	pha
	tay
#endif
	ldx helper_mem_tab_y, y
	lda $01, x
	jsr print_hex_byte

#if HAS_OPCODES_65C02
	ply
	phy
#else
	pla
	pha
	tay
#endif
	ldx helper_mem_tab_y, y
	lda $00, x
	jsr print_hex_byte


	ldx #IDX__STR_MEM_2
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

	bcs !+
	lda #$3F
	jsr JCHROUT
	jmp_8 cmd_mem_next

!:
	jsr print_integer

	// FALLTROUGH

cmd_mem_next:

	// Check if more iterations needed

	ply_trash_a
	dey
	bpl cmd_mem_loop

	// Finish

	jmp print_return


#endif // ROM layout
