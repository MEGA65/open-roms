
//
// Initializes DOS. For detailed description see 'm65dos_bridge.s' file
//

dos_INIT:

	lda #CONFIG_UNIT_SDCARD
	sta UNIT_SDCARD
	lda #CONFIG_UNIT_FLOPPY
	sta UNIT_FLOPPY
	lda #CONFIG_UNIT_RAMDISK
	sta UNIT_RAMDISK

	// XXX initialize drivers, etc.

	rts
