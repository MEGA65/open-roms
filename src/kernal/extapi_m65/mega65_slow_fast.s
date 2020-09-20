;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE


M65_SLOW: ; set CPU speed to 1 MHz

	lda #$40
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

M65_FAST: ; set CPU speed to 40 MHz

	lda #$41
	sta CPU_D6510
	rts
