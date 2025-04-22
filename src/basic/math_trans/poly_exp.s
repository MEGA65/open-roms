;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *  BASIC_0  #TAKE
;; #LAYOUT# *   *       #IGNORE

; Polynomial for the exponential function


!ifdef CONFIG_TRANSCENDENTAL_FUNCTIONS {


poly_exp:

    !byte $07                          ; series length - 1

    +PUT_CONST_POLY_EXP_1
    +PUT_CONST_POLY_EXP_2
    +PUT_CONST_POLY_EXP_3
    +PUT_CONST_POLY_EXP_4
    +PUT_CONST_POLY_EXP_5
    +PUT_CONST_POLY_EXP_6
    +PUT_CONST_POLY_EXP_7
    +PUT_CONST_POLY_EXP_8


}
