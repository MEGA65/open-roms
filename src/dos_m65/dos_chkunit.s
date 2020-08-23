
//
// Unit number handling. For detailed description see 'm65dos_bridge.s' file
//


dos_CHKUNIT:

	cmp UNIT_SDCARD
	beq dos_CHKUNIT_sdcard
	cmp UNIT_FLOPPY
	beq dos_CHKUNIT_floppy
	cmp UNIT_RAMDISK
	beq dos_CHKUNIT_ramdisk

	sec
	rts

dos_CHKUNIT_sdcard:

	lda #$00
	skip_2_bytes_trash_nvz

	// FALLTROUGH

dos_CHKUNIT_floppy:

	lda #$01
	skip_2_bytes_trash_nvz

	// FALLTROUGH

dos_CHKUNIT_ramdisk:

	lda #$02
	
	clc
	rts
