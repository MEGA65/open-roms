;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - add 0.5 to FAC1
;
; This is verified to be identical to the original Microsoft implementation where it was named FADDH.
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 112

add_HALF_FAC1:

	lda #<const_HALF
	ldy #>const_HALF

	jmp add_MEM_FAC1
