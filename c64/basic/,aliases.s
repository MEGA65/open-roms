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

	// Floating point accumulator 1 $61 - $68
	.label basic_fac1_exponent = $61
	.label basic_fac1_mantissa = $62 // $62 - $65
	.label basic_fac1_sign = $66
	.label basic_fac1_overflow = $68
	.label basic_fac1_mantissa_lob = $70

	.label basic_fac2_exponent = $69
	.label basic_fac2_mantissa = $6A // $6A - $6D
	.label basic_fac2_sign = $6E

	// We also re-use FAC2 for memory move pointers, since
	// we can't be doing calculations while moving memory
	.label memmove_src = $69
	.label memmove_dst = $6b
	.label memmove_size = $6d

#if CONFIG_MEMORY_MODEL_60K

	// BASIC uses some extra bytes for memory access under ROMs located at $2A7 onwards
	// IRQs are disabled when doing such accesses, and a default NMI handler only increments
	// a counter, so that if an NMI occurs, it doesn't crash the machine, but can be captured.
	.label missed_nmi_flag = $2A7
	.label tiny_nmi_handler = $2A8
	.label shift_mem_up = tiny_nmi_handler+shift_mem_up_routine-tiny_nmi_handler_routine
	.label shift_mem_down = tiny_nmi_handler+shift_mem_down_routine-tiny_nmi_handler_routine
	.label peek_under_roms = tiny_nmi_handler+peek_under_roms_routine-tiny_nmi_handler_routine
	.label poke_under_roms = tiny_nmi_handler+poke_under_roms_routine-tiny_nmi_handler_routine
	.label memmap_allram = tiny_nmi_handler+memmap_allram_routine-tiny_nmi_handler_routine
	.label memmap_normal = tiny_nmi_handler+memmap_normal_routine-tiny_nmi_handler_routine

#endif // CONFIG_MEMORY_MODEL_60K
