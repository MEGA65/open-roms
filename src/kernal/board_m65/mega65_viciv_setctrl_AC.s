;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Helper routine for setting VIC-IV control registers A and C
;


mega65_viciv_setctrl_AC:

	sta VIC_CTRLA
	ora #%00000100  ; always use RAM color palette

	lda VIC_CTRLC
	and #%01101000
	ora #%01000000  ; make C65/C128 fast modes switch to max MEGA65 CPU speed
	sta VIC_CTRLC

	rts
