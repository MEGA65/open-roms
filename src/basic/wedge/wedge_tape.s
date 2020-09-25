;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


!ifdef CONFIG_TAPE_WEDGE {


wedge_tape:

	; Prepare for execution

	jsr prepare_direct_execution
	jsr fetch_character

	; First character is a 'left arrow', we can ignore it - determine the command

	jsr fetch_character

	cmp #$4C                           ; 'L'
	beq wedge_arrow_L
	cmp #$4D                           ; 'M'
	beq wedge_arrow_M

!ifdef CONFIG_TAPE_HEAD_ALIGN {

	cmp #$48                           ; 'H'
	beq wedge_arrow_H
}

	jmp do_SYNTAX_error

!ifdef CONFIG_TAPE_HEAD_ALIGN {

wedge_arrow_H:

	; Make sure the syntax is correct

	jsr fetch_character_skip_spaces

	cmp #$00
	+bne do_SYNTAX_error

	jsr tape_head_align

	jsr print_return
	jmp do_BREAK_error
}

wedge_arrow_L:

	jsr wedge_tape_prepare_load

	; Perform loading

	jmp cmd_load_got_params

wedge_arrow_M:

	jsr wedge_tape_prepare_load
	ldy #$00
	sty SA                             ; for MERGE secondary address has to be 0!

	; Perform merging

	jmp cmd_merge_got_params

} ; CONFIG_TAPE_WEDGE
