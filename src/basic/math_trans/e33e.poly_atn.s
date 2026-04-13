;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *  BASIC_0  #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Polynomial for the atn function
;
; This is verified to be identical to the original Microsoft implementation where it was named ATNCON


!ifdef CONFIG_TRANSCENDENTAL_FUNCTIONS {


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


}
