	;; Print string at $YYAA
	;; Compute's Mapping the 64 p101

print_string:
	;; Setup pointer	
	sty temp_string_ptr+1
	sta temp_string_ptr+0

	txa			
	pha

	;; Get offset ready
	ldy #$00

print_string_loop:	
	;; Save Y in X, since X is preserved by chrout, but Y is not
	tya
	tax

	lda (temp_string_ptr),y
	beq print_string_end

	jsr JCHROUT

	txa
	tay

	iny
	bne print_string_loop


print_string_end:

	pla
	tax
	rts
