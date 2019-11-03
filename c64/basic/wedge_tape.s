
#if CONFIG_TAPE_WEDGE


// .X has to contain size of the buffer

wedge_tape:

	lda #$FF
	sta CURLIN+1                       // in case of error do not print line number

	cpx #$02
	bne_far do_SYNTAX_error

	lda BUF+1
	cmp #$4C                           // 'L'
	bne_far do_SYNTAX_error

	// Execute 'arrow + L'
	
	lda #$00
	sta FNLEN

	ldy #$01
	ldx #$07                           // turbo tape device
	jsr JSETFLS

	ldy TXTTAB+1
	ldx TXTTAB+0

	jmp cmd_load_got_secondaryaddress


#endif // CONFIG_TAPE_WEDGE
