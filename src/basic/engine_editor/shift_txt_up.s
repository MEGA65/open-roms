;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


;
; Shift the BASIC program up to make space for a new line
;


shift_txt_up:
	
	; Last byte of source is VARTAB-1

!ifndef HAS_OPCODES_65CE02 {

	sec
	lda VARTAB+0
	sbc #$01
	sta memmove__src+0
	lda VARTAB+1
	sbc #$00
	sta memmove__src+1	

} else { ; HAS_OPCODES_65CE02

	lda VARTAB+0
	sta memmove__src+0
	lda VARTAB+1
	sta memmove__src+1
	dew memmove__src
}

	; Last byte of destination is memmove__src + .X

	clc
	txa

	adc memmove__src+0
	sta memmove__dst+0
	lda memmove__src+1
	adc #$00
	sta memmove__dst+1

	; Size is distance from OLDTXT to the end of BASIC text (VARTAB)

	lda VARTAB+0
	sec
	sbc OLDTXT+0
	sta memmove__size+0
	lda VARTAB+1
	sbc OLDTXT+1
	sta memmove__size+1

	; Perform the copy

	jmp shift_mem_up
