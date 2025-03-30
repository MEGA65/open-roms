;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - natural logarigthm
;
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 113
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

; XXX provide implementation

log_FAC1:

	+STUB_IMPLEMENTATION


poly_log:

    !byte $03                          ; series length - 1

    +PUT_CONST_POLY_LOG_1
    +PUT_CONST_POLY_LOG_2
    +PUT_CONST_POLY_LOG_3
    +PUT_CONST_POLY_LOG_4
