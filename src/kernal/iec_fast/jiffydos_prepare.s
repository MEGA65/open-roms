;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; JiffyDOS transfer preparation routine
;


!ifdef CONFIG_IEC_JIFFYDOS {


jiffydos_prepare:

	jsr jiffydos_preserve_bits

	; FALLTROUGH

jiffydos_prepare_no_preserve_bits:

	; Hide sprites; JiffyDOS timing regime is very strict, before transmitting
	; anything we need to make sure nothing will steal the cycles

	lda VIC_SPENA
	ldx #$00
	stx VIC_SPENA

	rts
}
