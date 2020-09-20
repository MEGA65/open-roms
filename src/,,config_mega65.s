
!set CONFIG_ID = $02 ; should be 1 byte, different for each config file!

;
; Please read CONFIG.md before modifying this file!
;

; Idea:
; - sane defaults for the Mega 65 FPGA computer
; - do not enable features which are a significant compatibility risk



; Hardware platform

!set CONFIG_PLATFORM_COMMODORE_64 = 1
!set CONFIG_MB_M65                = 1


; Memory model

; !set CONFIG_MEMORY_MODEL_38K = 1
; !set CONFIG_MEMORY_MODEL_46K = 1
!set CONFIG_MEMORY_MODEL_50K = 1


; IEC bus configuration

!set CONFIG_IEC = 1
; !set CONFIG_IEC_DOLPHINDOS = 1
; !set CONFIG_IEC_DOLPHINDOS_FAST = 1
!set CONFIG_IEC_JIFFYDOS = 1
!set CONFIG_IEC_JIFFYDOS_BLANK = 1
; !set CONFIG_IEC_BURST_M65 = 1               ; please keep disabled for now


; Tape deck configuration

!set CONFIG_TAPE_NORMAL = 1
!set CONFIG_TAPE_TURBO = 1
!set CONFIG_TAPE_AUTODETECT = 1
!set CONFIG_TAPE_NO_KEY_SENSE = 1
!set CONFIG_TAPE_NO_MOTOR_CONTROL = 1


; Keyboard settings

; !set CONFIG_LEGACY_SCNKEY = 1
; !set CONFIG_KEYBOARD_C128 = 1
; !set CONFIG_KEYBOARD_C128_CAPS_LOCK = 1
; !set CONFIG_KEYBOARD_C65 = 1              ; untested
; !set CONFIG_KEYBOARD_C65_CAPS_LOCK = 1    ; untested
; !set CONFIG_KEY_REPEAT_DEFAULT = 1
; !set CONFIG_KEY_REPEAT_ALWAYS = 1
!set CONFIG_KEY_FAST_SCAN = 1
!set CONFIG_JOY1_CURSOR = 1
!set CONFIG_JOY2_CURSOR = 1

!set CONFIG_PROGRAMMABLE_KEYS = 1

!set   CONFIG_KEYCMD_RUN = 1
!macro CONFIG_KEYCMD_RUN  {
	!byte $5F
	!pet "l" }

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

!set   CONFIG_KEYCMD_F9 = 1
!macro CONFIG_KEYCMD_F9   { !pet "boot" }
!set   CONFIG_KEYCMD_F10 = 1
!macro CONFIG_KEYCMD_F10  { !pet "rem f10" }
!set   CONFIG_KEYCMD_F11 = 1
!macro CONFIG_KEYCMD_F11  { !pet "monitor" }
!set   CONFIG_KEYCMD_F12 = 1
!macro CONFIG_KEYCMD_F12  { !pet "rem f12" }
!set   CONFIG_KEYCMD_F13 = 1
!macro CONFIG_KEYCMD_F13  { !byte $5F !pet "h" }
!set   CONFIG_KEYCMD_F14 = 1
!macro CONFIG_KEYCMD_F14  { !pet "rem f14" }


; Screen editor

!set CONFIG_EDIT_STOPQUOTE = 1
!set CONFIG_EDIT_TABULATORS = 1


; Software features

!set CONFIG_PANIC_SCREEN = 1
!set CONFIG_DOS_WEDGE = 1
!set CONFIG_TAPE_WEDGE = 1
!set CONFIG_TAPE_HEAD_ALIGN = 1
!set CONFIG_BCD_SAFE_INTERRUPTS = 1


; Built-in DOS configuration

!set CONFIG_UNIT_SDCARD  = 0 ; do not change, DOS is not implemented yet
!set CONFIG_UNIT_FLOPPY  = 0 ; do not change, DOS is not implemented yet
!set CONFIG_UNIT_RAMDISK = 0 ; do not change, DOS is not implemented yet


; Debug options

; !set CONFIG_DBG_STUBS_BRK = 1
; !set CONFIG_DBG_PRINTF = 1

; Other

; !set CONFIG_COMPRESSION_LVL_2 = 1
