// #LAYOUT# STD *       #TAKE
// #LAYOUT# M65 BASIC_0 #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
// #LAYOUT# *   *       #IGNORE


// Routines imported from Kernal - our private API

#if ROM_LAYOUT_STD
	#import "KERNAL_combined.sym"
#else
	#import "KERNAL_0_combined.sym"
#endif


.function KERNAL()
{
#if ROM_LAYOUT_STD
	.return KERNAL
#else
	.return KERNAL_0
#endif
}


#if ROM_LAYOUT_M65
.label map_end             = KERNAL().map_end
.label map_NORMAL          = KERNAL().map_NORMAL
#endif

#if CONFIG_PANIC_SCREEN
.label panic               = KERNAL().panic
#endif

.label vector_reset        = KERNAL().vector_reset
.label hw_entry_reset      = KERNAL().hw_entry_reset

.label clear_screen        = KERNAL().clear_screen
.label M65_SETWIN_Y        = KERNAL().M65_SETWIN_Y

#if CONFIG_DBG_PRINTF
.label printf              = KERNAL().printf
#endif

.label plot_set            = KERNAL().plot_set
.label print_hex_byte      = KERNAL().print_hex_byte
.label print_return        = KERNAL().print_return
.label print_space         = KERNAL().print_space

#if CONFIG_TAPE_HEAD_ALIGN
.label tape_head_align     = KERNAL().tape_head_align
#endif

.label filename_any        = KERNAL().filename_any

.label SELDEV              = KERNAL().SELDEV

#if ROM_LAYOUT_M65
.label M65_MODE64          = KERNAL().M65_MODE64
.label M65_MODE65          = KERNAL().M65_MODE65
.label M65_ISMODE65        = KERNAL().M65_ISMODE65
.label M65_SLOW            = KERNAL().M65_SLOW
.label M65_FAST            = KERNAL().M65_FAST
#endif
