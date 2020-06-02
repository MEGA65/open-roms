// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Proxies for calling Mega65 segment KERNAL_0 routines from KERNAL_1
//


#if CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO


proxy_K1_kernalerror_ROUTINE_TERMINATED:

	jsr map_NORMAL
	jmp kernalerror_ROUTINE_TERMINATED


proxy_K1_lvs_display_loading_verifying:

	jsr map_NORMAL
	jsr lvs_display_loading_verifying
	jmp map_KERNAL_1

proxy_K1_lvs_display_done:

	jsr map_NORMAL
	jsr lvs_display_done
	jmp map_KERNAL_1

proxy_K1_lvs_return_last_address:

	jsr map_NORMAL
	jmp lvs_return_last_address

proxy_K1_lvs_device_not_found_error:

	jsr map_NORMAL
	jmp lvs_device_not_found_error

proxy_K1_lvs_load_verify_error:

	jsr map_NORMAL
	jmp lvs_load_verify_error


proxy_K1_print_kernal_message:

	jsr map_NORMAL
	jsr print_kernal_message
	jmp map_KERNAL_1

proxy_K1_print_return:

	jsr map_NORMAL
	jsr print_return
	jmp map_KERNAL_1

#endif
