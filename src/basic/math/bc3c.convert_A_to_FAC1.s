;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - convert int8 in A to FAC1
;
; Input: A - int8 to convert to float
; Result: FAC1
;
; This is verified to be identical to the original Microsoft implementation where it was named FLOAT.
;
; Sets first byte of FAC1 to A, sign extends A into tge second byte and falls through to convert_i16_to_FAC1
;
; - https://codebase64.org/doku.php?id=base:asm_include_file_for_basic_routines
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

convert_A_to_FAC1:
    sta FAC1_mantissa+0
    lda #0
    sta FAC1_mantissa+1
    ldx #$88

    ; Fall through to convert_i16_to_FAC1
