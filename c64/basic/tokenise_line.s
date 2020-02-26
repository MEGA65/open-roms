// #LAYOUT# STD *       #TAKE
// #LAYOUT# M65 *       #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

// Tokenise a line of BASIC
// Stored at $0200
// Length in __tokenise_work1

tokenise_line:

#if (ROM_LAYOUT_M65 && SEGMENT_BASIC_0)

	jsr     map_BASIC_1
	jsr_ind VB1__tokenise_line
	jmp     map_NORMAL

#else

	// We need to consider each offset in the string to see if it matches
	// a token.  No BASIC keyword is > 7 bytes, so we need to start with that
	// length (or remaining length of string) and count our way back down.
	// This means we need separate start and end points to keep track of.

	// $0110 = offset into string
	// $0111 = number of bytes to pack
	// $0112 = offset into tokenised output
	// $0113 = length of raw string

	lda #$00
	sta $0110
	sta $0112
	sta QTSW
	
	lda __tokenise_work1
	sta $0113

tokenise_char:

	// Check if we have reached end of the line?
	lda $0110
	cmp $0113
	bne !+

	// End of line reached
	
	// Finished tokenising line
	// Update __tokenise_work1 and terminate with null
	ldx $0112
	lda #$00
	sta $0200,x
	stx __tokenise_work1

	// Clear quote mode flag that is also used by KERNAL for screen display
	lda #$00
	sta QTSW
	rts
!:
	// More to do
	
	// Maximum keyword length
	lda #7
	sta $0111

tokenise_char_loop:	
	// Pack the word from the start (start = X, raw len = __tokenise_work1)
	// Returns packed length in __tokenise_work2 and writes the packed
	// word at $0100+

	ldx $0110
	lda $0200,x
	cmp #$22
	bne tk_not_quote

	// Quote
	lda QTSW
	eor #$ff
	sta QTSW
	jmp tk_literal_char
	
tk_not_quote:
	// Check for literal characters in various ranges
	// (This just speeds the tokeniser up, by avoiding the packed token search
	//  for such characters).

	// SPACE and punctuation before +,- and *
	cmp #$2a
	bcc tk_literal_char
	// Don't try to tokenise digits
	cmp #$30
	bcc tk_might_be_keyword
	cmp #$3a
	bcs tk_might_be_keyword
	jmp tk_literal_char

tk_might_be_keyword:	
	// Don't tokenise in quote mode
	lda QTSW
	bne tk_literal_char
	
	// Pack string
	ldx $0110
	lda $0111
	sta __tokenise_work1

	// XXX - We should implement an optimisation where we
	// trim the last symbol of successively, instead of re-packing the word
	// again with one less char each time.
	// XXX - We should limit the word length to the length of interesting chars
	// that are available.
	
	jsr pack_word
	lda __tokenise_work2
	cmp #$10
	bcc !+
	// Packed string too long
	jmp do_STRING_TOO_LONG_error
!:

	// Search for it in keywords
	jsr keyword_search

	// Did we find a keyword?
	bcc found_token_in_line

	// Nope, so try shorter
	dec $0111
	bne tokenise_char_loop

tk_literal_char:
	// Is not a token, so copy to output verbatim
	ldx $0110
	ldy $0112
	lda $0200,x
	sta $0200,y
	inc $0112
	inc $0110

	// Tokenise next char
	jmp tokenise_char

found_token_in_line:

	// Got a token, so write it out
	ldx $0112
	sta $0200,x
	inx
	stx $0112

	// If it is REM, then lock us in quote mode to the end of the line
	cmp #$8f
	bne not_rem
	sta QTSW
not_rem:

	// Now skip over the length of the token
	lda $0110
	clc
	adc $0111
	sta $0110

	// See if there is more of the line left to process
	jmp tokenise_char




	// Search for word in keyword list
	// The packed form is canonical, so we can search for the keyword while
	// it remains compressed. This also saves a little time.
	// Algorithm is simply to find matching first bytes, and then look for
	// the rest being a match.

keyword_search:
	// Search for the compressed keyword stored at $0100 in the list
	// of compressed keywords
	
	// __tokenise_work1 = offset in line of input
	// __tokenise_work2 = length of token we are matching
	// __tokenise_work3 = offset in token list
	// __tokenise_work5 = temporary work space
	// X and Y registers used as temporary space.
	// returns C=1 if no matching token, else C=0 and A=token

	lda #$00
	sta __tokenise_work1
	sta __tokenise_work3
next_kw_offset:	
	// Advance offset in compressed keyword list, to see if a match
	// BEGINS here

	//  Get count of bytes to compare
	lda __tokenise_work2
	sta __tokenise_work5

	// Load current position
	ldy __tokenise_work3
	ldx __tokenise_work1

	// Advance offset in compressed token list, and stop at the end
	inc __tokenise_work3
	lda __tokenise_work3
	cmp #packed_keyword_table_len
	bne next_in_match
	jmp done_searching_for_token
next_in_match:
	lda $0100,x
	cmp packed_keywords,y
	bne next_kw_offset
	// Advance to next chars in source and target
	inx
	iny

	dec __tokenise_work5 	// Have we compared all bytes yet?

	bne next_in_match

	// Keyword matches!

	// Now make sure we started on a keyword boundary
	// (we know we finished on one, because of the structure of the compressed
	// keyword data).
	// Offset 0
	// previous byte is $x0
	// two byte prior is $FE

	// Get offset of first byte of this token
	ldx __tokenise_work3
	dex 			// pointer points one late, so rewind it

	// At start of list?
	cpx #$00
	beq word_boundary
	dex
	// Previous byte is $x0 end token?
	lda packed_keywords,x
	and #$0f
	beq word_boundary
	dex
	// Uber-previouss byte is $FE final literal token?
	lda packed_keywords,x
	cmp #$fe
	beq word_boundary

	// Not a word boundary, so ignore
	jmp next_kw_offset

word_boundary:	
	// Found a token whose offset is in __tokenise_work3
	// Now trace back to the start of the compressed keyword list
	// to work out what keyword number we are, so that we can return
	// the token number.

	ldy #$80

token_count_loop:
	lda packed_keywords,x
	cmp #$fe
	bne !+
	iny
!:
	and #$0f
	cmp #$00
	bne !+
	iny
!:
	cpx #$00
	beq !+
	dex
	jmp token_count_loop
!:

	tya
	clc
	rts

done_searching_for_token:	
	//  No token found
	sec
	lda #$00
	rts

#endif // ROM layout
