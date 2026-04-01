;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - multiplies FAC1 by FAC2
;
; This is verified to be identical to the original Microsoft implementation where it was named FMULTT
;
; Input:
; - .A - must load FAC1 exponent ($61) beforehand to set the zero flag
;
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 113 XXX address does not match
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

mul_FAC2_FAC1:

        bne @1
        jmp MULTRT              ; If FAC1=0 return. FAC1 is set
@1:     jsr MULDIV              ; Fix up the exponents
        lda #0                  ; To clear result
        sta RESHO+0
        sta RESHO+1
        sta RESHO+2
        sta RESHO+3
        lda FACOV
        jsr MLTPLY
        lda FAC1_mantissa+3
        jsr MLTPLY
        lda FAC1_mantissa+2
        jsr MLTPLY
        lda FAC1_mantissa+1
        jsr MLTPLY
        lda FAC1_mantissa+0
        jsr MLTPL1
        jmp mov_RES_FAC1            ; Move result into FAC1, normalize and return
        
MLTPLY:
        bne MLTPL1
        jmp shift_for_mul_RES       ; Shift result right 1 byte
MLTPL1:
        lsr
        ora #$80
MLTPL2:
        tay
        bcc MLTPL3                  ; If mult bit=0, just shift
        clc
        lda RESHO+3
        adc FAC2_mantissa+3
        sta RESHO+3
        lda RESHO+2
        adc FAC2_mantissa+2
        sta RESHO+2
        lda RESHO+1
        adc FAC2_mantissa+1
        sta RESHO+1
        lda RESHO+0
        adc FAC2_mantissa+0
        sta RESHO+0
MLTPL3:
        ror RESHO+0
        ror RESHO+1
        ror RESHO+2
        ror RESHO+3
        ror FACOV       ; Save for rounding
        tya
        lsr             ; Clear MSB so we get closer to 0
        bne MLTPL2      ; Slow as a turtle!
MULTRT:
        rts
