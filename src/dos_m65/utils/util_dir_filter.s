
; Check if file name/type matches the filter (if so - Zero flag set)


util_dir_filter:

	lda PAR_FPATTERN
	cmp #$A0
	beq @done                          ; branch if no filter

	ldy #$00

@lp1:

	lda PAR_FPATTERN, y
	cmp #'*'
	beq @asterisk                      ; branch on wildcard

	cmp #'?'
	beq @lp1_next                      ; question mark substitutes any character

	cmp PAR_FNAME, y
	bne @done                          ; branch if does not match

@lp1_next:

	iny
	cpy #$10
	bne @lp1                           ; next iteration if maximum length not reached

@done_match:

	lda #$00

@done:

	rts

@asterisk:

	iny                                ; check if the next character after asterisk is '='
	cpy #$10
	beq @done
	lda PAR_FPATTERN, y
	cmp #'='
	bne @done_match

	iny
	cpy #$10
	beq @done
	lda PAR_FPATTERN, y
	
	sta $1000

	cmp #$44                           ; if 'D' - require a directory      XXX documment this extension
	beq @require_dir
	cmp #$50                           ; if 'P' - require PRG file
	beq @require_prg
	cmp #$52                           ; if 'R' - require REL file
	beq @require_rel
	cmp #$53                           ; if 'S' - require SEQ file
	beq @require_seq
	cmp #$55                           ; if 'U' - require USR file
	bne @done

@require_usr:

	lda #$03
	+skip_2_bytes_trash_nvz

@require_seq:

	lda #$01
	+skip_2_bytes_trash_nvz

@require_rel:

	lda #$04
	+skip_2_bytes_trash_nvz

@require_prg:

	lda #$02
	+skip_2_bytes_trash_nvz

@require_dir:

	lda #$06

	eor PAR_FTYPE
	and #%00111111

	rts
