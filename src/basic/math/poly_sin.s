;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *  BASIC_0  #TAKE
;; #LAYOUT# *   *       #IGNORE

; Polynomial for the sine function


poly_sin:

	!byte $05                          ; series length - 1

	+PUT_CONST_POLY_SIN_1
	+PUT_CONST_POLY_SIN_2
	+PUT_CONST_POLY_SIN_3
	+PUT_CONST_POLY_SIN_4
	+PUT_CONST_POLY_SIN_5
	+PUT_CONST_POLY_SIN_6

	
; Constant 0.75 needed for sine calculation
sin_three_quarters:
    !byte $80, $40, $00, $00, $00
