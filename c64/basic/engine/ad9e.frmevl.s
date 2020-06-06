// #LAYOUT# STD *       #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


// Well-known BASIC routine, described in:
//
// - [CM64] Computes Mapping the Commodore 64 - page 102
// - https://sta.c64.org/cbm64basconv.html
//
// Output:
// - VALTYP - $00 = floating number, $FF = string
// - INTFLG (XXX float/integer, probably)
// - for float: FAC1
// - for string: __FAC1 + 0 = length, __FAC1 + 1 = pointer to string

// XXX finish the implementation


FRMEVL:

	// Check if end of statement

	jsr end_of_statement_check
	bcs_16 do_SYNTAX_error

	// Search for opening quote

	jsr fetch_character
	cmp #$22
	bne FRMEVL_fetch_float

	// FALLTROUGH

FRMEVL_fetch_string:

	// Mark return value as a string, set initial length as 0

	ldx #$FF
	stx VALTYP

	inx
	stx __FAC1 + 0

	// Set pointer to start of the string

	ldx TXTPTR + 0
	stx __FAC1 + 1
	ldx TXTPTR + 1
	stx __FAC1 + 2
!:
	// Search for closing quote

	jsr fetch_character
	cmp #$22
	beq FRMEVL_done

	inc __FAC1 + 0
	bne !-

	jmp do_STRING_TOO_LONG_error

FRMEVL_fetch_float:

	// XXX implement this

	jmp do_SYNTAX_error

FRMEVL_done:

	rts
