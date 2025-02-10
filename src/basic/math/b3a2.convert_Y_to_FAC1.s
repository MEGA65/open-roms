;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - convert uint8 in Y to FAC1
;
; Input: Y - uint8 to convert to float
; Result: FAC1
;
; Stores Y into first FAC1 mantissa byte, clears the second and calls convert_i16_to_FAC1
;
; - https://www.c64-wiki.com/wiki/BASIC-ROM
; - https://sta.c64.org/cbm64basconv.html
; - https://sourceforge.net/p/acme-crossass/code-0/38/tree/trunk/ACME_Lib/cbm/c64/float.a?force=True
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

convert_Y_to_FAC1:
    sty FAC1_mantissa+1
    lda #$00
    sta FAC1_mantissa
    jmp convert_i16_to_FAC1
