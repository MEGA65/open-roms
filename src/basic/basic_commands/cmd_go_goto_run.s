;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


cmd_go:

	jsr fetch_character_skip_spaces
	cmp #$A4                           ; 'TO' keyword
	beq cmd_goto

!ifndef CONFIG_MB_M65 {

	; FALLTROUGH

cmd_go_syntax_error:

	jmp do_SYNTAX_error

} else {

	cmp #$9E                           ; 'SYS' keyword, for 'GO SYS'
	+beq cmd_gosys

	dew TXTPTR                         ; unconsume character

	; Fetch desired mode

	jsr fetch_uint8

	cmp #64
	bne @1

	; If in native mode - switch to C64 compatibilty

	jsr M65_MODEGET
	bcs cmd_go_rts

	jsr helper_ask_if_sure
	+bcs cmd_end
	sec
	jsr M65_MODESET                    ; Carry set = switch to C64 mode
	+bra cmd_go_switchmode_clr_banner
@1:
	cmp #65
	+bne do_ILLEGAL_QUANTITY_error

	; If in C64 compatibility mode - switch to native mode

	jsr M65_MODEGET
	bcc cmd_go_rts

	jsr helper_ask_if_sure
	+bcs cmd_end
	jsr M65_MODESET                    ; Carry clear = switch to M65 mode

	; FALLTROUGH

cmd_go_switchmode_clr_banner:

	jsr do_clr

	ldx CURLIN+1
	inx
	+beq INITMSG

	lda #147
	jmp JCHROUT

cmd_go_rts:

	rts
}

cmd_run:

	; RUN clears all variables

	jsr do_clr

	; Initialize OLDTXT pointer, disable Kernal messages

	jsr init_oldtxt
	lda #$00
	jsr JSETMSG

	; Check if we have any paramenters

	jsr is_end_of_statement
	bcs cmd_run_goto_launch

	; FALLTROUGH

cmd_goto:

	; GOTO requires line number
	; XXX in case of no parameter, go to line 0 - checked with original ROMs

	jsr fetch_line_number
!ifndef CONFIG_MB_M65 {
	bcs cmd_go_syntax_error
} else {
	+bcs do_SYNTAX_error
}

	; Check for direct mode

	lda CURLIN+1
	bmi cmd_goto_direct

	; Not a direct mode - compare desired line number (LINNUM) with the current one (CURLIN)

	lda LINNUM+1
	cmp CURLIN+1
	bne @2
	lda LINNUM+0
	cmp CURLIN+0
@2:
	; If desired line number is lower - search line number from start

	bcc cmd_goto_from_start

	; Else - search from the current line

	jsr find_line_from_current
	+bra cmd_goto_check

cmd_goto_direct:

	; Disable Kernal messages

	lda #$00
	jsr JSETMSG

	; FALLTROUGH

cmd_goto_from_start:

	; Direct mode - find the line from the beginning

	jsr find_line_from_start

	; FALLTROUGH

cmd_goto_check:

	+bcs do_UNDEFD_STATEMENT_error

	; FALLTROUGH

cmd_run_goto_launch:

	; Run it!

	pha
	pha
	jmp execute_line
