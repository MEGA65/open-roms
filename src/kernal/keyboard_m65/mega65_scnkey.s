;; #LAYOUT# M65 KERNAL_C #TAKE
;; #LAYOUT# *   *        #IGNORE


m65_scnkey:

	;
	; Scan the whole keyboard, store results in memory
	;

	lda #$00
	sta M65_KB_COLSUM

	ldx #$08

	lda #%01111111
	and KBSCN_BUCKY
	sta M65_KB_BUCKY

	; FALLTROUGH

m65_scnkey_fetch_loop:

	stx $D614
	lda $D613
	eor #$FF                           ; let bit 1 mean 'pressed', not the otherwise
	sta M65_KB_COLSCAN, x
	ora M65_KB_COLSUM
	sta M65_KB_COLSUM
	dex
	bpl m65_scnkey_fetch_loop

	;
	; Retrieve SHIFT / VENDOR / CTRL / ALT / NO SCROLL / CAPS LOCK status
	;

	lda SHFLAG
	sta LSTSHF                         ; needed for SHIFT+VENDOR support

	ldx #$00
	stx SHFLAG

	lda M65_KB_BUCKY
	dex                                ; index into kb_matrix_bucky_shflag

	; FALLTROUGH

m65_scnkey_bucky_loop:

	inx
	asr                                ; ASR preserves most significant bit, but in our case it is 0
	bcc m65_scnkey_bucky_next

	; Bucky key pressed

	pha
	lda kb_matrix_bucky_shflag, x
	ora SHFLAG
	sta SHFLAG
	pla

    ; FALLTROUGH

m65_scnkey_bucky_next:

	bne m65_scnkey_bucky_loop

	; Set KEYTAB vector

	lda KEYLOG+1
	bne @1
	jsr m65_scnkey_set_keytab          ; KEYLOG routine on zeropage? most likely vector not set
	bra m65_scnkey_keytab_set_done
@1:
	jsr (KEYLOG)

m65_scnkey_keytab_set_done:

	;
	; Scan the keyboard matrix stored in memory to determine which keys were pressed
	;

	ldx #$02
@1:
	lda M65_KB_PRESSED, x
	sta M65_KB_PRESSED_OLD, x
	dex
	bpl @1

	jsr m65_scnkey_init_pressed

	lda M65_KB_COLSUM
	beq m65_scnkey_no_keys              ; branch if no key was pressed   XXX try joystick

	ldx #$08

	; FALLTROUGH

m65_scnkey_loop_1:

	lda M65_KB_COLSCAN, x
	pha
	ldy #$FF

	; FALLTROUGH

m65_scnkey_loop_2:

	iny
	pla
	beq m65_scnkey_next_1
	clc
	ror                                ; can't use ASR here, as it preserves most significant bit
	pha
	bcc m65_scnkey_loop_2

	; Found a pressed key - add it to the list

	lda M65_KB_PRESSED+2
	bpl m65_scnkey_jam                 ; branch if too many keys pressed
	lda M65_KB_PRESSED+1
	sta M65_KB_PRESSED+2
	lda M65_KB_PRESSED+0
	sta M65_KB_PRESSED+1

	sty M65_KB_PRESSED+0
	txa
	asl
	asl
	asl
	adc M65_KB_PRESSED+0               ; Carry already cleared by ASL
	sta M65_KB_PRESSED+0

	bra m65_scnkey_loop_2

m65_scnkey_next_1:

	dex
	bpl m65_scnkey_loop_1

	;
	; Analyze currently and previously pressed keys
	;

	; XXX add proper implementation
	ldy M65_KB_PRESSED+0








	; FALLTROUGH

m65_scnkey_got_key: ; .Y should now contain the key offset in matrix pointed by KEYTAB

	cpy LSTX
	beq m65_scnkey_try_repeat          ; branch if the same key as previously
	sty LSTX

	; Reset key repeat counters

	lda #CONFIG_KEY_DELAY
	sta DELAY

	; FALLTROUGH

m65_scnkey_output_key:

	;
	; Output selected key to the keyboard buffer
	;

	; Check if we have free space in the keyboard buffer

	lda NDX
	cmp XMAX
	+bcs scnkey_buffer_full

	; Reinitialize secondary counter

	lda #$03
	sta KOUNT

	; Retrieve the PETSCII code

	lda (KEYTAB), y

	; FALLTROUGH

m65_scnkey_got_petscii:

	; Put the key into the keyboard buffer

	beq m65_scnkey_no_keys             ; branch if we have no PETSCII code for this key
	ldy NDX
	sta KEYD, y
	inc NDX

	; FALLTROUGH

m65_scnkey_done:

	rts

m65_scnkey_jam:

	pla
	jsr m65_scnkey_init_pressed

	; FALLTROUGH

m65_scnkey_no_keys:

	; Mark no key press

	lda #$48
	sta LSTX
	rts

m65_scnkey_try_repeat:

!ifndef CONFIG_KEY_REPEAT_ALWAYS {

	; Check whether we should repeat keys - first the flag, afterwards hardcoded list

	lda RPTFLG
	bmi m65_scnkey_handle_repeat           ; branch if we should repeat always

	tya
	ldx #(__kb_matrix_alwaysrepeat_end - kb_matrix_alwaysrepeat - 1)
@1:
	cmp kb_matrix_alwaysrepeat, x
	beq m65_scnkey_handle_repeat
	dex
	bpl @1
	bmi m65_scnkey_done

	; FALLTROUGH

m65_scnkey_handle_repeat:

} ; no CONFIG_KEY_REPEAT_ALWAYS

	; Countdown before first repeat

	lda DELAY
	beq @1
	dec DELAY

	rts
@1:
	; Countdown before subsequent repeats

	lda KOUNT
	beq m65_scnkey_output_key          ; if second counter is also 0, we can repeat the key
	dec KOUNT

	rts
