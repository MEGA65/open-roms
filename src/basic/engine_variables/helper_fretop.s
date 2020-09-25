;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Helper routines for FRETOP handling
;

helper_FRETOP_down_A:                  ; .A - bytes to lower FRETOP, uses DSCPNT+0

	sta DSCPNT+0 

	sec
	lda FRETOP+0
	sbc DSCPNT+0 
	sta FRETOP+0
	bcs @1
	dec FRETOP+1
@1:
	; FALLTROUGH

helper_FRETOP_check:                   ; check if FRETOP > STREND, Carry set if not

	lda STREND+1
	cmp FRETOP+1
	beq @2
	rts
@2:
	lda STREND+0
	cmp FRETOP+0
	rts
