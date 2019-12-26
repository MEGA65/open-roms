
//
// Sends file (stream) name to IEC device
//


#if CONFIG_IEC


iec_send_file_name:
	ldy #0

iec_send_file_name_loop:
	cpy FNLEN
	beq iec_send_file_name_done

#if CONFIG_MEMORY_MODEL_60K
	ldx #<FNADDR+0
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (FNADDR),y
#endif

	iny
	// Set Carry flag on the last file name character, to mark EOI
	cpy FNLEN
	clc
	bne !+
	sec
!:
	// Transmit one character
	sta TBTCNT
#if CONFIG_IEC_JIFFYDOS || CONFIG_IEC_DOLPHINDOS
	jsr iec_tx_dispatch
#else // no turbo supported
	jsr iec_tx_byte
#endif
	jmp iec_send_file_name_loop

iec_send_file_name_done:
	jmp UNLSN


#endif // CONFIG_IEC
