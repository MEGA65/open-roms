;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - set FAC1 as FAC2 raised to the power of FAC1
;
; This is verified to be almost identical to the original Microsoft implementation where it was named FPWRT.
;
; Input:
; - .A - must load FAC1 exponent ($61) beforehand to set the zero flag
;
; Note:
; - load FAC2 after FAC1, or mimic the Kernals sign comparison (XXX do we need it?)
; - uses exp(x*log(y)) formula to calculate y^x; slow and inaccurate
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 117
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

; EXPONENTIATION ---  X^Y.
; N.B.  0^0=1
; FIRST CHECK IF Y=0. IF SO, THE RESULT IS 1.
; NEXT CHECK IF X=0. IF SO THE RESULT IS 0.
; THEN CHECK IF X.GT.0. IF NOT CHECK THAT Y IS AN INTEGER.
; IF SO, NEGATE X, SO THAT LOG DOESN'T GIVE FCERR.
; IF X IS NEGATIVE AND Y IS ODD, NEGATE THE RESULT
; RETURNED BY EXP.
; TO COMPUTE THE RESULT USE X^Y=EXP((Y*LOG(X)).

!ifdef CONFIG_TRANSCENDENTAL_FUNCTIONS {
!ifdef CONFIG_MEMORY_MODEL_38K {

pwr_FAC2_FAC1:

    beq exp_FAC1        ; If FAC1=0, just exponentiate that
    lda FAC2_exponent   ; Is X=0?
    bne FPWRT1
    jmp ZEROF1          ; Zero FAC1
FPWRT1:
    ldx #TEMPF3         ; Save for later in a temp
    ldy #0
    jsr mov_r_FAC1_MEM
	; Y=0 already. Good in case no one calls INT
    lda FAC2_sign
    bpl FPWR1           ; No problems if X>0
    jsr int_FAC1        ; Integerize the FAC1
    lda #TEMPF3         ; Get addr of comperand
    ldy #0
    jsr FCOMP           ; Equal?
    bne FPWR1           ; Leave X neg. log will blow him out. A=-1 and Y is irrelevant
    tya                 ; Negate X. Make positive
    ldy INTEGR          ; Get evenness
FPWR1:
    jsr mov_FAC2_FAC1_sign      ; Alternate entry point
    tya
    pha                 ; Save evenness for later
    jsr log_FAC1        ; Find log
    lda #TEMPF3         ; Multiply FAC1 times log(x)
    ldy #0
    jsr mul_MEM_FAC1
    jsr exp_FAC1        ; Exponentiate the FAC1
    pla
    lsr                 ; Is it even=
    bcc NEGRTS          ; Yes. or X>0

    ; FALLTHROUGH to toggle_sign_FAC1
}
}
