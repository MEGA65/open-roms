;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - divide FAC1 by 10, result is always positive
;
; Notes:
; - moves FAC1 to FAC2, loads FAC1 with the constant 10, jumps to the division routine

;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 114
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

div10_FAC1_p:

    jsr mov_FAC1_FAC2
    ldy #>const_TEN
    lda #<const_TEN
    jsr mov_MEM_FAC1

    jmp div_FAC2_FAC1
