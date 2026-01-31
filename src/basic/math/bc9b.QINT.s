;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - Quick conversion of FAC1 to 32 bit signed integer
;
; This is verified to be identical to the original Microsoft implementation where it was named QINT.
;
; Output:
; - $62-$65, big-endian order
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 115
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
;


QINT:
 	;QUICK GREATEST INTEGER FUNCTION.
	;LEAVES INT(FAC) IN FACHO&MO&LO SIGNED.
	;ASSUMES FAC .LT. 2^23 = 8388608

	lda FAC1_exponent
	beq clear_FAC1          ; If zero, got it.
	sec
	sbc #$A0                ; Get number of places to shift.
	bit FAC1_sign
	bpl @1
	tax
	lda #$FF
	sta BITS
	jsr inv_FAC1_mantissa
	txa
@1: ldx #FAC1_exponent
    cmp #$F9
    bpl QINT1                   ; If number of places >= 7 shift 1 place at a time.
    jsr shiftr_FAC
    sty BITS                    ; Zero bits since adder wants zero.
QINT_ret:
    rts

QINT1:
    tay                             ; Put count in counter
    lda FAC1_sign
    and #$80                        ; Get sign bit
    lsr FAC1_mantissa               ; Save first shifted byte
    ora FAC1_mantissa
    sta FAC1_mantissa
    jsr short_shift_FAC             ; Shift the rest
    sty BITS                        ; Zero [BITS]
    rts
