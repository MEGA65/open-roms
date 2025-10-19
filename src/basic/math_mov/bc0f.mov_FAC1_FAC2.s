;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

;
; Math package - move FAC1 to FAC2
;
; This is verified to be identical to the original Microsoft implementation where it was named MOVEF.
;
; Output:
; - .A - FAC1 exponent
; - .X - always 0

; Preserves:
; - .Y
;
; Note:
; - Always clears FACOV, not sure why
;
; See also:
; - https://github.com/microsoft/BASIC-M6502/blob/7460af2c03ae19c0e60ff327489229d2005b9357/m6502.asm#L5540C1-L5548C12
; - [CM64] Computes Mapping the Commodore 64 - page 115
; - https://www.c64-wiki.com/wiki/BASIC-ROM
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
;

mov_FAC1_FAC2:

    ldx #6

@1
    lda FAC1_exponent - 1,X
    sta FAC2_exponent - 1,X
    dex
    bne @1
    stx FACOV           ; Always zero
    rts
