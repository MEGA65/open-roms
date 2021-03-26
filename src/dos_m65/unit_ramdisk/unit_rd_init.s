
;
; Initializes DOS part of RAM disk
;


unit_rd_init:


	; Copy status string

	ldx #$00
	stx RD_STATUS_IDX
	stx RD_CMDFN_IDX
	stx RD_MODE
	stx RD_ACPTR_LEN+0
	stx RD_ACPTR_LEN+1
	stx RD_ACPTR_PTR+0
	stx RD_ACPTR_PTR+1
	dex
@1:
	inx
	lda dos_sts_init_ramdisk,x
	sta RD_STATUS_BUF,x
	bne @1

	; FALLTROUGH

unit_rd_init_test_ram:                 ; non-destructive ATTIC/CELLAR RAM test

	; Preserve temporary address area on stack

	ldx #$03
@2:
	lda PNTR, x
	pha
	dex
	bpl @2

	; For the start, mark extended RAM as not present

	inx
	stx RAM_ATTIC                      ; set ATTIC/CELLAR RAM as not present
	stx RAM_CELLAR

	; Prepare address - ATTIC RAM, $0800:$0000

	stx PNTR+0
	stx PNTR+1
	stx PNTR+2
	lda #$08
	sta PNTR+3

	ldz #$00

	; Test for ATTIC RAM

	jsr @perform_ram_test
	bne @done_attic
	dec RAM_ATTIC                      ; test passed

@done_attic:

	; Prepare address - CELLAR RAM, $0880:$0000

	lda #$80
	sta PNTR+2

	; Test for cellar RAM

	jsr @perform_ram_test
	bne @done_cellar
	dec RAM_CELLAR                     ; test passed

@done_cellar:

	; Restore temporary address area content

	ldx #$00
@3:
	pla
	sta PNTR, x
	inx
	cpx #$04
	bne @3

	; End of initialization

	rts

@perform_ram_test:

	; Try to change one byte in extended RAM

	lda [PNTR], z
	tax
	eor #$FF
	sta [PNTR], z

	; Make sure the cache does not contain the value any more

	tay
	dez
	lda [PNTR], z
	inz
	tya

	; Check if byte still contains the new value

	cmp [PNTR], z
	php

	; Restore byte content

	txa
	sta [PNTR], z
	
	; Return test result

	plp
	rts
