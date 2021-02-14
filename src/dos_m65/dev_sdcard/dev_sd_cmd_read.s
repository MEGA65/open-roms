
;
; Read more data into the buffer
;


dev_sd_cmd_READ:

	; XXX provide implementation for regular files

	lda SD_DIR_PHASE
	cmp #$01
	beq dev_sd_cmd_READ_dir_blocksfree

	sec ; mark EOI
	rts

dev_sd_cmd_READ_dir:

	; Dirent structure:
	; - 4 bytes - inode
	; - 2 bytes - ('off' - not sure what's this)
	; - 4 bytes - ('reclen' - is it file size?)
	; - 2 bytes - type

    ; .X = file descriptor
    ; .Y = page of memory for output

	; lda #$12                          ; dos_readdir
	; sta HTRAP00
	; +nop

dev_sd_cmd_READ_dir_blocksfree:

	; Set pointer to '0 BLOCKS FREE.' line

	lda #$13
	sta SD_ACPTR_LEN+0
	lda #$00
	sta SD_ACPTR_LEN+1

	lda #<dir_end
	sta SD_ACPTR_PTR+0
	lda #>dir_end
	sta SD_ACPTR_PTR+1

	; Mark end of directory

	lda #$00
	sta SD_DIR_PHASE

    ; .X = file descriptor

	; lda #$13                          ; dos_closedir
	; sta HTRAP00
	; +nop

	clc
	rts
