
; Monitor helper code - output printing


Print_Attr_Bold:

	jsr Print_Attr_Common1
	lda #'s'
	bra Print_Attr_Common2

Print_Attr_NoBold:

	jsr Print_Attr_Common1
	lda #'u'

	; FALLTROUGH

Print_Attr_Common2:

	jmp CHROUT

Print_Attr_Common1:

	lda #$00
	sta QTSW     ; make sure quote mode is disabled
	lda #KEY_ESC
	jmp CHROUT
