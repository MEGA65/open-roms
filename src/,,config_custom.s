
!set CONFIG_ID = $00 ; should be 1 byte, different for each config file!

;
; Please read CONFIG.md before modifying this file!
;

; Idea:
; - configuration for custom builds and for development
; - file contains options to enable unfinished functionalities



; Hardware platform and brand

!set CONFIG_PLATFORM_COMMODORE_64 = 1
!set CONFIG_BRAND_CUSTOM_BUILD    = 1
!macro CONFIG_CUSTOM_BRAND { !pet "custom build" }


; Processor instruction set

!set CONFIG_CPU_MOS_6502   = 1
; !set CONFIG_CPU_DTV_6502   = 1
; !set CONFIG_CPU_RCW_65C02  = 1
; !set CONFIG_CPU_WDC_65C02  = 1
; !set CONFIG_CPU_WDC_65816  = 1
; !set CONFIG_CPU_CSG_65CE02 = 1


; Memory model

; !set CONFIG_MEMORY_MODEL_38K = 1
; !set CONFIG_MEMORY_MODEL_46K = 1
!set CONFIG_MEMORY_MODEL_50K = 1
; !set CONFIG_MEMORY_MODEL_60K = 1


; IEC bus configuration

!set CONFIG_IEC = 1
!set CONFIG_IEC_DOLPHINDOS = 1
!set CONFIG_IEC_DOLPHINDOS_FAST = 1
!set CONFIG_IEC_JIFFYDOS = 1
; !set CONFIG_IEC_JIFFYDOS_BLANK = 1
; !set CONFIG_IEC_BURST_CIA1 = 1                 ; please keep disabled for now
; !set CONFIG_IEC_BURST_CIA2 = 1                 ; please keep disabled for now
 

; Tape deck configuration

!set CONFIG_TAPE_NORMAL = 1
!set CONFIG_TAPE_TURBO = 1
!set CONFIG_TAPE_AUTODETECT = 1
; !set CONFIG_TAPE_NO_KEY_SENSE = 1
; !set CONFIG_TAPE_NO_MOTOR_CONTROL = 1


; RS-232 configuration

; !set CONFIG_RS232_ACIA = 1                     ; please keep disabled for now
; !set CONFIG_RS232_UP2400 = 1                   ; please keep disabled for now
; !set CONFIG_RS232_UP9600 = 1                   ; please keep disabled for now


; Sound support

; !set CONFIG_SID_2ND_ADDRESS = $D420
; !set CONFIG_SID_3RD_ADDRESS = $D440
; !set CONFIG_SID_D4XX = 1
; !set CONFIG_SID_D5XX = 1


; Keyboard settings

; !set CONFIG_LEGACY_SCNKEY = 1
; !set CONFIG_KEYBOARD_C128 = 1
; !set CONFIG_KEYBOARD_C128_CAPS_LOCK = 1
; !set CONFIG_KEYBOARD_C65 = 1              ; untested
; !set CONFIG_KEYBOARD_C65_CAPS_LOCK = 1    ; untested
; !set CONFIG_KEY_REPEAT_DEFAULT = 1
; !set CONFIG_KEY_REPEAT_ALWAYS = 1
!set CONFIG_KEY_FAST_SCAN = 1
; !set CONFIG_JOY1_CURSOR = 1
; !set CONFIG_JOY2_CURSOR = 1

!set CONFIG_PROGRAMMABLE_KEYS = 1

!set   CONFIG_KEYCMD_RUN = 1
!macro CONFIG_KEYCMD_RUN  {
	!byte $5F
	!pet "l"
}

!set   CONFIG_KEYCMD_F1 = 1
!macro CONFIG_KEYCMD_F1   { !pet "@" }
; !set   CONFIG_KEYCMD_F2 = 1
; !macro CONFIG_KEYCMD_F2   { !pet "" }
!set   CONFIG_KEYCMD_F3 = 1
!macro CONFIG_KEYCMD_F3   { !pet "run:" }
; !set   CONFIG_KEYCMD_F4 = 1
; !macro CONFIG_KEYCMD_F4   { !pet "" }
!set   CONFIG_KEYCMD_F5 = 1
!macro CONFIG_KEYCMD_F5   { !pet "load" }
; !set   CONFIG_KEYCMD_F6 = 1
; !macro CONFIG_KEYCMD_F6   { !pet "" }
!set   CONFIG_KEYCMD_F7 = 1
!macro CONFIG_KEYCMD_F7   { !pet "@$" }
; !set   CONFIG_KEYCMD_F8 = 1
; !macro CONFIG_KEYCMD_F8   { !pet "" }

!set   CONFIG_KEYCMD_HELP = 1
!macro CONFIG_KEYCMD_HELP { !pet "list" }

; !set   CONFIG_KEYCMD_F9 = 1
; !macro CONFIG_KEYCMD_F9   { !pet "" }
; !set   CONFIG_KEYCMD_F10 = 1
; !macro CONFIG_KEYCMD_F10  { !pet "" }
; !set   CONFIG_KEYCMD_F11 = 1
; !macro CONFIG_KEYCMD_F11  { !pet "" }
; !set   CONFIG_KEYCMD_F12 = 1
; !macro CONFIG_KEYCMD_F12  { !pet "" }
; !set   CONFIG_KEYCMD_F13 = 1
; !macro CONFIG_KEYCMD_F13  { !pet "" }
; !set   CONFIG_KEYCMD_F14 = 1
; !macro CONFIG_KEYCMD_F14  { !pet "" }


; Screen editor

!set CONFIG_EDIT_STOPQUOTE = 1
; !set CONFIG_EDIT_TABULATORS = 1


; Software features

!set CONFIG_PANIC_SCREEN = 1
!set CONFIG_DOS_WEDGE = 1
!set CONFIG_TAPE_WEDGE = 1
; !set CONFIG_TAPE_HEAD_ALIGN = 1
!set CONFIG_BCD_SAFE_INTERRUPTS = 1

; Eye candy

; !set CONFIG_COLORS_BRAND = 1
; !set CONFIG_BANNER_SIMPLE = 1
!set CONFIG_BANNER_FANCY = 1
!set CONFIG_SHOW_FEATURES = 1


; Debug options

; !set CONFIG_DBG_STUBS_BRK = 1
; !set CONFIG_DBG_PRINTF = 1

; Other

; !set CONFIG_COMPRESSION_LVL_2 = 1
