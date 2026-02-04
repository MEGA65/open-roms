;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - add FAC2 to FAC1
;
; Input:
; - .A - must load FAC1 exponent ($61) beforehand to set the zero flag
;
; This is verified to be identical to the original Microsoft implementation where it was named FADDT.
;
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 112
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

add_FAC2_FAC1:

    bne @1              ; If FAC1=0 result is in FAC2
    jmp mov_FAC2_FAC1
@1:
    ldx FACOV
    stx OLDOV
    ldx #FAC2_exponent
    lda FAC2_exponent
FADDC:
    tay
    beq FADDC;ZERRTS
    sec
    sbc FAC1_exponent
    beq FADD4           ; No shifting
    bcc @1              ; Branch if FAC2_exponent < FAC1_exponent
    sty FAC1_exponent   ; Resulting exponent
    ldy FAC2_sign       ; Since FAC2 is larger, its
    sty FAC1_sign       ; sign is sign of result
    eor #$FF            ; Shift a negative number of places
    adc #0              ; Complete negation  C=1
    ldy #0
    sty OLDOV
    ldx #FAC1_exponent
    bne @2
@1:
    ldy #0
    sty FACOV
@2:
    cmp #$F9
    bmi add_align_exponents
    tay
    lda FACOV
    lsr 1,X
    jsr short_shift_FAC
FADD4:
    bit ARISGN
    bpl add_mantissas_FAC2_FAC1
    ldy #FAC1_exponent
    cpx #FAC2_exponent      ; FAC1 is bigger
    beq @1
    ldy #FAC2_exponent      ; FAC2 is bigger
@1:
    sec
    eor #$FF
    adc OLDOV
    sta FACOV
    lda 4,Y
    sbc 4,X
    sta FAC1_mantissa+3
    lda 3,Y
    sbc 3,X
    sta FAC1_mantissa+2
    lda 2,Y
    sbc 2,X
    sta FAC1_mantissa+1
    lda 1,Y
    sbc 1,X
    sta FAC1_mantissa+0    

    ; Fallthrough to abs_and_normalize_FAC1

