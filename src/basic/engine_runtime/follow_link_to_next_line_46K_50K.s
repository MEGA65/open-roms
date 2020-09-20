;; #LAYOUT# STD *       #TAKE-HIGH
;; #LAYOUT# *   BASIC_0 #TAKE-HIGH
;; #LAYOUT# *   *       #IGNORE

; This has to go $E000 or above - routine below banks out the main BASIC ROM!


!ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {

follow_link_to_next_line:

	; Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	ldy #0	
	lda (OLDTXT), y
	pha

	iny
	lda (OLDTXT), y

	sta OLDTXT+1
	pla
	sta OLDTXT+0

	// Restore default mapping and quit

	jmp remap_BASIC
}
