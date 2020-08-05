// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


cmd_run:

	// RUN clears all variables

	jsr do_clr

	// Initialize OLDTXT pointer, disable Kernal messages

	jsr init_oldtxt
	lda #$00
	jsr JSETMSG

	// Check if we have any paramenters

	jsr is_end_of_statement
	bcs cmd_run_goto_launch

	// FALLTROUGH

cmd_goto:

	// GOTO requires line number

	jsr fetch_line_number
	bcs_16 do_SYNTAX_error

	// Check for direct mode

	lda CURLIN+1
	bmi cmd_goto_direct

	// Not a direct mode - compare desired line number (LINNUM) with the current one (CURLIN)

	lda LINNUM+1
	cmp CURLIN+1
	bne !+
	lda LINNUM+0
	cmp CURLIN+0
!:
	// If desired line number is lower - search line number from start

	bcc cmd_goto_from_start

	// Else - search from the current line

	jsr find_line_from_current
	jmp_8 cmd_goto_check

cmd_goto_direct:

	// Disable Kernal messages

	lda #$00
	jsr JSETMSG

	// FALLTROUGH

cmd_goto_from_start:

	// Direct mode - find the line from the beginning

	jsr find_line_from_start

	// FALLTROUGH

cmd_goto_check:

	bcs_16 do_UNDEFD_STATEMENT_error

	// FALLTROUGH

cmd_run_goto_launch:

	// Run it!

	pha
	pha
	jmp execute_line
