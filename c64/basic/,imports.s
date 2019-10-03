
// Routines imported from Kernal - our private API

#import "KERNAL_combined.sym"


#if CONFIG_DBG_PRINTF
.label printf              = KERNAL.printf
#endif

.label print_hex_byte      = KERNAL.print_hex_byte
