;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - arc tangent of FAC1
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 211
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
; - https://www.c64-wiki.com/wiki/ATN

; Algorithm:
; 1. Save sign of x
; 2. Calculate AX = |x|   (we can use that arctan(-x) = -arctan(x)
; 3. If AX > 1 set AX = 1/AX  (we can use that arctan(x) = pi/2 - arctan(1/x) )
; 4. Use polynomial to approximate arctan(AX) now since 0 <= AX <= 1
; 5. Adjust sign of result and offset with pi/2 if needed as per above


atn_FAC1:
    lda FAC1_sign               ; Save sign of FAC1 on the stack
    pha
    lda #$00                    ; FAC1 = abs(FAC1)
    sta FAC1_sign
    sta TEMPF1                  ; AX not scaled

    lda #<const_ONE
    ldy #>const_ONE
    jsr FCOMP
    bmi atn_skipscale

    lda #<const_ONE
    ldy #>const_ONE
    jsr div_MEM_FAC1
    inc TEMPF1                  ; AX scaled

atn_skipscale:
    lda #<poly_atn
    ldy #>poly_atn
    jsr poly1_FAC1

    lda TEMPF1
    beq atn_skipoffset

    lda #<const_HALF_PI
    ldy #>const_HALF_PI
    jsr sub_MEM_FAC1

atn_skipoffset:
    pla
    bpl atn_out
    jmp toggle_sign_FAC1
    
atn_out:
    rts
