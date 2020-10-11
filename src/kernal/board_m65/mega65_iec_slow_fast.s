;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Checks if system is in MEGA65 native mode; if so, switches CPU speed to fast/slow - for IEC routines;
; Alters only status bits, all remaining registers preserved
;

!ifdef CONFIG_IEC {


m65_iec_slow:

	jsr M65_MODEGET
	bcs m65_iec_fast_slow_done

	; Switch CPU speed

	pha
	lda VIC_CTRLB
	and #%10111111
	bra m65_iec_fast_slow_common

m65_iec_fast:

	jsr M65_MODEGET
	bcs m65_iec_fast_slow_done

	pha
	lda VIC_CTRLB
	ora #%01000000

	; FALLTROUGH

m65_iec_fast_slow_common:

	sta VIC_CTRLB
	pla

	; FALLTROUGH

m65_iec_fast_slow_done:

	rts
}
