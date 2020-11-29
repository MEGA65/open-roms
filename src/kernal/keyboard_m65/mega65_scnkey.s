;; #LAYOUT# M65 KERNAL_0 #TAKE
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

	lda M65_KB_COLSUM
	beq m65_scnkey_no_key

	; XXX




	

m65_scnkey_no_key:



	; XXX


	rts
