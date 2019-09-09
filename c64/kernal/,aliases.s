// Names of ZP and low memory locations
// (Only those of relevance for the KERNAL)
// (And only those for now that we feel the need to implement initially)
// (https://www.c64-wiki.com/wiki/Zeropage)

// XXX get rid of this file, use ,aliases_ram_lowmem.s instead

	.label kernal_load_or_verify_flag = $93
	.label current_file_num = $98
	.label input_device_number = DFLTN
	.label cassette_buffer_bytes_used = $A6
	.label load_or_scroll_temp_pointer = $AC
	// We also use the following for temp colour pointer when scrolling
	.label load_save_verify_end_address = $AE
	.label cassette_buffer_ptr = $B2
	.label current_logical_filenum = $B8
	.label current_secondary_address = $B9
	.label current_device_number = $BA
	.label current_filename_ptr = $BB
	.label load_save_end_ptr = $C3
	.label last_key_matrix_position = $C5
	.label keys_in_key_buffer = $C6
	.label reverse_video_flag = $C7
	.label end_of_input_line = $C8
	.label start_of_keyboard_input = $C9
	.label current_key_index_entry = $CB
	.label cursor_blink_disable = $CC
	.label cursor_blink_countdown = $CD
	.label cursor_saved_character = $CE
	.label cursor_is_visible = $CF
	.label keyboard_input_ready = $D0
	.label current_screen_line_ptr = $D1
	.label current_screen_x = $D3
	.label quote_mode_flag = $D4
	.label logical_line_length = $D5
	.label current_screen_y = $D6
	.label last_printed_character_ascii = $D7
	.label insert_mode = $D8
	// Bits 0 -3 = bits 8-11 of screen line address
	// Bit 7 = line spans multiple physical lines
	.label screen_line_link_table = $D9
	.label current_screen_line_colour_ptr = $F3
	.label keyboard_decoding_table_ptr = $F5
	
	// "Compute's Mapping the 64" book
	.label keyboard_buffer = $0277
	.label text_colour = $0286 // p55
	.label colour_under_cursor = $0287 // p56
	.label key_buffer_size = $0289 // p57

	// 0 = cursor keys, insert, delete and space repeat, but nothing else
	// 128 = all keys repeat
	// 64 = no keys repeat
	.label key_repeat_flags = $028A // p58
	// https://www.c64-wiki.com/wiki/Page_2
	.label key_repeat_counter = $028B
	.label key_first_repeat_delay = $028C
	// bit 0 = shift, 1 = Vendor Key, 2 = Control
	.label key_bucky_state = $028D
	.label key_last_bucky_state = $028E
	.label keyboard_decoding_ptr = $028F
	.label enable_case_switch = $0291
	.label screen_scroll_disable = $0292

	// Under-ROM routines
	// (BASIC also includes them. XXX - We should de-duplicate them in a safe manner)
	.label missed_nmi_flag = $2A7
	.label tiny_nmi_handler = $2A8	
	.label peek_under_roms = tiny_nmi_handler+peek_under_roms_routine-tiny_nmi_handler_routine
	.label poke_under_roms = tiny_nmi_handler+poke_under_roms_routine-tiny_nmi_handler_routine
	.label memmap_allram = tiny_nmi_handler+memmap_allram_routine-tiny_nmi_handler_routine
	.label memmap_normal = tiny_nmi_handler+memmap_normal_routine-tiny_nmi_handler_routine

