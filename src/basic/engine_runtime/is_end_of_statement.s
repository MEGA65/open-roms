;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Check for end of statement, sets Carry if so. Injests all spaces.
;


is_end_of_statement:

	jsr fetch_character_skip_spaces

	cmp #$00
	beq @1
	cmp #$3A
	beq @1

	; Not end of statement

!ifndef HAS_OPCODES_65CE02 {
	jsr unconsume_character
} else {
	dew TXTPTR
}

	clc
	rts
@1:
	; End of statement

!ifndef HAS_OPCODES_65CE02 {
	jsr unconsume_character
} else {
	dew TXTPTR
}

	sec
	rts
