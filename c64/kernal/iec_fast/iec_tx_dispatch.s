
//
// Arbitration code for normal/turbo transfer
//


#if CONFIG_IEC_JIFFYDOS || CONFIG_IEC_DOLPHINDOS


iec_tx_dispatch:

	php                                // preserve C flag for EOI indication
	lda IECPROTO

#if CONFIG_IEC_JIFFYDOS
	cmp #$01
	beq iec_tx_dispatch_jiffydos
#endif // CONFIG_IEC_JIFFYDOS

#if CONFIG_IEC_DOLPHINDOS
	cmp #$02
	beq iec_tx_dispatch_dolphindos
#endif // CONFIG_IEC_DOLPHINDOS

	// FALLTROUGH

iec_tx_dispatch_normal:

	plp
	jmp iec_tx_byte

#if CONFIG_IEC_JIFFYDOS
iec_tx_dispatch_jiffydos:
	plp
	jmp iec_tx_byte_jiffydos
#endif // CONFIG_IEC_JIFFYDOS

#if CONFIG_IEC_DOLPHINDOS
iec_tx_dispatch_dolphindos:
	plp
	jmp iec_tx_byte_dolphindos
#endif // CONFIG_IEC_DOLPHINDOS


#endif // any turbo supported
