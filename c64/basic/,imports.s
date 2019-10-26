
// Routines imported from Kernal - our private API

#import "KERNAL_combined.sym"


#if CONFIG_PANIC_SCREEN
.label panic               = KERNAL.panic
#endif

.label hw_entry_reset      = KERNAL.hw_entry_reset

#if CONFIG_DBG_PRINTF
.label printf              = KERNAL.printf
#endif

.label plot_set            = KERNAL.plot_set
.label print_hex_byte      = KERNAL.print_hex_byte
.label print_return        = KERNAL.print_return
.label print_space         = KERNAL.print_space

#if CONFIG_SHOW_PAL_NTSC
.label print_pal_ntsc      = KERNAL.print_pal_ntsc
#endif
