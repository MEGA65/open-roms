;	Names of ZP and low memory locations
;	(Only those of relevance for the KERNAL)
;	(And only those for now that we feel the need to implement initially)
;	(https://www.c64-wiki.com/wiki/Zeropage)

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
	.alias current_key_index_entry $CB
	.alias cursor_blink_disable $CC
	.alias cursor_blink_countdown $CD
	.alias cursor_saved_character $CE
	.alias cursor_is_visible $CF
	.alias input_source $D0
	.alias current_screen_line_ptr $D1
	.alias current_screen_line_logical_column $D3
	.alias quote_mode_flag $D4
	.alias max_logical_line_length $D5
	.alias cursor_physical_screen_line $D6
	.alias last_printed_character_ascii $D7
	.alias insert_mode $D8
	; Bits 0 -3 = bits 8-11 of screen line address
	; Bit 7 = line spans multiple physical lines
	.alias screen_line_link_table $D9
	.alias current_screen_line_colour_ptr $F3
	.alias keyboard_decoding_table_ptr $F5
	.alias rs232_rx_buffer_ptr $F7
	.alias rs232_tx_buffer_ptr $F9


	; "Compute's Mapping the 64" book
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
