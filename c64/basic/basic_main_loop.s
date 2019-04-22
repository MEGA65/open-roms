basic_main_loop:

	;; XXX - Check if direct or program mode, and get next line of input
	;; the appropriate way.
	;; XXX - For now, it is hard coded to direct mode
	
	;; Read a line of input
	ldx #$00
read_line_loop:	
	jsr $ffe4 		; KERNAL CHRIN
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
	jsr ready_message

	jmp basic_main_loop
