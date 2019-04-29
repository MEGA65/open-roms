	;; Jump back into the BASIC execute line loop
	;; after first checking that we have a colon
	;; or $00 char

basic_run_next_statement:
	ldx #<basic_current_statement_ptr
	ldy #0
	jsr peek_under_roms

	cmp #$00
	beq +
	cmp #$3a
	beq +

	;; Nope, so SYNTAX ERROR it is!
	ldx #10
	jmp do_basic_error

*

	;; Go through the line until its end is reached.
	;; If we reach the end are in direct mode, then
	;; go back to reading input, else look for the
	;; next line, and advance to that, or else
	;; return to READY prompt because we have run out
	;; of program.
	
basic_execute_line:	

	;; Get next char of program text, even if it is hiding under a ROM or the
	;; IO area.
	ldx #<basic_current_statement_ptr
	ldy #0
	jsr peek_under_roms
	
	;; The checks should be done in order of frequency, so that we are as
	;; fast as possible.

	cmp #$7f
	bcc not_a_token
	;; It's a token: So get the jump table entry for it, push it on the stack
	;; and then RTS to start it.
	asl
	tax
	lda basic_command_jump_table+1,x
	pha
	lda basic_command_jump_table+0,x
	pha

	;; Now consume the character
	jsr basic_consume_character
	
	rts	

not_a_token:	
	;; Space, which we can also just ignore
	cmp #$20
	beq basic_skip_char
	;; End of line?
	cmp #$00
	beq basic_end_of_line
	;; :, i.e., statement separator, which we can simply ignore
	cmp #$3a
	beq basic_skip_char
	
	;; If all else fails, it's a syntax error
	ldx #10
	jmp do_basic_error

	jmp basic_main_loop

basic_skip_char:
	jsr basic_consume_character
	jmp basic_execute_line

basic_consume_character:
	;; Advance basic text pointer
	inc basic_current_statement_ptr+0
	bne +
	inc basic_current_statement_ptr+1
*
	rts
	
basic_end_of_line:

	;; XXX - If not in direct mode, then advance to next line, if there is
	;; one.
	
	jmp basic_main_loop

basic_command_jump_table:
	;; $80 - $8F
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
	.word cmd_return	-1
	.word cmd_rem-1

	;; $90-$9F
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

	;; $A0-$AF
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

	;; $B0-$BF
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

	;; $C0-$CF
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
	;; Undefined tokens
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1

	;; $D0-$DF
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

	;; $E0-$EF
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

	;; $F0-$FF
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
	
