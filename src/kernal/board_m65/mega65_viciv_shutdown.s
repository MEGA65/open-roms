;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Routine to shutdown VIC-IV for leaving MEGA65 native mode
;


viciv_shutdown:

	; Switch VIC to VIC-IV mode, temporarily

	jsr viciv_unhide

	; Reenable badlines and slow interrupt emulation

	lda #$03
	sta MISC_EMU

	; Restore chargen location
	
	lda #$10
	sta VIC_CHARPTR+1
	lda #$00
	sta VIC_CHARPTR+0
	sta VIC_CHARPTR+2

	; Set misc VIC-IV flags
                                       ; .A is %00000000 here
	sta VIC_CTRLB                      ; disable extended resolution and attributes, disable 3.5 MHz mode
	jsr mega65_viciv_setctrl_AC        ; enable C64 character set, initialize remaining CTRLA / CTRLC bits

	; Reenable hot registers

	jsr viciv_hotregs_on

	; Hide VIC-IV registers and quit

	sta VIC_KEY
	rts
