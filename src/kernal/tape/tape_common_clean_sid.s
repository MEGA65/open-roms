;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# CRT KERNAL_0 #TAKE
;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Clear the SID settings - for sound effects during LOAD
;


!ifdef CONFIG_TAPE_TURBO {


tape_clean_sid:

	lda #$00
	ldy #$1C
@1:

!ifdef CONFIG_MB_M65 {

	; It should be safer than cleaning whole $D400-D47C range

	sta __SID_BASE + __SID_R1_OFFSET, y
	sta __SID_BASE + __SID_R2_OFFSET, y
	sta __SID_BASE + __SID_L1_OFFSET, y
	sta __SID_BASE + __SID_L2_OFFSET, y

} else {

	sta __SID_BASE, y

}

	dey
	bpl @1

	rts
}