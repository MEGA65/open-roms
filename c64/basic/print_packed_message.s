	;; This routine prints messages that have been packed
	;; using the make_error_tables program.
	;; The general idea is to save space in the ROM.

	;; The output of make_error_tables is written to packed_messages.s, and
	;; contains the following:
	;; 
	;; packed_message_words - List of nybl packed words.
	;; packed_message_tokens - List of tokens that get joined to make messages
	;; packed_message_chars - List of characters in messages sorted by frequency.
	
print_packed_message:
	;; X = message number

	lda #$ff
	ldy #$ff
packed_message_search:	
	iny
	cpx #$00
	beq found_message_in_token_stream
	lda packed_message_tokens,y
	cmp #$ff
	bne +
	dex
*
	cpy #$ff
	bne packed_message_search
	;; Could not find message
	sec
	rts

found_message_in_token_stream:
	;; Now print each word in the message
	tya
	pha
	lda packed_message_tokens,y
	cmp #$ff
	beq +
	jsr print_packed_word
	lda #$20
	jsr $ffd2
	pla
	tay
	iny
	bne found_message_in_token_stream
*
	rts

print_packed_word:
	;; A = the word to print
	tax

	;; Find the word in the list
	ldy #$ff
packed_word_search:	
	cpx #$00
	beq found_packed_word
	iny
	lda packed_message_words,y
	and #$0f
	cmp #$00
	bne +
	dex
*
	cpy #$ff
	bne packed_word_search
	;; Could not find word
	sec
	rts

found_packed_word:
	inc $0427
	
	;; Y = offset into packed word data - 1
	iny

	;; Check for end of word
	lda packed_message_words,y
	cmp #$00
	beq done_printing_word
	and #$f0
	beq done_printing_word

	;; Check if it is an uncommon char
	lda packed_message_words,y
	and #$f0
	cmp #$f0
	beq is_uncommon_char

	;; Is not an uncommon char, so get char of upper nybl
	lda packed_message_words,y

	;; Put high nybl into low bits of X
	lsr
	lsr
	lsr
	lsr
	tax

	;; Save Y so it doesn't get clobbered by $FFD2
	tya
	pha

	;; X=1-14 = first 14 chars, so subtract one
	lda packed_message_chars-1,x
	jsr $FFD2
	inc $426

	;; See if there is a char in the low nybl to print
	pla
	tay
	lda packed_message_words,y
	and #$0f
	beq no_lo_nybl_char
	cmp #$0f
	beq no_lo_nybl_char

has_lo_nybl_char:	
	;; We need to print the low nybl char as well
	tax
	tya
	pha

	;; Skip lower nybls of $F or $0 in nybl packed
	;; bytes, as these do not encode characters
	cpx #$f
	beq +
	cpx #0
	beq +
	
	;; X=1-14 = first 14 chars, so subtract one
	lda packed_message_chars-1,x
	jsr $FFD2
	inc $426	
*
	pla
	tay
	;; FALL THROUGH

no_lo_nybl_char:

	cpy #$ff
	bne found_packed_word
	;; Hit end of packed data
	rts

is_uncommon_char:
	;; Lower nybl has offset into low-frequency part of the table

	lda packed_message_words,y
	and #$0f
	clc
	adc #14
	jmp has_lo_nybl_char
	
done_printing_word:
	rts
