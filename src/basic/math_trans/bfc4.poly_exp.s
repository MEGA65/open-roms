;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *  BASIC_0  #TAKE
;; #LAYOUT# *   *       #IGNORE


; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Polynomial for the exponential function

; This is verified to be identical to the original Microsoft implementation where it was named EXPCON.


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

    ; The constant const_ONE now follows as part of this polynomial

}
