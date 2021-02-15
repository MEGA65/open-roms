
;
; Unit number handling. For detailed description see 'm65dos_bridge.s' file
;


dos_UNITNUM:

	; Before the start make sure memory content is not damaged

	jsr dos_MEMCHK
	bcc @ok
	lda #$00 ; failure
	rts
@ok:
	jsr dos_ENTER

	; Check what kind of device was requested

	cmp #$00
	beq dos_UNITNUM_sdcard
	cmp #$01
	beq dos_UNITNUM_floppy
	cmp #$02
	beq dos_UNITNUM_ramdisk

	; FALLTROUGH

dos_UNITNUM_fail:

	lda #$00

	jmp dos_EXIT_A_SEC

dos_UNITNUM_sdcard:

	lda UNIT_SDCARD
	bra dos_UNITNUM_common

dos_UNITNUM_floppy:

	lda UNIT_FLOPPY
	bra dos_UNITNUM_common

dos_UNITNUM_ramdisk:

	lda UNIT_RAMDISK
	
	; FALLTROUGH

dos_UNITNUM_common:

	cmp #$00
	beq dos_UNITNUM_fail

	jmp dos_EXIT_A
