;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# CRT BASIC_0 #TAKE
;; #LAYOUT# M65 BASIC_1 #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Search for a token on the list pointed by FRESPC
;
; Input:
; - list address in FRESPC, has to be refreshed after routine call
; - uses same variables as 'tk_pack'
; Output:
; - Carry set = not found
; - .X = index of token found
;


tk_search:

	ldx #$00                           ; initial token index

	; FALLTROUGH

tk_search_loop:

	; Check if end of the list

	ldy #$00
	lda (FRESPC), y
	cmp #$FF
	bne tk_search_compare
	iny
	lda (FRESPC), y
	dey
	cmp #$FF
	bne tk_search_compare

	; End of the list

	sec
	rts

tk_search_compare:

	; Compare the packed candidate with the current keyword list entry

	lda (FRESPC), y
	cmp tk__packed, y
	bne tk_search_not_matching

	cmp #$00
	beq tk_search_found

	; For now everything matches, try the next byte

	iny
	bne tk_search_compare              ; branch always

tk_search_not_matching:

	inx                                ; increment token index

	; We need to find the end of the keyword on the list
	; and proceed one byte further

	cmp #$00
	beq tk_search_next
@1:
	iny
	lda (FRESPC), y
	bne @1

	; FALLTROUGH

tk_search_next:

	; Update FRESPC - advance by .Y

	iny
	tya
	clc
	adc FRESPC+0
	sta FRESPC+0
	lda FRESPC+1
	adc #$00
	sta FRESPC+1

	bcc tk_search_loop                 ; branch always

tk_search_found:

	clc
	rts
