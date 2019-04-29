
cmd_new:
	jsr basic_do_new

	;; NEW command terminates execution
	;; (Confirmed on a C64)
	jmp basic_main_loop

cmd_clr:
	jsr basic_do_clr
	;; CLR command does not stop execution
	;; (Cconfirmed on a c64)
	jmp basic_execute_statement
	
basic_do_new:	
	;; Setup pointers to memory storage
	lda #<$0801
	sta basic_start_of_text_ptr+0
	lda #>$0801
	sta basic_start_of_text_ptr+1
	sta basic_start_of_vars_ptr+1
	lda #<$0803
	sta basic_start_of_vars_ptr+0

	;; Zero line pointer
	;; XXX - We should also zero $0800, i.e., basic_start_of_text_ptr - 1
	ldy #$00
	tya
	sta (basic_start_of_text_ptr),y
	iny
	sta (basic_start_of_text_ptr),y
	
	
	;; Get top of memory.
	;; If a cart is present, then it is $7FFF,
	;; if not, then it is $F7FF, since we support having
	;; programs and variables under ROM.
	;; i.e., we support 56KB RAM for BASIC, keeping some space
	;; free for some optimisation structures, e.g., FOR/NEXT loop
	;; records (without them going on the stack), GOSUB stack
	;; (same story), expression value cache?
	
	sec			; Read, not write value
	jsr $ff99 		; KERNAL MEMTOP routine
	cpx #$80
	beq +
	lda #>$f7ff
	.byte $2c
*	lda #>$7FFF
	sta basic_top_of_memory_ptr+1
	sta basic_start_of_strings_ptr+1
	lda #<$f7ff
	sta basic_top_of_memory_ptr+0
	sta basic_start_of_strings_ptr+0	
	
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
	
	
