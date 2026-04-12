;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *  BASIC_0  #TAKE
;; #LAYOUT# *   *       #IGNORE


; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Polynomial for the logarithm function

; This is verified to be identical to the original Microsoft implementation where it was named LOGCN2

!ifdef CONFIG_TRANSCENDENTAL_FUNCTIONS {


poly_log:

    !byte $03                          ; series length - 1

    +PUT_CONST_POLY_LOG_1
    +PUT_CONST_POLY_LOG_2
    +PUT_CONST_POLY_LOG_3
    +PUT_CONST_POLY_LOG_4


}
