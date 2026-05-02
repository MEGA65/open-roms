;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - add an ASCII digit in A that has been converted to a signed integer to FAC1
;
; This is verified to be identical to the original Microsoft implementation where it was named FINEDG.
;

; HERE PACK IN THE NEXT DIGIT OF THE EXPONENT.
; MULTIPLY THE OLD EXP BY 10 AND ADD IN THE NEXT
; DIGIT. NOTE: EXP OVERFLOW IS NOT CHECKED FOR.

!ifdef CONFIG_MEMORY_MODEL_38K {

FINEDG:
    lda TENEXP          ; Get exp so far
    cmp #10             ; Will result be >= 100
    bcc MLEX10
    lda #100            ; Get 100
    bit EXPSGN
    bmi MLEXMI          ; If neg exp, no check for overflow
    jmp overflow_error
MLEX10:
    asl                 ; Mult by 2 twice
    asl  
    clc                 ; Possible shift out of high
    adc TENEXP          ; Like multiplying by five
    asl                 ; And now by ten
    clc
    ldy #0
    adc (TXTPTR),Y
    sec
    sbc #'0'
MLEXMI:
    sta TENEXP          ; Save result
    jmp FINEC
    
}
