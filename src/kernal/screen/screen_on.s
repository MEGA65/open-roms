;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Helper routine to show screen
;

!set NEEDED = 0
!ifdef HAS_TAPE                                              { !set NEEDED = 1 }
!ifdef CONFIG_IEC_JIFFYDOS { !ifndef CONFIG_MEMORY_MODEL_60K { !set NEEDED = 1 } }

!if NEEDED {


screen_on:

	lda VIC_SCROLY
	ora #$10
	sta VIC_SCROLY

	rts
}
