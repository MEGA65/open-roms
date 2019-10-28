
//
// IEC part of the OPEN routine
//


#if CONFIG_IEC


open_iec:

	// We have a command to send to IEC device
	jsr LISTEN
	bcc !+
	jmp kernalerror_DEVICE_NOT_FOUND
!:
	lda SA
	jsr iec_cmd_open
	bcc !+
	jmp kernalerror_DEVICE_NOT_FOUND
!:

#if CONFIG_MEMORY_MODEL_60K
	// We need our helpers to get to filenames under ROMs or IO area
	jsr install_ram_routines
#endif

	// Send command ('file name')
	jsr lvs_send_file_name

	jmp open_done_success


#endif // CONFIG_IEC
