// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// ROM routine call redirect for tape routines
//


#if CONFIG_TAPE_NORMAL && !CONFIG_TAPE_AUTODETECT

load_tape_normal:

	jsr     map_KERNAL_1
	jsr_ind VK1__load_tape_normal
	jmp     map_NORMAL

#endif


#if CONFIG_TAPE_TURBO && !CONFIG_TAPE_AUTODETECT

load_tape_turbo:

	jsr     map_KERNAL_1
	jsr_ind VK1__load_tape_turbo
	jmp     map_NORMAL

#endif


#if CONFIG_TAPE_AUTODETECT

load_tape_auto:

	jsr     map_KERNAL_1
	jsr_ind VK1__load_tape_auto
	jmp     map_NORMAL

#endif


#if CONFIG_TAPE_HEAD_ALIGN

tape_head_align:

	jsr     map_KERNAL_1
	jsr_ind VK1__tape_head_align
	jmp     map_NORMAL

#endif
