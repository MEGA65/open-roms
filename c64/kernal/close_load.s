

;; Common ppart of CLOSE and LOAD routines

close_load:

	tax

	;; Command drive to stop talking and to close the file
	jsr untlk

	txa
	jsr listen

	lda #$E0 ; CLOSE command
	sta IEC_TMP2
	jsr iec_tx_command
	jsr iec_tx_command_finalize

	;; Tell drive to unlisten
	jsr unlsn

	rts
