
//
// PETSCII codes for all the supported keys, for all the keyboards
//
// - [CM64]  Compute's Mapping the Commodore 64
// - [CM128] Compute's Mapping the Commodore 128 
// - https://en.wikipedia.org/wiki/PETSCII
//



// Not really PETSCII codes, but bitmask values for SHFLAG variable
// [CM64] page 68, [CM128] page 212 

.const KEY_FLAG_SHIFT   = %00000001
.const KEY_FLAG_VENDOR  = %00000010
.const KEY_FLAG_CTRL    = %00000100
.const KEY_FLAG_ALT     = %00001000  // C65 / C128                            XXX implement this
.const KEY_FLAG_NO_SCRL = %00100000  // C65 / C128, Open ROMs unofficial      XXX implement this


// Note - the following PETSCII codes are currently unassigned, can be used for further extensions:
//
// $01, $04, $06, $0A, $0B, $0C, $0F, $82, $83, $84 


.const KEY_NA           = $00  // to indicate that no key is presed


// PETSCII codes for our extended screen editor       XXX implement these

.const KEY_BOTTOM       = $02  // CTRL+B            - DolphinDOS compatible
.const KEY_TAB_FW       = $8F  // CTRL+>, TAB       - Open ROMs unofficial
.const KEY_TAB_BW       = $80  // CTRL+<, SHIFT+TAB - Open ROMs unofficial


// PETSCII codes for certain C128 and C65 functionalities                     XXX implement these

.const KEY_BELL         = $07  // C65 / C128, no key
.const KEY_ESC          = $1B  // C65 / C128


// PETSCII codes for programmable keys

.const KEY_RUN          = $03

.const KEY_F1           = $85
.const KEY_F2           = $86
.const KEY_F3           = $87
.const KEY_F4           = $88
.const KEY_F5           = $89
.const KEY_F6           = $8A
.const KEY_F7           = $8B
.const KEY_F8           = $8C

.const KEY_F9           = $15  // C65, Open ROMs unofficial
.const KEY_F10          = $16  // C65, Open ROMs unofficial
.const KEY_F11          = $17  // C65, Open ROMs unofficial
.const KEY_F12          = $18  // C65, Open ROMs unofficial
.const KEY_F13          = $19  // C65, Open ROMs unofficial
.const KEY_F14          = $1A  // C65, Open ROMs unofficial

.const KEY_HELP         = $10  // C65 / C128, Open ROMs unofficial


// PETSCII codes for cursor keys

.const KEY_CRSR_UP      = $91
.const KEY_CRSR_DOWN    = $11
.const KEY_CRSR_LEFT    = $9D
.const KEY_CRSR_RIGHT   = $1D


// PETSCII codes for colors

.const KEY_RVS_ON       = $12  // CTRL+9
.const KEY_RVS_OFF      = $92  // CTRL+0

.const KEY_BLACK        = $90  // CTRL+1
.const KEY_WHITE        = $05  // CTRL+2
.const KEY_RED          = $1C  // CTRL+3
.const KEY_CYAN         = $9F  // CTRL+4
.const KEY_PURPLE       = $9C  // CTRL+5
.const KEY_GREEN        = $1E  // CTRL+6
.const KEY_BLUE         = $1F  // CTRL+7
.const KEY_YELLOW       = $9E  // CTRL+8

.const KEY_ORANGE       = $81  // VENDOR+1
.const KEY_BROWN        = $95  // VENDOR+2
.const KEY_LT_RED       = $96  // VENDOR+3
.const KEY_GREY_1       = $97  // VENDOR+4
.const KEY_GREY_2       = $98  // VENDOR+5
.const KEY_LT_GREEN     = $99  // VENDOR+6
.const KEY_LT_BLUE      = $9A  // VENDOR+7
.const KEY_GREY_3       = $9B  // VENDOR+8


// PETSCII codes for case toggle

.const KEY_SHIFT_ON     = $09  // no key
.const KEY_SHIFT_OFF    = $08  // no key
.const KEY_TXT          = $0E  // no key
.const KEY_GFX          = $8E  // no key


// PETSCII codes for other non-printable characters

.const KEY_RETURN       = $0D
.const KEY_CLR          = $93
.const KEY_HOME         = $13
.const KEY_INS          = $94
.const KEY_DEL          = $14


// PETSCII codes for printable characters

.const KEY_SPACE        = $20
.const KEY_EXCLAMATION  = $21
.const KEY_QUOTE        = $22
.const KEY_HASH         = $23
.const KEY_DOLLAR       = $24
.const KEY_PERCENT      = $25
.const KEY_AMPERSAND    = $26
.const KEY_APOSTROPHE   = $27
.const KEY_R_BRACKET_L  = $28
.const KEY_R_BRACKET_R  = $29
.const KEY_ASTERISK     = $2A
.const KEY_PLUS         = $2B
.const KEY_COMA         = $2C
.const KEY_MINUS        = $2D
.const KEY_FULLSTOP     = $2E
.const KEY_SLASH        = $2F

.const KEY_0            = $30
.const KEY_1            = $31
.const KEY_2            = $32
.const KEY_3            = $33
.const KEY_4            = $34
.const KEY_5            = $35
.const KEY_6            = $36
.const KEY_7            = $37
.const KEY_8            = $38
.const KEY_9            = $39
.const KEY_COLON        = $3A
.const KEY_SEMICOLON    = $3B
.const KEY_LT           = $3C
.const KEY_EQ           = $3D
.const KEY_GT           = $3E
.const KEY_QUESTION     = $3F

// XXX finish this: $4x, $5x, $6x, $7x, $Ax, $Bx, $Cx, $Dx, $Ex, $Fx
