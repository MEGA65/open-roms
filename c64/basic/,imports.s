
// Routines imported from Kernal - our private API

#import "KERNAL_combined.sym"


.label panic_vector        = KERNAL.panic_vector
.label rom_revision_kernal = KERNAL.rom_revision_kernal

#if CONFIG_DBG_PRINTF
.label printf              = KERNAL.printf
#endif

.label print_hex_byte      = KERNAL.print_hex_byte
.label print_return        = KERNAL.print_return
.label print_space         = KERNAL.print_space

#if CONFIG_BANNER_PAL_NTSC
.label print_pal_ntsc      = KERNAL.print_pal_ntsc
#endif
