// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Allocates memory for a temporary string
//
// Input:
// -.A desired string length, has to be > 0
//
// Output:
// - VARPNT points to the newly alocated descriptor
//

tmpstr_alloc:

	tax

	// First we need to find a free temporary string descriptor

	lda TEMPPT
	cmp #$22
	bcs_16 do_FORMULA_TOO_COMPLEX_error

	tay
	sta LASTPT
	clc
	adc #$03
	sta TEMPPT

	// Store desired string length

	stx $00, y

	// Store descriptor address

	lda LASTPT
	sta VARPNT+0
	lda #$00
	sta VARPNT+1

	// Jump to alocation routine
	// XXX consider falltrough

	jmp varstr_alloc
