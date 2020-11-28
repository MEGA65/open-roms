;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE


m65_scnkey:

	; Read the key from automatic scanner

	lda KBSCN_BUCKY
	ldy KBSCN_KEYCODE
	sty KBSCN_KEYCODE

	; Update the SHFLAG in a way that preserves .Y

	and #%01111111

	ldx SHFLAG
	stx LSTSHF                         ; needed for SHIFT+VENDOR support

	ldx #$00
	stx SHFLAG
	dex

	; FALLTROUGH

m65_scnkey_SHFLAG_loop:

	inx
	asr
	bcc m65_scnkey_SHFLAG_next

	; Bucky key pressed

	pha
	lda m65_kb_matrix_bucky, x
	ora SHFLAG
	sta SHFLAG
	pla

	; FALLTROUGH

m65_scnkey_SHFLAG_next:

	bne m65_scnkey_SHFLAG_loop

	; We have the key code in .Y - check if same as the last one

	cpy LSTX
	beq m65_scnkey_try_repeat

	; Not the same key - store the key code, reset delay counter

	sty LSTX
!ifndef CONFIG_RS232_UP9600 {
	lda #$16
} else {
	lda #$18
}
	sta DELAY

	; FALLTROUGH

m65_scnkey_output_key:

	; Check if we have free space in the keyboard buffer

	lda NDX
	cmp XMAX
	+bcs scnkey_early_repeat           ; branch if no free space in buffer

	; Reinitialize secondary counter

	lda #$03
	sta KOUNT

	; Output PETSCII code to the keyboard buffer

m65_scnkey_got_petscii:

	; XXX if no key pressed, try joysticks

	tya
	beq m65_scnkey_done                ; branch if no key was pressed
	ldy NDX
	sta KEYD, y
	inc NDX

	; FALLTROUGH

m65_scnkey_done:

	rts

m65_scnkey_try_repeat:

!ifndef CONFIG_KEY_REPEAT_ALWAYS {

	; Check whether we should repeat keys - first the flag, afterwards hardcoded list

	lda RPTFLG
	bmi m65_scnkey_handle_repeat           ; branch if we should repeat always

	; XXX if key to be repeated - go to m65_scnkey_handle_repeat, otherwise to m65_scnkey_done

m65_scnkey_handle_repeat:

} ; no CONFIG_KEY_REPEAT_ALWAYS

	; Countdown before first repeat

	lda DELAY
	beq @10
	dec DELAY

	rts
@10:
	; Countdown before subsequent repeats

	lda KOUNT
	beq m65_scnkey_output_key           ; if second counter is also 0, we can repeat the key
	dec KOUNT

	rts
