// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Messages to be prined out by Kernal
//

.encoding "petscii_upper"


// Double underscore prevents labels from being passed to VICE (would confuse monitor)

.label __MSG_KERNAL_SEARCHING_FOR      = __msg_kernalsearching_for      - __msg_kernal_first
.label __MSG_KERNAL_LOADING            = __msg_kernalloading            - __msg_kernal_first
.label __MSG_KERNAL_VERIFYING          = __msg_kernalverifying          - __msg_kernal_first
.label __MSG_KERNAL_SAVING             = __msg_kernalsaving             - __msg_kernal_first
.label __MSG_KERNAL_FROM_HEX           = __msg_kernalfrom_hex           - __msg_kernal_first
.label __MSG_KERNAL_TO_HEX             = __msg_kernalto_hex             - __msg_kernal_first

#if CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO
.label __MSG_KERNAL_PRESS_PLAY         = __msg_kernalplay               - __msg_kernal_first
.label __MSG_KERNAL_FOUND              = __msg_kernalfound              - __msg_kernal_first
#if CONFIG_MB_MEGA_65
.label __MSG_KERNAL_OK_SEARCHING       = __msg_kernaloksearching        - __msg_kernal_first
#endif
#endif

#if CONFIG_PANIC_SCREEN
.label __MSG_KERNAL_PANIC              = __msg_kernalpanic              - __msg_kernal_first
.label __MSG_KERNAL_PANIC_ROM_MISMATCH = __msg_kernalpanic_rom_mismatch - __msg_kernal_first
#endif


__msg_kernal_first:

__msg_kernalsearching_for:
	.byte $0D
	.text "SEARCHING FOR"
	.byte $80 + $20 // end of string mark + space

__msg_kernalloading:
	.byte $0D
	.text "LOADIN"
	.byte $80 + $47 // end of string mark + 'G'

__msg_kernalverifying:
	.byte $0D
	.text "VERIFYIN"
	.byte $80 + $47 // end of string mark + 'G'

__msg_kernalsaving:
	.byte $0D
	.text "SAVING"
	.byte $80 + $20 // end of string mark + space

__msg_kernalfrom_hex:
	.text " FROM "
	.byte $80 + $24 // end of string mark + '$'

__msg_kernalto_hex:
	.text " TO "
	.byte $80 + $24 // end of string mark + '$'

#if CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO

__msg_kernalplay:
	.byte $0D
	.text "PRESS PLAY ON TAPE"
	.byte $80 + $0D // end of string mark + return

__msg_kernalfound:
	.text "FOUND"
	.byte $80 + $20 // end of string mark + space

#if CONFIG_MB_MEGA_65

__msg_kernaloksearching:
	.text "OK"
	.byte $0D, $0D
	.text "SEARCHIN"
	.byte $80 + $47 // end of string mark + 'G'

#endif

#endif

#if CONFIG_PANIC_SCREEN

__msg_kernalpanic:
	.text "KERNAL PANI"
	.byte $80 + $43 // end of string mark + 'C'

__msg_kernalpanic_rom_mismatch:
	.text " - ROM MISMATC"
	.byte $80 + $48 // end of string mark + 'H'

#endif // CONFIG_PANIC_SCREEN