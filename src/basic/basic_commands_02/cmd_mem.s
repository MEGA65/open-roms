;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# M65 *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


!ifndef HAS_SMALL_BASIC {

!ifdef SEGMENT_M65_BASIC_0 {

cmd_mem:

	; First perform the garbage collection - to be able to determine real values

	jsr varstr_garbage_collect


	jsr map_BASIC_1
	jsr (VB1__cmd_mem_cont)
	jmp map_NORMAL

} else ifdef SEGMENT_M65_BASIC_1 {

cmd_mem_cont:

} else {

cmd_mem:

	; First perform the garbage collection - to be able to determine real values

	jsr varstr_garbage_collect
}

!ifndef SEGMENT_M65_BASIC_0 {

	; Print header

	lda #$12
	jsr JCHROUT
	ldx #IDX__STR_MEM_HDR
	jsr print_packed_misc_str

	; Print all the information, in a loop, in reverse order

	ldy #$04

	; FALLTROUGH

cmd_mem_loop:

	; First print the information string

	ldx helper_mem_tab_str, y
	+phy_trash_a
	jsr print_packed_misc_str

	; Print start address

	ldx #IDX__STR_MEM_1
	jsr print_packed_misc_str	

!ifdef HAS_OPCODES_65C02 {
	ply
	phy
} else {
	pla
	pha
	tay
}
	ldx helper_mem_tab_y, y
	lda $01, x
	jsr print_hex_byte

!ifdef HAS_OPCODES_65C02 {
	ply
	phy
} else {
	pla
	pha
	tay
}
	ldx helper_mem_tab_y, y
	lda $00, x
	jsr print_hex_byte


	ldx #IDX__STR_MEM_2
	jsr print_packed_misc_str

	; Fetch addresses of zeropage variables

!ifdef HAS_OPCODES_65C02 {
	ply
	phy
} else {
	pla
	pha
	tay
}

	ldx helper_mem_tab_x, y
	lda helper_mem_tab_y, y
	tay

	; Print difference between two zeropage variables

    sec
	lda $00, x
	sbc $0000, y
	pha
	inx
	iny
	lda $00, x
	sbc $0000, y

!ifdef HAS_OPCODES_65C02 {
	plx
} else {
	tay
	pla
	tax
	tya
}

	; Before printing, make sure the result is not negative

	bcs @1
	lda #$3F
	jsr JCHROUT
	+bra cmd_mem_next

@1:
	jsr print_integer

	; FALLTROUGH

cmd_mem_next:

	; Check if more iterations needed

	+ply_trash_a
	dey
	bpl cmd_mem_loop

	; Finish

	jmp print_return


} ; ROM layout

} ; !HAS_SMALL_BASIC
