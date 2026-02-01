;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - compare FAC1 with RAM location
;
; Input:
; - .A - address low byte
; - .Y - address high byte
;
; Output:
; - .A - $00 for equal, $01 for FAC1 > RAM, $FF for FAC1 < RAM
; - flags N/Z, Z=1 if equal, N=1 if FAC1 < RAM, Z=0, N=0 if FAC1 > RAM
;
; This is verified to be identical to the original Microsoft implementation where it was named FCOMP.
;
; Notes:
; - uses vector at $24, leaves FAC1 and FAC2 unchanged (Codebase64)
;
; Alternative entry point: FCOMPN - Instead of A set INDEX2 to low byte of address
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 115
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

FCOMP:
    sta INDEX2+0
FCOMPN:
    sty INDEX2+1
    ldy #0
    lda (INDEX2),Y
    iny
    tax
    beq sgn_FAC1_A              ; arg is zero so sign of FAC1 will decide
    lda (INDEX2),Y
    eor FAC1_sign
    bmi sgn_FAC1_A_nozero       ; signs differ so sign of FAC will decide

    cpx FAC1_exponent
    bne @1
    lda (INDEX2),Y
    ora #$80
    cmp FAC1_mantissa+0
    bne @1
    iny
    lda (INDEX2),Y
    cmp FAC1_mantissa+1
    bne @1
    iny
    lda (INDEX2),Y
    cmp FAC1_mantissa+2
    bne @1
    iny
    lda #$7F
    cmp FACOV
    lda (INDEX2),Y
    sbc FAC1_mantissa+3          ; Get zero if equal
    beq QINT_ret
@1:
    lda FAC1_sign
    bcc @2
    eor #$FF
@2:
    jmp sgn_A
