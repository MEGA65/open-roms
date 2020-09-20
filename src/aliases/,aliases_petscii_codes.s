
;
; PETSCII codes for all the supported keys, for all the keyboards
;
; - [CM64]  Compute's Mapping the Commodore 64
; - [CM128] Compute's Mapping the Commodore 128
; - https://github.com/MEGA65/c65-specifications/blob/master/c65manualupdated.txt
; - https://en.wikipedia.org/wiki/PETSCII
;



; First determine what to define

!ifdef CONFIG_KEYBOARD_C128           { !set _NEED_EXTENDED   = 1 }
!ifdef CONFIG_KEYBOARD_C128_CAPS_LOCK { !set _NEED_CAPS_LOCK  = 1 }
!ifdef CONFIG_KEYBOARD_C65            { !set _NEED_EXTENDED   = 1 }
!ifdef CONFIG_KEYBOARD_C65_CAPS_LOCK  { !set _NEED_CAPS_LOCK  = 1 }
!ifdef CONFIG_MB_M65                  { !set _NEED_EXTENDED   = 1 }
!ifdef CONFIG_KEYBOARD_C65            { !set _NEED_C65KB      = 1 }
!ifdef CONFIG_MB_M65                  { !set _NEED_C65KB      = 1 }



; Not really PETSCII codes, but bitmask values for SHFLAG variable
; [CM64] page 68, [CM128] page 212 

!set KEY_FLAG_SHIFT       = %00000001
!set KEY_FLAG_VENDOR      = %00000010
!set KEY_FLAG_CTRL        = %00000100

!ifdef _NEED_EXTENDED {
	!set KEY_FLAG_ALT     = %00001000
	!set KEY_FLAG_NO_SCRL = %00100000  
}
!ifdef _NEED_CAPS_LOCK {
	!set KEY_CAPS_LOCK    = %00010000
}



; Note - the following PETSCII codes are currently unassigned, can be used for further extensions: $01, $04, $06, ($80 ?)



!set KEY_NA                 = $00  ; to indicate that no key is presed


; PETSCII codes for our extended screen editor

!set KEY_C64_TAB_FW         = $8F  ; CTRL+>, TAB       - Open ROMs unofficial, original TAB conflicts with C64 PETSCII, XXX remove?
!set KEY_C64_TAB_BW         = $80  ; CTRL+<, SHIFT+TAB - Open ROMs unofficial, original TAB conflicts with C64 PETSCII, XXX remove?


; PETSCII codes for certain C128 and C65 functionalities

!ifdef _NEED_EXTENDED {
	!set KEY_BELL           = $07  ; no key, originally CTRL+G ; XXX implement, add to C65 keyboard matrix
	!set KEY_ESC            = $1B
}

!ifdef _NEED_C65KB {
	!set KEY_TAB            = $09  ; XXX add to C65 keyboard matrix
	!set KEY_LINE_FEED      = $0A  ; XXX add to C65 keyboard matrix
	!set KEY_TAB_SET_CLR    = $18  ; XXX add to C65 keyboard matrix
	!set KEY_UNDERLINE_ON   = $02  ; XXX add to C65 keyboard matrix
	!set KEY_UNDERLINE_OFF  = $82  ; XXX add to C65 keyboard matrix
	!set KEY_FLASHING_ON    = $0F  ; XXX add to C65 keyboard matrix
	!set KEY_FLASHING_OFF   = $8F  ; XXX add to C65 keyboard matrix
}


; PETSCII codes for programmable keys

!set KEY_STOP              = $03
!set KEY_RUN               = $83

!set KEY_F1                = $85
!set KEY_F2                = $89
!set KEY_F3                = $86
!set KEY_F4                = $8A
!set KEY_F5                = $87
!set KEY_F6                = $8B
!set KEY_F7                = $88
!set KEY_F8                = $8C

!ifdef _NEED_C65KB {
	!set KEY_F9            = $10
	!set KEY_F10           = $15
	!set KEY_F11           = $16
	!set KEY_F12           = $17
	!set KEY_F13           = $19
	!set KEY_F14           = $1A
}

!ifdef _NEED_EXTENDED {
	!set KEY_HELP          = $84
}


; PETSCII codes for cursor keys

!set KEY_CRSR_UP           = $91
!set KEY_CRSR_DOWN         = $11
!set KEY_CRSR_LEFT         = $9D
!set KEY_CRSR_RIGHT        = $1D


; PETSCII codes for colors

!set KEY_RVS_ON            = $12  ; CTRL+9
!set KEY_RVS_OFF           = $92  ; CTRL+0

!set KEY_BLACK             = $90  ; CTRL+1
!set KEY_WHITE             = $05  ; CTRL+2
!set KEY_RED               = $1C  ; CTRL+3
!set KEY_CYAN              = $9F  ; CTRL+4
!set KEY_PURPLE            = $9C  ; CTRL+5
!set KEY_GREEN             = $1E  ; CTRL+6
!set KEY_BLUE              = $1F  ; CTRL+7
!set KEY_YELLOW            = $9E  ; CTRL+8

!set KEY_ORANGE            = $81  ; VENDOR+1
!set KEY_BROWN             = $95  ; VENDOR+2
!set KEY_LT_RED            = $96  ; VENDOR+3
!set KEY_GREY_1            = $97  ; VENDOR+4
!set KEY_GREY_2            = $98  ; VENDOR+5
!set KEY_LT_GREEN          = $99  ; VENDOR+6
!set KEY_LT_BLUE           = $9A  ; VENDOR+7
!set KEY_GREY_3            = $9B  ; VENDOR+8


; PETSCII codes for case toggle

!set KEY_C64_SHIFT_ON      = $09  ; no key
!set KEY_C64_SHIFT_OFF     = $08  ; no key
!ifdef _NEED_C65KB {
	!set KEY_C65_SHIFT_OFF = $0B  ; no key
	!set KEY_C65_SHIFT_ON  = $0C  ; no key
}
!set KEY_TXT               = $0E  ; no key
!set KEY_GFX               = $8E  ; no key


; PETSCII codes for other non-printable characters

!set KEY_RETURN            = $0D
!set KEY_CLR               = $93
!set KEY_HOME              = $13
!set KEY_INS               = $94
!set KEY_DEL               = $14


; PETSCII codes for printable characters

!set KEY_SPACE             = $20
!set KEY_EXCLAMATION       = $21
!set KEY_QUOTE             = $22
!set KEY_HASH              = $23
!set KEY_DOLLAR            = $24
!set KEY_PERCENT           = $25
!set KEY_AMPERSAND         = $26
!set KEY_APOSTROPHE        = $27
!set KEY_R_BRACKET_L       = $28
!set KEY_R_BRACKET_R       = $29
!set KEY_ASTERISK          = $2A
!set KEY_PLUS              = $2B
!set KEY_COMA              = $2C
!set KEY_MINUS             = $2D
!set KEY_FULLSTOP          = $2E
!set KEY_SLASH             = $2F

!set KEY_0                 = $30
!set KEY_1                 = $31
!set KEY_2                 = $32
!set KEY_3                 = $33
!set KEY_4                 = $34
!set KEY_5                 = $35
!set KEY_6                 = $36
!set KEY_7                 = $37
!set KEY_8                 = $38
!set KEY_9                 = $39
!set KEY_COLON             = $3A
!set KEY_SEMICOLON         = $3B
!set KEY_LT                = $3C
!set KEY_EQ                = $3D
!set KEY_GT                = $3E
!set KEY_QUESTION          = $3F


; XXX finish this: $4x, $5x, $6x, $7x, $Ax, $Bx, $Cx, $Dx, $Ex, $Fx
