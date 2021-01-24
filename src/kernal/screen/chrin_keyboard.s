;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Keyboard part of the CHRIN routine
;


chrin_keyboard:

!ifdef CONFIG_MB_M65 {

	jsr M65_MODEGET
	+bcc m65_chrin_keyboard
}

	; Preserve .X and .Y registers

	stx XSAV
	+phy_trash_a

	; FALLTROUGH

chrin_keyboard_repeat:

	; Do we have a line of input we are currently returning?
	; If so, return the next byte, and clear the flag when we reach the end.

	lda CRSW
	beq chrin_keyboard_read

	; We have input waiting at (LSXP)+CRSW
	; When CRSW = INDX, then we return a carriage return and clear the flag
	cmp INDX
	bne chrin_keyboard_not_end_of_input

	; Clear pending input and quote flags
	lda #$00
	sta CRSW
	sta QTSW

	; FALLTROUGH

chrin_keyboard_empty_line:

	; For an empty line, just return the carriage return

	+ply_trash_a
	ldx XSAV
	clc
	lda #$0D
	rts

chrin_keyboard_not_end_of_input:

	; Advance index, return the next byte
	
	inc CRSW
	tay

	; FALLTROUGH

chrin_keyboard_return_byte:

	lda (LSXP),y
	jsr screen_check_toggle_quote
	tax
	+ply_trash_a
	txa
	ldx XSAV
	jsr screen_code_to_petscii
	clc
	rts

chrin_keyboard_read:

	jsr cursor_enable

	; Wait for a key
	lda NDX
	beq chrin_keyboard_repeat

	lda KEYD
	cmp #$0D
	bne chrkn_keyboard_not_enter

	; FALLTROUGH

chrin_keyboard_enter:

	jsr cursor_disable
	jsr pop_keyboard_buffer
	jsr cursor_hide_if_visible

	; It was enter. Note that we have a line of input to return, and return the first byte
	; after computing and storing its length (Computes Mapping the 64, p96)

	; Set pointer to line of input
	lda PNT+0
	sta LSXP+0
	lda PNT+1
	sta LSXP+1

	; If the current line is a continuation of the previous one, decrease LSXP by 40
	ldy TBLX
	lda LDTB1, y
	bmi chrin_enter_calc_length        ; branch if not continuation
	lda LSXP+0
	sec
	sbc #40
	sta LSXP+0
	bcs @1
	dec LSXP+1
@1:
	ldy #80
	bne chrin_enter_loop               ; branch always

chrin_enter_calc_length:

	; Get the logical line length
	jsr screen_get_logical_line_end_ptr
	iny

chrin_enter_loop:

	; Skip spaces at the end of line
	dey
	bmi chrin_keyboard_empty_line
	lda (LSXP),y
	cmp #$20
	beq chrin_enter_loop
	iny
	sty INDX

	; Set mark informing that we are returning a line
	ldy #$01
	sty CRSW          ; XXX has to get previous PNTR+1, not 1

	; Clear quote mode mark
	dey                                ; set .Y to 0
	sty QTSW

	; Return first char of line
	beq chrin_keyboard_return_byte     ; branch always

chrkn_keyboard_not_enter:

	lda KEYD

!ifdef CONFIG_PROGRAMMABLE_KEYS {

	jsr chrin_programmable_keys
	bcc chrin_keyboard_enter
}

	; Print character, keep looking for input from keyboard until carriage return
	jsr CHROUT
	jsr pop_keyboard_buffer
	+bra chrin_keyboard_read
