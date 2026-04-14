;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - evaluate polynomial with odd powers only for FAC1 value
;
; This is verified to be identical to the original Microsoft implementation where it was named POLYX.
;
; Input:
; - .A - table address low byte
; - .Y - table address low byte
; - table format:
;   - polynomial degree (8 bit integer)
;   - oefficients (floats), starting from highest degree, times 1+degree
;
; Notes:
; - calls POLY2(table, X*X)*X
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 206
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://www.c64-wiki.com/wiki/POLY1


!ifdef CONFIG_TRANSCENDENTAL_FUNCTIONS {


poly1_FAC1:
        sta POLYPT            ; Retain polynomial pointer for later
        sty POLYPT+1
        jsr mov_r_FAC1_TMP1     ; Save FAC1 in TMP1
        lda #TEMPF1
        jsr mul_MEM_FAC1        ; Compute x^2
        jsr POLY1               ; Compute P(x^2)
        lda #<TEMPF1
        ldy #>TEMPF1
        jmp mul_MEM_FAC1        ; Multiply by FAC1 again


} else {
    jmp do_NOT_IMPLEMENTED_error
}
