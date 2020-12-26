;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

; MEGA65 specific part of the hardware


m65_reset_part:

	jsr map_KERNAL_1
	jsr (VK1__m65_colorset_reset)
	jsr map_NORMAL                     ; we want normal memory mapping

	jsr viciv_shutdown                 ; by default we do not want the VIC-IV

	jsr M65_MODEGET
	bcs m65_clr_end

	; Clear MEAGA65 native mode mark, it might cause confusion
	
m65_clr_magictstr:                     ; entry point for mode switching routine

	lda #$00
	sta M65_MAGICSTR+0
	sta M65_MAGICSTR+1
	sta M65_MAGICSTR+2

	; FALLTROUGH

m65_clr_end:

	rts
