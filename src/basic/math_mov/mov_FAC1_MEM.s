;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - copy FAC1 to memory location, do not round
;
; Input:
; - .X - address low byte
; - .Y - address high byte
;
; Output:
; - .A - FAC1 exponent
;
; See also:
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

mov_FAC1_MEM:

	; Original routines use $22/$23 location for a vector too, see here:
	; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics

	sty INDEX+1
	stx INDEX+0

	ldy #$00

	; Copy exponent

	lda FAC1_exponent
	sta (INDEX), y
	beq mov_FAC1_MEM_end               ; for 0 no need to copy anything more

	; Copy first byte of mantissa

	iny
	lda FAC2_mantissa+3
	sta (INDEX), y

	; Copy the sign       XXX try to optimize this part

	lda FAC1_sign
	bne @1

	lda FAC2_mantissa+3
	and #$7F
	sta (INDEX), y
@1:
	; Copy remaining parts of mantissa

	iny
	lda FAC2_mantissa+2
	sta (INDEX), y

	iny
	lda FAC2_mantissa+1
	sta (INDEX), y

	iny
	lda FAC2_mantissa+0
	sta (INDEX), y

	; Checked, that mov_FAC1_MEM works on real ROM too (at $BBD7),
	; and clears FACOV in a similar way as mov_FAC1_FAC2 does (not surprising)

	ldy #$00
	sty FACOV

mov_FAC1_MEM_end:

	lda FAC1_exponent
	rts
