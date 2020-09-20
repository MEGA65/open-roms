;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Tries to convert PETSCII in .A to a digit (0-9 values), sets Carry to indicate failure
;

convert_PETSCII_to_digit:

	sec
	sbc #$30
	bcc convert_PETSCII_to_digit_fail

	cmp #$0A
	rts

convert_PETSCII_to_digit_fail:

	sec
	rts
