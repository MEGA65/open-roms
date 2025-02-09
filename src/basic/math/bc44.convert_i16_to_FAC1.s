;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - Convert signed 16-bit integer to floating point
;
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
; - https://www.c64-wiki.com/wiki/GIVAYF (which calls this function)
;
; Convert the signed 16-bit integer in FAC1 mantissa ($62:$63)
; into a floating point number in FAC1

; NOTE:
; According to https://c64os.com/post/floatingpointmath at $BC49
; Assume FAC1_mantissa+0 and +1. X=exponent and C=0 if negative and C=1 if positive

convert_i16_to_FAC1:
    ldx #$90
    jsr carry

    jmp convert_i16_expsign_to_FAC1   ; This should be at $BC49 (see note above)


carry:
    lda FAC1_mantissa
    cmp #$80                    ; Copy sign into carry
    rts
