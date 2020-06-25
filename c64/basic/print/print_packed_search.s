// #LAYOUT# STD *       #TAKE
// #LAYOUT# M65 BASIC_1 #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


print_packed_search:

	// First store the initial address of the packed strings list

	sta FRESPC+0
	sty FRESPC+1

	// Now find the address of the string to print out
	// The implementation assumes no packed string is longer than 255 bytes, including trailing zero
!:
	cpx #$00
	beq print_packed_done              // branch if no need to advance anymore
	dex

	ldy #$00
!:
	lda (FRESPC), y
	iny
	cmp #$00
	bne !-                             // branch if not the end of packed string

	clc                                // advance FREESPC pointer
	tya
	adc FRESPC+0
	sta FRESPC+0
	lda #$00
	adc FRESPC+1
	sta FRESPC+1

	jmp !--

print_packed_done:

	rts