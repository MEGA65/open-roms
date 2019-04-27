	;; Return C=1 if a pointer in BASIC memory space is NULL, else C=0
	;; X = ZP pointer to check

peek_pointer_null_check:
	ldy #$00
	jsr peek_under_roms
	bne ptr_not_null
	iny
	jsr peek_under_roms
	bne ptr_not_null

	;; Pointer is NULL
	clc
	rts
ptr_not_null:
	sec
	rts
	
