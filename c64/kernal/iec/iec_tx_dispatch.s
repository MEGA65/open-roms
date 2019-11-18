
//
// Arbitration code for normal/turbo transfer
//


#if CONFIG_IEC_JIFFYDOS


iec_tx_dispatch:

	php                                // preserve C flag for EOI indication
	lda IECPROTO
#if CONFIG_IEC_JIFFYDOS
	cmp #$01
	beq iec_tx_dispatch_jiffydos
#endif // CONFIG_IEC_JIFFYDOS

	// FALLTROUGH

iec_tx_dispatch_normal:

	plp
	jmp iec_tx_byte

#if CONFIG_IEC_JIFFYDOS
iec_tx_dispatch_jiffydos:
	plp
	jmp iec_tx_byte_jiffydos
#endif // CONFIG_IEC_JIFFYDOS


#endif // any turbo supported
