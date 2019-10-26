
screen_get_current_line_logical_length:
	ldy TBLX
	lda LDTBL,y
	bpl !+
	lda #79
	.byte $2c 		// BIT absolute mode, which we use to skip the next two instruction bytes
!:
	lda #39
	sta LNMX
	rts