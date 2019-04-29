basic_main_loop:

	;; XXX - Check if direct or program mode, and get next line of input
	;; the appropriate way.
	;; XXX - For now, it is hard coded to direct mode

	;; Tell user we are ready
	jsr ready_message

basic_read_next_line:	
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

	;; Ignore empty lines
	lda tokenise_work1
	beq basic_read_next_line

	;; Else, tokenise the line
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

	;; Try to read line number
	lda #<$0200
	sta basic_current_statement_ptr+0
	lda #>$0200
	sta basic_current_statement_ptr+1

	jsr basic_parse_line_number

	;; Get pointer to next char
	lda basic_current_statement_ptr+0
	sta tokenise_work1
	
	;; Got a valid line number -- so do add/del line

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

	;; Delete line if present
	jsr basic_find_line

	bcs +

	;; Delete the line, whether we are deleting or
	;; replacing the line
	jsr basic_delete_line
*
	;; Insert new line if non-zero length, i.e., that
	;; we are not just deleting the line.
	lda tokenise_work1
	cmp tokenise_work2
	beq +
	jsr basic_insert_line
*
	;; No READY message after entering or deleting a line of BASIC
	jmp basic_read_next_line
	
not_a_line:	

	;;  Actually interpret the line

	;; Setup pointer to the statement
	lda #<$0200
	sta basic_current_statement_ptr+0
	lda #>$0200
	sta basic_current_statement_ptr+1

	;; There is no stored line, so zero that pointer out
	lda #$00
	sta basic_current_line_ptr+0
	sta basic_current_line_ptr+1

	;; Put invalid line number in current line number value,
	;; so that we know we are in direct mode
	;; (Compute's Mapping the 64 p19)
	lda #$ff
	sta basic_current_line_number+1

	jmp basic_execute_line

