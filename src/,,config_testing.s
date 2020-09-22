
;; #CONFIG# ID $F0 ; should be 1 byte, different for each config file!

;
; Please read CONFIG.md before modifying this file!
;

; Idea:
; - enable compatibility-risky features
; - enable code not normally used - to make sure they still compile



; --- Hardware platform and brand

;; #CONFIG# PLATFORM_COMMODORE_64      YES
;; #CONFIG# BRAND_TESTING              YES


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
;; #CONFIG# MEMORY_MODEL_50K           NO
;; #CONFIG# MEMORY_MODEL_60K           YES


; --- IEC bus configuration

;; #CONFIG# IEC                        YES
;; #CONFIG# IEC_DOLPHINDOS             YES
;; #CONFIG# IEC_DOLPHINDOS_FAST        NO
;; #CONFIG# IEC_JIFFYDOS               YES
;; #CONFIG# IEC_JIFFYDOS_BLANK         NO


; --- Tape deck configuration

;; #CONFIG# TAPE_NORMAL                NO
;; #CONFIG# TAPE_TURBO                 YES
;; #CONFIG# TAPE_AUTODETECT            NO
;; #CONFIG# TAPE_NO_KEY_SENSE          NO
;; #CONFIG# TAPE_NO_MOTOR_CONTROL      NO


; --- Sound support

;; #CONFIG# SID_2ND_ADDRESS            NO
;; #CONFIG# SID_3RD_ADDRESS            NO
;; #CONFIG# SID_D4XX                   NO
;; #CONFIG# SID_D5XX                   NO
;; #CONFIG# SID_D6XX                   NO
;; #CONFIG# SID_D7XX                   NO


; --- Keyboard settings

;; #CONFIG# LEGACY_SCNKEY              YES
;; #CONFIG# KEYBOARD_C128              NO
;; #CONFIG# KEYBOARD_C128_CAPS_LOCK    NO
;; #CONFIG# KEY_REPEAT_DEFAULT         NO
;; #CONFIG# KEY_REPEAT_ALWAYS          NO
;; #CONFIG# KEY_FAST_SCAN              YES
;; #CONFIG# JOY1_CURSOR                YES
;; #CONFIG# JOY2_CURSOR                YES

;; #CONFIG# PROGRAMMABLE_KEYS          YES

;; #CONFIG# KEYCMD_RUN                 YES
!macro CONFIG_KEYCMD_RUN  {
	!byte $5F
	!pet "l"
}

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

;; #CONFIG# KEYCMD_F9                  NO
;; #CONFIG# KEYCMD_F10                 NO
;; #CONFIG# KEYCMD_F11                 NO
;; #CONFIG# KEYCMD_F12                 NO
;; #CONFIG# KEYCMD_F13                 NO
;; #CONFIG# KEYCMD_F14                 NO


; --- Screen editor

;; #CONFIG# EDIT_STOPQUOTE             YES
;; #CONFIG# EDIT_TABULATORS            YES


; --- Software features

;; #CONFIG# PANIC_SCREEN               YES
;; #CONFIG# DOS_WEDGE                  YES
;; #CONFIG# TAPE_WEDGE                 YES
;; #CONFIG# TAPE_HEAD_ALIGN            NO
;; #CONFIG# BCD_SAFE_INTERRUPTS        YES


; --- Eye candy

;; #CONFIG# COLORS_BRAND               NO
;; #CONFIG# BANNER_SIMPLE              YES
;; #CONFIG# BANNER_FANCY               NO
;; #CONFIG# SHOW_FEATURES              YES


; --- Debug options

;; #CONFIG# DBG_STUBS_BRK              NO
;; #CONFIG# DBG_PRINTF                 YES


; --- Other

;; #CONFIG# COMPRESSION_LVL_2          NO
