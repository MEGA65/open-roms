// #LAYOUT# STD *       #TAKE
// #LAYOUT# M65 *       #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

list_single_line:

#if (ROM_LAYOUT_M65 && SEGMENT_BASIC_0)

	jsr     map_BASIC_1
	jsr_ind VB1__list_single_line
	jmp     map_NORMAL

#else

	// Print line number - in a new line
	jsr print_return
	ldy #3

#if ROM_LAYOUT_M65
	jsr peek_via_OLDTXT
#elif CONFIG_MEMORY_MODEL_60K
	jsr peek_under_roms
#else
	lda (OLDTXT),y
#endif

	pha
	dey

#if ROM_LAYOUT_M65
	jsr peek_via_OLDTXT
#elif CONFIG_MEMORY_MODEL_60K
	jsr peek_under_roms
#else
	lda (OLDTXT),y
#endif

	tax
	pla
	jsr print_integer
	jsr print_space

	// Iterate through printing out the line
	// contents
	lda #0
	sta QTSW
	
	ldy #4

list_print_loop:

#if ROM_LAYOUT_M65
	jsr peek_via_OLDTXT
#elif CONFIG_MEMORY_MODEL_60K
	ldx #<OLDTXT
	jsr peek_under_roms
	cmp #$00
#else
	lda (OLDTXT),y
#endif

	beq list_end_of_line
	cmp #$22
	bne list_not_quote
	lda QTSW
	eor #$FF
	sta QTSW
	lda #$22
	jmp list_is_literal

list_not_quote:	
	// Check quote mode, and display as literal if required
	ldx QTSW
	bne list_is_literal
	
	cmp #$FF
	beq list_is_pi

	cmp #$7F
	bcc list_is_literal

	// Display a token

list_display_token_CC:

	cmp #$CC
	bne list_display_token_CD

	// Fetch the sub-token

	iny
#if ROM_LAYOUT_M65
	jsr peek_via_OLDTXT
#elif CONFIG_MEMORY_MODEL_60K
	ldx #<OLDTXT
	jsr peek_under_roms
	cmp #$00
#else
	lda (OLDTXT),y
#endif

	// Save registers
	tax
	pha
	phy_trash_a

	// Subtract $1 from token to get offset in token list
	dex

	// Now ask for it to be printed
	jsr print_packed_keyword_CC

#if HAS_OPCODES_65C02
	bra list_token_displayed
#else
	jmp list_token_displayed
#endif

list_display_token_CD:

	cmp #$CD
	bne list_display_token_V2
	
	// Fetch the sub-token

	iny
#if ROM_LAYOUT_M65
	jsr peek_via_OLDTXT
#elif CONFIG_MEMORY_MODEL_60K
	ldx #<OLDTXT
	jsr peek_under_roms
	cmp #$00
#else
	lda (OLDTXT),y
#endif
	
	// Save registers
	tax
	pha
	phy_trash_a

	// Subtract $1 from token to get offset in token list
	dex

	// Now ask for it to be printed
	jsr print_packed_keyword_CD

#if HAS_OPCODES_65C02
	bra list_token_displayed
#else
	jmp list_token_displayed
#endif

list_display_token_V2:

	// Save registers
	tax
	pha
	phy_trash_a

	// Subtract $80 from token to get offset in token list
	txa
	and #$7f
	tax

	// Now ask for it to be printed
	jsr print_packed_keyword_V2

	// FALLTROUGH

list_token_displayed:

	// Restore registers
	ply_trash_a
	pla

	cmp #$8f
	bne list_not_rem
	// REM command locks quote flag on until the end of the line, allowing
	// funny characters in REM statements without problem.
	sta QTSW    // Any value other than $00 or $FF will lock quote mode on, so the token value of REM is fine here
	// FALL THROUGH
list_not_rem:		
	
	iny
	bne list_print_loop // branch always

list_is_pi:
	lda #$7E

	// FALLTROUGH

list_is_literal:
	jsr JCHROUT
	iny
	bne list_print_loop
	
list_end_of_line:
	
	rts


#endif // ROM layout
