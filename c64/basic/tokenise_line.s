	;; Tokenise a line of BASIC
	;; Stored at $0200
	;; Length in tokenise_work1

tokenise_line:

	;; We need to consider each offset in the string to see if it matches
	;; a token.  No BASIC keyword is > 7 bytes, so we need to start with that
	;; length (or remaining length of string) and count our way back down.
	;; This means we need separate start and end points to keep track of.

	;; $0110 = offset into string
	;; $0111 = number of bytes to pack
	;; $0112 = offset into tokenised output
	;; $0113 = length of raw string

	lda #$00
	sta $0110
	sta $0112
	lda tokenise_work1
	sta $0113

tokenise_char:

	;; Check if we have reached end of the line?
	lda $0110
	tax
	inc $0400,x
	cmp $0113
	bne +

	;; End of line reached
	
	ldx #0
	stx $0450

	;; Finished tokenising line
	;; Update tokenise_work1 and terminate with null
	ldx $0112
	lda #$00
	sta $0200,x
	stx tokenise_work1
	rts
*
	;; More to do
	ldx #1
	stx $0450
	
	;; Maximum keyword length
	lda #7
	sta $0111

tokenise_char_loop:	
	;; Pack the word from the start (start = X, raw len = tokenise_work1)
	;; Returns packed length in tokenise_work2 and writes the packed
	;; word at $0100+

	ldx #2
	stx $0450
	
	;; Pack string
	ldx $0110
	stx $044e
	lda $0111
	sta tokenise_work1
	bpl +
foo:	inc $d020
	jmp foo
	
	*
	sta $044f
	jsr pack_word
	lda tokenise_work2
	cmp #$10
	bcc +
	;; Packed string too long
	ldx #16
	jmp do_basic_error
	*

	ldx #3
	stx $0450
	
	;; Search for it in keywords
	jsr keyword_search

	ldx #4
	stx $0450
	
	;; Did we find a keyword?
	bcc found_token_in_line

	ldx #5
	stx $0450
		
	;; Nope, so try shorter
	ldx $0111
	stx $044d
	inc $0608,x
	dec $0111
	bne tokenise_char_loop

	ldx #6
	stx $0450
		
	;; Is not a token, so copy to output verbatim
	ldx $0110
	ldy $0112
	lda $0200,x
	sta $0200,y
	inc $0112
	inc $0110

	;; Tokenise next char
	jmp tokenise_char

found_token_in_line:

	ldx #7
	stx $0450
	
	;; Got a token, so write it out
	ldx $0112
	sta $0200,x
	inx
	stx $0112
	;; Now skip over the length of the token
	lda $0110
	clc
	adc $0111
	sta $0110

	;; See if there is more of the line left to process
	jmp tokenise_char
	


	
	;; Search for word in keyword list
	;; The packed form is canonical, so we can search for the keyword while
	;; it remains compressed. This also saves a little time.
	;; Algorithm is simply to find matching first bytes, and then look for
	;; the rest being a match.

keyword_search:
	;; Search for the compressed keyword stored at $0100 in the list
	;; of compressed keywords
	
	;; tokenise_work1 = offset in line of input
	;; tokenise_work2 = length of token we are matching
	;; tokenise_work3 = offset in token list
	;; load_or_verify_or_tokenise_work5 = temporary work space
	;; X and Y registers used as temporary space.
	;; returns C=1 if no matching token, else C=0 and A=token
	
	lda #$00
	sta tokenise_work1
	sta tokenise_work3
next_kw_offset:	
	;; Advance offset in compressed keyword list, to see if a match
	;; BEGINS here

	;;  Get count of bytes to compare
	lda tokenise_work2
	sta load_or_verify_or_tokenise_work5
	
	;; Load current position
	ldy tokenise_work3
	ldx tokenise_work1
	
	;; Advance offset in compressed token list, and stop at the end
	inc tokenise_work3
	lda tokenise_work3
	cmp #$ff
	bne next_in_match
	jmp done_searching_for_token
next_in_match:
	lda $0100,x
	cmp packed_keywords,y
	bne next_kw_offset
	;; Advance to next chars in source and target
	inx
	iny

	dec load_or_verify_or_tokenise_work5 	; Have we compared all bytes yet?
	
	bne next_in_match

	;; Keyword matches!

	;; Now make sure we started on a keyword boundary
	;; (we know we finished on one, because of the structure of the compressed
	;; keyword data).
	;; Offset 0
	;; previous byte is $x0
	;; two byte prior is $FE

	;; Get offset of first byte of this token
	ldx tokenise_work3
	dex 			; pointer points one late, so rewind it

	;; At start of list?
	cpx #$00
	beq word_boundary
	dex
	;; Previous byte is $x0 end token?
	lda packed_keywords,x
	and #$0f
	beq word_boundary
	dex
	;; Uber-previouss byte is $FE final literal token?
	lda packed_keywords,x
	cmp #$fe
	beq word_boundary

	;; Not a word boundary, so ignore
	jmp next_kw_offset

word_boundary:	
	;; Found a token whose offset is in tokenise_work3
	;; No trace back to the start of the compressed keyword list
	;; to work out what word number we are, so that we can return
	;; the token number.

	inc $d020
	lda #$80 		; Pretend token
	clc
	rts
	
done_searching_for_token:	
	;;  No token found
	sec
	lda #$00
	rts
	
