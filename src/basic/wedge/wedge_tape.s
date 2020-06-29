// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


#if CONFIG_TAPE_WEDGE


wedge_tape:

	// Prepare for execution

	jsr prepare_direct_execution
	jsr fetch_character

	// First character is a 'left arrow', we can ignore it - determine the command

	jsr fetch_character

	cmp #$4C                           // 'L'
	beq wedge_arrow_L
	cmp #$4D                           // 'M'
	beq wedge_arrow_M

#if CONFIG_TAPE_HEAD_ALIGN

	cmp #$48                           // 'H'
	beq wedge_arrow_H

#endif

	jmp do_SYNTAX_error

#if CONFIG_TAPE_HEAD_ALIGN

wedge_arrow_H:

	// Make sure the syntax is correct

	jsr injest_spaces
	jsr fetch_character

	cmp #$00
	bne_16 do_SYNTAX_error

	jsr tape_head_align

	jsr print_return
	jmp do_BREAK_error

#endif

wedge_arrow_L:

	jsr wedge_tape_prepare_load

	// Perform loading

	jmp cmd_load_got_params

wedge_arrow_M:

	jsr wedge_tape_prepare_load
	ldy #$00
	sty SA                             // for MERGE secondary address has to be 0!

	// Perform merging

	jmp cmd_merge_got_params


#endif // CONFIG_TAPE_WEDGE
