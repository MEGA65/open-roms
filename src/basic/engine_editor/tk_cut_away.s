;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# CRT BASIC_1 #TAKE
;; #LAYOUT# M65 BASIC_1 #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Cuts away unnecessary characters after tokenizing a keyword
;


tk_cut_away_2: ; for two-bytes tokenized keywords

	dec tk__len_unpacked

	; FALLTROUGH

tk_cut_away_1: ; for single-byte tokenized keywords

	dec tk__len_unpacked                         ; keyword length, afterwards number of bytes to cut away

	; Correct the line length

	sec
	lda tk__length
	sbc tk__len_unpacked
	sta tk__length

	; Copy the remaining,. untokenized part in the proper place

	inc tk__offset
	ldy tk__offset

	lda tk__len_unpacked
	clc
	adc tk__offset
	tax
@1:
	lda BUF, x
	sta BUF, y
	beq @2

	inx
	iny
	bne @1
@2:
	rts
