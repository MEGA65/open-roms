// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Fetches an operator - for the expression parser
//
// Note: does not recognize unary operators
//


fetch_operator: // XXX change the operator code to start from 0

	// Retrieve the next character

	jsr fetch_character

	// Check if within range

	sec
	sbc #$A9
	bcc fetch_operator_failed             // branch if below 0
	beq fetch_operator_failed             // branch 0

	cmp #$0B
	bcs fetch_operator_failed             // branch if $0B or greater

	// Now we have to recognize '>=', '<=' and '<>' operators

	cmp #$08
	beq fetch_operator_try_gteq

	cmp #$0A
	beq fetch_operator_try_lteq_neq

	// FALLTROUGH

fetch_operator_success:

	clc
	rts

fetch_operator_failed:

	sec
	rts


fetch_operator_try_gteq:

	// Here we distinguish between '>' and '>='

	jsr fetch_character
	cmp #$B2                           // '='
	beq !+

	// This is a '>'

	jsr unconsume_character
	lda #$08
	bne fetch_operator_success         // branch always
!:
	// This is a '>='

	lda #$0B
	bne fetch_operator_success         // branch always


fetch_operator_try_lteq_neq:

	// Here we distinguish between '<', '<=', and '<>'

	jsr fetch_character
	cmp #$B2                           // '='
	beq !+
	cmp #$B1                           // '>'
	beq !++

	// This is a '<'

	jsr unconsume_character
	lda #$0A
	bne fetch_operator_success         // branch always
!:
	// This is a '<='

	lda #$0C
	bne fetch_operator_success         // branch always
!:
	// This is a '<>'

	lda #$0D
	bne fetch_operator_success         // branch always
