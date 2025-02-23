;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - compare FAC1 with RAM location
;
; Input:
; - .A - address low byte
; - .Y - address high byte
;
; Output:
; - .A - $00 for equal, $01 for FAC1 > RAM, $FF for FAC1 < RAM
; - flags N/Z, depending on whether FAC1 is 0, positive, or negative
;
; Notes:
; - uses vector at $24, leaves FAC1 and FAC2 unchanged (Codebase64)
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 115
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;


FCOMP: 
    sta INDEX+2
    sty INDEX+3

    jsr sgn_FAC1_A          ; Set N/Z flag for FAC1 and store on stack
    php

    ldy #$01
    lda #$7F                ; Expand sign of RAM float into A as $FF or $00
    cmp (INDEX+2),Y
    adc #$80
    cmp FAC1_sign
    bne FCOMP_greater_than  ; FAC < or > RAM, will be swapped to correct

    dey
    lda (INDEX+2),Y         ; Exponent of RAM float into A
    cmp FAC1_exponent
    bcc FCOMP_greater_than  ; FAC1 > RAM
    bne FCOMP_less_than

    cmp #$00
    beq FCOMP_equal         ; FAC1 = RAM = 0

    iny
    lda (INDEX+2),Y
    ora #$80                ; Set highest bit of mantissa (0.5)
    cmp FAC1_mantissa
    bcc FCOMP_greater_than
    bne FCOMP_less_than
    iny
    lda (INDEX+2),Y
    cmp FAC1_mantissa+1
    bcc FCOMP_greater_than
    bne FCOMP_less_than
    iny
    lda (INDEX+2),Y
    cmp FAC1_mantissa+2
    bcc FCOMP_greater_than
    bne FCOMP_less_than
    iny
    lda (INDEX+2),Y
    cmp FAC1_mantissa+3
    bcc FCOMP_greater_than
    bne FCOMP_less_than

FCOMP_equal:
    lda #$00
    plp
    rts


FCOMP_less_than:
    lda #$FF
    cmp FAC1_sign
    bne @1
    lda #$01
@1: plp
    rts

FCOMP_greater_than:
    lda #$01
    cmp FAC1_sign
    bcs @1
    lda #$FF
@1: plp
    rts
