;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - Copy RES to FAC1
;
; This is verified to be identical to the original Microsoft implementation where it was named MOVFR.
;


mov_RES_FAC1:
    lda RESHO
    sta FAC1_mantissa
    lda RESHO+1
    sta FAC1_mantissa+1
    lda RESHO+2
    sta FAC1_mantissa+2
    lda RESHO+3
    sta FAC1_mantissa+3
    jmp normal_FAC1
