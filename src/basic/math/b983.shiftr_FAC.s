;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - shift a floating point register right
;
; The main entry point is shiftr_FAC which shifts any FAC to the right with sign extension
; Inputs:
; - A is the negative of the number of bits to shift
; - X points to to the bytes to be shifted
; Returns:
; - Y = 0
; - CF = 0
; - A = overflowed bits
;
; Alternative entry point shift_for_mul_RES will shift the RES register for multiplication.
; Alternative entry point short_shift_FAC will makes a short shift without sign extension
;
; This is verified to be identical to the original Microsoft implementation where it was named SHIFTR.
;

shift_for_mul_RES:
    ldx #RESHO-1

.bytes:
    ldy 4,X             ; Shift entire bytes
    sty FACOV
    ldy 3,X
    sty 4,X
    ldy 2,X
    sty 3,X
    ldy 1,X
    sty 2,X
    ldy BITS
    sty 1,X

shiftr_FAC:
    adc #8
    bmi .bytes          ; More than or equal to 8 bits remaining
    beq .bytes
    sbc #8              ; Go back to previous value
    tay
    lda FACOV
    bcs shiftr_FAC
.sext:
    asl 1,X
    bcc @2
    inc 1,X
@2:
    ror 1,X             ; Undo previous shift
    ror 1,X
short_shift_FAC:
    ror 2,X
    ror 3,X
    ror 4,X
    ror
    iny
    bne .sext
shftrt:
    clc
    rts
