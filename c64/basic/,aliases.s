;	Names of ZP and low memory locations
;	(Only those for now that we feel the need to implement initially)
;	(https://www.c64-wiki.com/wiki/Zeropage)

	.alias tokenise_work1 $7
	.alias tokenise_work2 $8
	.alias tokenise_work3 $B
	.alias tokenise_work4 $F
	.alias basic_line_number $14
	.alias temp_string_ptr $35
	.alias load_or_verify_or_tokenise_work5 $C
	.alias basic_work22 $22
	.alias basic_work23 $23
	.alias basic_work24 $24
	.alias basic_work25 $25

	;; The various pointers that separate memory regions for BASIC storage
	;; We have multiple names for the ones that mark the boundary of regions.
	.alias basic_start_of_text_ptr $2b
	.alias basic_end_of_text_ptr $2d
	.alias basic_start_of_vars_ptr $2d
	.alias basic_end_of_vars_ptr $2f
	.alias basic_start_of_arrays_ptr $2f
	.alias basic_end_of_arrays_ptr $31
	.alias basic_start_of_free_space_ptr $31
	.alias basic_start_of_strings_ptr $33
	.alias basic_top_of_memory_ptr $37
	.alias basic_current_line_ptr $3d
	
	.alias basic_numeric_work_area $57 ; $57 - $60 inclusive = 10 bytes

	;; Floating point accumulator 1 $61 - $68
	.alias basic_fac1_exponent $61
	.alias basic_fac1_mantissa $62 ; $62 - $65
	.alias basic_fac1_sign $66
	.alias basic_fac1_overflow $68
	.alias basic_fac1_mantissa_lob $70

	.alias basic_fac2_exponent $69	
	.alias basic_fac2_mantissa $6A ; $6A - $6D
	.alias basic_fac2_sign $6E
	

	
	
	.alias TXTTAB $2B
	.alias IOSTATUS $90
	; Keys down clears bits. STOP=bit 7, C= bit 6, SPACE bit 4, CTRL bit 2
	.alias BUCKYSTATUS $91
	.alias load_or_verify_flag $93
	.alias current_file_num $98
	.alias input_device_number $99
	; bit 6 = error messages, bit 7 = control messages
	.alias kernal_message_control_flags $9d
	.alias jiffy_clock_24bits $a0
	.alias cassette_buffer_bytes_used $A6
	.alias load_or_scroll_temp_pointer $AC
	;; We also use the following for temp colour pointer when scrolling
	.alias load_save_verify_end_address $AE
	.alias cassette_buffer_ptr $B2
	.alias current_filename_length $B7
	.alias current_logical_filenum $B8
	.alias current_secondary_address $B9
	.alias current_device_number $BA
	.alias current_filename_ptr $BB
	.alias load_save_start_ptr $C1
	.alias load_save_end_ptr $C3
	.alias last_key_matrix_position $C5
	.alias keys_in_key_buffer $C6
	.alias reverse_video_flag $C7
	.alias end_of_input_line $C8
	.alias start_of_keyboard_input $C9
	.alias current_key_index_entry $CB
	.alias cursor_blink_disable $CC
	.alias cursor_blink_countdown $CD
	.alias cursor_saved_character $CE
	.alias cursor_is_visible $CF
	.alias keyboard_input_ready $D0
	.alias current_screen_line_ptr $D1
	.alias current_screen_x $D3
	.alias quote_mode_flag $D4
	.alias logical_line_length $D5
	.alias current_screen_y $D6
	.alias last_printed_character_ascii $D7
	.alias insert_mode $D8
	; Bits 0 -3 = bits 8-11 of screen line address
	; Bit 7 = line spans multiple physical lines
	.alias screen_line_link_table $D9
	.alias current_screen_line_colour_ptr $F3
	.alias keyboard_decoding_table_ptr $F5
	.alias rs232_rx_buffer_ptr $F7
	.alias rs232_tx_buffer_ptr $F9

	.alias basic_input_buffer $0200
	
	; "Compute's Mapping the 64" book
	.alias keyboard_buffer $0277
	.alias MEMSTR $0281
	.alias MEMSIZ $0283 	; NOTE: Mapping the 64 erroniously has the hex as $282, while the DEC is correct
	.alias text_colour $0286 ; p55
	.alias colour_under_cursor $0287 ; p56
	.alias HIBASE $0288     ; p56 (high byte of start of screen)
	.alias key_buffer_size $0289 ; p57

	;; 0 = cursor keys, insert, delete and space repeat, but nothing else
	;; 128 = all keys repeat
	;; 64 = no keys repeat
	.alias key_repeat_flags $028A ; p58
	;; https://www.c64-wiki.com/wiki/Page_2
	.alias key_repeat_counter $028B
	.alias key_first_repeat_delay $028C
	;; bit 0 = shift, 1 = Vendor Key, 2 = Control
	.alias key_bucky_state $028D
	.alias key_last_bucky_state $028E
	.alias keyboard_decoding_ptr $028F
	.alias enable_case_switch $0291
	.alias screen_scroll_disable $0292
	.alias pal_or_ntsc $02A6


	;; BASIC uses some extra bytes for memory access under ROMs located at $2A7 onwards
	;; IRQs are disabled when doing such accesses, and a default NMI handler only increments
	;; a counter, so that if an NMI occurs, it doesn't crash the machine, but can be captured.
	.alias missed_nmi_flag         $2A7
	.alias tiny_nmi_handler		$2A8	
	.alias peek_under_roms tiny_nmi_handler+peek_under_roms_routine-tiny_nmi_handler_routine
	.alias poke_under_roms tiny_nmi_handler+poke_under_roms_routine-tiny_nmi_handler_routine
	.alias memmap_allram tiny_nmi_handler+memmap_allram_routine-tiny_nmi_handler_routine
	.alias memmap_normal tiny_nmi_handler+memmap_normal_routine-tiny_nmi_handler_routine
	
