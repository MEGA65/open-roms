;; #LAYOUT# M65 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Proxies for calling MEGA65 segment BASIC_0 and KERNAL_0 routines from BASIC_1
;


proxy_B1_peek_via_OLDTXT:

	jsr map_NORMAL

!ifdef CONFIG_MEMORY_MODEL_60K {
	!error "not implemented"
} else ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {
	jsr peek_under_roms_via_OLDTXT
	cmp #$00
} else { ; CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
}
	jmp map_BASIC_1                    ; do not do 'bra' - we want this one as fast as possible

proxy_B1_poke_via_OLDTXT:

	jsr map_NORMAL
!ifdef CONFIG_MEMORY_MODEL_60K {
	!error "not implemented"
} else { ; CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	sta (OLDTXT),y
}
	; FALLTROUGH

proxy_B1_end:

	jmp map_BASIC_1

proxy_B1_JCLALL:

	jsr map_NORMAL
	jsr JCLALL
	bra proxy_B1_end

!ifdef CONFIG_DOS_WEDGE {

proxy_B1_JCLOSE:

	jsr map_NORMAL
	jsr JCLOSE
	bra proxy_B1_end

proxy_B1_JOPEN:

	jsr map_NORMAL
	jsr JOPEN
	bra proxy_B1_end
}

proxy_B1_JCHKIN:

	jsr map_NORMAL
	jsr JCHKIN
	bra proxy_B1_end

proxy_B1_JCHRIN:

	jsr map_NORMAL
	jsr JCHRIN
	bra proxy_B1_end

proxy_B1_JCHROUT:

	jsr map_NORMAL
	jsr JCHROUT
	bra proxy_B1_end

proxy_B1_print_hex_byte:

	jsr map_NORMAL
	jsr print_hex_byte
	bra proxy_B1_end

proxy_B1_print_integer:

	jsr map_NORMAL
	jsr print_integer
	bra proxy_B1_end

proxy_B1_print_return:

	jsr map_NORMAL
	jsr print_return
	bra proxy_B1_end

proxy_B1_print_space:

	jsr map_NORMAL
	jsr print_space
	bra proxy_B1_end

proxy_B1_plot_set:

	jsr map_NORMAL
	jsr plot_set
	bra proxy_B1_end

proxy_B1_M65_SETWIN_Y:

	jsr map_NORMAL
	jsr M65_SETWIN_Y
	bra proxy_B1_end

!ifdef CONFIG_DOS_WEDGE {

proxy_B1_fetch_character:

	jsr map_NORMAL
	jsr fetch_character

	; FALLTROUGH

proxy_B1_end_2:

	jmp map_BASIC_1

proxy_B1_fetch_character_skip_spaces:

	jsr map_NORMAL
	jsr fetch_character_skip_spaces
	bra proxy_B1_end_2

proxy_B1_fetch_uint8:

	jsr map_NORMAL
	jsr fetch_uint8
	bra proxy_B1_end_2

proxy_B1_shell_main_loop:

	jsr map_NORMAL
	jmp shell_main_loop

proxy_B1_do_error_print_only:

	jsr map_NORMAL
	jsr do_error_print_only
	bra proxy_B1_end_2

proxy_M1_print_kernal_error:

	tax
	bne @1
	ldx #$1E                           ; BREAK error + 1
@1:
	dex
	jsr m65_shadow_BZP
	jsr do_error_print_only
	jmp proxy_M1_IO_end
}
