;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Checks if system is in MEGA65 native mode; if so, switches CPU speed to fast/slow for IO routines
; Alters only status bits, all remaining registers preserved
;

; Entry points:
; - m65_speed_iec        - at the start of IEC operations
; - m65_speed_tape_cbdos - at the start of tape or CBDOS operations
; - m65_speed_restore    - restore current mode standard speed, hide VIC-IV for compatibility mode


!ifdef CONFIG_IEC {

m65_speed_iec:

	; If compatibility mode, unlock VIC-IV

	jsr M65_MODEGET
	pha
	bcc @1
	jsr viciv_unhide
@1:
	; Switch CPU speed to approx. 1 MHz

	lda #%01000000
	trb VIC_CTRLB

	; Disable badlines and slow interrupt emulation

	lda #$00
	sta MISC_EMU

	; Return

	pla
	rts
}


m65_speed_tape_cbdos:

	; If compatibility mode, unlock VIC-IV

	jsr M65_MODEGET
	pha
	bcc @1
	jsr viciv_unhide
@1:
	; Just set the maximum possible speed

	pha
	bra m65_speed_restore_native



m65_speed_restore:

	; Restore proper speed depending on the mode

	jsr M65_MODEGET
	pha
	bcc m65_speed_restore_native

	; FALLTROUGH

m65_speed_restore_compat:

	; C64 compatibility mode - approx 1 MHz, badlines and slow interrupts enabled

	lda #%01000000
	trb VIC_CTRLB

	; FALLTROUGH

m65_speed_ME_compat:

	; Reenable badlines and slow interrupt emulation

	lda #$03
	sta MISC_EMU

	; Hide the VIC-IV

	sta VIC_KEY

	; Return

	pla
	rts

m65_speed_restore_native:

	; Native mode - maximum speed

	lda #%01000000
	tsb VIC_CTRLB

	; All the special speed modes disable badlines and slow interrupts,
	; so there is no need to restore them

	pla
	rts
