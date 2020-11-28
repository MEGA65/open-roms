;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE


m65_scnkey:

	; First scan the whole keyboard

	lda KBSCN_BUCKY
	sta M65_KB_BUCKY

	ldx #$08
@1:
	stx KBSCN_SELECT
	lda KBSCN_PEEK
	eor #$FF                           ; let bit 1 mean 'pressed', not the otherwise
	sta M65_KB_COLSCAN, x
	dex
	bpl @1

	; Update the SHFLAG

	lda SHFLAG
	sta LSTSHF                         ; needed for SHIFT+VENDOR support

	ldy #$00                           ; the new SHFLAG will be constructed in .Y
	ldx M65_KB_BUCKY
	beq m65_scnkey_SHFLAG_ready

	; FALLTROUGH

m65_scnkey_detect_SHIFT:

	txa
	and #%00000011
	beq m65_scnkey_detect_VENDOR

	tya
	ora #KEY_FLAG_SHIFT
	tay

	; FALLTROUGH

m65_scnkey_detect_VENDOR:
	
	txa
	and #%00001000
	beq m65_scnkey_detect_CTRL

	tya
	ora #KEY_FLAG_VENDOR
	tay

	; FALLTROUGH

m65_scnkey_detect_CTRL:
	
	txa
	and #%00000100
	beq m65_scnkey_detect_ALT

	tya
	ora #KEY_FLAG_CTRL
	tay

	; FALLTROUGH

m65_scnkey_detect_ALT:
	
	txa
	and #%00010000
	beq m65_scnkey_detect_CAPS_LOCK

	tya
	ora #KEY_FLAG_ALT
	tay

	; FALLTROUGH

m65_scnkey_detect_CAPS_LOCK:
	
	txa
	and #%01000000
	beq m65_scnkey_detect_NO_SCRL

	tya
	ora #KEY_FLAG_NO_SCRL
	tay

	; FALLTROUGH

m65_scnkey_detect_NO_SCRL:
	
	txa
	and #%00100000
	beq m65_scnkey_SHFLAG_ready

	tya
	ora #KEY_FLAG_CAPSL
	tay

	; FALLTROUGH

m65_scnkey_SHFLAG_ready:

	sty SHFLAG
	

	; XXX


	rts
