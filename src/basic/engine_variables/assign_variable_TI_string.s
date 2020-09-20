;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


assign_variable_TI_string:

	; Evaluate the expression, check if the result is suitable

	jsr FRMEVL

	lda VALTYP
	+bpl do_TYPE_MISMATCH_error      ; branch if not string
	
	lda __FAC1+0
	cmp #$06
	+bne do_ILLEGAL_QUANTITY_error   ; we need exactly 6-character string

	; Initialize new time counter, process all the digits

	ldy #$00

	sty INDEX+0
	sty INDEX+1
	sty INDEX+2

	; FALLTROUGH

assign_variable_TI_string_loop:

	; First fetch the digit

!ifdef CONFIG_MEMORY_MODEL_60K {
	ldx #<(__FAC1 + 1)
	jsr peek_under_roms
} else ifdef CONFIG_MEMORY_MODEL_46K_OR__50K {
	jsr peek_under_roms_via_FAC1_PLUS_1
} else { ; CONFIG_MEMORY_MODEL_38K
	lda (__FAC1 + 1), y
}

	jsr convert_PETSCII_to_digit
	+bcs do_ILLEGAL_QUANTITY_error

	tax                      ; move decoded digit to .X

	; Strangely, original implementation seems to be very permissive,
	; it accepts any digit at any position; for compatibility
	; we should better follow this convention

assign_variable_TI_string_loop_digit:

	cpx #$00
	beq assign_variable_TI_string_loop_next

	clc
	lda table_TI_lo, y
	adc INDEX+0
	sta INDEX+0
	lda table_TI_mid, y
	adc INDEX+1
	sta INDEX+1
	lda table_TI_hi, y
	adc INDEX+2
	sta INDEX+2

	dex
	bpl assign_variable_TI_string_loop_digit     ; branch always

assign_variable_TI_string_loop_next:

	iny
	cpy #$06
	bne assign_variable_TI_string_loop

	; Set the resulting value

	ldy INDEX+2
	ldx INDEX+1
	lda INDEX+0

	jmp JSETTIM
