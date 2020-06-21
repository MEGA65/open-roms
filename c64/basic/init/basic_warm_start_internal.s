// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Continuation of the BASIC cold start routine
//

basic_warm_start_real:

#if CONFIG_MEMORY_MODEL_60K
	// We need our helpers to get to filenames under ROMs or IO area
	jsr install_ram_routines
#endif

	// If warm start caused by BRK, print it address
	// XXX sys 58235 also triggers this - to be fixed
	lda CMP0
	ora CMP0+1
	beq !+

	ldx #IDX__STR_BRK_AT
	jsr print_packed_misc_str

	lda CMP0+1
	jsr print_hex_byte
	lda CMP0+0
	jsr print_hex_byte
	jsr print_return

!:
	jmp basic_main_loop
