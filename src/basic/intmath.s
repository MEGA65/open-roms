;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; minimal integer-only arithmetic support
;
; The FRMEVL float support is incomplete (fetching float literals, pushing
; float values, and all the operators are stubs). This file provides a
; minimal integer-only implementation:
;
; - frmevl_fetch_int      - parses an unsigned integer literal (up to 65535)
;                          into FAC1 as a float; no decimals/exponents
; - emu_push_fac1_float  - pushes FAC1 onto the FRMEVL stack (inline in frmevl.s)
; - pop_fac2_value         - pops a pushed float value into FAC2 (used by operators)
; - fac1_to_int16        - FAC1 -> 16 bit unsigned integer (carry set if the
;                          value is not an integer in 0..65535 range)
; - int16_to_fac1        - 16 bit unsigned integer -> FAC1 float
;
; FAC1 = $61 (exponent), $62-$65 (mantissa, big endian, hidden top bit),
;        $66 (sign); FAC2 = $69-$6E, same layout.
;

;
!ifdef CONFIG_BASIC_MINIMAL_INTMATH {

; frmevl_fetch_int - parse unsigned integer literal at TXTPTR into FAC1
; entry: TXTPTR points at the first character (fetch_variable failed)
; exit:  jumps to FRMEVL_got_value_float with FAC1 set
;
frmevl_fetch_int:

	; V = 0, accumulated in __FAC1+1 (hi) / __FAC1+2 (lo)

	lda #$00
	sta __FAC1+1
	sta __FAC1+2

@loop:

	jsr fetch_character

	sec
	sbc #$30                           ; PETSCII '0'
	bcc @done                          ; below '0' - end of the number
	cmp #$0A
	bcs @done                          ; above '9' - end of the number

	; V = V * 10 + digit; digit in A
	; __FAC1+3/+4 = temporary copy of V for *10 computation

	pha                                ; save digit

	; T = V * 2

	lda __FAC1+2
	asl
	sta __FAC1+3
	lda __FAC1+1
	rol
	sta __FAC1+4

	; V = V * 8  (shift left 3)

	asl __FAC1+2
	rol __FAC1+1
	asl __FAC1+2
	rol __FAC1+1
	asl __FAC1+2
	rol __FAC1+1

	; V = V + T

	lda __FAC1+2
	clc
	adc __FAC1+3
	sta __FAC1+2
	lda __FAC1+1
	adc __FAC1+4
	sta __FAC1+1

	; V = V + digit

	pla                                ; retrieve digit
	clc
	adc __FAC1+2
	sta __FAC1+2
	bcc @loop
	inc __FAC1+1                       ; carry into hi byte (wraps on overflow)
	jmp @loop

@done:

	; Put back the character which terminated the number

	jsr unconsume_character

	; Convert V to FAC1 float and report a float value

	ldx __FAC1+1
	lda __FAC1+2
	jsr int16_to_fac1

	jmp FRMEVL_got_value_float

;
; pop_fac2_value - pop value pushed by the FRMEVL float push into FAC2
; entry (below the return address): stack = type byte, then FAC bytes (+4..+0)
; if the type is not float - NOT IMPLEMENTED error
; note: the subroutine return address has to be temporarily moved away,
; the pushed value sits below it on the stack
;
pop_fac2_value:

	pla                                ; return address, low
	sta __FAC1+5
	pla                                ; return address, high
	sta __FAC2+5

	pla                                ; value type
	beq @1

	jmp do_NOT_IMPLEMENTED_error       ; string operand not supported

@1:
	pla
	sta __FAC2+4
	pla
	sta __FAC2+3
	pla
	sta __FAC2+2
	pla
	sta __FAC2+1
	pla
	sta __FAC2+0

	lda __FAC2+5                       ; restore the return address
	pha
	lda __FAC1+5
	pha

	rts

;
; fac1_to_int16 / fac2_to_int16 - convert FAC to 16 bit unsigned integer
; exit: carry clear - X = hi byte, A = lo byte (FAC mantissa trashed)
;       carry set   - value not integral or above 65535
;
fac1_to_int16:

	ldx #$00                           ; FAC1 base ($61)

	+skip_2_bytes_trash_nvz            ; skip the ldx #$08 below

fac2_to_int16:

	ldx #$08                           ; FAC2 base ($69 = $61 + 8)

facN_to_int16:

	lda __FAC1+0, x                    ; exponent
	beq @zero

	cmp #$90
	bcc @1
	bne @bad                           ; above $90 - certainly above 65535

@1:
	; Shift mantissa right by ($A0 - exponent), dropped bits must be 0

	lda #$A0
	sec
	sbc __FAC1+0, x
	tay

@shift:
	lsr __FAC1+1, x
	ror __FAC1+2, x
	ror __FAC1+3, x
	ror __FAC1+4, x
	bcs @bad                           ; dropped bit 1 - not an integer
	dey
	bne @shift

	; Result has to fit into 16 bits

	lda __FAC1+1, x
	ora __FAC1+2, x
	bne @bad

	lda __FAC1+4, x
	pha
	lda __FAC1+3, x
	tax
	pla
	clc
	rts

@zero:
	ldx #$00
	txa
	clc
	rts

@bad:
	sec
	rts

; int16_to_fac1 - convert 16 bit unsigned integer to FAC1 float
; entry: X = hi byte, A = lo byte
;
int16_to_fac1:

	stx __FAC1+1
	sta __FAC1+2
	lda #$00
	sta __FAC1+3
	sta __FAC1+4
	sta __FAC1+5                       ; sign = positive

	lda #$90                           ; exponent for value * 2^16
	sta __FAC1+0

	lda __FAC1+1
	ora __FAC1+2
	bne @norm

	sta __FAC1+0                       ; value 0 - exponent 0 (A is 0 here)
	rts

@norm:
	lda __FAC1+1
	bmi @done                          ; top bit set - normalized

	asl __FAC1+4
	rol __FAC1+3
	rol __FAC1+2
	rol __FAC1+1
	dec __FAC1+0
	bne @norm

@done:
	rts

;
; store_fac1_var - store FAC1 (5 bytes) into the variable at VARPNT
;
store_fac1_var:

	ldy #$00
@1:
	lda __FAC1, y
	sta (VARPNT), y
	iny
	cpy #$05
	bne @1

	rts

;
; load_fac1_var - load FAC1 (5 bytes) from the variable at VARPNT
;
load_fac1_var:

	ldy #$00
@1:
	lda (VARPNT), y
	sta __FAC1, y
	iny
	cpy #$05
	bne @1

	rts

;
; push_for_frame - push the 13 byte FOR frame from zero page locations:
; marker, VARPNT, OLDTXT, CURLIN, limit (__FAC2+0/+1), step (__FAC2+2/+3),
; TXTPTR - in this order, so that the loop-back pops read txt..marker.
;
push_for_frame:

	pla                                ; move the return address aside,
	sta $FD                            ; the frame has to sit below it
	pla
	sta $FE

	lda TXTPTR+1
	pha
	lda TXTPTR+0
	pha
	lda OLDTXT+1
	pha
	lda OLDTXT+0
	pha
	lda CURLIN+1
	pha
	lda CURLIN+0
	pha
	lda #$81
	pha
	lda VARPNT+1
	pha
	lda VARPNT+0
	pha
	lda __FAC2+1
	pha
	lda __FAC2+0
	pha
	lda __FAC2+3
	pha
	lda __FAC2+2
	pha

	lda $FE                            ; restore the return address
	pha
	lda $FD
	pha

	rts

} ; CONFIG_BASIC_MINIMAL_INTMATH
