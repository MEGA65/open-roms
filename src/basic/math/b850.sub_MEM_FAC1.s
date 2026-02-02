;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - subtract FAC1 from memory variable
;
; Input:
; - .A - address low byte
; - .Y - address high byte
;
; This is verified to be identical to the original Microsoft implementation where it was named FSUB.
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 112
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

sub_MEM_FAC1:

	jsr mov_MEM_FAC2

	; FALLTROUGH to sub_FAC2_FAC1
