;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - sine of FAC1 in radians
;
; This is verified to be identical to the original Microsoft implementation where it was named SIN.
;
; USE IDENTITIES TO GET FAC IN QUADRANTS I OR IV.
; THE FAC IS DIVIDED BY 2*PI AND THE INTEGER PART IS IGNORED
; BECAUSE SIN(X+2*PI)=SIN(X). THEN THE ARGUMENT CAN BE COMPARED
; WITH PI/2 BY COMPARING THE RESULT OF THE DIVISION
; WITH PI/2/(2*PI)=1/4.
; IDENTITIES ARE THEN USED TO GET THE RESULT IN QUADRANTS
; I OR IV. AN APPROXIMATION POLYNOMIAL IS THEN USED TO
; COMPUTE SIN(X).
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 210 - XXX address does not match
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
; - https://www.c64-wiki.com/wiki/SIN


!ifdef CONFIG_TRANSCENDENTAL_FUNCTIONS {


sin_FAC1:

        jsr mov_r_FAC1_FAC2
        lda #<const_DOUBLE_PI       ; Get pointer to divisor
        ldy #>const_DOUBLE_PI
        ldx FAC2_sign               ; Get sign of result
        jsr div_FAC2_MEM
        jsr mov_r_FAC1_FAC2         ; Get result into FAC2
        jsr int_FAC1
        lda #$00
        sta ARISGN                  ; Always have the same sign
        jsr sub_FAC2_FAC1           ; Keep only the fractional part
        lda #<const_QUARTER         ; Get pointer to 1/4
        ldy #>const_QUARTER
        jsr sub_MEM_FAC1            ; Compute 1/4 - FAC1
        lda FAC1_sign               ; Save sign for later
        pha
        bpl SIN1                    ; First quadrant
        jsr add_HALF_FAC1           ; Add 1/2 to FAC1
        lda FAC1_sign               ; Sign is negative?
        bmi SIN2
        lda TANSGN                  ; Quadrants II and III come here
        eor #$FF
        sta TANSGN
SIN1:
        jsr toggle_sign_FAC1        ; If positive, negate it
SIN2:
        lda #<const_QUARTER         ; Get pointer to 1/4
        ldy #>const_QUARTER
        jsr add_MEM_FAC1            ; Add it in
        pla                         ; Get original quadrant
        bpl SIN3
        jsr toggle_sign_FAC1        ; If negative, negate result
SIN3:
        lda #<poly_sin
        ldy #>poly_sin
        jmp poly1_FAC1              ; Do approximation polynomial


} else {
    jmp do_NOT_IMPLEMENTED_error
}
