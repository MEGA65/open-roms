
;
; CBM/CMD virtual filesystem - reading the file
;


fs_cbm_read_file_open:

	; Get the first sector of the directory  XXX deduplicate code, create a separate open directory routine

	lda #40
	sta PAR_TRACK
	lda #$03
	sta PAR_SECTOR

	jsr lowlevel_readsector         ; XXX handle read errors

	; Set variables to point to the 1st directory entry in the 2nd sector of the buffer

	lda #$08
	sta FD_DIRENT

	; Make sure the 1st sector in buffer points to 2nd one

	lda #40
	sta SHARED_BUF_1+0
	lda #03
	sta SHARED_BUF_1+1

	; XXX deduplicate code above with fs_cbm_read_dir_open

	; Try to find the file, has to be PRG

@lp_find:

	jsr fs_cbm_nextdirentry
	+bcs dos_EXIT

	; Only accept files of type 'PRG', properly closed     XXX deduplicate with fs_vfs

	lda PAR_FTYPE
	and #%10111111 
	cmp #$82
	bne @lp_find

	; Check if file name matches the filter     XXX deduplicate with fs_vfs

	jsr util_dir_filter
	bne @lp_find                       ; if does not match, try the next entry

	; Found the file, load it

	lda #$03                 ; mode: read file
	sta FD_MODE

	lda FD_LOADTRACK
	sta PAR_TRACK
	lda FD_LOADSECTOR
	sta PAR_SECTOR

	bra fs_cbm_read_file_got_ts

fs_cbm_read_file:

	; Fetch the next track/sector

	lda FD_LOADSECTOR
	and #$01
	bne @part_2

@part_1:

	; We were reading from the 1st half of the buffer

	lda SHARED_BUF_1+1
	sta PAR_SECTOR
	lda SHARED_BUF_1+0
	bra @common_chk

@part_2:

	; We were reading from the 2nd half of the buffer

	lda SHARED_BUF_1+$100+1
	sta PAR_SECTOR
	lda SHARED_BUF_1+$100+0

@common_chk:

	bne @common_load

	lda #$00                           ; end of file
	sec
	rts

@common_load:

	sta PAR_TRACK

	; FALLTROUGH

fs_cbm_read_file_got_ts:

	; Load next track/sector

	jsr lowlevel_readsector         ; XXX handle read errors

	; Store pointer and amount of data ready to fetch

	lda #$FE
	sta FD_ACPTR_LEN+0
	lda #$00
	sta FD_ACPTR_LEN+1

	lda #$02
	sta FD_ACPTR_PTR+0
	lda #>SHARED_BUF_1
	sta FD_ACPTR_PTR+1

	lda PAR_SECTOR
	and #$01
	bne @part_2

@part_1:

	; Sector with data is located in the 1st half of the buffer

	lda SHARED_BUF_1+0
	beq @exit

	; Less than a full sector is used

	lda SHARED_BUF_1+1
	bra @not_full_buf

@part_2:

	; Sector with data is located in the 2nd half of the buffer

	inc FD_ACPTR_PTR+1

	lda SHARED_BUF_1+$100+0
	beq @exit

	; Less than a full sector is used

	lda SHARED_BUF_1+$100+0

@not_full_buf:

	sta FD_ACPTR_LEN+0

	; FALLTROUGH

@exit:

	clc
	rts
