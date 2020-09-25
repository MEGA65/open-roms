;; #LAYOUT# STD *       #TAKE-HIGH
;; #LAYOUT# *   BASIC_0 #TAKE-HIGH
;; #LAYOUT# *   *       #IGNORE

; This has to go $E000 or above - routines below bank out the main BASIC ROM!

!ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {

helper_gc_set_memmove_src:

	; Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	; Set memmove__src

	lda (OLDTXT),y
	sta memmove__src+0
	iny
	lda (OLDTXT),y
	sta memmove__src+1

	; Restore default memory mapping

	+bra helper_gc_misc_end

helper_gc_increase_oldtxt:

	; Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	; Increase OLDTXT accordingly

	lda (OLDTXT),y
	clc
	adc INDEX+0
	sta (OLDTXT),y
	iny
	lda (OLDTXT),y
	adc INDEX+1
	sta (OLDTXT),y

	; FALLTROUGH

helper_gc_misc_end:

	; Restore default memory mapping

	jmp remap_BASIC
}
