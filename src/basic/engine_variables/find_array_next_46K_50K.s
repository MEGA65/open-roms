;; #LAYOUT# STD *       #TAKE-HIGH
;; #LAYOUT# *   BASIC_0 #TAKE-HIGH
;; #LAYOUT# *   *       #IGNORE

; This has to go $E000 or above - routines below banks out the main BASIC ROM!


!ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {

find_array_next:

	; Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	; Fetch offset to the next array

	ldy #$03
	lda (VARPNT),y
	pha
	dey
	lda	(VARPNT),y

	; Adjust VARPNT to point to the next array

	clc
	adc VARPNT+0
	sta VARPNT+0

	pla
	adc VARPNT+1
	sta VARPNT+1	

	; Restore default memory mapping

	lda #$27
	sta CPU_R6510

	; Next iteration

	jmp find_array_loop
}
