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

// XXX provide documentation and implementation

FRMEVL:

	// XXX for now we just report dummy string

	lda #$FF
	sta VALTYP

	lda #$0B
	sta __FAC1 + 0

	lda #<dummy_text
	sta __FAC1 + 1

	lda #>dummy_text
	sta __FAC1 + 2

	rts

dummy_text:

	.text "LOREM IPSUM"
