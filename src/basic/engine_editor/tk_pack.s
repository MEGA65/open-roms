;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# M65 BASIC_1 #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Packs a keyword candidate using a simple compression scheme,
; same as in 'generate_strings.cc'.
;
; This allows us to search through the compressed tokens directly
; using the compressed fragment of BASIC, and thus work out the
; token for a given piece of string.
;
; This also helps ensure that we have an implementation that is totally
; different to that of the original C64 BASIC, as well as likely
; saving a bit of space in the ROM, especially once we start implementing
; larger keyword vocabs for extended BASIC, since the compression and
; decompression machinery is of fixed size.
;
; Input:
; - .X = offset of string to pack, address is BUF ($0200) + .X
; Output:
; - see labels in 'tk_pack'
;


tk_pack:

	; Initialize variables

	lda #$00
	ldy #($04 + 25)                    ; initialize 5 bytes of data + 25 bytes of space for packing
@1:
	sta tk__len_unpacked, y
	dey
	bpl @1

	; FALLTROUGH

tk_pack_loop:

	; Get the next character

	lda BUF, x

	; If character cannot be a part of a keyword - do not pack anything more

	cmp #$23                           ; '#' - first sane character for a keyword
	bcc tk_pack_done                   ; branch if below '#'
	cmp #$7B                           ; 'Z' + 1
	bcs tk_pack_done                   ; branch if above 'Z'

	; Keywords should not contain digits, colons, or semicolons

	cmp #$30
	bcc @2                             ; branch if below '0'
	cmp #$3C
	bcc tk_pack_done                   ; branch if below '<'
@2:
	; Try to find a nibble to encode the character

	ldy #$0E
@3:
	cmp packed_as_1n-1, y 
	beq tk_pack_1n

	dey
	bne @3

	; Try to find a 3-nibble sequence to encode the character (1st nibble is always 0xF in this case)

	ldy #TK__PACKED_AS_3N
@4:
	cmp packed_as_3n-1, y 
	beq tk_pack_3n

	dey
	bne @4

	; If it is not on the list, it cannot be a part of token - quit

	; FALLTROUGH

tk_pack_done:

	rts

tk_pack_1n:

	; .Y contains our nibble; check whether we should start a new encoded byte

	bit tk__nibble_flag
	bpl tk_pack_1n_new_byte

	; Store in the high nibble of the current byte

	tya

	asl
	asl
	asl
	asl

	ldy tk__byte_offset
	ora tk__packed, y
	sta tk__packed, y

	; Adjust remaining counters / flags

	inc tk__byte_offset
	inc tk__nibble_flag                ; $FF -> $00

	; FALLTROUGH

tk_pack_1n_done:

	; Put the bit mark - to indicate 1-nibble encoding

	clc
	ror tk__shorten_bits+0
	ror tk__shorten_bits+1

	; FALLTROUGH

tk_pack_loop_next:

	; Prepare for the next loop iteration - increment counters

	inx
	inc tk__len_unpacked

	; Check length, if it is OK to pack one more byte; quit if not

	lda tk__len_unpacked
	cmp #TK__MAX_KEYWORD_LEN
	beq @5                             ; if max length reached - quit

	; Check for characters that can only end the keyword

	lda BUF-1, x
	cmp #$41
	bcs tk_pack_loop
@5:
	rts

tk_pack_1n_new_byte:

	; Store in the low nibble of the next byte

	tya
	ldy tk__byte_offset
	sta tk__packed, y

	; Adjust remaining counters / flags

	dec tk__nibble_flag                ; $00 -> $FF
	bmi tk_pack_1n_done

tk_pack_3n:

	; .Y contains 2 nibbles to encode; check whether we should start a new encoded byte

	bit tk__nibble_flag
	bpl tk_pack_3n_new_byte

	; Store 1st nibble (alwys 0xF) in the high nibble of the current byte

	+phy_trash_a

	lda #$F0
	ldy tk__byte_offset
	ora tk__packed, y
	sta tk__packed, y

	; Store byte in the next byte

	iny
	pla
	sta tk__packed, y

	; Adjust remaining counters / flags

	iny
	sty tk__byte_offset
	inc tk__nibble_flag                ; $FF -> $00

	; FALLTROUGH

tk_pack_3n_done:

	; Put the bit mark - to indicate 3-nibble encoding

	sec
	ror tk__shorten_bits+0
	ror tk__shorten_bits+1

	bcc tk_pack_loop_next              ; branch always

tk_pack_3n_new_byte:

	; First store everything in the current byte, we will set '0xF' mark later

	tya
	ldy tk__byte_offset
	sta tk__packed, y

	; Now store just the low nibble in the next byte

	iny
	and #$0F
	sta tk__packed, y

	; Go back for a moment and set the '0xF' mark in the low nibble

	dey
	lda tk__packed, y
	ora #$0F
	sta tk__packed, y
	iny

	; Adjust remaining counters / flags

	sty tk__byte_offset
	dec tk__nibble_flag                ; $00 -> $FF

	bmi tk_pack_3n_done                ; branch always
