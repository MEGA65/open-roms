;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE


; 'Print immediate', original implementation by Mike Barry, adapted to 65CE02, modified to preserve .Y
; see http://www.6502.org/source/io/primm.htm


PRIMM:

	pla            ; get low part of (string address-1)
	sta PTR1
	pla            ; get high part of (string address-1)
	sta PTR2
	phy
	+bra @2
@1:
	jsr JCHROUT    ; output a string char
@2:
	inc PTR1       ; advance the string pointer
	bne @3
    inc PTR2
@3:
	ldy #$00
	lda (PTR1), y  ; get string char
	bne @1         ; output and continue if not NUL
	ply
	lda PTR2
	pha
	lda PTR1
	pha

	rts
