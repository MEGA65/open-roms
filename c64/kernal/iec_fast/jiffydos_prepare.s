// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// JiffyDOS transfer preparation routine
//


#if CONFIG_IEC_JIFFYDOS


jiffydos_prepare:

	// We need to preserve 3 lowest bits of CIA2_PRA, they contain important
	// data - fortunately, the bits are never changed by external devices
	// Use C3PO for this, as afterwards we have to set there 0 nevertheless
	lda CIA2_PRA
	and #%00000111
	sta C3PO

	// Hide sprites; JiffyDOS timing regime is very strict, before transmitting
	// anything we need to make sure nothing will steal the cycles

	lda VIC_SPENA
	ldx #$00
	stx VIC_SPENA

	rts


#endif // CONFIG_IEC_JIFFYDOS
