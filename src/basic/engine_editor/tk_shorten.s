;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# M65 BASIC_1 #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Shortens a keyword candidate previously packed by tk_pack by 1 character
;
; Input:
; - uses same variables as 'tk_pack'
;


tk_shorten:

	; First make sure we actually can shorten anything

	dec tk__len_unpacked
	beq tk_shorten_end

	; Now check if the last character was encoded as 1 nibble or 3 nibbles

	asl tk__shorten_bits+1
	rol tk__shorten_bits+0
	bcs tk_shorten_3n

	; FALLTROUGH

tk_shorten_1n:

	ldy tk__byte_offset                ; will be needed in both cases

	; Now we need to check which nibble to cut away
	bit tk__nibble_flag
	bmi tk_shorten_1n_lo

	; FALLTROUGH

tk_shorten_1n_hi:                      ; tk__nibble_flag = $00, both nibbles free

    ; Go back one byte and clear the high nibble only

    dey
    sty tk__byte_offset

	lda tk__packed, y
	and #$0F
	sta tk__packed, y

	; Adjust remaining counters / flags, and quit

	dec tk__nibble_flag                ; $00 -> $FF

	; FALLTROUGH

tk_shorten_end:

	rts

tk_shorten_1n_lo:                      ; tk__nibble_flag = $FF, only the high nibble is free

	; Clear the whole byte, it will be faster

	lda #$00
	sta tk__packed, y

	; Adjust remaining counters / flags, and quit

	inc tk__nibble_flag                ; $FF -> $00
	rts

tk_shorten_3n:

	ldy tk__byte_offset                ; will be needed in both cases
	lda #$00

	; Now we need to check which nibble to cut away

	bit tk__nibble_flag
	bmi tk_shorten_3n_2bytes

	; FALLTROUGH

tk_shorten_3n_byte_nibble:             ; tk__nibble_flag = $00, both nibbles free

    ; Go back one byte, clear it, go back and clear the high nibble only

	dey
	sta tk__packed, y

	; Reuse 'tk_shorten_1n_hi'

	sty tk__byte_offset
	+bra tk_shorten_1n_hi

tk_shorten_3n_2bytes:                  ; tk__nibble_flag = $FF, only the high nibble is free

    ; Clear the byte, go back, clear one more byte

	sta tk__packed, y
	dey
	sta tk__packed, y

	; Adjust remaining counters / flags, and quit

	sty tk__byte_offset
	inc tk__nibble_flag                ; $FF -> $00
	rts
