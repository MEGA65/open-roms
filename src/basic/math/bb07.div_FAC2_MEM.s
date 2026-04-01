;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - divide FAC2 by MEM
;
; This is verified to be identical to the original Microsoft implementation where it was named FDIVF.
;
; Input:
; - .A - address low byte
; - .Y - address high byte
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 114
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

div_FAC2_MEM:

        stx	ARISGN
	    jsr mov_MEM_FAC1
	    jmp div_FAC2_FAC1
