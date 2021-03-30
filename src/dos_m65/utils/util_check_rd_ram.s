
; If no Hyper RAM is present, clear the RAM DISK device number and set Carry


util_check_rd_ram:

	lda RAM_ATTIC
	ora RAM_CELLAR
	beq @no_hyperram

	clc
	rts


@no_hyperram:

	lda #$00
	sta UNIT_RAMDISK

	sec
	rts
