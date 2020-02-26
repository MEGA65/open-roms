// #LAYOUT# M65 BASIC_1 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Definitions for calling Mega65 segments BASIC_0 and KERNAL_0 routines from BASIC_1
//

#import "BASIC_0_combined.sym"


.label peek_under_roms                 = BASIC_0.proxy_B1_peek_under_roms
.label JCHROUT                         = BASIC_0.proxy_B1_JCHROUT
.label plot_set                        = KERNAL_0.plot_set
.label basic_do_new                    = BASIC_0.proxy_B1_basic_do_new
.label rom_revision_basic_string       = BASIC_0.rom_revision_basic_string
.label print_integer                   = BASIC_0.proxy_B1_print_integer
.label print_return                    = BASIC_0.proxy_B1_print_return
.label print_space                     = BASIC_0.proxy_B1_print_space
#if CONFIG_SHOW_PAL_NTSC
.label print_pal_ntsc                  = BASIC_0.proxy_B1_print_pal_ntsc
#endif
#if CONFIG_SHOW_FEATURES
.label print_features                  = BASIC_0.proxy_B1_print_features
#endif
.label do_STRING_TOO_LONG_error        = BASIC_0.do_STRING_TOO_LONG_error
