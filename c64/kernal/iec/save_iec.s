
//
// IEC part of the SAVE routine
//


#if CONFIG_IEC


save_iec:

/*
	// Display SAVING
	// XXX jsr lvs_display_saving

	// Call device to LISTEN
	lda FA
	jsr LISTEN
	bcs save_iec_dev_not_found // XXX redirecto to load

	// Open channel XXX (reserved for file writing)
	lda #XXX
	jsr iec_cmd_open
	bcs // XXX error

	// Send file name
	jsr lvs_send_file_name
	bcs load_iec_error

	// XXX finish the implementation
	
	rts
*/

	STUB_IMPLEMENTATION()

#endif // CONFIG_IEC
