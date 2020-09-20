;; #LAYOUT# M65 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; ROM mapping routines for MEGA65
;

; Available memory maps:
; - NORMAL  - nothing mapped in (taken from Kernal)
; - BASIC_1 - for calling KERNAL_1 segment code


map_BASIC_1:

	php
	pha
	phx
	phy
	phz

	lda #$00
	tay
	taz

	lda #$20
	ldx #$C2    ; $4000 <- map 16KB from $22000

	jmp map_end
