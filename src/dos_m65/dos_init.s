
;
; Initializes DOS. For detailed description see 'm65dos_bridge.s' file
;


!set CONFIG_UNIT_FLOPPY  = 0 ; XXX floppy not supported yet
!set CONFIG_UNIT_RAMDISK = 0 ; XXX RAM disk not supported yet


dos_INIT:

	jsr dos_ENTER

	; Set the magic string 'CBDOS'

	ldx #$04
@1:
	lda dos_magicstr, x
	sta MAGICSTR, x
	dex
	bpl @1

	; Set default device numbers

	lda #CONFIG_UNIT_SDCARD
	sta UNIT_SDCARD
	lda #CONFIG_UNIT_FLOPPY
	sta UNIT_FLOPPY
	lda #CONFIG_UNIT_RAMDISK
	sta UNIT_RAMDISK

	; Clear listener / talker

	lda #$FF
	sta IDX1_LISTENER
	sta IDX2_LISTENER
	sta IDX1_TALKER
	sta IDX2_TALKER

	; Initialize device handlers

	jsr dev_sd_init
	jsr dev_fd_init
	jsr dev_rd_init

	; Initialize helper code in RAM

	lda #$AD                 ; LDA opcode, absolute
	sta code_LDA_01
	sta code_LDA_02
	sta code_LDA_03

	lda #$B9                 ; LDA nnnn, y opcode
	sta code_LDA_nnnn_Y

	lda #$60                 ; RTS opcode
	sta code_RTS_01
	sta code_RTS_02
	sta code_RTS_03
	sta code_RTS_04

	; Exit DOS context

	jmp dos_EXIT
