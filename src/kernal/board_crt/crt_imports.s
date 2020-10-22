;; #LAYOUT# CRT KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

;; #IMPORT# KERNAL_0 = KERNAL_0_combined.sym

;
; Definitions for calling cartridge segment KERNAL_0 routines from KERNAL_1
;

;; #ALIAS# STOP                            = KERNAL_0.STOP
;; #ALIAS# IOINIT                          = KERNAL_0.proxy_K1_IOINIT
;; #ALIAS# xxx                             = KERNAL_0.xxx

;; #ALIAS# map_NORMAL                      = KERNAL_0.map_NORMAL
;; #ALIAS# map_KERNAL_1                    = KERNAL_0.map_KERNAL_1

;; #ALIAS# screen_on                       = KERNAL_0.screen_on
;; #ALIAS# screen_off                      = KERNAL_0.screen_off

;; #ALIAS# hw_entry_reset                  = KERNAL_0.hw_entry_reset
;; #ALIAS# return_from_interrupt           = KERNAL_0.return_from_interrupt
;; #ALIAS# udtim_keyboard                  = KERNAL_0.udtim_keyboard
;; #ALIAS# wait_x_bars                     = KERNAL_0.wait_x_bars

;; #ALIAS# tape_motor_on                   = KERNAL_0.tape_motor_on
;; #ALIAS# tape_motor_off                  = KERNAL_0.tape_motor_off

;; #ALIAS# lvs_display_loading_verifying   = KERNAL_0.proxy_K1_lvs_display_loading_verifying
;; #ALIAS# lvs_display_done                = KERNAL_0.proxy_K1_lvs_display_done
;; #ALIAS# lvs_return_last_address         = KERNAL_0.proxy_K1_lvs_return_last_address
;; #ALIAS# lvs_device_not_found_error      = KERNAL_0.proxy_K1_lvs_device_not_found_error
;; #ALIAS# lvs_load_verify_error           = KERNAL_0.proxy_K1_lvs_load_verify_error
;; #ALIAS# lvs_check_EAL                   = KERNAL_0.lvs_check_EAL
;; #ALIAS# lvs_STAL_to_MEMUSS              = KERNAL_0.lvs_STAL_to_MEMUSS
;; #ALIAS# lvs_advance_MEMUSS              = KERNAL_0.lvs_advance_MEMUSS

;; #ALIAS# kernalerror_ROUTINE_TERMINATED  = KERNAL_0.proxy_K1_kernalerror_ROUTINE_TERMINATED

;; #ALIAS# print_kernal_message            = KERNAL_0.proxy_K1_print_kernal_message
;; #ALIAS# print_return                    = KERNAL_0.proxy_K1_print_return

;; #ALIAS# __MSG_KERNAL_PRESS_PLAY         = KERNAL_0.__MSG_KERNAL_PRESS_PLAY
;; #ALIAS# __MSG_KERNAL_OK                 = KERNAL_0.__MSG_KERNAL_OK
;; #ALIAS# __MSG_KERNAL_FOUND              = KERNAL_0.__MSG_KERNAL_FOUND

;; #ALIAS# tape_normal_byte_store          = KERNAL_0.tape_normal_byte_store

;; #ALIAS# CLALL                           = KERNAL_0.proxy_K1_CLALL
;; #ALIAS# nmi_lock                        = KERNAL_0.nmi_lock
