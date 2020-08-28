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
.label plot_set                        = BASIC_0.proxy_B1_plot_set
#if CONFIG_DOS_WEDGE
.label JCLOSE                          = BASIC_0.proxy_B1_JCLOSE
.label JOPEN                           = BASIC_0.proxy_B1_JOPEN
#endif
.label JMEMTOP                         = KERNAL_0.JMEMTOP
.label JSETFLS                         = KERNAL_0.JSETFLS
.label JSETNAM                         = KERNAL_0.JSETNAM
.label JGETIN                          = KERNAL_0.JGETIN
.label JCHKIN                          = BASIC_0.proxy_B1_JCHKIN
.label JCHRIN                          = BASIC_0.proxy_B1_JCHRIN
.label JREADST                         = KERNAL_0.JREADST
.label JSCREEN                         = KERNAL_0.JSCREEN
.label SELDEV                          = KERNAL_0.SELDEV
.label M65_ISMODE65                    = KERNAL_0.M65_ISMODE65
.label M65_SETWIN_XY                   = KERNAL_0.M65_SETWIN_XY
.label M65_SETWIN_WH                   = KERNAL_0.M65_SETWIN_WH
.label M65_SETWIN_Y                    = BASIC_0.proxy_B1_M65_SETWIN_Y
.label M65_SETWIN_N                    = KERNAL_0.M65_SETWIN_N
.label init_oldtxt                     = BASIC_0.init_oldtxt
.label tmpstr_free_all_reset           = BASIC_0.tmpstr_free_all_reset
.label rom_revision_basic_string       = BASIC_0.rom_revision_basic_string
.label print_hex_byte                  = BASIC_0.proxy_B1_print_hex_byte
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
