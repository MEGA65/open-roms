;
; Memory locations for the DOS
;

; NOTES:
; - DOS zeropage is mirrored at $8000
; - starting from $8000, 16KB RAM is available (starting from $10000 in C65 address space)
; - additional 16KB RAM is reserved for DOS too ($14000-$17FFF), and can be banked-in if needed



	;
	; Page 0
	;

	!addr MAGICSTR         = $00 ; magic string; if not matching, DOS considered non-functional

	; General DOS configuration

	!addr UNIT_SDCARD      = $05
	!addr UNIT_FLOPPY      = $06
	!addr UNIT_RAMDISK     = $07

	; General DOS status

	!addr UNIT_HANDLER     = $08