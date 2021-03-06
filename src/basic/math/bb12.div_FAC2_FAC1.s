;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - divide FAC2 (dividend) by FAC1 (divisor)
;
; Input:
; - .A - must load FAC1 exponent ($61) beforehand to set the zero flag (but our routine does not need this)
;
; Output:
; - FAC1
;
; Note:
; - some documentation suggest this is a division leaving quotient and remainder (left in FAC2),
;   but it seems (experimentation) that this is not true
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 114
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

div_FAC2_FAC1:

	; 'Pamiętaj, cholero - nie dziel przez zero!' - ancient polish proverb

	lda FAC1_exponent
	+beq do_DIVISION_BY_ZERO_error

	; Handle special case - dividing 0 by non-zero value

	lda FAC2_exponent
	+beq set_FAC1_zero

	; Multiply signs

	lda FAC1_sign
	eor FAC2_sign
	sta FAC1_sign

	; Subtract the exponents

	lda #$A0                            ; correction for bias and FAC2 digits
	sta RESHO+0
	lda #$00
	sta RESHO+1

	lda FAC2_exponent                   ; add FAC2 exponent to temporary variable 
	jsr muldiv_RESHO_01_add_A

    lda RESHO+0                         ; subtract FAC1 exponent from temporary variable
    sec
    sbc FAC1_exponent
    sta RESHO+0
    bcs @1
    dec RESHO+1
@1:

    lda RESHO+1
    +bmi set_FAC1_zero                ; result too low, set 0 and quit

	lda RESHO+0
	sta FAC1_exponent

	; Divide the mantissas
	jsr div_FAC1_denorm
	jsr muldiv_RESHO_set_0
	jsr div_mantissas

	; Copy the result to FAC1 - XXX we probably already have similar code somewhere...

	lda FAC2_mantissa+3
	sta FAC1_mantissa+3
	lda FAC2_mantissa+2
	sta FAC1_mantissa+2
	lda FAC2_mantissa+1
	sta FAC1_mantissa+1
	lda FAC2_mantissa+0
	sta FAC1_mantissa+0

	; Normalize and quit
	
	jmp normal_FAC1
