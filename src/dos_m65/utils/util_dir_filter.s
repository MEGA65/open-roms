
; Check if file name matches the filter (if so - Zero flag set)


util_dir_filter:

	lda PAR_FPATTERN
	cmp #$A0
	beq @done                          ; branch if no filter

	ldy #$00

@lp1:

	lda PAR_FPATTERN, y
	cmp #'*'
	beq @done                          ; branch on wildcard

	cmp PAR_FNAME, y
	bne @done                          ; branch if does not match

	iny
	cpy #$10
	bne @lp1                           ; next iteration if maximum length not reached

@done:

	rts
