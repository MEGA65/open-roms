;; #LAYOUT# STD *       #TAKE-HIGH
;; #LAYOUT# *   BASIC_0 #TAKE-HIGH
;; #LAYOUT# *   *       #IGNORE

; This has to go $E000 or above - routines below banks out the main BASIC ROM!

;
; Helper routine to copy string variable content
;


!ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {

helper_strvarcpy:

	; Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	; Retrieve pointer to destination

	ldy #$02
	lda (VARPNT), y
	sta DSCPNT+2
	dey
	lda (VARPNT), y
	sta DSCPNT+1
	dey

	; Copy the string content
@1:
	lda (__FAC1+1),y
	sta (DSCPNT+1),y
	iny
	cpy __FAC1+0
	bne @1

	; Restore default memory mapping

	lda #$27
	sta CPU_R6510

	rts
}
