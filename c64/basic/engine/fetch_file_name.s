// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Fetches file name, Carry set if not found
//


fetch_filename:

	// Check if end of statement

	jsr end_of_statement_check
	bcs fetch_filename_done

	// Call the expression parser, make sure it returned a string

	jsr FRMEVL

	lda VALTYP
	bpl_16 do_SYNTAX_error

	// Set the filename address and pointer

	lda __FAC1+0
	sta FNLEN

	lda __FAC1+1
	sta FNADDR+0
	lda __FAC1+2
	sta FNADDR+1

	// Mark success

	clc

	// FALLTROUGH

fetch_filename_done:

	rts
