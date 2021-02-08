;
; Memory locations for the DOS
;

; NOTES:
; - starting from $8000, 16KB RAM is available (starting from $10000 in C65 address space)
; - additional 16KB RAM is reserved for DOS too ($14000-$17FFF), and can be banked-in if needed


	;
	; Page start+0
	;

	!addr MAGICSTR         = $8000 ; magic string; if not matching, DOS considered non-functional

	; General DOS configuration

	!addr UNIT_SDCARD      = $8005 ; unit number for device, 0 = none
	!addr UNIT_FLOPPY      = $8006 ; as above
	!addr UNIT_RAMDISK     = $8007 ; as above

	; General DOS status

	!addr IDX1_LISTENER    = $8008 ; listener idx, >=$80 = none
	!addr IDX2_LISTENER    = $8009 ; listener idx * 2, >=$80 = none - for calling routines via vector table
	!addr IDX1_TALKER      = $800A ; talker idx, >=$80 = none
	!addr IDX2_TALKER      = $800B ; talker idx * 2, >=$80 = none - for calling routines via vector table

	; Free space: $800C-$8069

	!addr XX_CHANNEL       = $806A ; current channel
	!addr SD_CHANNEL       = $806A ; - SD card
	!addr FD_CHANNEL       = $806B ; - floppy
	!addr RD_CHANNEL       = $806C ; - ram disk

	!addr XX_STATUS_IDX    = $806D ; index byte for reading status 
	!addr SD_STATUS_IDX    = $806D ; - SD card
	!addr FD_STATUS_IDX    = $806E ; - floppy
	!addr RD_STATUS_IDX    = $806F ; - ram disk

	!addr SD_STATUS_STR    = $8070 ; status string for SD card, terminated by 0
	!addr FD_STATUS_STR    = $80A0 ; status string for floppy drive, terminated by 0
	!addr RD_STATUS_STR    = $80D0 ; status string for ram disk, terminated by 0
