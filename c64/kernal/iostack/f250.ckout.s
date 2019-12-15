
//
// Official Kernal routines, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 276
// - [CM64] Compute's Mapping the Commodore 64 - page 229
//
// CPU registers that has to be preserved (see [RG64]): .Y, .A (see [CM64], page 213)
//


CKOUT:

	// Store registers for preservation
	pha
	phy_trash_a

	// Reset status
	jsr kernalstatus_reset

	// First retrieve the FAT/LAT/SAT table index (and check if file is open)

	txa
	jsr find_fls
	bcs_far chkinout_file_not_open

	// Now we have table index in Y

	lda FAT,Y

	// Handle all the devices

	beq ckout_file_not_output // 0 - keyboard

	// Tape not supported here

#if HAS_RS232

	cmp #$02
	beq_far ckout_rs232

#endif // HAS_RS232

#if CONFIG_IEC

	jsr iec_check_devnum_oc
	bcc_far ckout_iec

#endif // CONFIG_IEC

	cmp #$03 // screen - only legal one left
	bne_far chkinout_device_not_present

ckout_set_device:
	lda FAT,Y
	sta DFLTO
	jmp chkinout_end

ckout_file_not_output:
	ply_trash_a
	pla
	jmp kernalerror_FILE_NOT_OUTPUT














