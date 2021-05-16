
;
; Initializes DOS. For detailed description see 'm65dos_bridge.s' file
;


dos_INIT:

	; Safer version of 'dos_ENTER' - does not affect speed related registers

	sta REG_A
	stx REG_X
	sty REG_Y
	stz REG_Z

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
	lda #CONFIG_UNIT_FLOPPY0
	sta UNIT_FLOPPY0
	lda #CONFIG_UNIT_FLOPPY1
	sta UNIT_FLOPPY1
	lda #CONFIG_UNIT_RAMDISK
	sta UNIT_RAMDISK

	; Clear listener / talker

	lda #$FF
	sta IDX1_LISTENER
	sta IDX2_LISTENER
	sta IDX1_TALKER
	sta IDX2_TALKER

	; Initialize buffer metadata

	lda #$0
	ldx #17
@2:
	sta BUFTAB_TRACK, x
	dec
	sta BUFTAB_UNIT, x
	sta BUFTAB_DEV, x
	sta BUFTAB_SECTOR, x
	inc
	dex
	bpl @2

	; Initialize DMA list

	ldy #$08
@3:
	lda dos_dmalist_template, y
	sta DMAJOB_LIST, y
	dey
	bpl @3:

	; Initialize helper code in RAM

	lda #$AD                 ; LDA opcode, absolute
	sta code_LDA_01
	sta code_LDA_02
	sta code_LDA_03
	sta code_LDA_04

	lda #$B9                 ; LDA nnnn, y opcode
	sta code_LDA_nnnn_Y

	lda #$60                 ; RTS opcode
	sta code_RTS_01
	sta code_RTS_02
	sta code_RTS_03
	sta code_RTS_04
	sta code_RTS_05

	; Initialize device handlers

	jsr unit_sd_init
	jsr unit_fd_init
	jsr unit_rd_init

	; Safer version of 'dos_EXIT' - does not affect speed related registers

	clc
	ldz REG_Z
	ldy REG_Y
	ldx REG_X
	lda REG_A

	rts
