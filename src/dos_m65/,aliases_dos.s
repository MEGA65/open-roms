;
; Memory locations for the DOS
;

; NOTES:
; - starting from $8000, 16KB RAM is available (starting from $10000 in C65 address space)
; - additional 16KB RAM is reserved for DOS too ($14000-$17FFF), and can be banked-in if needed



	;
	; Page 0
	;

	!addr MAGICSTR         = $8000 ; magic string; if not matching, DOS considered non-functional

	; General DOS configuration

	!addr UNIT_SDCARD      = $8005
	!addr UNIT_FLOPPY      = $8006
	!addr UNIT_RAMDISK     = $8007

	; General DOS status

	!addr UNIT_HANDLER     = $8008
