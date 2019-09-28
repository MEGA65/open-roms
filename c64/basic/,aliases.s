//
// Helper aliases to make the code more readable
// Always use double underscore in label names
// to allow automatic VICE label conflict prevention
//

	// Temporary variables for various routines
	.label __tokenise_work1 = $07 // CHARAC
	.label __tokenise_work2 = $08 // ENDCHR
	.label __tokenise_work3 = $0B // COUNT
	.label __tokenise_work4 = $0F // GARBFL
	.label __tokenise_work5 = $0C // DIMFLG

	// We re-use FAC2 for memory move pointers, since
	// we can't be doing calculations while moving memory
	.label __memmove_src  = $69
	.label __memmove_dst  = $6B
	.label __memmove_size = $6D

// XXX cleanup lines below

	// The various pointers that separate memory regions for BASIC storage
	// We have multiple names for the ones that mark the boundary of regions.
	.label basic_start_of_text_ptr       = $2b
	.label basic_end_of_text_ptr         = $2d
	.label basic_start_of_vars_ptr       = $2d
	.label basic_end_of_vars_ptr         = $2f
	.label basic_start_of_arrays_ptr     = $2f
	.label basic_end_of_arrays_ptr       = $31
	.label basic_start_of_free_space_ptr = $31
	.label basic_start_of_strings_ptr    = $33
	.label basic_top_of_memory_ptr       = $37
	.label basic_current_line_number     = $39
	.label basic_previous_line_number    = $3b
	.label basic_current_line_ptr        = $3d
