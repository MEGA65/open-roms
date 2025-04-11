;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *  BASIC_0  #TAKE
;; #LAYOUT# *   *       #IGNORE

; Polynomial for the logarithm function

poly_log:

    !byte $03                          ; series length - 1

    +PUT_CONST_POLY_LOG_1
    +PUT_CONST_POLY_LOG_2
    +PUT_CONST_POLY_LOG_3
    +PUT_CONST_POLY_LOG_4
