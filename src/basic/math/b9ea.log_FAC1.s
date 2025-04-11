;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - natural logarigthm of FAC1
;
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 113
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
; - https://www.c64-wiki.com/wiki/LOG
;
; Calculate log of FAC1
; Algorithm:
; 1. Separate exponent and significand of FAC1.  N = exponent, XF = significand
; 2. T = 1.0 - sqrt(2.0) / (XF + sqrt(0.5))
; 3. Apply polynomial 0.43425594189 * T7 + 0.57658454124 * T5 + 0.96180075919 * T3 + 2.8853900731 * T - 0.5  giving log2(XF)
; 4. N + log2(XF) giving log2(X)
; 5. Multiply by LOG(2) giving LOG(X)



log_FAC1:
    lda FAC1_exponent           ; Store exponent for later
    pha

    ldx #$80                    ; Set exponent to 0 so that FAC1 becomes XF
    stx FAC1_exponent

    ldy #>const_INV_SQR_2       ; FAC1 <- FAC1 + sqrt(0.5)
    lda #<const_INV_SQR_2
    jsr add_MEM_FAC1

    ldy #>const_SQR_2           ; FAC1 <- sqrt(2.0) / FAC1
    lda #<const_SQR_2
    jsr div_MEM_FAC1

    ldy #>const_ONE             ; FAC1 <- 1.0 - FAC1
    lda #<const_ONE
    jsr sub_MEM_FAC1

    ldy #>poly_log              ; FAC1 <- log_poly(FAC1)
    lda #<poly_log
    jsr poly1_FAC1
    
    ldy #>const_NEG_HALF        ; FAC1 <- FAC1 - 0.5
    lda #<const_NEG_HALF
    jsr add_MEM_FAC1
    
    jsr mov_FAC1_FAC2           ; FAC2 <- FAC1

    pla                         ; FAC1 <- N
    sec
    sbc #$80
    jsr convert_A_to_FAC1

    jsr add_FAC2_FAC1           ; FAC1 <- FAC1 + FAC2

    ldy #>const_LOG_2           ; FAC1 <- FAC1 * log(2.0)
    lda #<const_LOG_2
    jmp mul_MEM_FAC1
