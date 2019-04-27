basic_main_loop:

	;; XXX - Check if direct or program mode, and get next line of input
	;; the appropriate way.
	;; XXX - For now, it is hard coded to direct mode

	;; Tell user we are ready
	jsr ready_message
	
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

	;; Strip leading spaces from the line
remove_leading_spaces:	
	lda $0200
	cmp #$20
	bne +
	ldx #1
rsl_l1:	lda $0200,x
	sta $01ff,x
	inx
	cpx tokenise_work1
	bne rsl_l1

	;; Reduce length of input by one
	dec tokenise_work1
	;; Stop trying to rim if we run out of input
	bne remove_leading_spaces
*	
	;; Do printing of the new line
	lda #$0d
	jsr $ffd2

	jsr tokenise_line	

	;; Has the user entered a line of BASIC beginning with a number?
	lda $0200
	cmp #$30
	bcc not_a_line
	cmp #$39
	bcs not_a_line

	;; Yes, the line begins with a number.
	;; Parse the line number and check validity
	inc $d020

	;; injest_number follows tokenise_work1 as the offset into the line,
	;; so remember the line length somewhere else for now.
	lda tokenise_work1
	sta tokenise_work2
	lda #$00
	sta tokenise_work1
	
	jsr injest_number

	;; Check if the number is a valid line number
	;; i.e., 16 bits, no exponent, no decimal
	lda basic_fac1_mantissa+2
	ora basic_fac1_mantissa+3
	ora basic_fac1_exponent
	beq +
ml_bad_line_number:
	inc $0424
	;; Syntax error
	ldx #10
	jmp do_basic_error
*	lda tokenise_work4
	cmp #$ff
	bne ml_bad_line_number

	;; Got a valid line number.

	;; Skip any spaces after the line number
	ldx tokenise_work1
skip_spaces:	
	lda $0200,x
	cmp #$20
	bne +
	inx
	bne skip_spaces
*	stx tokenise_work1
	
	;; First, clear all variables, so that we only have to shove BASIC text around.
	;; (We could later remove this requirement, and the only effect should be
	;; to slow things down, and that you might have to either CLR if there is no
	;; memory free, or else it would auto CLR when you ran out of program space).
	jsr basic_do_clr

	;; Copy to line number holder
	lda basic_fac1_mantissa+0
	sta basic_line_number+0
	lda basic_fac1_mantissa+1
	sta basic_line_number+1

	lda basic_current_line_ptr+0
	sta $0420
	lda basic_current_line_ptr+1
	sta $0421
	
	;; Delete line if present
	jsr basic_find_line

	lda basic_current_line_ptr+0
	sta $0420
	lda basic_current_line_ptr+1
	sta $0421
	
	bcs +
	jsr basic_delete_line
*
	;; Insert new line if non-zero length
	jsr basic_insert_line
	
not_a_line:	
	
	jmp basic_main_loop
