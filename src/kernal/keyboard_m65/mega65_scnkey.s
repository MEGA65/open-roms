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

m65_scnkey_loop:

	stx KBSCN_SELECT
	lda KBSCN_PEEK
	eor #$FF                           ; let bit 1 mean 'pressed', not the otherwise
	sta M65_KB_COLSCAN, x
	ora M65_KB_COLSUM
	sta M65_KB_COLSUM
	dex
	bpl m65_scnkey_loop

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

m65_scnkey_shflag_loop:

	inx
	asr
	bcc m65_scnkey_shflag_next

	; Bucky key pressed

	pha
	lda kb_matrix_bucky_shflag, x
	ora SHFLAG
	sta SHFLAG
	pla

    ; FALLTROUGH

m65_scnkey_shflag_next:

	bne m65_scnkey_shflag_loop

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
	beq m65_scnkey_no_key              ; branch if no key was pressed   XXX try joystick

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
	asr
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
	clc
	adc M65_KB_PRESSED+0
	sta M65_KB_PRESSED+0

	bra m65_scnkey_loop_2

m65_scnkey_next_1:

	dex
	bpl m65_scnkey_loop_1

	rts

	;
	; Analyze currently and previously pressed keys
	;

	; XXX add proper implementation
	ldx M65_KB_PRESSED+0

	;
	; Convert the key coordinates to key code
	;

	; XXX add proper implementation
	ldy __kb_matrix_normal, x
	beq m65_scnkey_no_key

m65_scnkey_output_key:

	;
	; Output selected key to the keyboard buffer
	;

	; Check if we have free space in the keyboard buffer

	lda NDX
	cmp XMAX
	+bcs scnkey_buffer_full

	; Put the key into the keyboard buffer

	inc $D020

	tya
	ldy NDX
	sta KEYD, y
	inc NDX

	rts


	; XXX


	



m65_scnkey_jam:

	; XXX

	jmp m65_scnkey_init_pressed

m65_scnkey_no_key:

	; XXX

	rts
