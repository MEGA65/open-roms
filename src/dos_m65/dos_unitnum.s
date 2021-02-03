
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

	; FALLTROUGH

dos_UNITNUM_none:

	lda #$00

	sec
	rts

dos_UNITNUM_sdcard:

	lda UNIT_SDCARD
	bra dos_UNITNUM_common

dos_UNITNUM_floppy:

	lda UNIT_FLOPPY
	bra dos_UNITNUM_common

dos_UNITNUM_ramdisk:

	lda UNIT_RAMDISK
	bra dos_UNITNUM_common

dos_UNITNUM_common:

	cmp #$00
	beq dos_UNITNUM_none

	clc
	rts

