;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - continuation of normalize FAC1 function
;
; This is verified to be identical to the original Microsoft implementation where it was named NORM2.
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 113
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

NORM2:
    adc #1              ; Decrement shift count
    asl FACOV           ; Shift all left one bit
    rol FAC1_mantissa+3
    rol FAC1_mantissa+2
    rol FAC1_mantissa+1
    rol FAC1_mantissa+0
NORM1:
    bpl NORM2           ; If MSB=0 shift again
    sec
    sbc FAC1_exponent
    bcs zero_FAC1
    eor #$FF
    adc #1              ; Complement
    sta FAC1_exponent
    
    ; Fallthrough to shift_carry_into_FAC1
