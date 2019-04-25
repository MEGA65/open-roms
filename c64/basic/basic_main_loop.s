basic_main_loop:

	;; XXX - Check if direct or program mode, and get next line of input
	;; the appropriate way.
	;; XXX - For now, it is hard coded to direct mode
	
	;; Read a line of input
	ldx #$00
read_line_loop:	
	jsr $ffcf 		; KERNAL CHRIN
	bcs read_line_loop
	
	cmp #$0d
	beq got_line_of_input
	;; Not carriage return, so try to append to line so far
	cpx #80
	bcc +
	;; Report STRING TOO LONG error (Compute's Mapping the 64 p93)
	ldx #22
	jmp basic_do_error
*
	sta basic_input_buffer,x
	inx
	jmp read_line_loop

got_line_of_input:

	;; Store length of input buffer ready for tokenising
	stx tokenise_work1
	
	;; Do printing of the new line
	lda #$0d
	jsr $ffd2

	;; Pack the word from the start
	ldx #$00
	jsr pack_word

	;; Search for word in keyword list
	;; The packed form is canonical, so we can search for the keyword while
	;; it remains compressed. This also saves a little time.
	;; Algorithm is simply to find matching first bytes, and then look for
	;; the rest being a match.

token_search:
	;; tokenise_work1 = offset in line of input
	;; tokenise_work2 = length of token we are matching
	;; tokenise_work3 = offset in token list
	ldy #$00
	sta tokenise_work1
	sta tokenise_work3
next_kw_offset:	
	;; Advance offset in compressed keyword list, to see if a match
	;; BEGINS here

	;;  Get count of bytes to compare
	lda tokenise_work2
	sta tokenise_work4
	sta $0427
	
	;; Load current position
	ldx tokenise_work1
	ldy tokenise_work3
	
	;; Advance offset in compressed token list
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
	dec tokenise_work4 	; Have we compared all bytes yet?
	bne next_in_match
	;; Keyword matches!
	inc $d020
	tya
	clc
	adc #<packed_keywords
	sta temp_string_ptr+0
	lda #>packed_keywords
	sta temp_string_ptr+1
	jsr print_packed_string
	
done_searching_for_token:	
	jsr ready_message

	jmp basic_main_loop
