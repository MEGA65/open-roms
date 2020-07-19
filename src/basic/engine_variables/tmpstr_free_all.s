// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


tmpstr_free_all:

	// Go through all the temporary descriptors and free everything

	ldx #$19

	// XXX implement this

	//FALLTROUGH

tmpstr_free_all_loop:

	// XXX finish, deduplicate part with CLR
	
	rts
