
;; #CONFIG# ID $00 ; should be 1 byte, different for each config file!

;
; Please read CONFIG.md before modifying this file!
;

; Idea:
; - configuration for custom builds and for development
; - file contains options to enable unfinished functionalities



; --- Hardware platform and brand

;; #CONFIG# PLATFORM_COMMODORE_64      YES
;; #CONFIG# BRAND_CUSTOM               "CUSTOM BUILD"


; --- Processor instruction set

;; #CONFIG# CPU_MOS_6502               YES
;; #CONFIG# CPU_DTV_6502               NO
;; #CONFIG# CPU_RCW_65C02              NO
;; #CONFIG# CPU_WDC_65C02              NO
;; #CONFIG# CPU_WDC_65816              NO
;; #CONFIG# CPU_CSG_65CE02             NO


; --- Memory model

;; #CONFIG# MEMORY_MODEL_38K           NO
;; #CONFIG# MEMORY_MODEL_46K           NO
;; #CONFIG# MEMORY_MODEL_50K           YES
;; #CONFIG# MEMORY_MODEL_60K           NO


; --- IEC bus configuration

;; #CONFIG# IEC                        YES
;; #CONFIG# IEC_DOLPHINDOS             YES
;; #CONFIG# IEC_DOLPHINDOS_FAST        NO
;; #CONFIG# IEC_JIFFYDOS               YES
;; #CONFIG# IEC_JIFFYDOS_BLANK         NO
;; #CONFIG# IEC_BURST_CIA1             NO        ; please keep disabled for now
;; #CONFIG# IEC_BURST_CIA2             NO        ; please keep disabled for now
 
;; #CONFIG# IEC_JD_TEST                NO        ; temporary setting, for JiffyDOS development


; --- Tape deck configuration

;; #CONFIG# TAPE_NORMAL                YES
;; #CONFIG# TAPE_TURBO                 YES
;; #CONFIG# TAPE_AUTODETECT            YES
;; #CONFIG# TAPE_NO_KEY_SENSE          NO
;; #CONFIG# TAPE_NO_MOTOR_CONTROL      NO


; --- RS-232 configuration

;; #CONFIG# RS232_ACIA                 NO        ; please keep disabled for now
;; #CONFIG# RS232_UP2400               NO        ; please keep disabled for now
;; #CONFIG# RS232_UP9600               NO        ; please keep disabled for now


; --- Sound support

;; #CONFIG# SID_2ND_ADDRESS            NO
;; #CONFIG# SID_3RD_ADDRESS            NO
;; #CONFIG# SID_D4XX                   NO
;; #CONFIG# SID_D5XX                   NO
;; #CONFIG# SID_D6XX                   NO
;; #CONFIG# SID_D7XX                   NO


; --- Keyboard settings

;; #CONFIG# LEGACY_SCNKEY              NO
;; #CONFIG# KEYBOARD_C128              NO
;; #CONFIG# KEYBOARD_C128_CAPS_LOCK    NO
;; #CONFIG# KEY_REPEAT_DEFAULT         NO
;; #CONFIG# KEY_REPEAT_ALWAYS          NO
;; #CONFIG# KEY_FAST_SCAN              YES
;; #CONFIG# JOY1_CURSOR                NO
;; #CONFIG# JOY2_CURSOR                NO

;; #CONFIG# PROGRAMMABLE_KEYS          YES

;; #CONFIG# KEYCMD_RUN                 "\5FL"

;; #CONFIG# KEYCMD_F1                  "@8$"
;; #CONFIG# KEYCMD_F2                  "LOAD"
;; #CONFIG# KEYCMD_F3                  "@9$"
;; #CONFIG# KEYCMD_F4                  "RUN:"
;; #CONFIG# KEYCMD_F5                  "@10$"
;; #CONFIG# KEYCMD_F6                  NO
;; #CONFIG# KEYCMD_F7                  "@11$"
;; #CONFIG# KEYCMD_F8                  NO

;; #CONFIG# KEYCMD_HELP                "LIST"


; --- Screen editor

;; #CONFIG# EDIT_STOPQUOTE             YES


; --- Software features

;; #CONFIG# PANIC_SCREEN               YES
;; #CONFIG# DOS_WEDGE                  YES
;; #CONFIG# TAPE_WEDGE                 YES
;; #CONFIG# TAPE_HEAD_ALIGN            NO
;; #CONFIG# BCD_SAFE_INTERRUPTS        YES


; --- Eye candy

;; #CONFIG# COLORS_BRAND               NO
;; #CONFIG# BANNER_SIMPLE              NO
;; #CONFIG# BANNER_FANCY               YES
;; #CONFIG# SHOW_FEATURES              YES


; --- Debug options

;; #CONFIG# DBG_STUBS_BRK              NO
;; #CONFIG# DBG_PRINTF                 NO


; --- Other

;; #CONFIG# COMPRESSION_LVL_2          NO
