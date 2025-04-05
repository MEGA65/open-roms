;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - evaluate FAC1 sign, to .A
;
; Output:
; - .A - 0 for FAC1 equal 0, 1 for FAC1 > 0, -1 for FAC1 < 0
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 115
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

sgn_FAC1_A:

	lda FAC1_exponent
	beq @1
	lda FAC1_sign
	bmi @2
	lda #$01
@1:
	rts
	
@2:
    lda #$FF
    rts
