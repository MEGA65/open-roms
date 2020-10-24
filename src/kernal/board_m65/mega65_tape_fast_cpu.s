;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Tape helper routine
;
; - unlocks VIC-IV
; - switches CPU to fast processing mode and disables badlines
; - stores previous VIC_CTRLB in NXTBIN
;

!ifdef HAS_TAPE {


tape_fast_cpu:

	jsr M65_MODEGET
	bcc @1
	
	jsr viciv_unhide
@1:
	lda VIC_CTRLB
	ora #%01000000
	sta VIC_CTRLB
	sta NXTBIT

	lda #$00
	sta MISC_EMU

	rts
}
