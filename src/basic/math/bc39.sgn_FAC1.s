;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - evaluate FAC1 sign, to FAC1
;
; Output:
; - FAC1 - 0 for FAC1 equal 0, 1 for FAC1 > 0, -1 for FAC1 < 0
;
; This is verified to be identical to the original Microsoft implementation where it was named SGN.
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 115
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

sgn_FAC1:
	jsr sgn_FAC1_A

	; Fallthrough to convert_A_to_FAC1
