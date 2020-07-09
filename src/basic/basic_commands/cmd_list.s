// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


// LIST basic text.
// XXX - Does not currently support line number ranges

cmd_list:

	// Set current line pointer to start of memory
	jsr init_oldtxt

list_loop:

	ldy #1

#if CONFIG_MEMORY_MODEL_60K
	ldx #<OLDTXT+0
	jsr peek_under_roms
	cmp #$00
#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	jsr peek_under_roms_via_OLDTXT
	cmp #$00
#else // CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
#endif

	bne list_more_lines

	// LIST terminates any running program,
	// because it has fiddled with the current line pointer.
	// (Confirmed by testing on a C64)
	jmp end_of_program

list_more_lines:

	lda STKEY
	bmi !+
	jmp cmd_stop
!:
	jsr list_single_line
	jsr follow_link_to_next_line
	jmp list_loop
