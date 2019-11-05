
//
// Common part of CLOSE and LOAD/SAVE routines for IEC
//


#if CONFIG_IEC


iec_close_load:

	tax

	// Command drive to stop talking before closing the file
	jsr UNTLK
!:
	txa
	jsr LISTEN

	lda #$E0 // CLOSE command
	sta TBTCNT
	jsr iec_tx_command
	jsr iec_tx_command_finalize

	// Tell drive to unlisten
	jsr UNLSN

	rts


iec_close_save:

	tax

	// Command drive to stop listening before closing the file
	jsr UNLSN

	bne !-                             // branch alwayys


#endif // CONFIG_IEC
