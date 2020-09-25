;; #LAYOUT# STD *       #TAKE-HIGH
;; #LAYOUT# *   BASIC_0 #TAKE-HIGH
;; #LAYOUT# *   *       #IGNORE

; This has to go $E000 or above - as the routines below bank out the main BASIC ROM!


!ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {


shift_mem_up_internal:

	; Move memmove__size bytes from memmove__src to memmove__dst, where memmove__dst > memmove__src
	;
	; This means we have to copy from the back end down.
	; This routine assumes the pointers are already pointed to the end of the areas, and that .Y is correctly initialized

	; Unmap BASIC lower ROM

	php

	lda #$26
	sta CPU_R6510

	; Perform the copying
@1:	
	lda (memmove__src),y
	sta (memmove__dst),y
	dey
	bne @1
	dec memmove__src+1
	dec memmove__dst+1
	dec memmove__size+1
	bne @1

	+bra shift_mem_internal_finalize


shift_mem_down_internal:

	; Move memmove__size bytes from memmove__src to memmove__dst, where memmove__dst > memmove__src
	;
	; This means we have to copy from the back end down.
	; This routine assumes the pointers are already pointed to the end of the areas, and that .Y is correctly initialized

	; Unmap BASIC lower ROM

	php

	lda #$26
	sta CPU_R6510

	; Perform the copying
@2:
	lda (memmove__src),y
	sta (memmove__dst),y
	iny
	bne @2
	inc memmove__src+1
	inc memmove__dst+1
	dec memmove__size+1
	bne @2

	; FALLTROUGH

shift_mem_internal_finalize:

	; Restore memory mapping and quit

	lda #$27
	sta CPU_R6510
	
	plp

	rts
}
