;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *  BASIC_0  #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Polynomial for the sine function
;
; This is 2 coefficients shorter than SINCON in the Microsoft implementation.
; See https://www.c64-wiki.com/wiki/SIN


!ifdef CONFIG_TRANSCENDENTAL_FUNCTIONS {


poly_sin:

	!byte $05                          ; series length - 1

	+PUT_CONST_POLY_SIN_1
	+PUT_CONST_POLY_SIN_2
	+PUT_CONST_POLY_SIN_3
	+PUT_CONST_POLY_SIN_4
	+PUT_CONST_POLY_SIN_5
    +PUT_CONST_POLY_SIN_6

}
