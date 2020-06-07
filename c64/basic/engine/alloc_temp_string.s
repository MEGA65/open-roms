// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Allocates area for a temporary string
//
// Input:
// - .A - string length
//


// XXX - this is a dummy implementation, until proper string handling is implemented
// XXX - addresses are probably wrong, debug it


alloc_temp_string:

	// Check if temporary descriptor stack has a free slot

	ldx LASTPT
	cpx #$1F
	bcs_16 do_FORMULA_TOO_COMPLEX_error

	// Prepare data in index registers

	tay                                // store length, we will need .A in a moment

	// Increment temporary descriptor stack pointers by 3

	lda LASTPT
	adc #$03                           // Carry is already clear here
	sta LASTPT
	adc #$03
	sta TEMPPT

	// Fill in the new entry

	cmp #$1C
	bne !+

	// Fill in the address - first entry

	ldx TEMPPT
	lda STREND+0
	sta $01, x                    // address - lo byte
	lda STREND+1
	sta $02, x                    // address - hi byte

	jmp alloc_temp_string_space_check
!:
	// Fill in the adress - use previous entry

	ldx LASTPT
	lda $01, x                   // address - lo byte
	ldx TEMPPT
	sta $01, x

	ldx LASTPT
	lda $02, x                   // address - hi byte
	ldx TEMPPT
	sta $02, x
	inc $02, x

	// FALLTROUGH

alloc_temp_string_space_check:

	// Fill in the length of the new string

	ldx TEMPPT
	tya
	sta $00, x                    // length

	// Check if we have enough space

	lda $02, x
	cmp FRETOP+1
	beq_16 do_OUT_OF_MEMORY_error

	rts
