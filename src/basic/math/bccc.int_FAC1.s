;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - rounds away the decimal to make an integer
;
; This is verified to be identical to the original Microsoft implementation where it was named INT.
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 116
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

int_FAC1:

    lda FAC1_exponent
    cmp #$A0
    bcs clear_FAC1_rts
    jsr QINT
    sty FACOV
    lda FAC1_sign
    sty FAC1_sign
    eor #$80
    rol
    lda #$A0
    sta FAC1_exponent
    lda FAC1_mantissa+3
    sta CHARAC                  ; INTEGR in the original code ($07)
    jmp abs_and_normal_FAC1
