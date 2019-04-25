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
	pla
	;; Rub out space at the end
	lda #$14
	jsr $ffd2
	rts

print_packed_word:
	;; A = the word to print
	tax

	;; Setup pointer to packed words
	lda #<packed_message_words
	sta temp_string_ptr+0
	lda #>packed_message_words
	sta temp_string_ptr+1

	;; Find the word in the list
	ldy #$ff
packed_word_search:
	iny
	cpx #$00
	beq found_packed_word

	;;  $x0 is an end of work marker
	lda (temp_string_ptr),y
	and #$0f
	cmp #$00
	bne +
	dex
*
	;; $FE $xx is an end of work marker
	lda (temp_string_ptr),y
	cmp #$fe
	bne +
	dex 
	iny 			; skip next byte
*
	cmp #$ff
	bne +
	iny			; skip next byte
*

	;; Advance to next page if required
	cpy #$ff
	bne packed_word_search
	inc temp_string_ptr+1
	jmp packed_word_search

found_packed_word:

	;; Get pointer to start of packed word
	;; Make sure we don't wrap on a page boundary
	tya
	clc
	adc temp_string_ptr+0
	sta temp_string_ptr+0
	lda temp_string_ptr+1
	adc #$00
	sta temp_string_ptr+1

print_packed_string:	
	ldy #$ff

next_packed_word_char:
	;; Y = offset into packed word data - 1
	iny
	
	;; Check for end of word
	lda (temp_string_ptr),y
	cmp #$00
	beq end_of_packed_word
	cmp #$fe
	beq last_literal
	cmp #$ff
	beq next_is_literal_char
	and #$f0
	beq end_of_packed_word	

	;; Check if it is an uncommon char
	lda (temp_string_ptr),y
	and #$f0
	cmp #$f0
	beq is_uncommon_char

	;; Is not an uncommon char, so get char of upper nybl
	lda (temp_string_ptr),y

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

	;; See if there is a char in the low nybl to print
	pla
	tay
	lda (temp_string_ptr),y
	and #$0f
	beq end_of_packed_word
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
has_nybl:	
	cpx #0
	beq +
	
	;; X=1-14 = first 14 chars, so subtract one
	lda packed_message_chars-1,x
	jsr $FFD2
*
	pla
	tay
	;; FALL THROUGH

no_lo_nybl_char:

	;; If current byte has $0F in low nybl, then the next
	;; byte is a whole byte.
	lda (temp_string_ptr),y
	and #$0f
	cmp #$0f
	beq next_is_literal_char

ready_for_next_char:	
	cpy #$ff
	bne next_packed_word_char
end_of_packed_word:	
	;; Hit end of packed data
	rts

last_literal:
	jsr unpack_literal_char
	rts
	
next_is_literal_char:
	jsr unpack_literal_char
	jmp ready_for_next_char

unpack_literal_char:	
	;; Output the literal char, and ready for next char
	iny
	tya
	pha
	lda (temp_string_ptr),y
	jsr $ffd2
	pla
	tay
	rts
	
is_uncommon_char:
	;; Lower nybl has offset into low-frequency part of the table

	lda (temp_string_ptr),y
	and #$0f
	clc
	adc #14

	;; We need to print the low nybl char as well
	tax
	tya
	pha

	jmp has_nybl
