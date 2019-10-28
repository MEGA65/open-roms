
//
// IEC part of the CLOSE routine
// 


#if CONFIG_IEC


// .Y contains LAT/FAT/SAT table index, it should stay this way

close_iec:

	jsr iec_tx_flush // make sure no byte is awaiting
	lda SAT, y       // get secondary address
	cmp #$60
	bne !+

	// workaround for using CLOSE on reading executable - XXX is this a proper way?
	jsr iec_close_load 
	jmp close_remove_from_table

!:
	ora $E0 // CLOSE command
	sta TBTCNT
	jsr iec_tx_command
	bcs close_iec_end
	jsr iec_tx_command_finalize

close_iec_end:

	jmp close_remove_from_table


#endif // CONFIG_IEC
