
//
// DolphinDOS protocol support for IEC - optimized load loop
//


#if CONFIG_IEC_DOLPHINDOS && !CONFIG_MEMORY_MODEL_60K


load_dolphindos:

	// Timing is critical for some parts, do not allow interrupts
	sei

	// A trick to shorten EAL update time
	ldy #$FF

	// FALLTROUGH

load_dolphindos_loop:

	// Check if this was EOI
	lda IOSTATUS
	and #K_STS_EOI
	bne load_dolphindos_end

	// Wait for the talker to release the CLK line
!:
	bit CIA2_PRA
	bvc !-

	// Release the DATA to signal we are ready
	lda CIA2_PRA
	and #$FF - BIT_CIA2_PRA_DAT_OUT    // release
	sta CIA2_PRA

	// Wait till data line is released (someone else might be holding it)
!:
	lda CIA2_PRA
	bpl !-

	// Check if EOI - routine can damage .X, but this is safe
	jsr iec_rx_check_eoi

	// Retrieve and store byte
	lda CIA2_PRB
	iny
	sta (EAL),y

	// Pull DATA to acknowledge
	lda CIA2_PRA
	ora #BIT_CIA2_PRA_DAT_OUT
	sta CIA2_PRA

	// Handle EAL
	cpy #$FF
	bne load_dolphindos_loop
	inc EAL+1
	jmp load_dolphindos_loop

load_dolphindos_end:

	// Update EAL
	jsr iec_update_EAL_by_Y

	// End of load loop
	jmp load_iec_loop_end


#endif // CONFIG_IEC_DOLPHINDOS and not CONFIG_MEMORY_MODEL_60K
