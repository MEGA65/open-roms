;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - evaluate polynomial with odd powers only for FAC1 value
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


poly1_FAC1:
    jsr store_YA_in_ZP              ; Store YA in second INDEX pointer
    jsr mov_r_FAC1_TMP1             ; TMPF1 <- FAC1  (rounds)
    jsr mov_FAC1_FAC2               ; FAC2 <- FAC1
    jsr mul_FAC2_FAC1               ; FAC1 <- FAC1 * FAC2  (x^2)
    jsr poly2_table_in_index2       ; poly2: skip storing YA to ZP
    ldy #$00                        ; FAC1 <- FAC1 * TEMPF1
    lda #TEMPF1
    jmp mul_MEM_FAC1
