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

