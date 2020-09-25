;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; CHROUT routine - convert PETSCII to screen code
;


chrout_to_screen_code:

	; Codes $C0-$DF become $40-$5F
	cmp #$E0
	bcs @1
	cmp #$C0
	bcc @1
	
	and #$7F
	rts                                ; not high char
@1:
	; Range $20-$3F is unchanged
	cmp #$40
	bcc @done                          ; not high char

	; Unshifted letters and symbols from $40-$5F
	; all end up being -$40
	; (C64 PRG p376)

	; But anything >= $80 needs to be -$40
	; (C64 PRG p380-381)
	; And bit 7 should be cleared, only to be
	; set by reverse video
	sec
	sbc #$40

	; Fix shifted chars by adding $20 again
	cmp #$20
	bcc @done                          ; not high char
	cmp #$40
	bcs @done                          ; not high char
	clc
	adc #$20

	; FALLTROUGH

@done:

	rts
