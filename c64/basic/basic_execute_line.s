// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

// Jump back into the BASIC execute line loop
// after first checking that we have a colon
// or $00 char


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

	jsr end_of_statement_check
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
	lda command_jumptable+1,x
	pha
	lda command_jumptable+0,x
	pha

	// Now consume the character
	jsr consume_character
	
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
	jsr consume_character
	jmp basic_execute_statement



	
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
