
//
// Official Kernal routines, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 275 (CHKIN) / 276 (CKOUT)
// - [CM64] Compute's Mapping the Commodore 64 - page 229
//
// CPU registers that has to be preserved (see [RG64]): .Y, .A (see [CM64], page 213)
//


// CHKIN implementation

chkin_real:

	// Store registers for preservation
	pha
	phy_trash_a

	// Reset status
	jsr kernalstatus_reset

	// First retrieve the FAT/LAT/SAT table index (and check if file is open)

	txa
	jsr find_fls
	bcs chkinout_file_not_open

	// Now we have table index in Y - first filter out unsuitable devices

	lda FAT,Y
	cmp #$01
	beq chkinout_device_not_present // tape not implemented
	cmp #$02
	beq chkinout_device_not_present // RS-232 not implemented

	// Fail if the file is open for writing (secondary address 1)
	
	lda LAT, Y
	cmp #$01
	beq chkin_file_not_input

#if CONFIG_IEC

	// For IEC devices, send TALK + TKSA first
	lda FAT,Y
	jsr iec_check_devnum_oc
	bcs chkin_set_device
	
	jsr TALK
	bcs chkinout_device_not_present // don't set DFLTN in case of failure

	lda LAT, Y
	jsr TKSA
	bcs chkinout_device_not_present

#endif // CONFIG_IEC

chkin_set_device:
	lda FAT,Y
	sta DFLTN

	// FALLTROUGH

// Common part for booth CHKIN and CKOUT

chkinout_end:
	ply_trash_a
	pla
	clc // indicate success
	rts

chkin_file_not_input: // XXX move this out of common section
	ply_trash_a
	pla
	jmp kernalerror_FILE_NOT_INPUT

chkinout_file_not_open:
	ply_trash_a
	pla
	jmp kernalerror_FILE_NOT_OPEN

chkinout_device_not_present:
	ply_trash_a
	pla
	jsr kernalstatus_DEVICE_NOT_FOUND
	jmp kernalerror_DEVICE_NOT_FOUND


// CKOUT implementation

ckout_real:

	// Store registers for preservation
	pha
	phy_trash_a

	// Reset status
	jsr kernalstatus_reset

	// First retrieve the FAT/LAT/SAT table index (and check if file is open)

	txa
	jsr find_fls
	bcs chkinout_file_not_open

	// Now we have table index in Y - first filter out unsuitable devices

	lda FAT,Y
	cmp #$01
	beq chkinout_device_not_present // tape not implemented
	cmp #$02
	beq chkinout_device_not_present // RS-232 not implemented

	cmp #$00
	beq ckout_file_not_output // cannot output to keyboard - XXX check real ROM behaviour

	// Fail if the file is open for reading (secondary address 0)
	
	lda LAT, Y
	beq ckout_file_not_output

#if CONFIG_IEC

	// For IEC devices, send LISTEN + SECOND first
	lda FAT,Y
	jsr iec_check_devnum_oc
	bcs ckout_set_device

	jsr LISTEN
	bcs chkinout_device_not_present // don't set DFLTO in case of failure

	lda LAT, Y
	jsr SECOND
	bcs chkinout_device_not_present

#endif // CONFIG_IEC

ckout_set_device:
	lda FAT,Y
	sta DFLTO
	jmp chkinout_end

ckout_file_not_output:
	ply_trash_a
	pla
	jmp kernalerror_FILE_NOT_OUTPUT

