;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - evaluate polynomial with odd and even powers for FAC1 value
;
; Input:
; - .A - table address low byte
; - .Y - table address low byte
; - FAC1 - value of the independent variable
; Outputs: FAC1 holds the calculated value
; Clobbers: X, Y, A, FAC2, TEMPF2
;
; The polynomial table is formatted as:
; First one byte represents the degree of the polynomial
; Then comes an array of floating point number coefficients starting with the highest degree
; Horner's method is used for the calculation.

; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 207
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://www.c64-wiki.com/wiki/POLY1
;


!ifdef CONFIG_TRANSCENDENTAL_FUNCTIONS {


poly2_FAC1:
    jsr store_YA_in_ZP

poly2_table_in_index2:  ; Called from poly1
    ldy #$00            ; FAC1 -> TMPF2
    ldx #TEMPF2
    jsr mov_FAC1_MEM

    ldx #$80            ; 0 -> FAC1
    stx FAC1_exponent

    ldx #0
    lda (INDEX+2, x)    ; degree (degree+1 = num coeffs)
    sta SGNFLG          ; number of terms register
    inc INDEX+2
    bcc @1
    inc INDEX+3

@1:
    lda INDEX+2
    ldy INDEX+3
    jsr add_MEM_FAC1    ; Add with coefficient
    ldy #$00
    lda #TEMPF2
    jsr mul_MEM_FAC1    ; Multiply with x

    clc                 ; Add 5 to table pointer
    lda #$05
    adc INDEX+2
    sta INDEX+2
    bcc @2
    inc INDEX+3

@2:
    dec SGNFLG
    bpl @1
    rts


store_YA_in_ZP:     ; Used also by poly1
    sty INDEX+3     ; Store YA in second INDEX pointer
    sta INDEX+2
    rts


} else {
    jmp do_NOT_IMPLEMENTED_error
}
