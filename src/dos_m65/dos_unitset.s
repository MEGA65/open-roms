
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

	; XXX do not allow illegal device numbers (above 30 or below 8)

	; Check what kind of device was requested

	cmp #$00
	beq dos_UNITSET_sdcard
	cmp #$01
	beq dos_UNITSET_floppy0
	cmp #$02
	beq dos_UNITSET_floppy1
	cmp #$03
	beq dos_UNITSET_ramdisk

	jmp dos_EXIT_SEC

dos_UNITSET_sdcard:

	stx UNIT_SDCARD

	; FALLTROUGH

dos_UNITSET_end:

	jmp dos_EXIT_CLC

dos_UNITSET_floppy0:

	stx UNIT_FLOPPY0
	bra dos_UNITSET_end

dos_UNITSET_floppy1:

	stx UNIT_FLOPPY1
	bra dos_UNITSET_end

dos_UNITSET_ramdisk:

	stx UNIT_RAMDISK

	; Clear RAM disk device number if no Hyper RAM available

	jsr util_check_rd_ram
	jmp dos_EXIT
