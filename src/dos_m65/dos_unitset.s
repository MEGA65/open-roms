
;
; Unit number handling. For detailed description see 'm65dos_bridge.s' file
;


dos_UNITSET:

	; Check if memory content is not damaged

	jsr dos_MEMCHK
	bcc @1
	rts
@1:
	; Check what kind of device was requested

	cmp #$00
	beq dos_UNITSET_sdcard
	; XXX devioces below are not implemented yet
	; cmp #$01
	; beq dos_UNITSET_floppy
	; cmp #$02
	; beq dos_UNITSET_ramdisk

	sec
	rts

dos_UNITSET_sdcard:

	stx UNIT_SDCARD
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

dos_UNITSET_floppy:

	stx UNIT_FLOPPY
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

dos_UNITSET_ramdisk:

	stx UNIT_RAMDISK

	; FALLTROUGH

	clc
	rts
