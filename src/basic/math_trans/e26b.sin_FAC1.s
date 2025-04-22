;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - sine of FAC1 in radians
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 210 - XXX address does not match
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
; - https://www.c64-wiki.com/wiki/SIN


!ifdef CONFIG_TRANSCENDENTAL_FUNCTIONS {


sin_FAC1:

    jsr mov_FAC1_FAC2               ; FAC1 <- X / (2*pi)     (X2)
    ldy #>const_DOUBLE_PI
    lda #<const_DOUBLE_PI
    jsr mov_MEM_FAC1
    jsr div_FAC2_FAC1

    jsr mov_FAC1_FAC2               ; FAC2 <- X2
    jsr int_FAC1                    ; FAC1 <- INT(X2)
    jsr sub_FAC2_FAC1               ; FAC1 <- X2 - INT(X2)   (F)

    ldy #>const_QUARTER
    lda #<const_QUARTER
    jsr FCOMP
    bmi sin_next                    ; FAC1 < 0.25

    ldy #>sin_three_quarters
    lda #<sin_three_quarters
    jsr FCOMP
    bmi sin_q23                     ; FAC1 < 0.75

    jsr mov_FAC1_FAC2               ; FAC1 <- FAC1 - 1.0
    ldy #>const_ONE
    lda #<const_ONE
    jsr mov_MEM_FAC1
    jsr sub_FAC2_FAC1
    +bra sin_next

sin_q23:
    ldy #>const_HALF
    lda #<const_HALF
    jsr sub_MEM_FAC1                ; FAC1 <- 0.5 - FAC1

    ; FALLTHROUGH
    
sin_next:
    ldy #>poly_sin
    lda #<poly_sin
    jmp poly1_FAC1
    

} else {
    jmp do_NOT_IMPLEMENTED_error
}
