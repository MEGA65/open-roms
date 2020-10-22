;; #LAYOUT# CRT KERNAL_0 #TAKE-FLOAT
;; #LAYOUT# CRT KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Definitions for communication with cartridge segment KERNAL_1 from KERNAL_0
;


!ifdef SEGMENT_KERNAL_0 {

	; Label definitions

	!addr JK1__load_tape_normal          = $8000 + 3 * 0
	!addr JK1__load_tape_turbo           = $8000 + 3 * 1
	!addr JK1__load_tape_auto            = $8000 + 3 * 2
	!addr JK1__tape_head_align           = $8000 + 3 * 3

} else {

	; Jump table (Open ROMs private!)

!ifdef CONFIG_TAPE_NORMAL { !ifndef CONFIG_TAPE_AUTODETECT {
	jmp load_tape_normal
} else { !byte $00, $00, $00 } } else { !byte $00, $00, $00 }

!ifdef CONFIG_TAPE_TURBO { !ifndef CONFIG_TAPE_AUTODETECT {
	jmp load_tape_turbo
} else { !byte $00, $00, $00 } } else { !byte $00, $00, $00 }

!ifdef CONFIG_TAPE_AUTODETECT {
	jmp load_tape_auto
} else { !byte $00, $00, $00 }

!ifdef CONFIG_TAPE_HEAD_ALIGN {
	jmp tape_head_align
} else { !byte $00, $00, $00 }


}
