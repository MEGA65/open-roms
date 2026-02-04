;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - normalize FAC1
;
; This is verified to be identical to the original Microsoft implementation where it was named NORMAL.
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 113
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;


normal_FAC1:

    ldy #0
    tya
    clc
@1:
    ldx FAC1_mantissa+0
    bne NORM1
    ldx FAC1_mantissa+1     ; Shift 8 bites at a time for speed
    stx FAC1_mantissa
    ldx FAC1_mantissa+2
    stx FAC1_mantissa+1
    ldx FAC1_mantissa+3
    stx FAC1_mantissa+2
    ldx FACOV
    stx FAC1_mantissa+3
    sty FACOV
    adc #8
    cmp #$20
    bne @1

    ; Fallthrough to zero_FAC1
