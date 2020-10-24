;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Helper routine to show screen
;

!set NEEDED = 0
!ifdef HAS_TAPE { !ifndef CONFIG_MB_M65 { !set NEEDED = 1 } }
!ifdef CONFIG_IEC_JIFFYDOS_BLANK        { !set NEEDED = 1 }

!if NEEDED {


screen_on:

	lda VIC_SCROLY
	ora #$10
	sta VIC_SCROLY

	rts
}
