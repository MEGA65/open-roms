;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - natural logarigthm of FAC1
;
; This is verified to be identical to the original Microsoft implementation where it was named LOG.
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


!ifdef CONFIG_TRANSCENDENTAL_FUNCTIONS {


log_FAC1:

        jsr sgn_FAC1_A          ; Is it positive
        beq LOGERR
        bpl LOG1
LOGERR:
        jmp illegal_quantity_error   ; Can't tolerate neg or zero
LOG1:
        lda FAC1_exponent
        sbc #$7F                ; Remove bias (carry is off)
        pha                     ; Save awhile
        lda #$80
        sta FAC1_exponent       ; Result is FAC1 in range [0.5,1]
        lda #<const_INV_SQR_2   ; Get pointer to SQR(0.5)
        ldy #>const_INV_SQR_2

; Calculate (F - SQR(.5)) / (F + SQR(.5))

        jsr add_MEM_FAC1        ; Add to FAC1
        lda #<const_SQR_2       ; Get SQR(2.)
        ldy #>const_SQR_2
        jsr div_MEM_FAC1
        lda #<const_ONE
        ldy #>const_ONE
        jsr sub_MEM_FAC1
        lda #<poly_log
        ldy #>poly_log
        jsr poly1_FAC1          ; Evaluate approximation polynomial
        lda #<const_NEG_HALF    ; Add in last constant
        ldy #>const_NEG_HALF
        jsr add_MEM_FAC1
        pla                     ; Get exponent back
        jsr FINLOG              ; Add it in
MULLN2:
        lda #<const_LOG_2       ; Multiply result by log(2.0)
        ldy #>const_LOG_2
        
        ; FALLTHROUGH to mul_MEM_FAC1


} else {
    jmp do_NOT_IMPLEMENTED_error
}
