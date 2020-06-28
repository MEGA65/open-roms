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
#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	jsr peek_under_roms_via_OLDTXT
#else // CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
#endif

	pha
	dey

#if ROM_LAYOUT_M65
	jsr peek_via_OLDTXT
#elif CONFIG_MEMORY_MODEL_60K
	jsr peek_under_roms
#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	jsr peek_under_roms_via_OLDTXT
#else // CONFIG_MEMORY_MODEL_38K
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
#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	jsr peek_under_roms_via_OLDTXT
	cmp #$00
#else // CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
#endif

	bne !+
	rts                                          // end of line
!:
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
#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	jsr peek_under_roms_via_OLDTXT
	cmp #$00
#else // CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
#endif

	// Save registers
	tax
	pha
	phy_trash_a

	// Subtract $1 from token to get offset in token list
	dex

	// Check if token is known
	cpx #TK__MAXTOKEN_keywords_CC
	bcs list_display_unknown_token               // XXX consider displaying two question marks here

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
#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	jsr peek_under_roms_via_OLDTXT
	cmp #$00
#else // CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
#endif
	
	// Save registers
	tax
	pha
	phy_trash_a

	// Subtract $1 from token to get offset in token list
	dex

	// Check if token is known
	cpx #TK__MAXTOKEN_keywords_CD
	bcs list_display_unknown_token               // XXX consider displaying two question marks here

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
	and #$7F
	tax

	// Check if token is known
	cpx #TK__MAXTOKEN_keywords_V2
	bcs list_display_unknown_token

	// Now ask for it to be printed
	jsr print_packed_keyword_V2

	// FALLTROUGH

list_token_displayed:

	// Restore registers
	ply_trash_a
	pla

	cmp #$8F
	bne list_not_rem
	// REM command locks quote flag on until the end of the line, allowing
	// funny characters in REM statements without problem.
	sta QTSW    // Any value other than $00 or $FF will lock quote mode on, so the token value of REM is fine here
	
	// FALLTHROUGH

list_not_rem:		
	
	iny
	bne list_print_loop // branch always

list_is_pi:
	lda #$7E

	// FALLTROUGH

list_is_literal:

	pha
	and #$7F
	cmp #$12
	beq list_is_literal_known                    // branch if quote mode on/off
	and #%01100000
	bne list_is_literal_known
	pla

	// FALLTROUGH

list_is_unknown:

	phy_trash_a
	lda #<str_rev_question
	ldy #>str_rev_question
	jsr STROUT
	ply_trash_a

#if HAS_OPCODES_65C02
	bra !+
#else
	jmp !+
#endif

list_is_literal_known:

	pla
	jsr JCHROUT
!:
	iny
	bne_16 list_print_loop
	
	rts                                          // end of line

list_display_unknown_token:

	pla
	pla

#if HAS_OPCODES_65C02
	bra list_is_unknown
#else
	jmp list_is_unknown
#endif

#endif // ROM layout
