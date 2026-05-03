;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Continuation of the exp function in the BASIC part of KERNAL ROM

!ifdef CONFIG_TRANSCENDENTAL_FUNCTIONS {
!ifdef CONFIG_MEMORY_MODEL_38K {

STOLD:
        sta OLDOV
        jsr mov_FAC1_FAC2           ; To save in FAC2 without ROUND
        lda FAC1_exponent
        cmp #$88                    ; IF abs(FAC1) >= 128, too big
        bcc @3  

@2
        jsr MLDVEX                 	; overflow or overflow
@3
        jsr int_FAC1
        lda CHARAC                  ; Get low part
        clc
        adc #$81
        beq @2                      ; overflow or overflow !!
        sec
        sbc #1                      ; Subtract 1
        pha                         ; Save a while
        ldx #5                      ; Prep to swap FAC1 and FAC2
@4
        lda FAC2_exponent,X
        ldy FAC1_exponent,X
        sta FAC1_exponent,X
        sty FAC2_exponent,X
        dex
        bpl @4
        lda OLDOV
        sta FACOV
        jsr sub_FAC2_FAC1
        jsr toggle_sign_FAC1        ; Negate FAC1
        lda #<poly_exp
        ldy #>poly_exp
        jsr poly2_FAC1
        lda #$00
        sta ARISGN                  ; Multiply by positive 1.0
        pla                         ; Get scale factor
        jsr MLDEXP                  ; Modify FAC1_exponent and check for overflow
        rts
        
 }
 }
