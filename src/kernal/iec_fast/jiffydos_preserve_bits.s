;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; JiffyDOS transfer preparation routine
;


!ifdef CONFIG_IEC_JIFFYDOS {


jiffydos_preserve_bits:

	; We need to preserve 3 lowest bits of CIA2_PRA, they contain important
	; data - fortunately, the bits are never changed by external devices
	; Use C3PO for this, as afterwards we have to set there 0 nevertheless
	lda CIA2_PRA
	and #%00000111
	sta C3PO

	rts
}
