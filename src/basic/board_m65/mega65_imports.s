;; #LAYOUT# M65 BASIC_1 #TAKE
;; #LAYOUT# *   *       #IGNORE

;; #IMPORT# BASIC_0  = BASIC_0_combined.sym
;; #IMPORT# KERNAL_0 = KERNAL_0_combined.sym

;
; Definitions for calling MEGA65 segments BASIC_0 and KERNAL_0 routines from BASIC_1
;

;; #ALIAS# peek_via_OLDTXT                 = BASIC_0.proxy_B1_peek_via_OLDTXT
;; #ALIAS# poke_via_OLDTXT                 = BASIC_0.proxy_B1_poke_via_OLDTXT
;; #ALIAS# JCHROUT                         = BASIC_0.proxy_B1_JCHROUT
;; #ALIAS# JCLALL                          = BASIC_0.proxy_B1_JCLALL
;; #ALIAS# plot_set                        = BASIC_0.proxy_B1_plot_set

;; #ALIAS# JCLOSE                          = BASIC_0.proxy_B1_JCLOSE
;; #ALIAS# JOPEN                           = BASIC_0.proxy_B1_JOPEN
;; #ALIAS# JMEMTOP                         = KERNAL_0.JMEMTOP
;; #ALIAS# JSETFLS                         = KERNAL_0.JSETFLS
;; #ALIAS# JSETNAM                         = KERNAL_0.JSETNAM
;; #ALIAS# JGETIN                          = KERNAL_0.JGETIN
;; #ALIAS# JCHKIN                          = BASIC_0.proxy_B1_JCHKIN
;; #ALIAS# JCHRIN                          = BASIC_0.proxy_B1_JCHRIN
;; #ALIAS# JREADST                         = KERNAL_0.JREADST
;; #ALIAS# JSCREEN                         = KERNAL_0.JSCREEN
;; #ALIAS# SELDEV                          = KERNAL_0.SELDEV
;; #ALIAS# M65_MODEGET                     = KERNAL_0.M65_MODEGET
;; #ALIAS# M65_SETWIN_XY                   = KERNAL_0.M65_SETWIN_XY
;; #ALIAS# M65_SETWIN_WH                   = KERNAL_0.M65_SETWIN_WH
;; #ALIAS# M65_SETWIN_Y                    = BASIC_0.proxy_B1_M65_SETWIN_Y
;; #ALIAS# M65_SETWIN_N                    = KERNAL_0.M65_SETWIN_N
;; #ALIAS# init_oldtxt                     = BASIC_0.init_oldtxt
;; #ALIAS# tmpstr_free_all_reset           = BASIC_0.tmpstr_free_all_reset
;; #ALIAS# rom_revision_basic_string       = BASIC_0.rom_revision_basic_string
;; #ALIAS# print_hex_byte                  = BASIC_0.proxy_B1_print_hex_byte
;; #ALIAS# print_integer                   = BASIC_0.proxy_B1_print_integer
;; #ALIAS# print_return                    = BASIC_0.proxy_B1_print_return
;; #ALIAS# print_space                     = BASIC_0.proxy_B1_print_space
;; #ALIAS# print_features                  = BASIC_0.proxy_B1_print_features
;; #ALIAS# do_error_fetch                  = BASIC_0.do_error_fetch
;; #ALIAS# do_basic_error                  = BASIC_0.do_basic_error
;; #ALIAS# str_rev_question                = BASIC_0.str_rev_question
;; #ALIAS# do_error_print_only             = BASIC_0.proxy_B1_do_error_print_only
;; #ALIAS# fetch_character                 = BASIC_0.proxy_B1_fetch_character
;; #ALIAS# fetch_character_skip_spaces     = BASIC_0.proxy_B1_fetch_character_skip_spaces
;; #ALIAS# fetch_uint8                     = BASIC_0.proxy_B1_fetch_uint8
;; #ALIAS# shell_main_loop                 = BASIC_0.proxy_B1_shell_main_loop
