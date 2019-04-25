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

	;; Print the packed word
	lda #<$0100
	sta temp_string_ptr+0
	lda #>$0100
	sta temp_string_ptr+1
	jsr print_packed_string
	
	jsr ready_message

	jmp basic_main_loop
