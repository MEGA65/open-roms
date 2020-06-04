// #LAYOUT# STD *        #TAKE
// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape head alignemnt tool - prints out a help message on screen
//


#if CONFIG_TAPE_HEAD_ALIGN


tape_head_align_print_help:

	// Make screen font visible

	lda CPU_R6510
	pha
	and #%11111011
	sta CPU_R6510

	// Print help message

	ldy #$00

	// Retrieve address
!:
	lda tape_head_align_help_text, y
	iny
	cmp #$FF
	beq tape_head_align_print_end
	sta EAL+0
 
	lda tape_head_align_help_text, y
	iny
	sta EAL+1
!:
	// Retrieve and print character

	lda tape_head_align_help_text, y
	iny
	cmp #$FF
	beq !--

	sty __ha_storage
	jsr tape_head_align_print_char
	ldy __ha_storage

	bne !-                             // branch alwats


tape_head_align_print_end:

	// Restore normal memory configuration and quit

	pla
	sta CPU_R6510
	rts

tape_head_align_print_string:



tape_head_align_print_char:

	// Calculate start address of character in .A

	sta SAL+0
	lda #$00
	sta SAL+1

	asl SAL+0
	rol SAL+1
	asl SAL+0
	rol SAL+1
	asl SAL+0
	rol SAL+1

	clc
	lda SAL+1
	adc #$D0
	sta SAL+1

	// Print out the character

	ldy #$07
!:
	lda (SAL), y
	sta (EAL), y
	dey
	bpl !-

	// Prepare EAL for the next character

	lda EAL+0
	clc
	adc #$08
	sta EAL+0
	bne !+
	inc EAL+1
!:
	rts


//
// Strings to print
//

.encoding "screencode_upper"


tape_head_align_help_text:

	// Each string consists of:
	// - destination (start byte) address
	// - text in screencodes
	/ - $FF to mark end

	.word $2000 + (40 * 8) * 0 + 8 * 1
	.text "COMPUTER HAS TO TELL THE SIGNALS APART"
	.byte $FF

	.word $2000 + (40 * 8) * 3 + 8 * 6
	.text "ALIGN HEAD FOR MINIMUM NOISE"
	.byte $FF

	.word $2000 + (40 * 8) * 6 + 8 * 2
	.text "IF THE DECK HAS A PITCH (TAPE SPEED)"
	.byte $FF

	.word $2000 + (40 * 8) * 7 + 8 * 1
	.text "CONTROL, TWEAK IT SO THAT DOTTED LINES"
	.byte $FF

	.word $2000 + (40 * 8) * 8 + 8 * 5
	.text "ARE HALF A WAY BETWEEN SIGNALS"
	.byte $FF

	.byte $FF                          // end of strings


#endif
