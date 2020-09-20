;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


;
; Copies the memory down
;
; Input:
; - memmove__src  - pointer to the first byte of source
; - memmove__dst  - pointer to the first byte of destination
; - memmove__size - number of bytes to copy
;
; All the input variables, .A, and .Y register, are destroyed. Also uses memmove__tmp variable.
;


shift_mem_down:

	; The copy routine is simplified, so that it is fast and (for memory model 60K)
	; can fit in a small RAM area - therefore it requires to pre-set .Y, so that
	; the copy ends when it reaches 0; so if copying one byte we want .Y = $FF

	sec
	lda #$00
	sbc memmove__size+0
	tay

	; Now we have to move down the memmove_src and memmove_dst pointers to compensate for .Y not being 0

	jsr shift_mem_adapt_pointers

!ifdef CONFIG_MEMORY_MODEL_38K {

shift_mem_down_internal:

	; Move memmove__size bytes from memmove__src to memmove__dst, where memmove__dst > memmove__src
	;
	; This means we have to copy from the back end down.
	; This routine assumes the pointers are already pointed to the end of the areas, and that .Y is correctly initialized

	php
@1:
	lda (memmove__src),y
	sta (memmove__dst),y
	iny
	bne @1
	inc memmove__src+1
	inc memmove__dst+1
	dec memmove__size+1
	bne @1
	plp
	rts

} else {

	jmp shift_mem_down_internal
}
