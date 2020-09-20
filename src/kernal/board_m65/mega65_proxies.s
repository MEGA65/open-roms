;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Proxies for calling MEGA65 segment KERNAL_0 routines from KERNAL_1
;


proxy_K1_chrin_programmable_keys:

	jsr map_NORMAL
	jsr chrin_programmable_keys
	bra proxy_K1_end

proxy_K1_CHROUT:

	jsr map_NORMAL
	jsr CHROUT

	; FALLTROUGH

proxy_K1_end:

	jmp map_KERNAL_1

!ifdef HAS_TAPE {

proxy_K1_kernalerror_ROUTINE_TERMINATED:

	jsr map_NORMAL
	jmp kernalerror_ROUTINE_TERMINATED

proxy_K1_lvs_display_loading_verifying:

	jsr map_NORMAL
	jsr lvs_display_loading_verifying
	bra proxy_K1_end

proxy_K1_lvs_display_done:

	jsr map_NORMAL
	jsr lvs_display_done
	bra proxy_K1_end

proxy_K1_lvs_return_last_address:

	jsr map_NORMAL
	jmp lvs_return_last_address

proxy_K1_lvs_device_not_found_error:

	jsr map_NORMAL
	jmp lvs_device_not_found_error

proxy_K1_lvs_load_verify_error:

	jsr map_NORMAL
	jmp lvs_load_verify_error

proxy_K1_m65_load_autoswitch_tape:

	jsr map_NORMAL
	jsr m65_load_autoswitch_tape
	bra proxy_K1_end

proxy_K1_print_kernal_message:

	jsr map_NORMAL
	jsr print_kernal_message
	bra proxy_K1_end

proxy_K1_print_return:

	jsr map_NORMAL
	jsr print_return
	bra proxy_K1_end
}


!ifdef CONFIG_TAPE_HEAD_ALIGN {

proxy_K1_CLALL:

	jsr map_NORMAL
	jsr CLALL
	bra proxy_K1_end
}
