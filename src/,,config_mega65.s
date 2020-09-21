
;; #CONFIG# ID $02 ; should be 1 byte, different for each config file!

;
; Please read CONFIG.md before modifying this file!
;

; Idea:
; - sane defaults for the MEGA65 FPGA computer
; - do not enable features which are a significant compatibility risk



; Hardware platform

;; #CONFIG# PLATFORM_COMMODORE_64      YES
;; #CONFIG# MB_M65                     YES


; Memory model

;; #CONFIG# MEMORY_MODEL_38K           NO
;; #CONFIG# MEMORY_MODEL_46K           NO
;; #CONFIG# MEMORY_MODEL_50K           YES


; IEC bus configuration

;; #CONFIG# IEC                        YES
;; #CONFIG# IEC_DOLPHINDOS             NO
;; #CONFIG# IEC_DOLPHINDOS_FAST        NO
;; #CONFIG# IEC_JIFFYDOS               YES
;; #CONFIG# IEC_JIFFYDOS_BLANK         YES
;; #CONFIG# IEC_BURST_M65              NO        ; please keep disabled for now


; Tape deck configuration

;; #CONFIG# TAPE_NORMAL                YES
;; #CONFIG# TAPE_TURBO                 YES
;; #CONFIG# TAPE_AUTODETECT            YES
;; #CONFIG# TAPE_NO_KEY_SENSE          YES
;; #CONFIG# TAPE_NO_MOTOR_CONTROL      YES


; Keyboard settings

;; #CONFIG# LEGACY_SCNKEY              NO
;; #CONFIG# KEYBOARD_C65               NO        ; untested
;; #CONFIG# KEYBOARD_C65_CAPS_LOCK     NO        ; untested
;; #CONFIG# KEY_REPEAT_DEFAULT         NO
;; #CONFIG# KEY_REPEAT_ALWAYS          NO
;; #CONFIG# KEY_FAST_SCAN              YES
;; #CONFIG# JOY1_CURSOR                YES
;; #CONFIG# JOY2_CURSOR                YES

;; #CONFIG# PROGRAMMABLE_KEYS          YES

;; #CONFIG# KEYCMD_RUN                 YES
!macro CONFIG_KEYCMD_RUN  {
	!byte $5F
	!pet "l" }

;; #CONFIG# KEYCMD_F1                  YES
!macro CONFIG_KEYCMD_F1   { !pet "@" }
;; #CONFIG# KEYCMD_F2                  NO
; !macro CONFIG_KEYCMD_F2   { !pet "" }
;; #CONFIG# KEYCMD_F3                  YES
!macro CONFIG_KEYCMD_F3   { !pet "run:" }
;; #CONFIG# KEYCMD_F4                  NO
; !macro CONFIG_KEYCMD_F4   { !pet "" }
;; #CONFIG# KEYCMD_F5                  YES
!macro CONFIG_KEYCMD_F5   { !pet "load" }
;; #CONFIG# KEYCMD_F6                  NO
; !macro CONFIG_KEYCMD_F6   { !pet "" }
;; #CONFIG# KEYCMD_F7                  YES
!macro CONFIG_KEYCMD_F7   { !pet "@$" }
;; #CONFIG# KEYCMD_F8                  NO
; !macro CONFIG_KEYCMD_F8   { !pet "" }

;; #CONFIG# KEYCMD_HELP                YES
!macro CONFIG_KEYCMD_HELP { !pet "list" }

;; #CONFIG# KEYCMD_F9                  YES
!macro CONFIG_KEYCMD_F9   { !pet "rem f9" }
;; #CONFIG# KEYCMD_F10                 YES
!macro CONFIG_KEYCMD_F10  { !pet "rem f10" }
;; #CONFIG# KEYCMD_F11                 YES
!macro CONFIG_KEYCMD_F11  { !pet "rem f11" }
;; #CONFIG# KEYCMD_F12                 YES
!macro CONFIG_KEYCMD_F12  { !pet "rem f12" }
;; #CONFIG# KEYCMD_F13                 YES
!macro CONFIG_KEYCMD_F13  { !pet "rem f13" }
;; #CONFIG# KEYCMD_F14                 YES
!macro CONFIG_KEYCMD_F14  { !pet "rem f14" }


; Screen editor

;; #CONFIG# EDIT_STOPQUOTE             YES
;; #CONFIG# EDIT_TABULATORS            NO


; Software features

;; #CONFIG# PANIC_SCREEN               YES
;; #CONFIG# DOS_WEDGE                  YES
;; #CONFIG# TAPE_WEDGE                 YES
;; #CONFIG# TAPE_HEAD_ALIGN            YES
;; #CONFIG# BCD_SAFE_INTERRUPTS        YES


; Built-in DOS configuration

!set CONFIG_UNIT_SDCARD  = 0 ; do not change, DOS is not implemented yet
!set CONFIG_UNIT_FLOPPY  = 0 ; do not change, DOS is not implemented yet
!set CONFIG_UNIT_RAMDISK = 0 ; do not change, DOS is not implemented yet


; Debug options

;; #CONFIG# DBG_STUBS_BRK              NO
;; #CONFIG# DBG_PRINTF                 NO


; Other

;; #CONFIG# COMPRESSION_LVL_2          NO
