;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - imports string to FAC1, ignores spaces
;
;
; Input:
; - .A needs to be loaded with first char of the string
; - Carry flag must be clear
; - string address in $7A/$7B
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 116
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

!ifdef CONFIG_MEMORY_MODEL_38K {
; NOTE: Currently CHRGET is only available for the 38K model and the equivalent function
;       does not test for digits to set carry

FIN_NUMDEC      = TEMPF2
FIN_DIGIT       = TEMPF2 + 1
FIN_DECFOUND    = TEMPF2 + 2
FIN_EXPSIGN     = TEMPF2 + 3
FIN_EXP         = TEMPF2 + 4


FIN:
    ldx #$00
    stx SGNFLG          ; Sign is positive
    stx FIN_DECFOUND    ; Decimal point not found
    stx FIN_EXP         ; Exponent
    stx FAC1_exponent   ; FAC1 <- 0
    bcc FIN_loop        ; Starting with digit
    cmp #$2D            ; Is minus?
    bne @1
    dec SGNFLG
    bne FIN_next        ; Will always branch

@1: cmp #$2B            ; Is plus?
    beq FIN_next

FIN_loop:
    bcs FIN_nonnumeric
    sec
    sbc #48             ; Convert to number
    sta FIN_DIGIT
    jsr mul10_FAC1
    jsr mov_FAC1_FAC2
    lda FIN_DIGIT
    jsr convert_A_to_FAC1
    jsr add_FAC2_FAC1

    lda FIN_DECFOUND    ; Have we passed the decimal sign?
    bpl FIN_next
    inc FIN_NUMDEC

FIN_next:
    jsr CHRGET
    +bra FIN_loop

FIN_nonnumeric:
    cmp #$2E            ; decimal point
    beq FIN_decimal
    cmp #$45            ; E
    beq FIN_exponent
FIN_finalize:
    lda FIN_EXP
    sec
    sbc FIN_NUMDEC
    sta FIN_EXP
    bmi FIN_div_loop

FIN_mul_loop:
    dec FIN_EXP
    bmi FIN_out
    jsr mul10_FAC1
    +bra FIN_mul_loop

FIN_div_loop:
    jsr div10_FAC1_p
    inc FIN_EXP
    bne FIN_div_loop

FIN_out:
    lda SGNFLG
    sta FAC1_sign
    rts
    
FIN_decimal:
    lda FIN_DECFOUND
    bmi FIN_finalize
    dec FIN_DECFOUND    ; Indicate found decimal point
    sta FIN_NUMDEC      ; Number of decimal places = 0
    +bra FIN_next
    
FIN_exponent:
    ldx #0
    stx FIN_EXPSIGN
    jsr CHRGET
    bcc FIN_exp_loop
    cmp #$2D            ; Is minus?
    bne @1
    dec FIN_EXPSIGN
    bne FIN_exp_next    ; Always branches
@1: cmp #$2B            ; Is plus?
    beq FIN_exp_next
    bne FIN_done_exp

FIN_exp_loop:
     tax
     lda FIN_EXP
     cmp #10
     bcs FIN_exp_limit
     asl                ; Multiply by 10
     sta FIN_EXP
     asl
     asl
     clc
     adc FIN_EXP
     sta FIN_EXP
     txa
     sec
     sbc #48             ; Convert to number
     clc
     adc FIN_EXP
     sta FIN_EXP

FIN_exp_next:
     jsr CHRGET
     bcc FIN_exp_loop

FIN_done_exp:
     lda FIN_EXP
     bpl FIN_finalize
     eor #$FF
     tax
     inx
     stx FIN_EXP
     +bra FIN_finalize

FIN_exp_limit:
     ldx FIN_EXPSIGN
     bmi FIN_zero
     jmp do_OVERFLOW_error

FIN_zero:
     ldx #0
     stx FAC1_exponent
     rts
 }
