;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


; Well-known BASIC routine, described in:
;
; - [CM64] Computes Mapping the Commodore 64 - page 102
; - https://sta.c64.org/cbm64basconv.html
;
; Output:
; - VALTYP - $00 = floating number, $FF = string
; - for float: FAC1
; - for string: __FAC1 + 0 = length, __FAC1 + 1 = pointer to string
;
; Idea:
; - use a stack to reorder operations, so that they can be executed
;   in a correct order
;

; XXX finish the implementation: invoking functions, fetching floats


FRMEVL:

	; Push the sentinel to the stack

	lda #$00
	pha

	; FALLTROUGH

FRMEVL_loop:

	; At this point there are 4 valid possibilities:
	; - a string, a float, pi, or a variable (in short: a value to fetch)
	; - a token (whichj means function to execute)
	; - an unary operator
	; - an opening bracket

	; Check if end of statement, fetch the character

	jsr is_end_of_statement
	+bcs do_SYNTAX_error
	jsr fetch_character

	; Check for a string or opening bracket

	cmp #$22                           ; check for opening quote
	beq FRMEVL_fetch_string
	cmp #$28                           ; check for opening bracket
	beq FRMEVL_handle_bracket

	; Check for unary operators

	cmp #$AB                           ; check for unary minus
	+beq FRMEVL_unary_minus
	cmp #$A8                           ; check for NOT
	+beq FRMEVL_unary_not

	; Check for the PI

	cmp #$FF                           ; check for PI
	+beq FRMEVL_fetch_PI

	; If not a PI and not an unary operator, than everything above
	; $7F has to be a function

	cmp #$80                           ; check for a token
	bcs FRMEVL_execute_function

	; Check for a variable

!ifndef HAS_OPCODES_65CE02 {
	jsr unconsume_character
} else {
	dew TXTPTR
}
	jsr fetch_variable
	bcs FRMEVL_fetch_float

	; Found the variable - copy descriptor to FAC1

!ifdef CONFIG_MEMORY_MODEL_60K {
	
	ldx #<VARPNT

	ldy #$00
	jsr peek_under_roms
	sta __FAC1+0
	iny
	jsr peek_under_roms
	sta __FAC1+1
	iny
	jsr peek_under_roms
	sta __FAC1+2

} else ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {
	
	jsr helper_frmevl_strdesccpy

} else { ; CONFIG_MEMORY_MODEL_38K

	ldy #$00
	lda (VARPNT),y
	sta __FAC1+0
	iny
	lda (VARPNT),y
	sta __FAC1+1
	iny
	lda (VARPNT),y
	sta __FAC1+2
}

	+bra FRMEVL_got_value

;
; This subroutine handles the situation when we have to execute a BASIC function
; in place when parser normally expects a value
;

FRMEVL_execute_function:

	; XXX implement this - use function_jumptable*

	jmp do_NOT_IMPLEMENTED_error

;
; These two subroutines handles the situation when we got an unary operator
; in place when parser normally expects a value
;

FRMEVL_unary_not:

	ldy #$0D                           ; our code for unary NOT
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

FRMEVL_unary_minus:

	ldy #$0E                           ; our code for unary NOT
	jmp FRMEVL_push_operator_address

;
; This subroutine handle brackets - it just calls FRMEVL recursively
; and consumes the closing bracket afterwards
;

FRMEVL_handle_bracket:

	jsr FRMEVL
	jsr fetch_character
	cmp #$29                           ; closing bracket
	beq FRMEVL_got_value

	jmp do_SYNTAX_error

;
; This subroutine handles the situation when our value to fetch is PI
;

FRMEVL_fetch_PI:

	lda #<const_PI
	ldy #>const_PI
	jsr mov_MEM_FAC1

	+bra FRMEVL_got_value_float

;
; This subroutine fetches the floating point value from the 'outside world'
;

FRMEVL_fetch_float:

	; XXX implement this

	jmp do_NOT_IMPLEMENTED_error

	; FALLTROUGH

