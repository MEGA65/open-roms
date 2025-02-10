;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - convert i16 with exponent in X and sign in C to FAC1

convert_i16_expsign_to_FAC1:

    lda #$00                    
    sta FAC1_mantissa+2         ; Clear high bytes of mantissa
    sta FAC1_mantissa+3
    stx FAC1_exponent
    sta FAC1_sign
    bcc @1

    ; Handle signed int
    lda FAC1_mantissa            ; Clear sign bit of int 16
    and #$7F
    sta FAC1_mantissa
    ldy #>CONST_NEG_32768       ; Subtract with 32768 to invert negative number
    lda #<CONST_NEG_32768
    jsr add_MEM_FAC1
@1: jmp normal_FAC1
