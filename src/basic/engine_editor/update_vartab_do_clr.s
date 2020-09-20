;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Calculate the VARTAB value - to mark the end of BASIC program code. Also clears all variables.
;

update_VARTAB_do_clr:

	lda TXTTAB+0
	sta OLDTXT+0
	lda TXTTAB+1
	sta OLDTXT+1
@1:
	lda OLDTXT+0
	sta VARTAB+0
	lda OLDTXT+1
	sta VARTAB+1

	jsr follow_link_to_next_line

	lda OLDTXT+0
	ora OLDTXT+1
	bne @1                                       ; branch if pointer not NULL

	; Correct VARTAB by 2 bytes NULL pointer

!ifdef HAS_OPCODES_65CE02 {

	inw VARTAB
	inw VARTAB

} else {

	clc
	lda VARTAB+0
	adc #$02
	sta VARTAB+0
	bcc @2
	inc VARTAB+1
@2:
}

	; Call CLR to set-up remaining variables

	jmp do_clr
