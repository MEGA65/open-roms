
;
; Unit number handling. For detailed description see 'm65dos_bridge.s' file
;


dos_UNITNUM:

	; Check if memory content is not damaged

	jsr dos_MEMCHK
	bcs dos_UNITNUM_none

	; Check what kind of device was requested

	cmp #$00
	beq dos_UNITNUM_sdcard
	cmp #$01
	beq dos_UNITNUM_floppy
	cmp #$02
	beq dos_UNITNUM_ramdisk

	lda #$00

	; FALLTROUGH

dos_UNITNUM_none:

	sec
	rts

dos_UNITNUM_sdcard:

	lda UNIT_SDCARD

	+skip_2_bytes_trash_nvz

dos_UNITNUM_floppy:

	lda UNIT_FLOPPY

	+skip_2_bytes_trash_nvz

dos_UNITNUM_ramdisk:

	lda UNIT_RAMDISK

	cmp #$00
	beq dos_UNITNUM_none

	clc
	rts

