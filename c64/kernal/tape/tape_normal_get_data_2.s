// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape (normal) helper routine - data block (backup) reading
//


#if CONFIG_TAPE_NORMAL


tape_normal_get_data_2:

	// First check if there is a need to read anything

	lda PTR1
	beq tape_normal_get_data_2_checksum

	// Read sync of the block
	
	ldy #$09
	jsr tape_normal_sync
	bcs tape_normal_get_data_2_done    // Carry already set, will indicate error
	jsr tape_normal_get_marker

	// FALLTROUGH

tape_normal_get_data_2_loop:

	// XXX read missing bytes

	sec
	rts


tape_normal_get_data_2_checksum:

	// Validate checksum

	lda RIPRTY
	cmp #$01                           // sets Carry if checksum verification fails

	// FALLTROUGH

tape_normal_get_data_2_done:

	rts


#endif
