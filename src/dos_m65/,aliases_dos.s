//
// Memory locations for the DOS
//

	//
	// Page 0
	//

	.label MAGICSTR     = $00 // magic string; if not matching, DOS considered non-functional

	.label UNIT_SDCARD  = $05
	.label UNIT_FLOPPY  = $06
	.label UNIT_RAMDISK = $07


	// NOTES:
	// - DOS zeropage is mirrored at $8000
	// - starting from $8000, 16KB RAM is available (starting from $10000 in C65 address space)
	// - additional 16KB RAM is reserved for DOS too ($14000-$17FFF), and can be banked-in if needed
