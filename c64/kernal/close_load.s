

// Common ppart of CLOSE and LOAD routines

close_load:

	tax

	// Command drive to stop talking and to close the file
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
