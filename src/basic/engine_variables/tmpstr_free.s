;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Frees the string if it belongs to temporary string stack
;
; Input:
; - DSCPNT+1/+2 - pointer to string (depending on the call addres, can fetch from FAC1/FAC2)
;


tmpstr_free_FAC1:

	lda __FAC1+1
	sta DSCPNT+1
	lda __FAC1+2

	+bra tmpstr_free_FAC2_cont

tmpstr_free_FAC2:

	lda __FAC2+1
	sta DSCPNT+1
	lda __FAC2+2

	; FALLTROUGH

tmpstr_free_FAC2_cont:

	sta DSCPNT+2

	; FALLTROUGH

tmpstr_free:

	; First find the descriptor matching the given string

	ldx #$19

	;FALLTROUGH

tmpstr_free_loop:

	cpx TEMPPT
	bne @1
	rts                                ; quit if not found
@1:
	; First fetch the string size - if 0, do not even try to compare

	ldy $00, x
	beq tmpstr_free_next_3

	; Check if current string
	
	inx
	lda $00, x
	cmp DSCPNT+1
	bne tmpstr_free_next_2

	inx
	lda $00, x
	cmp DSCPNT+2
	bne tmpstr_free_next_1

	; This is the string we need to free

	sty DSCPNT+0
	+phx_trash_a
	jsr varstr_free_no_checks
	+plx_trash_a

	; Mark empty string as free and quit

	dex
	dex
	lda #$00
	sta $00, x

	rts

tmpstr_free_next_3:

	inx

	; FALLTROUGH

tmpstr_free_next_2:

	inx

	; FALLTROUGH

tmpstr_free_next_1:

	inx
	bne tmpstr_free_loop
