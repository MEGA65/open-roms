
;
; Unit number handling. For detailed description see 'm65dos_bridge.s' file
;


dos_UNITCHK:

	; Check if memory content is not damaged

	jsr dos_MEMCHK
	bcs dos_UNITCHK_none

	; Check for unit

	cmp UNIT_SDCARD
	beq dos_UNITCHK_sdcard
	cmp UNIT_FLOPPY
	beq dos_UNITCHK_floppy
	cmp UNIT_RAMDISK
	beq dos_UNITCHK_ramdisk

	; FALLTROUGH

dos_UNITCHK_none:

	sec
	rts

dos_UNITCHK_sdcard:

	lda #$00
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

dos_UNITCHK_floppy:

	lda #$01
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

dos_UNITCHK_ramdisk:

	lda #$02
	
	clc
	rts

dos_UNITCHK_mem_fail:

	plx
	pla
	sec
	rts