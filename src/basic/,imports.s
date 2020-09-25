;; #LAYOUT# STD *       #TAKE
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

;; #ALIAS# plot_set            = KERNAL_0.plot_set
;; #ALIAS# print_hex_byte      = KERNAL_0.print_hex_byte
;; #ALIAS# print_return        = KERNAL_0.print_return
;; #ALIAS# print_space         = KERNAL_0.print_space

;; #ALIAS# tape_head_align     = KERNAL_0.tape_head_align

;; #ALIAS# filename_any        = KERNAL_0.filename_any

;; #ALIAS# SELDEV              = KERNAL_0.SELDEV

;; #ALIAS# map_end             = KERNAL_0.map_end
;; #ALIAS# map_NORMAL          = KERNAL_0.map_NORMAL

;; #ALIAS# M65_MODEGET         = KERNAL_0.M65_MODEGET
;; #ALIAS# M65_MODESET         = KERNAL_0.M65_MODESET
;; #ALIAS# M65_SLOW            = KERNAL_0.M65_SLOW
;; #ALIAS# M65_FAST            = KERNAL_0.M65_FAST
;; #ALIAS# M65_SETWIN_Y        = KERNAL_0.M65_SETWIN_Y
