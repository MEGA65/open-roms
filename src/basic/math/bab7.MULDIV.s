;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - add exponents of FAC1 and FAC2 for multiplication and division
;
; This is verified to be identical to the original Microsoft implementation where it was named MULDIV
;


	;CHECK SPECIAL CASES AND ADD EXPONENTS FOR FMULT, FDIV.
	
MULDIV:
        lda FAC2_exponent   ; Exponent of FAC2 = 0?
MLDEXP:
        beq ZEREMV
        clc
        adc FAC1_exponent   ; Result is in A
        bcc @1              ; Find CF XOR NF
        bmi GOOVER          ; Overflow if bits match
        clc
        +skip_2_bytes_trash_nvz
@1:
        bpl ZEREMV          ; underflow
        adc #$80            ; Add bias
        sta FAC1_exponent
        bne @2
	    jmp ZEROML          ; Zero the rest of it
@2:
        lda ARISGN
        sta FAC1_sign       ; ARISGN is result's sign
        rts

MLDVEX:
        lda FAC1_sign
        eor #$FF
        bmi GOOVER
ZEREMV:
        pla                 ; Get address off stack
        pla
        jmp zero_FAC1       ; underflow
GOOVER:
        jmp overflow_error  ; overflow
