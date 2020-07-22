// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Carry set = failure, not recognized variable name
// sets FOUR6 and DIMFLG ($80 for array, $00 for regular variable)


fetch_variable_name:

	// Set default second character and variable type

	lda #$00
	sta VARNAM+1

	// Fetch the first character of variable name

	jsr fetch_character_skip_spaces
	jsr is_AZ
	bcc !+

#if !HAS_OPCODES_65CE02
	jsr unconsume_character
#else
	dew TXTPTR
#endif

	sec
	rts
!:
	sta VARNAM+0

	// Fetch the (optional) second character

	jsr fetch_character
	jsr is_09_AZ
	bcs fetch_variable_check_type

	sta VARNAM+1

	// Fetch the remaining variable characters - ignore them
!:
	jsr fetch_character
	jsr is_09_AZ
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

	lda #$05
	sta FOUR6

#if !HAS_OPCODES_65CE02
	jsr unconsume_character
#else
	dew TXTPTR
#endif

	jmp_8 fetch_variable_name_check_array

fetch_variable_type_integer:

	ldy #$02

	lda #$02
	sta FOUR6

	lda VARNAM+0
	ora #$80
	sta VARNAM+0

	lda #$00
	beq !+                             // branch always

fetch_variable_type_string:

	ldy #$03
	lda #$80
!:
	sta VALTYP
	sty FOUR6

	lda VARNAM+1
	ora #$80
	sta VARNAM+1

	// FALLTROUGH

fetch_variable_name_check_array:

	jsr fetch_character_skip_spaces
	cmp #$28                          // '('
	beq !+

	// This is not an array

#if !HAS_OPCODES_65CE02
	jsr unconsume_character
#else
	dew TXTPTR
#endif

	lda #$00
	skip_2_bytes_trash_nvz
!:
	// This is an array

	lda #$80

	sta DIMFLG
	rts
