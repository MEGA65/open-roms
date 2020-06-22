// #LAYOUT# STD *       #TAKE
// #LAYOUT# M65 BASIC_1 #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Print configured features and current video system on startup banner
//

#if CONFIG_SHOW_FEATURES

print_features:

	ldx #IDX__STR_FEATURES
	jsr print_packed_misc_str

	// FALLTROUGH

print_pal_ntsc:

	ldx #IDX__STR_NTSC
	lda TVSFLG
	beq !+
	ldx #IDX__STR_PAL
!:
	jmp print_packed_misc_str

#endif // CONFIG_SHOW_FEATURES
