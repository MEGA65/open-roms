;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Routine to initialize VIC-IV for entering MEGA65 native mode
;


viciv_init:

	; Switch VIC to VIC-IV mode

	jsr viciv_unhide

	; Disable badlines and slow interrupt emulation

	lda #$00
	sta MISC_EMU

	; Set VIC-IV CTRL registers

	lda #%01000000                     ; enable C65 character set
	jsr mega65_viciv_setctrl_AC        ; also initialize remaining CTRLA / CTRLC bits; CTRLB will be set by screen editor

	; Disable hot registers

	; FALLTROUGH

viciv_hotregs_off:

	lda VIC_SRH
	and #$7F

	; FALLTROUGH

viciv_hotregs_common:

	sta VIC_SRH
	
	rts

viciv_hotregs_on:

	lda VIC_SRH
	ora #$80
	bra viciv_hotregs_common
