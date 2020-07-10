// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


fetch_variable:

	// Fetch variable name

	lda #$00
	sta VARNAM+1

	// Fetch the first character
!:
	jsr fetch_character
	cmp #$20                           // ignore all the spaces
	beq !-

	jsr fetch_variable_is_AZ
	bcs_16 do_SYNTAX_error

	sta VARNAM+0

	// Fetch the (optional) second character

	jsr fetch_character
	jsr fetch_variable_is_09_AZ
	bcs fetch_variable_check_type

	sta VARNAM+1

	// Fetch the remaining variable characters - ignore them
!:
	jsr fetch_character
	jsr fetch_variable_is_09_AZ
	bcc !-

	// FALLTROUGH

fetch_variable_check_type:

	// Encode variable type within name, as documented in:
	// - https://sites.google.com/site/h2obsession/CBM/basic/variable-format

	cmp #$24                           // '$'
	beq fetch_variable_type_string
	cmp #$25                           // '%'
	beq fetch_variable_type_integer

	// FALLTORUGH

fetch_variable_type_float:

	jsr unconsume_character

#if HAS_OPCODES_65C02
	bra fetch_variable_find_addr
#else
	jmp fetch_variable_find_addr
#endif

fetch_variable_type_integer:

	lda VARNAM+0
	ora #$80
	sta VARNAM+0

	// FALLTROUGH

fetch_variable_type_string:

	lda VARNAM+1
	ora #$80
	sta VARNAM+1
	
	// FALLTROUGH

fetch_variable_find_addr:

	// Now try to find variable address

	// XXX

	rts
