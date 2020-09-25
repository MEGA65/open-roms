;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Helper routine for FRETOP handling
;


helper_FRETOP_up:                    ; DSCPNT+0 - bytes to increment FRETO

	clc
	lda FRETOP+0
	adc DSCPNT+0
	sta FRETOP+0
	bcc @1
	inc FRETOP+1
@1:
	rts
