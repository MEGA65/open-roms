;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - arc tangent of FAC1
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 211
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

; XXX provide implementation

atn_FAC1:

	+STUB_IMPLEMENTATION
	
poly_atn:

    !byte $0B                          ; series length - 1

    +PUT_CONST_POLY_ATN_1
    +PUT_CONST_POLY_ATN_2
    +PUT_CONST_POLY_ATN_3
    +PUT_CONST_POLY_ATN_4
    +PUT_CONST_POLY_ATN_5
    +PUT_CONST_POLY_ATN_6
    +PUT_CONST_POLY_ATN_7
    +PUT_CONST_POLY_ATN_8
    +PUT_CONST_POLY_ATN_9
    +PUT_CONST_POLY_ATN_10
    +PUT_CONST_POLY_ATN_11
    +PUT_CONST_POLY_ATN_12
