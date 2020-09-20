;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Helper routine to copy string descriptor
;


!ifdef CONFIG_MEMORY_MODEL_38K {

helper_strdesccpy:

	ldy #$00
	lda (VARPNT), y
	sta DSCPNT+0
	iny
	lda (VARPNT), y
	sta DSCPNT+1
	iny
	lda (VARPNT), y
	sta DSCPNT+2

	rts
}
