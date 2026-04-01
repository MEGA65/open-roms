;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - multiply FAC1 by 10
;
; This is verified to be identical to the original Microsoft implementation where it was named MUL10
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 114
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

mul10_FAC1:

MUL10:	

        jsr mov_r_FAC1_FAC2
        tax
        beq MUL10R
        clc
        adc #2
        bcs GOOVER      ; Closest jmp to overflow
FINML6: ldx #0
        stx ARISGN
        jsr FADDC
        inc FAC1_exponent
        beq GOOVER
MUL10R: rts
