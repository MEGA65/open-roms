
;
; Unit number handling. For detailed description see 'm65dos_bridge.s' file
;


dos_SETUNIT:

	; XXX check if .X is valid

	cmp #$00
	beq dos_SETUNIT_sdcard
	cmp #$01
	beq dos_SETUNIT_floppy
	cmp #$02
	beq dos_SETUNIT_ramdisk

	sec
	rts

dos_SETUNIT_sdcard:

	stx UNIT_SDCARD
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

dos_SETUNIT_floppy:

	stx UNIT_FLOPPY
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

dos_SETUNIT_ramdisk:

	stx UNIT_RAMDISK

	; FALLTROUGH

	clc
	rts
