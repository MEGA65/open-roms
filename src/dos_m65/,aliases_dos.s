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

	!addr IDX_LISTENER     = $8008 ; listener idx * 2, >=$80 = none
	!addr IDX_TALKER       = $8009 ; talker   idx * 2, >=$80 = none
