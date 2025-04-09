;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - tangent of FAC1 in radians
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 210
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
; - https://www.c64-wiki.com/wiki/TAN

; tan(x) = sin(x) / cos(x)

tan_FAC1:
    jsr mov_r_FAC1_TMP1         ; TMP1 = x
    jsr sin_FAC1                ; FAC1 = sin(x)
    jsr mov_r_FAC1_TMP2         ; TMP2 = sin(x)
    lda #TEMPF1
    ldy #0
    jsr mov_MEM_FAC1            ; FAC1 = x
    jsr COS                     ; FAC1 = cos(x)
    lda #TEMPF2
    ldy #0
    jsr mov_MEM_FAC2            ; FAC2 = sin(x)
    jmp div_FAC2_FAC1           ; FAC1 = tan(x)
