// LIST basic text.
// XXX - Doesn't currently support line number ranges

cmd_list:

	// Set current line pointer to start of memory
	jsr init_oldtxt

list_loop:

	ldy #1

#if CONFIG_MEMORY_MODEL_60K
	ldx #<OLDTXT+0
	jsr peek_under_roms
	cmp #$00
#else // CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
#endif

	bne list_more_lines

	// LIST terminates any running program,
	// because it has fiddled with the current line pointer.
	// (Confirmed by testing on a C64)
	jmp basic_main_loop

list_more_lines:
	lda STKEY
	bmi !+
	jmp cmd_stop
!:
	jsr list_single_line
	// Now link to the next line
	jsr basic_find_next_line
	jmp list_loop

list_single_line: // entry point needed by DOS wedge
	// Print line number
	ldy #3

#if CONFIG_MEMORY_MODEL_60K
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
#endif

	pha
	dey

#if CONFIG_MEMORY_MODEL_60K
	jsr peek_under_roms
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

#if CONFIG_MEMORY_MODEL_60K
	ldx #<OLDTXT
	jsr peek_under_roms
	cmp #$00
#else // CONFIG_MEMORY_MODEL_38K
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

	// Save registers
	tax
	pha
	phy_trash_a

	// Get pointer to compressed keyword list
	lda #<packed_keywords
	sta FRESPC+0
	lda #>packed_keywords
	sta FRESPC+1
	
	// Subtract $80 from token to get offset in word
	// list
	txa
	and #$7f
	tax

	// Now ask for it to be printed
	ldy #$ff
	jsr packed_word_search

	ply_trash_a
	pla

	cmp #$8f
	bne list_not_rem
	// REM command locks quote flag on until the end of the line, allowing
	// funny characters in REM statements without problem.
	inc $0427
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
	// Print end of line
	jmp print_return


