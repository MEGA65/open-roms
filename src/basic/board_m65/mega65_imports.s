// #LAYOUT# M65 BASIC_1 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Definitions for calling Mega65 segments BASIC_0 and KERNAL_0 routines from BASIC_1
//

#import "BASIC_0_combined.sym"


.label peek_via_OLDTXT                 = BASIC_0.proxy_B1_peek_via_OLDTXT
.label poke_via_OLDTXT                 = BASIC_0.proxy_B1_poke_via_OLDTXT
.label JCHROUT                         = BASIC_0.proxy_B1_JCHROUT
.label JCLALL                          = BASIC_0.proxy_B1_JCLALL
#if CONFIG_DOS_WEDGE
.label JCLOSE                          = BASIC_0.proxy_B1_JCLOSE
.label JOPEN                           = BASIC_0.proxy_B1_JOPEN
#endif
.label JMEMTOP                         = KERNAL_0.JMEMTOP
.label JSETFLS                         = KERNAL_0.JSETFLS
.label JSETNAM                         = KERNAL_0.JSETNAM
.label JGETIN                          = KERNAL_0.JGETIN
.label JCHKIN                          = KERNAL_0.JCHKIN
.label JCHRIN                          = KERNAL_0.JCHRIN
.label JREADST                         = KERNAL_0.JREADST
.label plot_set                        = KERNAL_0.plot_set
.label init_oldtxt                     = BASIC_0.init_oldtxt
.label rom_revision_basic_string       = BASIC_0.rom_revision_basic_string
.label print_integer                   = BASIC_0.proxy_B1_print_integer
.label print_return                    = BASIC_0.proxy_B1_print_return
.label print_space                     = BASIC_0.proxy_B1_print_space
#if CONFIG_SHOW_FEATURES
.label print_features                  = BASIC_0.proxy_B1_print_features
#endif
.label do_error_fetch                  = BASIC_0.do_error_fetch
.label do_basic_error                  = BASIC_0.do_basic_error
.label str_rev_question                = BASIC_0.str_rev_question
#if CONFIG_DOS_WEDGE
.label fetch_character                 = BASIC_0.proxy_B1_fetch_character
.label fetch_character_skip_spaces     = BASIC_0.proxy_B1_fetch_character_skip_spaces
.label fetch_uint8                     = BASIC_0.proxy_B1_fetch_uint8
.label shell_main_loop                 = BASIC_0.proxy_B1_shell_main_loop
#endif