FRMEVL_got_value_float:

	lda #$00
	sta VALTYP
	beq FRMEVL_got_value

;
; This subroutine fetches the string value from the 'outside world'
;

FRMEVL_fetch_string:

	; Mark return value as a string, set initial length as 0

	ldx #$FF
	stx VALTYP

	inx
	stx __FAC1 + 0

	; Set pointer to start of the string

	ldx TXTPTR + 0
	stx __FAC1 + 1
	ldx TXTPTR + 1
	stx __FAC1 + 2
@1:
	; Search for closing quote

	jsr fetch_character
	cmp #$22
	beq FRMEVL_got_value
	cmp #$00
	beq @2

	inc __FAC1 + 0
	bne @1

	jmp do_STRING_TOO_LONG_error
@2:
	; No closing quote, but end of the data

!ifndef HAS_OPCODES_65CE02 {
	jsr unconsume_character
} else {
	dew TXTPTR
}

	; FALLTROUGH


;
; This subroutine handles the situation after fetching the value from 'outside world':
; - either there is nothing sane remaining there; if so, this value is or final result
; - or there is an operator following the value; in such case we have much more work to do;
;   we push the current value and the operator to the stack and we proceed to fetch the next
;   value (which is mandatory)
;   small catch: if the priority of the new operator is not higher than priority of the last
;   operator on the stack (sentinel is considered as the lowest priority operator) we first
;   compute what currently is present on the stack - this enforces proper operator precedence
;

FRMEVL_got_value:

	jsr is_end_of_statement
	bcs FRMEVL_compute_all             ; compute the stack if expression ended

	; FALLTROUGH

FRMEVL_fetch_operator:

	; We have a value, but this is not the end of expression. Check if
	; there is an operator waiting to be served

	jsr fetch_operator
	bcs FRMEVL_compute_all             ; if operator not recognized, compute what we have
	                                   ; on stack and quit

	; Move the new operator ID to .Y

	tay

	; Compare the priority of the last operator with the new one

	pla
	pha

	cmp operator_priorities, y 
	bcc FRMEVL_push_value_operator

	; Here the priority is not higher - so compute what we already have on stack
	; but do not finish proccessing

	sty OPPTR+1                        ; store .Y, we want to preserve it
	lda #$FF                           ; mark that we want to return here
	sta OPPTR+0

	; FALLTROUGH

FRMEVL_fetch_operator_end:
	
	jmp FRMEVL_compute_partial

FRMEVL_compute_partial_return:

	pla
	pha
	bne FRMEVL_fetch_operator_end

	ldy OPPTR+1

	; FALLTROUGH

FRMEVL_push_value_operator:

	; Push the value from FAC1

	ldx VALTYP
	bmi FRMEVL_push_string

	; Push float

	; XXX implement this

FRMEVL_push_string:

	; Push string - length, address, type

	lda __FAC1+0
	pha

	lda __FAC1+1
	pha
	lda __FAC1+2
	pha

	txa
	pha

	; FALLTROUGH

FRMEVL_push_operator_address:

	; Check if there is enough stack space; this could not have been done earlier,
	; as this is the place where unary operator support calls

	jsr check_stack_space

	; Push the operator address to stack, in a form
	; suitable for RTS

	lda operator_jumptable_hi, y
	pha
	lda operator_jumptable_lo, y
	pha

	; Push operator priority

	lda operator_priorities, y
	pha

	; Continue

	jmp FRMEVL_loop

;
; This part serves two purposes:
; - it is an exit point for the concrete operator implementations
; - it causes computation of everything which is stored on the stack 
;

FRMEVL_compute_all:

	lda #$00
	sta OPPTR+0

	; FALLTROUGH

FRMEVL_continue:

	lda OPPTR+0
	bne FRMEVL_compute_partial_return

	; FALLTROUGH

FRMEVL_compute_partial:

	; Now, we have to compute operation; at this point we should have a value
	; in FAC1 and (most likely) operator on a stack

	pla                                ; priority does not matter here, get rid of it
	rts                                ; this either jumps to operator, or quits FRMEVL
