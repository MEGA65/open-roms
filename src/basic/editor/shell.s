// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


shell_main_loop:

	// Tell user we are ready
	ldx #IDX__STR_READY
	jsr print_packed_misc_str

	// Enable Kernal messages
	lda #$80
	jsr JSETMSG

shell_read_next_line:

	// Read a line of input
	ldx #$00
!:
	jsr JCHRIN
	bcs !-
	
	// Check for RETURN key
	cmp #$0D
	beq shell_got_line

	// Not carriage return, so try to append to line so far
	cpx #80
	bcs_16 do_STRING_TOO_LONG_error              // see Computes Mapping the 64 p93

	sta BUF,x
	inx
	jmp !-

shell_got_line:

	// Store length of input buffer ready for tokenising
	stx __tokenise_work1

	// Store 0 as the sentinel
	lda #$00
	sta BUF, x

	// FALLTROUGH

shell_strip_leading_spaces:

	// Strip leading spaces from the line
	lda BUF
	cmp #$20
	bne shell_process_line                       // branch if no more leading spaces

	// We have a leading space - strip it away
	ldx #$01
!:
	lda BUF,x
	sta BUF-1,x
	inx
	cpx __tokenise_work1
	bne !-

	// Reduce length of input by one
	dec __tokenise_work1

	// Stop trying to rim if we run out of input
	bne shell_strip_leading_spaces

	// FALLTROUGH

shell_process_line:

	// Print a new line
	jsr print_return

	// Ignore empty lines
	lda __tokenise_work1
	beq shell_read_next_line

	// Check if a wedge should take over

#if CONFIG_DOS_WEDGE

	ldx __tokenise_work1                         // size of the input, DOS wedges needs this  XXX this should not be needed

#endif
#if CONFIG_DOS_WEDGE || CONFIG_TAPE_WEDGE
	
	// Check if DOS wedge should take over
	lda BUF

#if CONFIG_DOS_WEDGE

	cmp #$40 // '@'
	beq_16 wedge_dos

#endif
#if CONFIG_TAPE_WEDGE

	cmp #$5F // left arrow
	beq_16 wedge_tape

#endif

#endif

	// Tokenise the line
	jsr tokenise_line

	// Has the user entered a line of BASIC beginning with a number?
	lda BUF
	cmp #$30
	bcc shell_execute_line
	cmp #$39
	bcs shell_execute_line

	// Yes, the line begins with a number - parse it and check validity

	// The injest_number follows __tokenise_work1 as the offset into the line,
	// so remember the line length somewhere else for now.
	lda __tokenise_work1
	sta __tokenise_work2
	lda #$00
	sta __tokenise_work1

	// Try to read line number
	lda #<BUF
	sta TXTPTR+0
	lda #>BUF
	sta TXTPTR+1

	jsr basic_parse_line_number

	// Get pointer to next char
	lda TXTPTR+0
	sta __tokenise_work1
	
	// Got a valid line number - we will be adding/deleting a new line

	// Skip any spaces after the line number
	ldx __tokenise_work1
!:
	lda BUF,x
	cmp #$20
	bne !+
	inx
	bne !-
!:	
	stx __tokenise_work1

	// FALLTROUGH

shell_add_delete_line:

	// First make sure VARTAB is correct and clear all the variables
	jsr update_VARTAB_do_clr

	// Check if line already present
	jsr find_line
	bcs !+

	// Line already present - delete it
	jsr delete_line
	jsr find_line                                // refresh OLDTXT
!:
	// Insert new line if non-zero length, i.e., that
	// we are not just deleting the line.
	lda __tokenise_work1
	cmp __tokenise_work2
	beq !+
	jsr insert_line
!:
	// No READY message after entering or deleting a line of BASIC
	jmp shell_read_next_line
	

shell_execute_line:	

	jsr prepare_direct_execution
	jmp execute_statements

