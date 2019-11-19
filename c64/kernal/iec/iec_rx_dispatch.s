
//
// Arbitration code for normal/turbo transfer
//


#if CONFIG_IEC_JIFFYDOS


iec_rx_dispatch:

	lda IECPROTO

#if CONFIG_IEC_JIFFYDOS
	cmp #$01
	beq_far iec_rx_byte_jiffydos
#endif // CONFIG_IEC_JIFFYDOS

	jmp iec_rx_byte


#endif // any turbo supported
