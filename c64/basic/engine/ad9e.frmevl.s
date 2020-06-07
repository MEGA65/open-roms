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
//
// Idea:
// - use a stack to reorder operations, so that they can be executed
//   in a correct order
//

// XXX finish the implementation


FRMEVL:

	// XXX we neeed FRETOP for string concatenation

	// lda VARTAB+0
	// sta FRETOP+0
	// lda VARTAB+1
	// sta FRETOP+1

	// XXX we also need TEMMPPT, LASTPT and TEMPST

	// Push the sentinel to the stack

	lda #$00
	pha

	// FALLTROUGH

FRMEVL_loop:

	// Check if end of statement

	jsr end_of_statement_check
	bcs_16 do_SYNTAX_error

	// There are 4 basic possibilities: a string, a float, an opening bracket, or a token

	jsr fetch_character
	cmp #$22                           // check for opening quote
	beq FRMEVL_fetch_string
	cmp #$28                           // check for opening bracket
	beq FRMEVL_handle_bracket
	cmp #$7F                           // check for a token
	bcc FRMEVL_fetch_float

	// Search for a value or unary operator, starting from the most probable
	// XXX check all other operators

	cmp #$AB                           // check for unary minus
	beq_16 do_NOT_IMPLEMENTED_error    // XXX
	cmp #$A8                           // check for NOT
	beq_16 do_NOT_IMPLEMENTED_error    // XXX
	cmp #$FF                           // check for PI
	beq_16 do_NOT_IMPLEMENTED_error    // XXX
	cmp #$AA                           // check for unary plus (ignore this one)    
	beq FRMEVL_loop

	// Nothing recognized

	jmp do_SYNTAX_error

FRMEVL_handle_bracket:

	// Brackets are easy to handle - just call FRMEVL recursively
	// and consume the closing bracket afterwards

	jsr FRMEVL
	jsr fetch_character
	cmp #$29                           // closing bracket
	beq FRMEVL_got_value

	jmp do_SYNTAX_error

FRMEVL_fetch_float:

	// XXX implement this

	jmp do_SYNTAX_error

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
	beq FRMEVL_got_value

	inc __FAC1 + 0
	bne !-

	jmp do_STRING_TOO_LONG_error

FRMEVL_got_value:

	jsr end_of_statement_check
	bcs FRMEVL_continue                // calculate the stack if expression ended

	// FALLTROUGH

FRMEVL_fetch_operator:

	// We have a value, but this is not the end of expression. Check if
	// there is an operator waiting to be served

	jsr fetch_operator
	bcs FRMEVL_continue                // if operator not recognized, calculate what we have
	                                   // on stack and quit

	// XXX check the priorities - possibly execute the current stack first

	// FALLTROUGH

FRMEVL_push_value_operator:

	// Ccheck if there is enough stack space
	tsx
	cpx #$40                           // XXX is this a safe threshold?
	bcc_16 do_FORMULA_TOO_COMPLEX_error

	// Move the operator ID in .Y

	tay

	// Push the value from FAC1

	ldx VALTYP
	bmi FRMEVL_push_string

	// Push float

	// XXX implement this

FRMEVL_push_string:

	// Push string - address, length, type

	lda __FAC1+1
	pha
	lda __FAC1+2
	pha

	lda __FAC1+0
	pha

	txa
	pha

	// FALLTROUGH

FRMEVL_push_operator_address:

	// Push the operator address to stack, in a form
	// suitable for RTS

	// XXX add support for other operators, use .Y

	lda operator_jumptable_hi, y
	pha
	lda operator_jumptable_lo, y
	pha

	// Push operator priority

	lda operator_priorities, y
	pha

	// Continue

	jmp FRMEVL_loop


FRMEVL_continue:                       // this is the exit point for the operators

	// Now, we have to calculate all the operations; at this point we
	// should have a value in FAC1 and (possibly) operator on the top of the stack

	pla                                // priority does not matter here, get rid of it
	rts                                // this either jumps to operator, or quits FRMEVL
