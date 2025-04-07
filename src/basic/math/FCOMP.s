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
; - flags N/Z, Z=1 if equal, N=1 if FAC1 < RAM, Z=0, N=0 if FAC1 > RAM
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

    ldy #$01
    lda (INDEX+2),Y
    eor FAC1_sign           ; Check if signs are different
    bmi FCOMP_greater_than  ; FAC < or > RAM, will be swapped to correct

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
    rts


FCOMP_less_than:
    lda FAC1_sign
    bpl FCOMP_FF
FCOMP_01:
    lda #$01
    rts
    
FCOMP_greater_than:
    lda FAC1_sign
    bpl FCOMP_01
FCOMP_FF:
    lda #$FF
    rts
