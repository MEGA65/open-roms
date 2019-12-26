
//
// Arbitration code for normal/turbo transfer
//


#if CONFIG_IEC_JIFFYDOS || CONFIG_IEC_DOLPHINDOS


iec_rx_dispatch:

	lda IECPROTO

#if CONFIG_IEC_JIFFYDOS
	cmp #$01
	beq_far iec_rx_byte_jiffydos
#endif // CONFIG_IEC_JIFFYDOS

#if CONFIG_IEC_DOLPHINDOS
	cmp #$02
	beq_far iec_rx_byte_dolphindos
#endif // CONFIG_IEC_DOLPHINDOS

	jmp iec_rx_byte


#endif // any turbo supported
