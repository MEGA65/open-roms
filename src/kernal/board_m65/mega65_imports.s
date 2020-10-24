;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

;; #IMPORT# KERNAL_0 = KERNAL_0_combined.sym

;
; Definitions for calling MEGA65 segment KERNAL_0 routines from KERNAL_1
;

;; #ALIAS# CHROUT                          = KERNAL_0.proxy_K1_CHROUT
;; #ALIAS# STOP                            = KERNAL_0.STOP
;; #ALIAS# M65_MODEGET                     = KERNAL_0.M65_MODEGET
;; #ALIAS# M65_SETWIN_XY                   = KERNAL_0.M65_SETWIN_XY
;; #ALIAS# M65_SETWIN_WH                   = KERNAL_0.M65_SETWIN_WH
;; #ALIAS# M65_SETWIN_N                    = KERNAL_0.M65_SETWIN_N
;; #ALIAS# M65_SETWIN_Y                    = KERNAL_0.M65_SETWIN_Y

;; #ALIAS# map_NORMAL                      = KERNAL_0.map_NORMAL
;; #ALIAS# map_KERNAL_1                    = KERNAL_0.map_KERNAL_1

;; #ALIAS# screen_on                       = KERNAL_0.screen_on
;; #ALIAS# screen_off                      = KERNAL_0.screen_off

;; #ALIAS# hw_entry_reset                  = KERNAL_0.hw_entry_reset
;; #ALIAS# return_from_interrupt           = KERNAL_0.return_from_interrupt
;; #ALIAS# clrchn_reset                    = KERNAL_0.clrchn_reset
;; #ALIAS# udtim_keyboard                  = KERNAL_0.udtim_keyboard
;; #ALIAS# chrout_to_screen_code           = KERNAL_0.chrout_to_screen_code
;; #ALIAS# colour_codes                    = KERNAL_0.colour_codes
;; #ALIAS# screen_check_toggle_quote       = KERNAL_0.screen_check_toggle_quote
;; #ALIAS# screen_code_to_petscii          = KERNAL_0.screen_code_to_petscii

;; #ALIAS# setup_irq_timer                 = KERNAL_0.setup_irq_timer
;; #ALIAS# wait_x_bars                     = KERNAL_0.wait_x_bars
;; #ALIAS# viciv_unhide                    = KERNAL_0.viciv_unhide
;; #ALIAS# viciv_init                      = KERNAL_0.viciv_init
;; #ALIAS# viciv_shutdown                  = KERNAL_0.viciv_shutdown
;; #ALIAS# viciv_hotregs_on                = KERNAL_0.viciv_hotregs_on
;; #ALIAS# viciv_hotregs_off               = KERNAL_0.viciv_hotregs_off

;; #ALIAS# m65_clr_magictstr               = KERNAL_0.m65_clr_magictstr
;; #ALIAS# m65_scrtab_txtwidth             = KERNAL_0.m65_scrtab_txtwidth
;; #ALIAS# m65_scrtab_txtheight            = KERNAL_0.m65_scrtab_txtheight
;; #ALIAS# m65_screen_set_indx             = KERNAL_0.m65_screen_set_indx
;; #ALIAS# cursor_enable                   = KERNAL_0.cursor_enable
;; #ALIAS# cursor_undraw_cont              = KERNAL_0.cursor_undraw_cont
;; #ALIAS# cursor_timer_reset              = KERNAL_0.cursor_timer_reset
;; #ALIAS# cursor_show_if_enabled          = KERNAL_0.cursor_show_if_enabled
;; #ALIAS# chrin_programmable_keys         = KERNAL_0.proxy_K1_chrin_programmable_keys
;; #ALIAS# pop_keyboard_buffer             = KERNAL_0.pop_keyboard_buffer

;; #ALIAS# iec_set_idle                    = KERNAL_0.iec_set_idle

;; #ALIAS# tape_motor_on                   = KERNAL_0.tape_motor_on
;; #ALIAS# tape_motor_off                  = KERNAL_0.tape_motor_off

;; #ALIAS# lvs_display_loading_verifying   = KERNAL_0.proxy_K1_lvs_display_loading_verifying
;; #ALIAS# lvs_display_done                = KERNAL_0.proxy_K1_lvs_display_done
;; #ALIAS# lvs_return_last_address         = KERNAL_0.proxy_K1_lvs_return_last_address
;; #ALIAS# lvs_device_not_found_error      = KERNAL_0.proxy_K1_lvs_device_not_found_error
;; #ALIAS# lvs_load_verify_error           = KERNAL_0.proxy_K1_lvs_load_verify_error
;; #ALIAS# m65_load_autoswitch_tape        = KERNAL_0.proxy_K1_m65_load_autoswitch_tape

;; #ALIAS# lvs_check_EAL                   = KERNAL_0.lvs_check_EAL
;; #ALIAS# lvs_STAL_to_MEMUSS              = KERNAL_0.lvs_STAL_to_MEMUSS

;; #ALIAS# kernalerror_ROUTINE_TERMINATED  = KERNAL_0.proxy_K1_kernalerror_ROUTINE_TERMINATED

;; #ALIAS# print_kernal_message            = KERNAL_0.proxy_K1_print_kernal_message
;; #ALIAS# print_return                    = KERNAL_0.proxy_K1_print_return

;; #ALIAS# __MSG_KERNAL_PRESS_PLAY         = KERNAL_0.__MSG_KERNAL_PRESS_PLAY
;; #ALIAS# __MSG_KERNAL_OK_SEARCH          = KERNAL_0.__MSG_KERNAL_OK_SEARCH
;; #ALIAS# __MSG_KERNAL_FOUND              = KERNAL_0.__MSG_KERNAL_FOUND

;; #ALIAS# tape_normal_byte_store          = KERNAL_0.tape_normal_byte_store

;; #ALIAS# CLALL                           = KERNAL_0.proxy_K1_CLALL
;; #ALIAS# nmi_lock                        = KERNAL_0.nmi_lock
