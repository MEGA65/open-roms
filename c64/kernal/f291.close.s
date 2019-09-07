
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 281/282
// - [CM64] Compute's Mapping the Commodore 64 - page 229/230
// - https://www.pagetable.com/?p=1031, https://github.com/mist64/cbmbus_doc (IEC command)
//
// CPU registers that has to be preserved (see [RG64]): none
//

CLOSE:

	// XXX this needs more testing (opening 10 files at once, closing in various orders, etc) once the code is more mature

	// Find the LAT / SAT / FAT entry which LAT corresponds to A

	jsr find_fls
	bcs close_error_not_found // XXX can we report error in IOSTATUS here?

	// We have the entry index in Y - check whether this is IEC device
	lda FAT, y
	jsr iec_check_devnum
	bcs close_remove_from_table

	// IEC device

	jsr iec_tx_flush // make sure no byte is awaiting
	lda SAT, y       // get secondary address
	cmp #$60
	bne !+
	// workaround for using CLOSE on reading executable - XXX is this a proper way?
	jsr close_load 
	jmp close_remove_from_table
!:
	ora $E0 // CLOSE command
	sta IEC_TMP2
	jsr iec_tx_command
	bcs close_remove_from_table
	jsr iec_tx_command_finalize

close_remove_from_table:
	// Remove channel from the table
	iny
	cpy #$0A
	bpl !+
	lda LAT, y
	sta LAT-1, y
	lda FAT, y
	sta FAT-1, y
	lda SAT, y
	sta SAT-1, y
	jmp close_remove_from_table
!:
	// Decrement the list size variable
	dec LDTND

	clc // report success - not sure if original CLOSE does this, but it's nevertheless a good practice
	rts

close_error_not_found:

	sec // report success - not sure if original CLOSE does this, but it's nevertheless a good practice
	rts
