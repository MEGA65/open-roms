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

	; SD/SDHC card variables

	!addr CARD_INIT_DONE   = $08 ; $80 - init done, $00 - init not done
    !addr CARD_IS_SDHC     = $09 ; $00 = SD, $80 = SDHC
    !addr CARD_SIZE        = $0A ; 4 bytes
    !addr CARD_SECNUM      = $0E ; 4 bytes - sector number

    !addr CARD_TMP_STEP    = $12 ; 4 bytes
    !addr CARD_TMP_RETRIES = $16 ; 1 byte

    !addr CARD_BUFPNT      = $FC ; 4 bytes - pointer to hardware sector buffer  XXX replace copy routines with DMAgic



	;
	; High memory
	;

	!addr CARD_BUF     = $8100 ; 512 bytes, up to $82FF - buffer for reading/writing data
