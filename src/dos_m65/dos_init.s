
;
; Initializes DOS. For detailed description see 'm65dos_bridge.s' file
;


!set CONFIG_UNIT_FLOPPY  = 0 ; XXX floppy not supported yet
!set CONFIG_UNIT_RAMDISK = 0 ; XXX RAM disk not supported yet


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

	rts
