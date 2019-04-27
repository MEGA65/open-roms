
cmd_new:
	jsr basic_do_new
	jmp basic_main_loop

cmd_clr:
	jsr basic_do_clr
	jmp basic_main_loop
	
basic_do_new:	
	;; Setup pointers to memory storage
	lda #<$0801
	sta basic_start_of_text_ptr+0
	lda >$0801
	sta basic_start_of_text_ptr+1
	sta basic_start_of_vars_ptr+1
	lda #<$0803
	sta basic_start_of_vars_ptr+0

	;; FALL THROUGH
	
basic_do_clr:
	;; Clear variables, arrays and strings
	lda basic_start_of_vars_ptr+0
	sta basic_start_of_arrays_ptr+0
	sta basic_start_of_free_space_ptr+0
	lda basic_start_of_vars_ptr+1
	sta basic_start_of_arrays_ptr+1
	sta basic_start_of_free_space_ptr+1

	rts
	
	
