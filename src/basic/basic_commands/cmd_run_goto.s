// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


cmd_run:
	// RUN clears all variables
	jsr do_clr
cmd_goto:
	// Disable Kernal messages
	lda #$00
	jsr JSETMSG

	// Reset line pointer to first line of program.
	jsr init_oldtxt

	jsr end_of_statement_check
	bcs !+

	jsr basic_parse_line_number
	jsr find_line
	bcc !+
	// Line does not exist, so report error
	jmp do_UNDEFD_STATEMENT_error
!:
	// Run it!
	jmp execute_line