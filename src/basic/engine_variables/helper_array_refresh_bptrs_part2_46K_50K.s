;; #LAYOUT# STD *       #TAKE-HIGH
;; #LAYOUT# *   BASIC_0 #TAKE-HIGH
;; #LAYOUT# *   *       #IGNORE

; This has to go $E000 or above - routine below banks out the main BASIC ROM!

!ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {

helper_array_refresh_bptrs_part2:

	; Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	; Write new back-pointer

	ldy #$00
	lda (INDEX+0), y
	beq @1

	iny
	clc
	adc (INDEX+0), y
	sta INDEX+4
	iny
	lda #$00
	adc (INDEX+0), y
	sta INDEX+5

	ldy #$00
	lda INDEX+0
	sta (INDEX+4), y
	iny
	lda INDEX+1
	sta (INDEX+4), y

@1:
	; Restore default memory mapping

	jmp remap_BASIC
}

