;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - Convert signed 16-bit integer to floating point
;
; This is verified to be identical to the original Microsoft implementation where it was named FLOATS.
;
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
; - https://www.c64-wiki.com/wiki/GIVAYF (which calls this function)
;
; Convert the signed 16-bit integer in FAC1 mantissa ($62:$63)
; into a floating point number in FAC1. Assume X=exponent
;
; Alternative entry points:
; FLOATC: Assume FAC1_mantissa+0 and +1 loaded. Assume CF=0 if negative and C=1 if positive
; FLOATB: as for FLOATC and do not clear FAC1_mantissa+2 and +3 and set sign and FACOV to A

convert_i16_to_FAC1:

    lda FAC1_mantissa+0
    eor #$FF
    rol                             ; CF = Complement of sign
FLOATC:
    lda #0
    sta FAC1_mantissa+3
    sta FAC1_mantissa+2
FLOATB:
    stx FAC1_exponent
    sta FACOV
    sta FAC1_sign
    jmp abs_and_normal_FAC1
