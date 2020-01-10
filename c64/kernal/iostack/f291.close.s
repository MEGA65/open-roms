#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmers Reference Guide   - page 281/282
// - [CM64] Computes Mapping the Commodore 64 - page 229/230
// - https://www.pagetable.com/?p=1031, https://github.com/mist64/cbmbus_doc (IEC command)
//
// CPU registers that has to be preserved (see [RG64]): none
//

CLOSE:

	// Find the LAT / SAT / FAT entry which LAT corresponds to A

	jsr find_fls
	bcs close_end // XXX can we report error in IOSTATUS here?

	// We have the entry index in .Y 

	lda FAT, y

	// Perform device-specific actions

#if HAS_RS232
	cmp #$02
	beq_far close_rs232
#endif

#if CONFIG_IEC
	jsr iec_check_devnum_oc
	bcc_far close_iec
#endif

	// FALLTROUGH

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

	clc // report success - not sure if original CLOSE does this, but it is nevertheless a good practice

close_end:
	rts


#endif // ROM layout
