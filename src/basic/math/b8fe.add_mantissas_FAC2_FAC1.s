;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - add FAC2 mantissa to FAC1
;
; This is verified to be identical to the original Microsoft implementation where it was named FADD2.
;
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 112
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

add_mantissas_FAC2_FAC1:

    adc OLDOV
    sta FACOV

    lda FAC1_mantissa+3
    adc FAC2_mantissa+3
    sta FAC1_mantissa+3

    lda FAC1_mantissa+2
    adc FAC2_mantissa+2
    sta FAC1_mantissa+2

    lda FAC1_mantissa+1
    adc FAC2_mantissa+1
    sta FAC1_mantissa+1

    lda FAC1_mantissa+0
    adc FAC2_mantissa+0
    sta FAC1_mantissa+0

    jmp shift_carry_into_FAC1
