;; #LAYOUT# CRT KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Proxies for calling cartridge segment KERNAL_0 routines from KERNAL_1
;



!ifdef HAS_TAPE {

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
}


!ifdef CONFIG_TAPE_HEAD_ALIGN {

proxy_K1_CLALL:

	jsr map_NORMAL
	jsr CLALL
	jmp map_KERNAL_1

proxy_K1_IOINIT:

	jsr map_NORMAL
	jsr IOINIT
	jmp map_KERNAL_1

}
