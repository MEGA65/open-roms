;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - invert FAC1 mantissa
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 113
; - https://www.c64-wiki.com/wiki/BASIC-ROM
; - https://sta.c64.org/cbm64basconv.html
;

; 2-complement the FAC1 mantissa
; The 4 byte mantissa is treated as an integer in big endian form


inv_FAC1_mantissa:

    ldx #3
@1: lda FAC1_mantissa,X
    eor #$FF
    sta FAC1_mantissa,X
    dex
    bpl @1

    inc FAC1_mantissa+3
    bne @2
    inc FAC1_mantissa+2
    bne @2
    inc FAC1_mantissa+1
    bne @2
    inc FAC1_mantissa
    
@2: rts
