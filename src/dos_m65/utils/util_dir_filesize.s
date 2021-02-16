
; Adapt the file size for displaying in a directory list


util_dir_filesize_bytes: ; preserves .X

	; Convert file size in bytes (32-bit value) to blocks, afterwards
	; continue processing in 'util_dir_filesize_blocks'

	; Start from handling some large values
	
	lda PAR_FSIZE_BYTES+3
	+bne util_dir_filesize_max         ; file over 16MB size
	lda PAR_FSIZE_BYTES+2
	inc
	+beq util_dir_filesize_max         ; file over 8MB size 

	; Set initial size as 0 blocks
	
	lda #$00
	sta PAR_FSIZE_BLOCKS+0
	sta PAR_FSIZE_BLOCKS+1

	; Calculate number of blocks

	ldy #$03

@lp:

	lda PAR_FSIZE_BYTES+2
	cmp util_dir_cmptab_hi,y
	bcc @lp_next
	bne @lp_adc_sbc
	lda PAR_FSIZE_BYTES+1
	cmp util_dir_cmptab_mi,y
	bcc @lp_next
	bne @lp_adc_sbc
	lda PAR_FSIZE_BYTES+0
	cmp util_dir_cmptab_lo,y
	bcc @lp_next

@lp_adc_sbc:

	clc
	lda PAR_FSIZE_BLOCKS+0
	adc util_dir_addtab_lo,y
	sta PAR_FSIZE_BLOCKS+0
	lda PAR_FSIZE_BLOCKS+1
	adc util_dir_addtab_hi,y
	sta PAR_FSIZE_BLOCKS+1

	sec
	lda PAR_FSIZE_BYTES+0
	sbc util_dir_cmptab_lo, y
	sta PAR_FSIZE_BYTES+0
	lda PAR_FSIZE_BYTES+1
	sbc util_dir_cmptab_mi, y
	sta PAR_FSIZE_BYTES+1
	lda PAR_FSIZE_BYTES+2
	sbc util_dir_cmptab_hi, y
	sta PAR_FSIZE_BYTES+2

	bra @lp

@lp_next:

	dey
	bpl @lp
	
	; Correct for bytes not filling in the whole block
	
	lda PAR_FSIZE_BYTES+0
	beq util_dir_filesize_blocks
	
	inc PAR_FSIZE_BLOCKS+0
	bne util_dir_filesize_blocks
	inc PAR_FSIZE_BLOCKS+1

	; FALLTROUGH

util_dir_filesize_blocks: ; preserves .X

	; Take file size in blocks (16-bit value), clip to max 9999,
	; return in .Y the amount of spaces needed for indentation
	
	lda PAR_FSIZE_BLOCKS+1
	cmp #>9999
	beq @cmp_9999_p2
	bcs util_dir_filesize_max
	bcc @size_ok

@cmp_9999_p2:

	lda PAR_FSIZE_BLOCKS+0
	cmp #<9999
	bcs util_dir_filesize_max

@size_ok:
	
	lda PAR_FSIZE_BLOCKS+1
	beq @size_123

@size_34:  ; file size is 256 or above (3 or 4 digits)

	cmp #>1000
	beq @cmp_1000_p2
	bcs util_dir_filesize_4
	bra util_dir_filesize_3

@cmp_1000_p2:

	lda PAR_FSIZE_BLOCKS+0
	cmp #<1000
	bcs util_dir_filesize_4
	bra util_dir_filesize_3

@size_123: ; file size is 255 or below (1, 2, or 3 digits)

	lda PAR_FSIZE_BLOCKS+0
	cmp #10
	bcs util_dir_filesize_23

	; FALLTROUGH

util_dir_filesize_1:  ; file size needs 1 digit

	ldy #$03
	rts

util_dir_filesize_23: ; file size needs 2 or 3 digits, size in .A

	cmp #100
	bcs util_dir_filesize_3

	; FALLTROUGH

util_dir_filesize_2:  ; file size needs 2 digits

	ldy #$02
	rts

util_dir_filesize_3: ; file size needs 3 digits

	ldy #$01
	rts

util_dir_filesize_max:

	lda #<9999
	sta PAR_FSIZE_BLOCKS+0
	lda #>9999
	sta PAR_FSIZE_BLOCKS+1

	; FALLTROUGH

util_dir_filesize_4: ; file size needs 4 digits

	ldy #$00
	rts


; Tables for calculating blocks from bytes

util_dir_addtab_hi:

	!byte $00, $00 ; 2 next bytes same as in 'lo' table

util_dir_addtab_lo:	

	!byte $01, $10, $00, $00

util_dir_cmptab_hi:

	!byte ^(254), ^(254 * 16), ^(254 * 16 * 16), ^(254 * 16 * 16 * 16), ^(254 * 16 * 16 * 16 * 16)

util_dir_cmptab_mi:

	!byte >(254), >(254 * 16), >(254 * 16 * 16), >(254 * 16 * 16 * 16), >(254 * 16 * 16 * 16 * 16)

util_dir_cmptab_lo:

	!byte <(254), <(254 * 16), <(254 * 16 * 16), <(254 * 16 * 16 * 16), <(254 * 16 * 16 * 16 * 16)
