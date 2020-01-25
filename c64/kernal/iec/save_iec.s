// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// IEC part of the SAVE routine
//


#if CONFIG_IEC


save_iec_dev_not_found:
	jmp lvs_device_not_found_error


save_iec:

	// Check file name
	lda FNLEN
	beq_16 kernalerror_FILE_NAME_MISSING

	// Display SAVING
	jsr lvs_display_saving

	// Call device to LISTEN
	lda FA
	jsr LISTEN
	bcs save_iec_dev_not_found

	// Open channel 1 (reserved for file writing)
	lda #$01
	jsr iec_cmd_open
	bcs save_iec_dev_not_found

	// Send file name
	jsr iec_send_file_name
	bcs save_iec_dev_not_found

	// Call device to LISTEN once again
	lda FA
	jsr LISTEN
	bcs save_iec_dev_not_found

#if CONFIG_IEC_BURST_CIA1 || CONFIG_IEC_BURST_CIA2 || CONFIG_IEC_BURST_SOFT
	jsr burst_advertise
#endif

	lda #$61 // open channel / data (p3) , required according to p13
	sta TBTCNT
	jsr iec_tx_command
	bcs save_iec_dev_not_found

#if CONFIG_IEC_DOLPHINDOS
	jsr dolphindos_detect
#endif

	// Save start address
	lda STAL+0
	sta TBTCNT
	clc
#if CONFIG_IEC_JIFFYDOS
	jsr iec_tx_dispatch
#else
	jsr iec_tx_byte
#endif

	lda STAL+1
	sta TBTCNT
	clc
#if CONFIG_IEC_JIFFYDOS
	jsr iec_tx_dispatch
#else
	jsr iec_tx_byte
#endif

	jsr lvs_STAL_to_MEMUSS
	ldy #$00
iec_save_loop:

	// Retrieve byte to send
#if CONFIG_MEMORY_MODEL_60K
	ldx #<MEMUSS+0
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (MEMUSS),y
#endif

	// Send the byte
	sta TBTCNT
	clc
#if CONFIG_IEC_JIFFYDOS
	jsr iec_tx_dispatch
#else
	jsr iec_tx_byte
#endif

	// Next iteration
#if !HAS_OPCODES_65CE02
	jsr lvs_advance_MEMUSS
#else
	inw MEMUSS+0
#endif
	jsr lvs_check_EAL
	bne iec_save_loop

iec_save_loop_end:

	// Close file on drive
	lda FA
	jsr UNLSN

	lda FA
	jsr LISTEN

	lda #$E1 // CLOSE command
	sta TBTCNT
	jsr iec_tx_command
	jsr iec_tx_command_finalize

	// Tell drive to unlisten
	lda FA
	jsr UNLSN

	// Return success
	clc
	rts


#endif // CONFIG_IEC
