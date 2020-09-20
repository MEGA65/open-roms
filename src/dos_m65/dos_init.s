
;
; Initializes DOS. For detailed description see 'm65dos_bridge.s' file
;

dos_INIT:

	; Set the magic string 'CBDOS'

	phx
	ldx #$04
@1:
	lda dos_magicstr, x
	sta MAGICSTR, x
	dex
	bpl @1

	plx

	; Set default device numbers

	lda #CONFIG_UNIT_SDCARD
	sta UNIT_SDCARD
	lda #CONFIG_UNIT_FLOPPY
	sta UNIT_FLOPPY
	lda #CONFIG_UNIT_RAMDISK
	sta UNIT_RAMDISK

	; XXX initialize drivers, etc.

	rts

dos_magicstr: ; 'CBDOS'

	!byte $43, $42, $44, $4F, $53
