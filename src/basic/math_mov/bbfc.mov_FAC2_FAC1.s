;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - Copy FAC2 to FAC1
;
; This is verified to be identical to the original Microsoft implementation where it was named MOVFA.
;
; It has an alternative entry point at mov_FAC2_FAC1_sign (original: MOVFA1) that instead of copying the sign uses A for the copied sign.
;
; Output (found by experimentation):
; - .A - FAC1 exponent
; - .X - always 0
;
; Preserves:
; - .Y
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 115
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;


mov_FAC2_FAC1:
    ; Copy the sign

    lda FAC2_sign

mov_FAC2_FAC1_sign:
    sta FAC1_sign

    ; Copy the mantissa and the exponent

    ldx #5

@1
    lda FAC2_exponent - 1,X
    sta FAC1_exponent - 1,X
    dex
    bne @1
    stx FACOV           ; Always 0
    rts
