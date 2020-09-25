;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Helper routine to blank screen
;

!set NEEDED = 0
!ifdef HAS_TAPE                                              { !set NEEDED = 1 }
!ifdef CONFIG_IEC_JIFFYDOS { !ifndef CONFIG_MEMORY_MODEL_60K { !set NEEDED = 1 } }

!if NEEDED {


screen_off:

	lda VIC_SCROLY
	and #($FF - $10)
	sta VIC_SCROLY

	; To be sure there are no badlines we have to wait till the next screen,
	; as the bit is checked by VIC-II at the start of the frame only
@1:
	lda VIC_SCROLY                     ; wait for higher part of screen
	bpl @1
@2:
	lda VIC_SCROLY                     ; wait for lower part of the screen
	bmi @2

	rts
}
