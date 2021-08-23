;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# CRT BASIC_0 #TAKE
;; #LAYOUT# M65 BASIC_0 #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   *       #IGNORE

;; #IMPORT# KERNAL_0 = KERNAL_combined.sym KERNAL_0_combined.sym

;
; Routines imported from Kernal - our private API
;

;; #ALIAS# panic               = KERNAL_0.panic

;; #ALIAS# vector_reset        = KERNAL_0.vector_reset
;; #ALIAS# hw_entry_reset      = KERNAL_0.hw_entry_reset

;; #ALIAS# clear_screen        = KERNAL_0.clear_screen

;; #ALIAS# printf              = KERNAL_0.printf
;; #ALIAS# PRIMM               = KERNAL_0.PRIMM
;; #ALIAS# MONITOR             = KERNAL_0.MONITOR
;; #ALIAS# BOOTCPM             = KERNAL_0.BOOTCPM

;; #ALIAS# plot_set            = KERNAL_0.plot_set
;; #ALIAS# print_hex_byte      = KERNAL_0.print_hex_byte
;; #ALIAS# print_return        = KERNAL_0.print_return
;; #ALIAS# print_space         = KERNAL_0.print_space

;; #ALIAS# tape_head_align     = KERNAL_0.tape_head_align

;; #ALIAS# filename_any        = KERNAL_0.filename_any

;; #ALIAS# SELDEV              = KERNAL_0.SELDEV

;
; MEGA65 specific parts
;

;; #ALIAS# map_end             = KERNAL_0.map_end
;; #ALIAS# map_NORMAL          = KERNAL_0.map_NORMAL
;; #ALIAS# map_BASIC_1         = KERNAL_0.map_BASIC_1
;; #ALIAS# map_MON_1           = KERNAL_0.map_MON_1

;; #ALIAS# M65_MODEGET         = KERNAL_0.M65_MODEGET
;; #ALIAS# M65_MODESET         = KERNAL_0.M65_MODESET
;; #ALIAS# M65_SETWIN_Y        = KERNAL_0.M65_SETWIN_Y

;; #ALIAS# m65_colorset        = KERNAL_0.m65_colorset
;; #ALIAS# m65_shadow_BZP      = KERNAL_0.m65_shadow_BZP
;; #ALIAS# proxy_M1_IO_end     = KERNAL_0.proxy_M1_IO_end

;; #ALIAS# m65dos_rdchk        = KERNAL_0.m65dos_rdchk
;; #ALIAS# m65dos_unitnum      = KERNAL_0.m65dos_unitnum

;
; Ultimate 64 specific parts
;

;; #ALIAS# U64_SLOW            = KERNAL_0.U64_SLOW
;; #ALIAS# U64_FAST            = KERNAL_0.U64_FAST
