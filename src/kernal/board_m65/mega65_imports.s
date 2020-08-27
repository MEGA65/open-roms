// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Definitions for calling Mega65 segment KERNAL_0 routines from KERNAL_1
//

#import "KERNAL_0_combined.sym"


.label CHROUT                          = KERNAL_0.proxy_K1_CHROUT
.label STOP                            = KERNAL_0.STOP
.label M65_SLOW                        = KERNAL_0.M65_SLOW
.label M65_FAST                        = KERNAL_0.M65_FAST
.label M65_ISMODE65                    = KERNAL_0.M65_ISMODE65
.label M65_SETWIN_XY                   = KERNAL_0.M65_SETWIN_XY
.label M65_SETWIN_WH                   = KERNAL_0.M65_SETWIN_WH
.label M65_SETWIN_N                    = KERNAL_0.M65_SETWIN_N
.label M65_SETWIN_Y                    = KERNAL_0.M65_SETWIN_Y


#if (CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO) || (CONFIG_IEC_JIFFYDOS && !CONFIG_MEMORY_MODEL_60K)
.label screen_on                       = KERNAL_0.screen_on
.label screen_off                      = KERNAL_0.screen_off
#endif

.label hw_entry_reset                  = KERNAL_0.hw_entry_reset
.label return_from_interrupt           = KERNAL_0.return_from_interrupt
.label clrchn_reset                    = KERNAL_0.clrchn_reset
.label udtim_keyboard                  = KERNAL_0.udtim_keyboard
.label chrout_to_screen_code           = KERNAL_0.chrout_to_screen_code
.label colour_codes                    = KERNAL_0.colour_codes
.label screen_check_toggle_quote       = KERNAL_0.screen_check_toggle_quote
.label screen_code_to_petscii          = KERNAL_0.screen_code_to_petscii

.label setup_irq_timer                 = KERNAL_0.setup_irq_timer
.label wait_x_bars                     = KERNAL_0.wait_x_bars
.label viciv_unhide                    = KERNAL_0.viciv_unhide

.label m65_scrtab_txtwidth             = KERNAL_0.m65_scrtab_txtwidth
.label m65_scrtab_txtheight            = KERNAL_0.m65_scrtab_txtheight
.label m65_screen_set_indx             = KERNAL_0.m65_screen_set_indx
.label cursor_enable                   = KERNAL_0.cursor_enable
.label cursor_undraw_cont              = KERNAL_0.cursor_undraw_cont
.label cursor_timer_reset              = KERNAL_0.cursor_timer_reset
.label cursor_show_if_enabled          = KERNAL_0.cursor_show_if_enabled
.label chrin_programmable_keys         = KERNAL_0.proxy_K1_chrin_programmable_keys
.label pop_keyboard_buffer             = KERNAL_0.pop_keyboard_buffer

#if CONFIG_IEC

.label iec_set_idle                    = KERNAL_0.iec_set_idle

#endif


#if CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO

.label tape_motor_on                   = KERNAL_0.tape_motor_on
.label tape_motor_off                  = KERNAL_0.tape_motor_off

.label lvs_display_loading_verifying   = KERNAL_0.proxy_K1_lvs_display_loading_verifying
.label lvs_display_done                = KERNAL_0.proxy_K1_lvs_display_done
.label lvs_return_last_address         = KERNAL_0.proxy_K1_lvs_return_last_address
.label lvs_device_not_found_error      = KERNAL_0.proxy_K1_lvs_device_not_found_error
.label lvs_load_verify_error           = KERNAL_0.proxy_K1_lvs_load_verify_error

.label lvs_check_EAL                   = KERNAL_0.lvs_check_EAL
.label lvs_STAL_to_MEMUSS              = KERNAL_0.lvs_STAL_to_MEMUSS

.label kernalerror_ROUTINE_TERMINATED  = KERNAL_0.proxy_K1_kernalerror_ROUTINE_TERMINATED

.label print_kernal_message            = KERNAL_0.proxy_K1_print_kernal_message
.label print_return                    = KERNAL_0.proxy_K1_print_return

.label __MSG_KERNAL_PRESS_PLAY         = KERNAL_0.__MSG_KERNAL_PRESS_PLAY
.label __MSG_KERNAL_OK_SEARCHING       = KERNAL_0.__MSG_KERNAL_OK_SEARCHING
.label __MSG_KERNAL_FOUND              = KERNAL_0.__MSG_KERNAL_FOUND

#endif


#if CONFIG_TAPE_NORMAL

.label tape_normal_byte_store          = KERNAL_0.tape_normal_byte_store

#endif


#if CONFIG_TAPE_HEAD_ALIGN

.label CLALL                           = KERNAL_0.proxy_K1_CLALL
.label nmi_lock                        = KERNAL_0.nmi_lock

#endif
