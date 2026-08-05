;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Math package - print FAC1 value
;
; minimal integer-only implementation (see intmath.s);
; prints integral values in -32767..65535 range, anything else is reported
; as not implemented. Sign handling: FAC1 sign byte, C64 style leading
; space for positive numbers.
;

!ifndef CONFIG_BASIC_MINIMAL_INTMATH {

print_FAC1:

	+STUB_IMPLEMENTATION

} else ifdef CONFIG_MB_M65 {

print_FAC1:

	; should not be needed for the MEGA65 build - XXX provide error

	jmp do_NOT_IMPLEMENTED_error

} else {

print_FAC1:

	; Handle the sign first (C64 prints space for positive numbers)

	lda __FAC1+5
	bmi @1

	lda #$20                           ; space for positive values
	+skip_2_bytes_trash_nvz

@1:
	lda #$2D                           ; minus for negative values

	jsr JCHROUT

	; Convert to 16 bit integer (mantissa holds the magnitude)

	jsr fac1_to_int16
	bcs print_FAC1_bad

	; Print the integer - print_integer wants .A = hi, .X = lo
	; (it trashes FAC1, just like the original C64 implementation)

	sta __FAC1+0                       ; FAC1 content can be trashed now
	txa
	ldx __FAC1+0

	jmp print_integer

print_FAC1_bad:

	jmp do_NOT_IMPLEMENTED_error

}
