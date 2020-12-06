;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


cmd_wait:

	; Fetch address, store it on the stack

	jsr fetch_uint16
	+bcs do_SYNTAX_error

	lda LINNUM+0
	pha
	lda LINNUM+1
	pha

	; Fetch 1st value, store it on the stack

	jsr fetch_coma_uint8
	+bcs do_SYNTAX_error
	pha

	; Fetch 2nd value

	jsr fetch_coma_uint8
	bcc @1
	lda #$00
@1:

	; Put all the values into work area

	sta INDEX+3
	pla
	sta INDEX+2
	pla
	sta INDEX+1
	pla
	sta INDEX+0

!ifdef CONFIG_MB_M65 {

	jsr helper_eggshell
}

	ldy #$00
	; FALLTROUGH

cmd_wait_loop:

	; Wait for the congition to be met - see https://www.c64-wiki.com/wiki/WAIT

	lda (INDEX), y
	eor INDEX+3
	and INDEX+2
	beq cmd_wait_loop

	; FALLTROUGH

cmd_wait_end:

	rts
