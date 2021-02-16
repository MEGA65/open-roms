
; Adapt the file size for displaying in a directory list


util_dir_filesize_bytes: ; preserves .X

	; Convert file size in bytes (32-bit value) to blocks, afterwards
	; continue processing in 'util_dir_filesize_blocks'

	; XXX temporary - calculate size in 254-byte blocks

	lda PAR_FSIZE_BYTES+1
	sta PAR_FSIZE_BLOCKS+0
	lda PAR_FSIZE_BYTES+2
	sta PAR_FSIZE_BLOCKS+1

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
