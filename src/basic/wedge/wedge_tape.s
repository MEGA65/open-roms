// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


#if CONFIG_TAPE_WEDGE


wedge_tape:

	// Prepare for execution

	jsr prepare_direct_execution
	jsr fetch_character

	// First character is a 'left arrow', we can ignore it - determine the command

	jsr fetch_character

	cmp #$4C                           // 'L'
	beq wedge_arrow_L

#if CONFIG_TAPE_HEAD_ALIGN

	cmp #$48                           // 'H'
	beq wedge_arrow_H

#endif

	jmp do_SYNTAX_error

#if CONFIG_TAPE_HEAD_ALIGN

wedge_arrow_H:

	// Make sure the syntax is correct

	jsr injest_spaces
	jsr fetch_character

	cmp #$00
	bne_16 do_SYNTAX_error

	jsr tape_head_align

	jsr print_return
	jmp do_BREAK_error

#endif

wedge_arrow_L:

	// Make sure the syntax is correct

	jsr injest_spaces
	jsr fetch_character
	
	cmp #$00
	beq wedge_arrow_L_no_filename      // branch if no file name given
	cmp #$22
	bne_16 do_SYNTAX_error             // branch if no opening quote

	// Fetch the file name

	lda TXTPTR+0
	sta FNADDR+0
	lda TXTPTR+1
	sta FNADDR+1

	ldx #$00
!:
	jsr fetch_character

	cmp #$00
	beq !+
	cmp #$22
	beq !+

	inx
	bne !-
!:
	stx FNLEN

	lda #$00
	beq wedge_arrow_L_got_filename

wedge_arrow_L_no_filename:
	
	sta FNLEN                          // .A is 0 here, default file name is empty
	
	// FALLTROUGH

wedge_arrow_L_got_filename:            // .A has to be 0

	sta VERCKB                         // operation is LOAD, not VERIFY

	ldy #$01
#if CONFIG_TAPE_TURBO
	ldx #$07                           // turbo tape device
#else
	ldx #$01                           // normal tape device
#endif

	jsr JSETFLS

	// Perform loading

	jmp cmd_load_got_params


#endif // CONFIG_TAPE_WEDGE
