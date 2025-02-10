;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Continuation of the BASIC cold start routine
;


basic_cold_start_internal:

	; Setup vectors at $300
	ldy #$0B
@1
	lda basic_vector_defaults_1, y
	sta IERROR, y
	dey
	bpl @1

	; Setup misc vectors
	ldy #$04
@2:
	lda basic_vector_defaults_2, y
	sta ADRAY1, y
	dey
	bpl @2

	; Setup USRPOK
	lda #$4C ; JMP opcode
	sta USRPOK
	lda #<do_ILLEGAL_QUANTITY_error
	sta USRADD+0
	lda #>do_ILLEGAL_QUANTITY_error
	sta USRADD+1

	; Clear the BRK location address
	lda #$00
	sta CMP0+0
	sta CMP0+1

	; Print startup messages
	jsr INITMSG

	; Initialize other variables by performing NEW
	jsr do_new

!ifdef CONFIG_MEMORY_MODEL_38K {

	; Copy CHRGET to the zero page
	; This is for maximum C64 compatibility
	jsr copy_CHRGET

}

	; jump into warm start loop
	jmp basic_warm_start
