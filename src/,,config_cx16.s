
!set CONFIG_ID = $04 ; should be 1 byte, different for each config file!

;
; Please read CONFIG.md before modifying this file!
;

; Idea:
; - settings file for the Commander X16 machine



; Hardware platform and brand

!set CONFIG_PLATFORM_COMMANDER_X16 = 1


; Memory model

!set CONFIG_MEMORY_MODEL_38K = 1


; Keyboard settings

; !set CONFIG_PROGRAMMABLE_KEYS = 1

!set   CONFIG_KEYCMD_RUN = 1
!macro CONFIG_KEYCMD_RUN  { !pet "load\"*\"" }

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

; !set CONFIG_EDIT_STOPQUOTE = 1
; !set CONFIG_EDIT_TABULATORS = 1


; Software features

; !set CONFIG_PANIC_SCREEN = 1
; !set CONFIG_DOS_WEDGE = 1
; !set CONFIG_TAPE_WEDGE = 1
; !set CONFIG_TAPE_HEAD_ALIGN = 1
!set CONFIG_BCD_SAFE_INTERRUPTS = 1


; Eye candy

; !set CONFIG_COLORS_BRAND = 1
; !set CONFIG_BANNER_SIMPLE = 1
!set CONFIG_BANNER_FANCY = 1
; !set CONFIG_SHOW_FEATURES = 1


; Debug options

; !set CONFIG_DBG_STUBS_BRK = 1
; !set CONFIG_DBG_PRINTF = 1

; Other

; !set CONFIG_COMPRESSION_LVL_2 = 1
