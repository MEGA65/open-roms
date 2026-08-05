;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; minimal FOR/NEXT implementation (integer only, see
; intmath.s). Supports: FOR var = start TO limit, integral values,
; step is always 1 (no STEP clause); NEXT [var] - the variable name is
; consumed and ignored. Limit/start must be literal values (expressions
; containing variables or binary operators are not supported).
;
; Stack frame (13 bytes, top of stack listed first):
;   step_lo step_hi lim_lo lim_hi var_lo var_hi $81 cur_lo cur_hi
;   old_lo old_hi txt_lo txt_hi
; txt/cur/old = TXTPTR/CURLIN/OLDTXT right after the FOR statement - they
; are only restored when the loop continues; var = VARPNT of the loop
; variable value (5 float bytes); lim/step = signed 16 bit integers.
; $FB/$FC and $FD/$FE are used as scratch (documented as unused).
;

!ifdef CONFIG_BASIC_MINIMAL_INTMATH {

cmd_for:

	; Pull the dispatcher return address aside - the frame has to sit
	; below it on the stack (it is re-pushed before the final RTS)

	pla
	sta $FB
	pla
	sta $FC

	; Fetch the loop variable name

	jsr fetch_variable_name
	+bcs cmd_for_syntax

	; Require the assignment operator

	jsr injest_assign

	; Preserve VARNAM while evaluating the start expression

	lda VARNAM+1
	pha
	lda VARNAM+0
	pha

	jsr FRMEVL

	pla
	sta VARNAM+0
	pla
	sta VARNAM+1

	; Store the start value into the variable (float, 5 bytes)

	jsr fetch_variable_find_addr
	jsr store_fac1_var

	; Require the TO keyword

	jsr fetch_character
	cmp #$A4                           ; TO token
	bne cmd_for_syntax

	; Evaluate the limit, convert to integer

	jsr FRMEVL
	jsr fac1_to_int16
	+bcs cmd_for_not_implemented

	sta __FAC2+0                       ; lim_lo
	stx __FAC2+1                       ; lim_hi

	; STEP clause is not supported - step is always 1

	lda #$01
	sta __FAC2+2                       ; step_lo
	lda #$00
	sta __FAC2+3                       ; step_hi

	; Push the frame, re-push the dispatcher return address, and quit

	jsr push_for_frame

	lda $FC
	pha
	lda $FB
	pha

	rts

cmd_for_syntax:

	jmp do_SYNTAX_error

cmd_for_not_implemented:

	jmp do_NOT_IMPLEMENTED_error

;
; NEXT [var]
;

cmd_next:

	; Consume the optional variable name

	jsr is_end_of_statement
	bcs @1

	jsr fetch_variable_name

@1:
	; Verify the frame marker (9th byte from the stack top - the frame
	; starts below the 2 byte return address pushed by the dispatcher)

	tsx
	lda $0109, x
	cmp #$81
	bne cmd_for_not_implemented        ; NEXT without FOR

	; Pull the dispatcher return address aside (see cmd_for)

	pla
	sta $FB
	pla
	sta $FC

	; Pop the working part of the frame into zero page locations

	pla
	sta __FAC2+2                       ; step_lo
	pla
	sta __FAC2+3                       ; step_hi
	pla
	sta __FAC2+0                       ; lim_lo
	pla
	sta __FAC2+1                       ; lim_hi
	pla
	sta VARPNT+0
	pla
	sta VARPNT+1
	pla                                ; drop the marker

	; Load the variable value into FAC1

	jsr load_fac1_var
	jsr fac1_to_int16
	+bcs cmd_for_not_implemented

	; Add the step: new value in $FD (lo) / $FE (hi) - int16_to_fac1
	; would trash FAC1, so the value can not stay there

	sta $FD
	stx $FE

	lda $FD
	clc
	adc __FAC2+2
	sta $FD
	lda $FE
	adc __FAC2+3
	sta $FE

	; Store the new value back into the variable

	ldx $FE
	lda $FD
	jsr int16_to_fac1
	jsr store_fac1_var

	; Compare the new value with the limit (both are signed 16 bit,
	; the $8000 offset cancels out in the subtraction):
	; continue while value <= limit, i.e. lim - val does not borrow

	lda __FAC2+0
	sec
	sbc $FD
	lda __FAC2+1
	sbc $FE
	bcc cmd_next_done

	; Loop goes on - pop and restore the loop-back part of the frame

	pla
	sta CURLIN+0
	pla
	sta CURLIN+1
	pla
	sta OLDTXT+0
	pla
	sta OLDTXT+1
	pla
	sta TXTPTR+0
	pla
	sta TXTPTR+1

	; Re-push the whole frame (zero page locations just restored)

	jsr push_for_frame

cmd_next_finish:

	lda $FC
	pha
	lda $FB
	pha

	rts

cmd_next_done:

	; Loop finished - drop the loop-back part of the frame; TXTPTR and
	; friends keep pointing after the NEXT statement

	pla
	pla
	pla
	pla
	pla
	pla

	jmp cmd_next_finish

} ; CONFIG_BASIC_MINIMAL_INTMATH
