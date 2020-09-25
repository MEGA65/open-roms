;; #LAYOUT# STD *       #TAKE-HIGH
;; #LAYOUT# *   BASIC_0 #TAKE-HIGH
;; #LAYOUT# *   *       #IGNORE

; This has to go $E000 or above - routine below banks out the main BASIC ROM!


!ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {

helper_execute_line_statements:

	; Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	; Update CURLIN

	lda (OLDTXT), y
	sta CURLIN+0
	
	iny
	lda (OLDTXT), y
	sta CURLIN+1

	; Restore memory mapping and continue

	lda #$27
	sta CPU_R6510

	jmp execute_statements
}
