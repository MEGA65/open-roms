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

#elif DISABLED_DISABLED

tape_normal_get_data_2:

	// First check if there is a need to read anything

	// XXX lda PTR1
	// XXX beq tape_normal_get_data_2_checksum

	// Read sync of the block
	
	ldy #$09
	jsr tape_normal_sync
	bcs tape_normal_get_data_2_done    // Carry already set, will indicate error
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
	bne tape_normal_get_data_2_loop_advance

	// This is a byte from the log

	// XXX store correct byte


tape_normal_get_data_2_loop_advance:

	// XXX finish the implementation

	sec
	rts


tape_normal_get_data_2_checksum:

	// Validate checksum

	lda RIPRTY
	cmp #$01                           // sets Carry if checksum verification fails

	// FALLTROUGH

tape_normal_get_data_2_done:

	rts



load_cmp_log_MEMUSS:

	// XXX

!:
	rts


#endif
