// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape (normal) helper routine - data block (backup) reading
//


#if CONFIG_TAPE_NORMAL

tape_normal_get_data_2:
	
	lda RIPRTY
	cmp #$01
	rts

#elif XXX_DISABLED

tape_normal_get_data_2:

	// First check if there is a need to read anything

	// XXX lda PTR1
	// XXX beq tape_normal_get_data_2_checksum

	// Read sync of the block
	
	ldy #$09
	jsr tape_normal_sync
	bcs tape_normal_get_data_2_done              // Carry already set, will indicate error
	jsr tape_normal_get_marker

	// FALLTROUGH

tape_normal_get_data_2_loop:

	// Read missing bytes

	jsr tape_normal_get_byte
	bcc tape_normal_get_data_2_loop_byte_OK

	// Problem reading byte

	jsr load_cmp_log_MEMUSS
	bne tape_normal_get_data_2_loop_advance

	sec
	rts

tape_normal_get_data_2_loop_byte_OK:

	jsr load_cmp_log_MEMUSS
	beq tape_normal_get_data_2_loop_byte_correct // branch if byte from the log

	jsr tape_normal_get_marker
	bcs tape_normal_get_data_2_log_checksum      // branch if end of blocks
	bcc tape_normal_get_data_2_loop_advance


tape_normal_get_data_2_loop_byte_correct:

	// This is a byte from the log

	jsr tape_normal_get_marker
	bcs !+

	lda INBIT
	ldy #$00
	sta (MEMUSS), y
!:
	jsr tape_normal_update_checksum

	// FALLTROUGH

tape_normal_get_data_2_loop_advance:

	// Advance pointer
#if !HAS_OPCODES_65CE02
	jsr lvs_advance_MEMUSS
#else
	inw MEMUSS+0
#endif

	jmp tape_normal_get_data_2_loop


tape_normal_get_data_2_log_checksum:

	lda PTR1
	cmp PTR2
	bne tape_normal_get_data_2_done              // Carry already set

	// Validate checksum

	lda RIPRTY
	cmp #$01                                     // sets Carry if checksum verification fails

	// FALLTROUGH

tape_normal_get_data_2_done:

	rts



load_cmp_log_MEMUSS:

	lda PTR1 // XXX this comparison can be probably moved somewhere else
	cmp PTR2
	bne !+

	lda #$01                                     // to clear Zero flag
	rts
!:
	ldx PTR2
	lda STACK+0, x
	cmp MEMUSS+0
	bne !+

	lda STACK+1, x
	cmp MEMUSS+1
	bne !+

	// MEMUSS matches address from the log

	inc PTR2
	inc PTR2
	lda #$00                                     // to set Zero flag
!:
	rts


#endif
