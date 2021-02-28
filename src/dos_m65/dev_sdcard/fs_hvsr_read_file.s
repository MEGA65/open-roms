
;
; Hypervisor virtual filesystem - opening the file
;


fs_hvsr_read_file_open:

	; Open the directory

	lda #$12                          ; dos_opendir
	sta HTRAP00
	+nop

	; XXX handle read errors

	sta SD_DESC                       ; store directory descriptor  XXX invent better name

	; Reset status to OK

	lda #$00
	sta PAR_TRACK
	sta PAR_SECTOR
	jsr util_status_SD

	; XXX deduplicate part above with opening directory

	; Read dirent structures into $1000, find the first matching file
	; Starting at $1000 VIC sees chargen, so this should be a safe place

	jsr fs_hvsr_direntmem_prepare

@lp_find:

	jsr fs_hvsr_util_nextdirentry      ; fetch the next file name
	+bcs fs_hvsr_file_not_found

	; Only accept files of type 'PRG', properly closed

	lda PAR_FTYPE
	and #%10111111 
	cmp #$82
	bne @lp_find

	; Check if file name matches the filter

	jsr util_dir_filter
	bne @lp_find                       ; if does not match, try the next entry

	; Found the file - load it

	jsr fs_hvsr_direntmem_restore     ; restore $1000 memory content

	lda #$18                          ; dos_openfile
	sta HTRAP00
	+nop

	; XXX check error code

	; Read the first 512-byte chunk

	lda #$03                 ; mode: read file
	sta SD_MODE

	jsr fs_hvsr_read_file
	jmp dos_EXIT

fs_hvsr_read_file:

	; Read chunk of data to SD card buffer

	ldx SD_DESC
	lda #$1A                          ; dos_readfile
	sta HTRAP00
	+nop

	; XXX check error code

	; Store number of bytes read

	stx SD_ACPTR_LEN+0
	sty SD_ACPTR_LEN+1

	; Check if any data was read

	tya
	ora SD_ACPTR_LEN+0
	bne @copy

	lda #$20                          ; dos_closefile
	sta HTRAP00
	+nop

	lda #$00
	sec
	rts

@copy:

	; Set pointer to new data

	lda #<SD_FILEBUF
	sta SD_ACPTR_PTR+0
	lda #>SD_FILEBUF
	sta SD_ACPTR_PTR+1

	; Copy data to SD_FILEBUF

	lda #%10000000                    ; select SD card buffer
	tsb SD_BUFCTL

	lda #$02
	sta DMA_ADDRBANK                  ; $D702
	lda #$00
	sta DMA_ADDRMB                    ; $D704

	lda #>(@dmalist-$4000)
	sta DMA_ADDRMSB                   ; $D701
	lda #<(@dmalist-$4000)
	sta DMA_ETRIG                     ; $D705

	clc
	rts

@dmalist:

	!byte $0A                         ; use F018A list format (it is shorter by 1 byte)
	!byte $80, $FF                    ; src. address is $FFxxxxx
	!byte $81, $00                    ; dst. address is $00xxxxx
	!byte $00                         ; end of options
	!byte $00                         ; operation: COPY
	!word $0200                       ; data size if 512 bytes
	!byte $00, $6E, $0D               ; src. addr is $xxD6E00
	!byte <SD_FILEBUF, >SD_FILEBUF - $80, $01 ; dst. addr is $xx1xxxx (internal buffer)

fs_hvsr_file_not_found:

	jsr fs_hvsr_direntmem_restore     ; restore $1000 memory content

    ldx SD_DESC
	lda #$16                          ; dos_closedir
	sta HTRAP00
	+nop

	lda #39                           ; file not found error
	jsr util_status_SD

	lda #K_ERR_FILE_NOT_FOUND
	jmp dos_EXIT_SEC_A
