;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - arc tangent of FAC1
;
; This is verified to be identical to the original Microsoft implementation where it was named ATN
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


!ifdef CONFIG_TRANSCENDENTAL_FUNCTIONS {


atn_FAC1:
        lda FAC1_sign           ; What is sign?
        pha 			        ; (Meanwhile save it for later)
        bpl ATN1
        jsr toggle_sign_FAC1    ; If negative, negate FAC1, use arctan(x) = -arctan(-x)
ATN1:
        lda FAC1_exponent
        pha                     ; Save this too for later
        cmp #$81                ; See if FAC1 >= 1.0
        bcc ATN2                ; It is less than 1
        lda #<const_ONE         ; Get pointer to 1.0
        ldy #>const_ONE
        jsr div_MEM_FAC1        ; Compute reciprocal. Use arctan(x) = pi/2 - arctan(1/x)
ATN2:
        lda #<poly_atn          ; Pointer to arctan polynomial
        ldy #>poly_atn          
        jsr poly1_FAC1
        pla
        cmp #$81                ; Was original argument < 1 ?
        bcc ATN3                ; Yes
        lda #<const_HALF_PI
        ldy #>const_HALF_PI
        jsr sub_MEM_FAC1        ; Subtract arctan from pi/2
ATN3:
        pla                     ; Was original argument positive?
        bpl ATN4                ; Yes
        jmp toggle_sign_FAC1    ; If negative, negate result
ATN4:
        rts


} else {
    jmp do_NOT_IMPLEMENTED_error
}
