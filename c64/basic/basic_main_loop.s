// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


basic_main_loop:

	// Tell user we are ready
	jsr ready_message

	// Enable Kernal messages
	lda #$80
	jsr JSETMSG

basic_read_next_line:	
	// Read a line of input
	ldx #$00
read_line_loop:

	jsr JCHRIN
	bcs read_line_loop
	
	cmp #$0d
	beq got_line_of_input
	// Not carriage return, so try to append to line so far
	cpx #80
	bcc !+
	// Report STRING TOO LONG error (Computes Mapping the 64 p93)
	ldx #22
	jmp do_basic_error
!:
	sta BUF,x
	inx
	jmp read_line_loop

got_line_of_input:

	// Store length of input buffer ready for tokenising
	stx __tokenise_work1

	// Strip leading spaces from the line
remove_leading_spaces:
	lda BUF
	cmp #$20
	bne !+
	ldx #1
rsl_l1:
	lda BUF,x
	sta BUF-1,x
	inx
	cpx __tokenise_work1
	bne rsl_l1

	// Reduce length of input by one
	dec __tokenise_work1
	// Stop trying to rim if we run out of input
	bne remove_leading_spaces
!:
	// Do printing of the new line
	jsr print_return

	// Ignore empty lines
	lda __tokenise_work1
	beq basic_read_next_line

	// Check if a wedge should take over

#if CONFIG_DOS_WEDGE || CONFIG_TAPE_WEDGE
	
	ldx __tokenise_work1 // here is the size of input
	
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

	// Else, tokenise the line
	jsr tokenise_line

	// Has the user entered a line of BASIC beginning with a number?
	lda BUF
	cmp #$30
	bcc not_a_line
	cmp #$39
	bcs not_a_line

	// Yes, the line begins with a number.
	// Parse the line number and check validity

	// injest_number follows __tokenise_work1 as the offset into the line,
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
	
	// Got a valid line number -- so do add/del line

	// Skip any spaces after the line number
	ldx __tokenise_work1
skip_spaces:	
	lda BUF,x
	cmp #$20
	bne !+
	inx
	bne skip_spaces
!:	stx __tokenise_work1

	// First, clear all variables, so that we only have to shove BASIC text around.
	// (We could later remove this requirement, and the only effect should be
	// to slow things down, and that you might have to either CLR if there is no
	// memory free, or else it would auto CLR when you ran out of program space).
	jsr basic_do_clr

	// Delete line if present
	jsr basic_find_line

	bcs !+

	// Delete the line, whether we are deleting or
	// replacing the line
	jsr basic_delete_line
!:
	// Insert new line if non-zero length, i.e., that
	// we are not just deleting the line.
	lda __tokenise_work1
	cmp __tokenise_work2
	beq !+
	jsr basic_insert_line
!:
	// No READY message after entering or deleting a line of BASIC
	jmp basic_read_next_line
	
not_a_line:	

	//  Actually interpret the line

	// Setup pointer to the statement
	lda #<BUF
	sta TXTPTR+0
	lda #>BUF
	sta TXTPTR+1

	// There is no stored line, so zero that pointer out
	lda #$00
	sta OLDTXT+0
	sta OLDTXT+1

	// Put invalid line number in current line number value,
	// so that we know we are in direct mode
	// (Computes Mapping the 64 p19)
	lda #$FF
	sta CURLIN+1

	jmp execute_statements
