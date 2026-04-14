;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - tangent of FAC1 in radians
;
; This is verified to be almost identical to the original Microsoft implementation where it was named TAN.
; The difference is the optimization of the jsr to mov_r_FAC1_MEM
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 210
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
; - https://www.c64-wiki.com/wiki/TAN

; tan(x) = sin(x) / cos(x)


!ifdef CONFIG_TRANSCENDENTAL_FUNCTIONS {


tan_FAC1:

        jsr mov_r_FAC1_TMP1         ; Mov FAC1 into temporary
        lda #$00
        sta TANSGN                  ; Remember whether to negate
        jsr sin_FAC1                ; Compute the sin
        ldx #<TEMPF3
        ldy #>TEMPF3
        jsr mov_r_FAC1_MEM          ; In the original BASIC this does jsr GMOVMF that jmps to mov_r_FAC1_MEM
        lda #<TEMPF1
        ldy #>TEMPF1
        jsr mov_MEM_FAC1            ; Put this memory loc into FAC1
        lda #$00
        sta FAC1_sign               ; Start off positive
        lda TANSGN
        jsr COSC                    ; Compute cosine
        lda #<TEMPF3                ; Address of sine value
        ldy #>TEMPF3
GFDIV:
        jmp div_MEM_FAC1            ; Divide sine by cosine and return
COSC:
        pha
        jmp SIN1


} else {
    jmp do_NOT_IMPLEMENTED_error
}
