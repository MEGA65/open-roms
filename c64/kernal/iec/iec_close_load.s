#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Common part of CLOSE and LOAD/SAVE routines for IEC
//


#if CONFIG_IEC


iec_close_load:

	tax

	// Command drive to stop talking before closing the file
	jsr UNTLK

	txa
	jsr LISTEN

	lda #$E0 // CLOSE command
	sta TBTCNT
	jsr iec_tx_command
	jsr iec_tx_command_finalize

	// Tell drive to unlisten
	jsr UNLSN

	rts


#endif // CONFIG_IEC


#endif // ROM layout
