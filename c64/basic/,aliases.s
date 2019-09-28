// Names of ZP and low memory locations
// (Only those for now that we feel the need to implement initially)
// (https://www.c64-wiki.com/wiki/Zeropage)

// XXX get rid of this file, use ,aliases_ram_lowmem.s instead

	.label tokenise_work1 = $7
	.label tokenise_work2 = $8
	.label tokenise_work3 = $B
	.label tokenise_work4 = $F
	.label basic_line_number = $14
	.label temp_string_ptr = $35
	.label load_or_verify_or_tokenise_work5 = $C
	.label basic_work22 = $22
	.label basic_work23 = $23
	.label basic_work24 = $24
	.label basic_work25 = $25

	// The various pointers that separate memory regions for BASIC storage
	// We have multiple names for the ones that mark the boundary of regions.
	.label basic_start_of_text_ptr = $2b
	.label basic_end_of_text_ptr = $2d
	.label basic_start_of_vars_ptr = $2d
	.label basic_end_of_vars_ptr = $2f
	.label basic_start_of_arrays_ptr = $2f
	.label basic_end_of_arrays_ptr = $31
	.label basic_start_of_free_space_ptr = $31
	.label basic_start_of_strings_ptr = $33
	.label basic_top_of_memory_ptr = $37
	.label basic_current_line_number = $39
	.label basic_previous_line_number = $3b
	.label basic_current_line_ptr = $3d

	// Note that the statement point is in the CHRGET/CHRGOT routine
	// in ZP RAM.  (Compute's Mapping the 64, p25)
	.label basic_current_statement_ptr = $7a
	
	.label basic_numeric_work_area = $57 // $57 - $60 inclusive = 10 bytes

	// We also re-use FAC2 for memory move pointers, since
	// we can't be doing calculations while moving memory
	.label memmove_src = $69
	.label memmove_dst = $6b
	.label memmove_size = $6d
