;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - divide FAC2 (dividend) by FAC1 (divisor)
;
; This is verified to be identical to the original Microsoft implementation where it was named FDIVT.
;
; Input:
;   ZF - If FAC1 is zero
;
; Output:
; - FAC1
;
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 114
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

div_FAC2_FAC1:

	; 'Pamiętaj, cholero - nie dziel przez zero!' - ancient polish proverb

    beq DV0ERR          ; Can't divide by zero!
    jsr round_FAC1      ; TAKE FACOV INTO ACCT IN FAC.
	lda #0              ; NEGATE FACEXP.
    sec
    sbc FAC1_exponent
    sta FAC1_exponent
    jsr MULDIV          ; FIX UP EXPONENTS.
    inc FAC1_exponent   ; SCALE IT RIGHT.
    ;beq GOOVER         ; OVERFLOW.
    !byte $F0, $BA      ; This is a workaround for beq GOOVER beause build_segment doesn't always place code in order in the first pass
    ldx #$FC        	; SETUP PROCEDURE.
    lda #1
DIVIDE: 				; THIS IS THE BEST CODE IN THE WHOLE PILE.
    ldy FAC2_mantissa+0 ; SEE WHAT RELATION HOLDS.
    cpy FAC1_mantissa+0
    bne	SAVQUO	    	;[C]=0,1. N(C=0)=0.
    ldy FAC2_mantissa+1
    cpy FAC1_mantissa+1
    bne SAVQUO
    ldy FAC2_mantissa+2
    cpy FAC1_mantissa+2
    bne SAVQUO
    ldy FAC2_mantissa+3
    cpy FAC1_mantissa+3

SAVQUO:
    php
    rol                 ; SAVE RESULT.
    bcc QSHFT           ; IF NOT DONE, CONTINUE.
    inx
    sta RESHO+3,X
    beq LD100
    bpl DIVNRM          ; NOTE THIS REQ 1 MO RAM THEN NECESS.
    lda #1
QSHFT:
    plp                 ; RETURN CONDITION CODES.
	bcs DIVSUB          ; FAC .LE. ARG.
SHFARG:
    asl FAC2_mantissa+3	; SHIFT ARG ONE PLACE LEFT.
	rol FAC2_mantissa+2
	rol FAC2_mantissa+1
	rol FAC2_mantissa+0
	bcs SAVQUO		    ; SAVE A RESULT OF ONE FOR THIS POSITION AND DIVIDE.
    bmi DIVIDE		    ; IF MSB ON, GO DECIDE WHETHER TO SUB.
	bpl SAVQUO
DIVSUB:
    tay             	; NOTICE C MUST BE ON HERE.
	lda FAC2_mantissa+3
	sbc FAC1_mantissa+3
	sta FAC2_mantissa+3
	lda FAC2_mantissa+2
	sbc FAC1_mantissa+2
	sta FAC2_mantissa+2
    lda FAC2_mantissa+1
    sbc FAC1_mantissa+1
    sta FAC2_mantissa+1
    lda FAC2_mantissa+0
    sbc FAC1_mantissa+0
	sta FAC2_mantissa+0
	tya
	jmp SHFARG
LD100:
    lda #$40            ; ONLY WANT TWO MORE BITS.
	bne QSHFT   		; ALWAYS BRANCHES.
DIVNRM:
    asl                 ; GET LAST TWO BITS INTO MSB AND B6.
    asl
    asl
    asl
    asl
    asl
    sta FACOV
	plp                 ; TO GET GARBAGE OFF STACK.
	jmp	mov_RES_FAC1  	; MOVE RESULT INTO FAC, THEN NORMALIZE RESULT AND RETURN.
DV0ERR:
    ldx #B_ERR_DIVISION_BY_ZERO
	jmp error
