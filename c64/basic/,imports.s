
// Routines imported from Kernal - our private API

#import "KERNAL_combined.sym"


#if CONFIG_DBG_PRINTF
.label printf              = KERNAL.printf
#endif

.label print_hex_byte      = KERNAL.print_hex_byte
.label print_return        = KERNAL.print_return
.label print_space         = KERNAL.print_space
