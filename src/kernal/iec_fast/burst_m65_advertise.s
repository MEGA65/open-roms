;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Advertise burst IEC protocol support to the receiver
;


!ifdef CONFIG_IEC_BURST_M65 {


burst_advertise:

!ifdef CONFIG_IEC_JIFFYDOS {

	; Skip if other protocol (only JiffyDOS is possible at this moment) already detected
	lda IECPROTO
	bmi @1
	bne burst_advertise_done:              
@1:
}

	+panic #$FF ; XXX implement this

burst_advertise_done:

	rts
}
