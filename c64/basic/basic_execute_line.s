// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

// Jump back into the BASIC execute line loop
// after first checking that we have a colon
// or $00 char

basic_end_of_statement_check:
	ldy #0

#if CONFIG_MEMORY_MODEL_60K
	ldx #<TXTPTR
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (TXTPTR),y
#endif

	// Consume any spaces
	cmp #$20
	bne no_space_to_skip
	jsr basic_consume_character
	jmp basic_end_of_statement_check

no_space_to_skip:
	cmp #$00
	beq !+
	cmp #$3a
	beq !+

	// not end of statement
	clc
	rts
!:
	sec
	rts

basic_execute_statement:

	// Check for RUN/STOP
	lda STKEY
	bmi !+
	jmp cmd_stop
!:
	// Skip over any white space and :
	ldy #0

#if CONFIG_MEMORY_MODEL_60K
	ldx #<TXTPTR
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (TXTPTR),y
#endif

	jsr basic_end_of_statement_check
	bcs basic_end_of_line
	
	// jsr printf
	// .text "LINE PTR = $"
	// .byte $f1,<OLDTXT,>OLDTXT
	// .byte $f0,<OLDTXT,>OLDTXT
	// .text ", STATEMENT PTR = $"
	// .byte $f1,<TXTPTR,>TXTPTR
	// .byte $f0,<TXTPTR,>TXTPTR
	// .byte $d,0
		
	// Go through the line until its end is reached.
	// If we reach the end are in direct mode, then
	// go back to reading input, else look for the
	// next line, and advance to that, or else
	// return to READY prompt because we have run out
	// of program.
	
	// Get next char of program text, even if it is hiding under a ROM or the
	// IO area.

	ldy #0

#if CONFIG_MEMORY_MODEL_60K
	ldx #<TXTPTR
	jsr peek_under_roms
	cmp #$00
#else // CONFIG_MEMORY_MODEL_38K
	lda (TXTPTR),y
#endif

	beq basic_end_of_line
	
	// The checks should be done in order of frequency, so that we are as
	// fast as possible.

	cmp #$7f
	bcc not_a_token
	// It is a token: So get the jump table entry for it, push it on the stack
	// and then RTS to start it.
	asl
	tax
	lda basic_command_jump_table+1,x
	pha
	lda basic_command_jump_table+0,x
	pha

	// Now consume the character
	jsr basic_consume_character
	
	rts

not_a_token:
	// Space, which we can also just ignore
	cmp #$20
	beq basic_skip_char
	// End of line?
	cmp #$00
	beq basic_end_of_line
	// :, i.e., statement separator, which we can simply ignore
	cmp #$3a
	beq basic_skip_char
	
	// If all else fails, it is a syntax error
	jmp do_SYNTAX_error

basic_skip_char:
	jsr basic_consume_character
	jmp basic_execute_statement

basic_fetch_and_consume_character:
	ldy #0

#if CONFIG_MEMORY_MODEL_60K
	ldx #<TXTPTR
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (TXTPTR),y
#endif

	// FALL THROUGH
	
basic_consume_character:
	// Advance basic text pointer
	inc TXTPTR+0
	bne !+
	inc TXTPTR+1
!:
	rts

basic_unconsume_character:
	lda TXTPTR+0
	sec
	sbc #1
	sta TXTPTR+0
	lda TXTPTR+1
	sbc #0
	sta TXTPTR+1
	rts
	
basic_end_of_line:

	// XXX - If not in direct mode, then advance to next line, if there is
	// one.

	// Are we in direct mode
	lda CURLIN+1
	cmp #$ff
	bne basic_not_direct_mode

	// Yes, we were in direct mode, so stop now
	jmp basic_main_loop

basic_not_direct_mode:
	// Copy line number to previous line number
	lda CURLIN+0
	sta OLDLIN+0
	lda CURLIN+1
	sta OLDLIN+1
	
	// Advance the basic line pointer to the next line
	jsr basic_follow_link_to_next_line

	// Are we at the end of the program?
	lda OLDTXT+0
	ora OLDTXT+1
	bne basic_execute_from_current_line

	// End of program found
	jmp basic_main_loop
	
basic_execute_from_current_line:
	// Check if pointer is null, if so, we are at the end of
	// the program.
	ldy #0
	jsr peek_line_pointer_null_check
	bcs !+
	// End of program reached
	jmp basic_main_loop
!:
	// Skip pointer and line number to get address of first statement
	lda OLDTXT+0
	clc
	adc #4
	sta TXTPTR+0
	lda OLDTXT+1
	adc #0
	sta TXTPTR+1

	ldy #2

#if CONFIG_MEMORY_MODEL_60K
	ldx #<OLDTXT
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
#endif

	sta CURLIN+0
	iny

#if CONFIG_MEMORY_MODEL_60K
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
#endif

	sta CURLIN+1

	jmp basic_execute_statement
	
basic_command_jump_table:
	// $80 - $8F
	.word cmd_end-1
	.word cmd_for-1
	.word cmd_next-1
	.word cmd_data-1
	.word cmd_inputhash-1
	.word cmd_input-1
	.word cmd_dim-1
	.word cmd_read-1
	.word cmd_let-1
	.word cmd_goto-1
	.word cmd_run-1
	.word cmd_if-1
	.word cmd_restore-1
	.word cmd_gosub-1
	.word cmd_return-1
	.word cmd_rem-1

	// $90-$9F
	.word cmd_stop-1
	.word cmd_on-1
	.word cmd_wait-1
	.word cmd_load-1
	.word cmd_save-1
	.word cmd_verify-1
	.word cmd_def-1
	.word cmd_poke-1
	.word cmd_printhash-1
	.word cmd_print-1
	.word cmd_cont-1
	.word cmd_list-1
	.word cmd_clr-1
	.word cmd_cmd-1
	.word cmd_sys-1
	.word cmd_open-1

	// $A0-$AF
	.word cmd_close-1
	.word cmd_get-1
	.word cmd_new-1
	.word cmd_tab-1
	.word cmd_to-1
	.word cmd_fn-1
	.word cmd_spc-1
	.word cmd_then-1
	.word cmd_not-1
	.word cmd_step-1
	.word cmd_plus-1
	.word cmd_minus-1
	.word cmd_mult-1
	.word cmd_div-1
	.word cmd_exponent-1
	.word cmd_and-1

	// $B0-$BF
	.word cmd_or-1
	.word cmd_greater-1
	.word cmd_equal-1
	.word cmd_less-1
	.word cmd_sgn-1
	.word cmd_int-1
	.word cmd_abs-1
	.word cmd_usr-1
	.word cmd_fre-1
	.word cmd_pos-1
	.word cmd_sqr-1
	.word cmd_rnd-1
	.word cmd_log-1
	.word cmd_exp-1
	.word cmd_cos-1
	.word cmd_sin-1

	// $C0-$CF
	.word cmd_tan-1
	.word cmd_atn-1
	.word cmd_peek-1
	.word cmd_len-1
	.word cmd_str-1
	.word cmd_val-1
	.word cmd_asc-1
	.word cmd_chr-1
	.word cmd_left-1
	.word cmd_right-1
	.word cmd_mid-1
	.word cmd_go-1 	
	// Undefined tokens
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1

	// $D0-$DF
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1

	// $E0-$EF
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1

	// $F0-$FF
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
