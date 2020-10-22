;; #LAYOUT# CRT KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; ROM routine call redirect for tape routines
;


!ifdef CONFIG_TAPE_NORMAL { !ifndef CONFIG_TAPE_AUTODETECT {

load_tape_normal:

	jsr map_KERNAL_1
	jsr JK1__load_tape_normal
	jmp map_NORMAL
} }


!ifdef CONFIG_TAPE_TURBO { !ifndef CONFIG_TAPE_AUTODETECT {

load_tape_turbo:

	jsr map_KERNAL_1
	jsr JK1__load_tape_turbo
	jmp map_NORMAL
} }


!ifdef CONFIG_TAPE_AUTODETECT {

load_tape_auto:

	jsr map_KERNAL_1
	jsr JK1__load_tape_auto
	jmp map_NORMAL
}


!ifdef CONFIG_TAPE_HEAD_ALIGN {

tape_head_align:

	jsr map_KERNAL_1
	jsr JK1__tape_head_align
	jmp map_NORMAL
}
