
;
; Hypervisor virtual filesystem - helper routine to get the next directory entry
;


; Fills-in: PAR_FNAME, PAR_FTYPE, PAR_FSIZE_BYTES

; NOTE: overrides page pointed by MEM_BUF!


fs_vfs_nextdirentry:

	; Clear the page which will be used

	ldx #$00
	txa

@lpclear:

	sta MEM_BUF, x
	inx
	bne @lpclear

	; Ask the hypervisor to read the next dirent structure

	ldx SD_DESC                       ; directory descriptor    XXX rename to FS_HVSR_DESC
	ldy #>MEM_BUF                     ; target page number

	jsr util_htrap_dos_readddir

	+bcc @fail

	; Reading entry succeeded, try to decode it. Important dirent fileds:

	; - $00-$3F - file name
	; - $40     - file name length
	; - $52-$55 - file length
	; - $56-$57 - file type ($10 = dir, $20 = regular) and attributes ($01 for read-only)

	;
	; Preprocess/validate the filename
	;

	ldx MEM_BUF+$40                    ; file name length
	beq fs_vfs_nextdirentry            ; do not even try for empty file name
	cpx #20
	bcs fs_vfs_nextdirentry            ; if longer than 16 characters + dot + extension - also skip this one
	dex

@lpname:

	lda MEM_BUF,x
	cmp #$22
	beq fs_vfs_nextdirentry            ; quotation mark is illegal
	cmp #$2A
	beq fs_vfs_nextdirentry            ; asterisk is illegal, it is used for filtering
	cmp #$3F
	beq fs_vfs_nextdirentry            ; the question mark - in the MS-DOS world it is illegal
	cmp #$20
	bcc fs_vfs_nextdirentry            ; control characters are not allowed
	cmp #$5B
	bcc @lpname_next                   ; up to PETSCII 'Z' is OK
	cmp #$61
	bcc fs_vfs_nextdirentry            ; some characters are not allowed
	cmp #$7E
	bne @lpname_1
	lda #$A6                           ; replace tilde / pi with something more sane                         
	bra @lpname_store_next

@lpname_1:

	cmp #$7B
	bcs fs_vfs_nextdirentry            ; PETSCII-art and control characters are illegal
	clc
	sbc #$20                           ; make everything the same case

@lpname_store_next:

	sta MEM_BUF,x                      ; use this when file name has to be adapted

@lpname_next:

	dex
	bpl @lpname

	;
	; Determine type (file/directory)
	;

	lda MEM_BUF+$56
	tax
	and #$FE
	beq @entity_file                   ; workaround for older hypervisors

	and #$20
	bne @entity_file                   ; branch on file
	
	txa
	and #$10
	beq fs_vfs_nextdirentry            ; this type is unknown 

@entity_dir:

	; Once again validate the name length, with more precise information

	lda MEM_BUF+$40
	cmp #$11
	bcs fs_vfs_nextdirentry            ; skip entry if file name longer than 16 characters

	; Set the type to directory

	lda #$06
	bra @detect_attributes

@entity_file:

	; Once again validate the name length, with more precise information

	lda MEM_BUF+$40
	sec
	sbc #$04                           ; strip 4 bytes - for dot and extension
	bmi fs_vfs_nextdirentry            ; if name too short, try next entry
	beq fs_vfs_nextdirentry            ; if name too short, try next entry
	sta MEM_BUF+$40                    ; store corrected file name length
	tax

	; Make sure there is a dot marking the start of a 3-byte extension

	lda MEM_BUF, x
	cmp #$2E
	+bne fs_vfs_nextdirentry

	;
	; Detect file type by extension
	;

	inx
	ldy #$00

@lpext:

	lda MEM_BUF+0, x
	cmp dir_types+0, y
	bne @lpext_next

	lda MEM_BUF+1, x
	cmp dir_types+1, y
	bne @lpext_next

	lda MEM_BUF+2, x
	cmp dir_types+2, y
	beq @lpext_found

@lpext_next:

	iny
	iny
	iny
	iny
	cpy #(dir_types__end - dir_types)
	bcc @lpext

	jmp fs_vfs_nextdirentry            ; file extension not detected

@lpext_found:

	cpy #$18
	+beq fs_vfs_nextdirentry           ; file extension 'DIR' does not mean this is a directory
	tya

	clc
	ror
	clc
	ror

	cmp #$07                           ; mark some file types (not SEQ/PRG/USR/REL/CBM/DIR) as read-only
	bcc @detect_attributes
	ora #$40

@detect_attributes:

	ora #$80                           ; mark the file as closed, FAT32 does not have a 'not closed' attribute
	sta PAR_FTYPE

	lda MEM_BUF+$56                    ; also apply read-only attribute from FAT32
	and #$01
	beq @copy_size

	lda PAR_FTYPE
	ora #$40
	sta PAR_FTYPE

@copy_size:

	; Copy the file size

	ldx #$03

@lpsize:

	lda MEM_BUF+$52,x                  ; copy file size in byytes
	sta PAR_FSIZE_BYTES,x
	dex
	bpl @lpsize

@copy_name:

	; Last, but not least - copy file name

	lda #$A0                           ; fill-in empty bytes with $A0, to simulate CBM file system
	ldx #$0F

@lpname_cpy:

	cpx MEM_BUF+$40
	bcs @lpname_fill
	lda MEM_BUF, x

@lpname_fill:

	sta PAR_FNAME,x
	dex
	bpl @lpname_cpy

	; All done

	clc
	rts

@fail:

	; Reading next entry failed, this is the end

	; XXX check error code

	sec
	rts
