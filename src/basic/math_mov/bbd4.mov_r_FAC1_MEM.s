;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - copy FAC1 to memory location, do not round
;
; This is verified to be identical to the original Microsoft implementation where it was named MOVMF.
;
; Input:
; - .X - address low byte
; - .Y - address high byte
;
; Output:
; - .A - FAC1 exponent
; - .Y - 0

; See also:
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

mov_r_FAC1_MEM:
	
    jsr round_FAC1
    stx INDEX+0
    sty INDEX+1
    ldy #4
    lda FAC1_mantissa+3
    sta (INDEX),y
    dey
    lda FAC1_mantissa+2
    sta (INDEX),y
    dey
    lda FAC1_mantissa+1
    sta (INDEX),y
    dey
    lda FAC1_sign
    ora #$7F
    and FAC1_mantissa
    sta (INDEX),y
    dey
    lda FAC1_exponent
    sta (INDEX),y
    sty FACOV
    rts
