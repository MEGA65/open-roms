
;
; Unit number handling. For detailed description see 'm65dos_bridge.s' file
;


dos_UNITSET:

	; Before the start make sure memory content is not damaged

	jsr dos_MEMCHK
	bcc @ok
	rts
@ok:
	jsr dos_ENTER

	; XXX do not allow illegal device numbers... above 30 or below 8 ?

	; Check what kind of device was requested

	cmp #$00
	beq dos_UNITSET_sdcard
	; XXX devices below are not implemented yet
	; cmp #$01
	; beq dos_UNITSET_floppy
	; cmp #$02
	; beq dos_UNITSET_ramdisk

	jmp dos_EXIT_SEC

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

	jmp dos_EXIT_CLC
