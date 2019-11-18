
//
// Arbitration code for normal/turbo transfer
//


#if CONFIG_IEC_JIFFYDOS


iec_rx_dispatch:

	lda IECPROTO
#if CONFIG_IEC_JIFFYDOS
	cmp #$01
	beq iec_rx_dispatch_jiffydos
#endif // CONFIG_IEC_JIFFYDOS

	// FALLTROUGH

iec_rx_dispatch_normal:

	plp
	jmp iec_rx_byte

#if CONFIG_IEC_JIFFYDOS
iec_rx_dispatch_jiffydos:
	plp
	jmp iec_rx_byte_jiffydos
#endif // CONFIG_IEC_JIFFYDOS


#endif // any turbo supported
