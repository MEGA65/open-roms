;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Checks if there is enough memory free for array
;
; Input:
; __FAC1+0    - number of dimensions
; __FAC1+1/+2 - bytes needed for storage
;
; Uses INDEX+2/+3, preserves .X and .Y
;


helper_array_create_checkmem:

	; First calculate FRETOP - STREND

	sec
	lda FRETOP+0
	sbc STREND+0
	sta INDEX+2
	lda FRETOP+1
	sbc STREND+1
	sta INDEX+3
	bcc helper_array_create_checkmem_fail

	; INDEX+2/+3 contains the amount of memory left, subtract the space needed for storage

	lda INDEX+2
	sbc __FAC1+1
	sta INDEX+2
	lda INDEX+3
	sbc __FAC1+2
	sta INDEX+3
	bcc helper_array_create_checkmem_fail

	; If high byte (INDEX+3) > 0, then we certainly have enough space

	lda INDEX+3
	bne helper_array_create_checkmem_success

	; We have very little memory left - we need at least number of dimensions*2 + 5 bytes

	lda __FAC1+0
	asl
	clc
	adc #$04

	cmp INDEX+2
	bcs helper_array_create_checkmem_fail

	; FALLTROUGH

helper_array_create_checkmem_success:

	rts

helper_array_create_checkmem_fail:

	jmp do_OUT_OF_MEMORY_error
