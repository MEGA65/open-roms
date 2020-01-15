// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

// Works similar to $BDCD in original C64 BASIC
// XXX Should eventually get replaced by a more flexible and optimal routine.
// Temp result gets written to $0100-$0104

print_integer:

	pha
	phx_trash_a

	// Clear temporary output
	lda #$00
	ldy #5
!:	sta $0100,y
	dey
	bpl !-
	
	pla
	ldy #23 		// 8 x 3 - 1 = offset of last digit of 128
lo_loop:	
	cmp #$7f
	bcc bit_clear

	// Bit set, so add the digits
	pha
	ldx #2
	clc
lo_add_loop:	
	lda $0102,x
	adc number_table_lo,y
	sta $0102,x

	dey
	dex
	bpl lo_add_loop
	pla
	jmp next_lo_bit	
	
bit_clear:
	dey
	dey
	dey
next_lo_bit:
	asl
	cpy #$7f
	bcc lo_loop	


	// Now do the same for upper byte
	pla
	
	ldy #39 		// 8 x 5 - 1 = offset of last digit of 32768
hi_loop:	
	cmp #$7f
	bcc bit_clear_hi

	
	// Bit set, so add the digits
	pha
	ldx #4
	clc
hi_add_loop:
	lda $0100,x
	adc number_table_hi,y
	sta $0100,x

	dey
	dex
	bpl hi_add_loop
	pla
	jmp next_hi_bit

bit_clear_hi:
	dey
	dey
	dey
	dey
	dey
next_hi_bit:
	asl
	cpy #$7f
	bcc hi_loop

fix_carry:

	// Deal with any carries
	ldx #3
carry_fix_loop:
	lda $0101,x
	cmp #10
	bcc !+
	inc $0100,x
	sec
	sbc #10
	sta $0101,x

	jmp carry_fix_loop	

!:	dex	
	bpl carry_fix_loop

post_carry:

	// Got digits.
	// Skip leading zeros, and print the resulting number

	// Skip leading zeros
	ldy #0
!:	lda $0100,y
	bne found_start_of_number
	iny
	cpy #4
	bne !-

found_start_of_number:
	// Print digits
!:	lda $0100,y
	ora #$30
	jsr JCHROUT
	iny
	cpy #5
	bne !-
	
	
	rts


number_table_lo:
	.byte 0,0,1
	.byte 0,0,2
	.byte 0,0,4
	.byte 0,0,8
	.byte 0,1,6
	.byte 0,3,2
	.byte 0,6,4
	.byte 1,2,8
number_table_hi:
	.byte 0,0,2,5,6
	.byte 0,0,5,1,2
	.byte 0,1,0,2,4
	.byte 0,2,0,4,8
	.byte 0,4,0,9,6
	.byte 0,8,1,9,2
	.byte 1,6,3,8,4
	.byte 3,2,7,6,8
