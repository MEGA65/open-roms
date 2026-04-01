;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - divide FAC1 by 10, result is always positive
;
;
; This is verified to be identical to the original Microsoft implementation where it was named DIV10.
;
; Notes:
; - moves FAC1 to FAC2, loads FAC1 with the constant 10, falls through to the division routine

;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 114
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

div10_FAC1_p:

    	jsr	mov_r_FAC1_FAC2
        lda #<const_TEN
        ldy #>const_TEN
	    ldx #0      		    ; SIGNS ARE BOTH POSITIVE.

        ; Fallthrough to div_FAC2_MEM
