;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - rounds away the decimal to make an integer
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 116
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

int_FAC1:

    lda FAC1_exponent
    cmp #$81
    bcc int_FAC1_zero           ; exponent is 0 or lower so integer part is 0
    cmp #$A0
    bcs int_FAC1_out            ; exponent is 32 or larger so the entire mantissa is part of the integer

    tax
    and #$07                    ; low three bits of exponent is number of bits to keep
    tay
    
    txa
    lsr                         ; Bits 4-5 of exponent is how many full mantissa bytes to keep
    lsr
    lsr
    and #$03
    tax

    lda #$FF                    ; Create bit mask for first mantissa byte to change
@1: lsr
    dey
    bne @1
    eor #$FF

    and FAC1_mantissa,X
    sta FAC1_mantissa,X
    lda #0
@2: inx
    cpx #$4
    bcs @3
    sta FAC1_mantissa,X
    bcc @2

@3: lda FAC1_sign
    bpl int_FAC1_out
    lda #<const_ONE             ; If negative subtract one
    ldy #>const_ONE
    jsr sub_MEM_FAC1            ; FAC1 = 1 - FAC1
    lda #$FF
    sta FAC1_sign               ; FAC1 = FAC1 - 1
    rts


    ; FIXME: Do we need to set FACOV to 0?

int_FAC1_zero:
    lda #0
    sta FAC1_exponent
int_FAC1_out:
    rts
