;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - evaluate polynomial with odd and even powers for FAC1 value
;
; This is verified to be identical to the original Microsoft implementation where it was named POLY.
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
        sta POLYPT
        sty POLYPT+1
        
POLY1:
        jsr mov_r_FAC1_TMP2     ; Save FAC1
        lda (POLYPT),Y
        sta DEGREE
        ldy POLYPT
        iny
        tya
        bne POLY3
        inc POLYPT+1
POLY3:
        sta POLYPT
        ldy POLYPT+1
POLY2:
        jsr mul_MEM_FAC1
        lda POLYPT             ; Get current pointer
        ldy POLYPT+1
        clc
        adc #5
        bcc POLY4
        iny
POLY4:
        sta POLYPT
        sty POLYPT+1
        jsr add_MEM_FAC1        ; Add in constant
        lda #<TEMPF2            ; Multiply the original FAC1
        ldy #>TEMPF2
        dec DEGREE              ; Done?
        bne POLY2
RANDRT:
        rts                     ; Yes



} else {
    jmp do_NOT_IMPLEMENTED_error
}
