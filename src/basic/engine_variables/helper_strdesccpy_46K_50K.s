;; #LAYOUT# STD *       #TAKE-HIGH
;; #LAYOUT# *   BASIC_0 #TAKE-HIGH
;; #LAYOUT# *   *       #IGNORE

; This has to go $E000 or above - routine below banks out the main BASIC ROM!

;
; Helper routine to copy string descriptor
;


!ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {

helper_strdesccpy:

	; Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	; Retrieve pointer to destination

	ldy #$00
	lda (VARPNT), y
	sta DSCPNT+0
	iny
	lda (VARPNT), y
	sta DSCPNT+1
	iny
	lda (VARPNT), y
	sta DSCPNT+2

	; Restore default memory mapping

	lda #$27
	sta CPU_R6510

	rts
}
