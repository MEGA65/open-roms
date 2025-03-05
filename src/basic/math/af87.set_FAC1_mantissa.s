;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - sets mantissa to 00yyxxaa
;
; See also:
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;


set_FAC1_mantissa:
    sty FAC1_mantissa+1
    stx FAC1_mantissa+2
    sta FAC1_mantissa+3
    lda #0
    sta FAC1_mantissa
    rts
