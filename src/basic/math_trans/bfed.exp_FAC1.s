;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - exponential function, e raised to FAC1 power
;
; This is verified to be almost identical to the original Microsoft implementation where it was named EXP.
; The addition is the jmp between the two ROMs
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 117
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

; FIRST SAVE THE ORIGINAL ARGUMENT AND MULTIPLY THE FAC BY
; LOG2(E). THE RESULT IS USED TO DETERMINE IF OVERFLOW
; WILL OCCUR SINCE EXP(X)=2^(X*LOG2(E)) WHERE
; LOG2(E)=LOG(E) BASE 2. THEN SAVE THE INTEGER PART OF
; THIS TO SCALE THE ANSWER AT THE END. SINCE
; 2^Y=2^INT(Y)*2^(Y-INT(Y)) AND 2^INT(Y) IS EASY TO COMPUTE.
; NOW COMPUTE 2^(X*LOG2(E)-INT(X*LOG2(E)) BY
; P(LN(2)*(INT(X*LOG2(E))+1)-X) WHERE P IS AN APPROXIMATION
; POLYNOMIAL. THE RESULT IS THEN SCALED BY THE POWER OF 2
; PREVIOUSLY SAVED.

!ifdef CONFIG_TRANSCENDENTAL_FUNCTIONS {
!ifdef CONFIG_MEMORY_MODEL_38K {

exp_FAC1:

        lda #<const_INV_LOG_2       ; Multiply by log_2(e)
        ldy #>const_INV_LOG_2
        jsr mul_MEM_FAC1
        lda FACOV
        adc #$50
        bcc @1
        jsr INCRND
@1      jmp STOLD                   ; The BASIC ROM ends here so we need to jump to the KERNAL ROM
       
 } else {
    jmp do_NOT_IMPLEMENTED_error
} }
