
//
// Messages to be prined out by Kernal
//

// Double underscore prevents labels from being passed to VICE (would confuse monitor)

.label __MSG_KERNAL_SEARCHING_FOR = __kernal_message_searching_for - __kernal_messages_start
.label __MSG_KERNAL_LOADING       = __kernal_message_loading       - __kernal_messages_start
.label __MSG_KERNAL_VERIFYING     = __kernal_message_verifying     - __kernal_messages_start
.label __MSG_KERNAL_SAVING        = __kernal_message_saving        - __kernal_messages_start
.label __MSG_KERNAL_FROM_HEX      = __kernal_message_from_hex      - __kernal_messages_start
.label __MSG_KERNAL_TO_HEX        = __kernal_message_to_hex        - __kernal_messages_start

#if CONFIG_BANNER_PAL_NTSC
.label __MSG_KERNAL_PAL           = __kernal_message_pal           - __kernal_messages_start
.label __MSG_KERNAL_NTSC          = __kernal_message_ntsc          - __kernal_messages_start
#endif


__kernal_messages_start:

__kernal_message_searching_for:
	.byte $0D
	.text "SEARCHING FOR"
	.byte $80 + $20 // end of string mark + space

__kernal_message_loading:
	.byte $0D
	.text "LOADIN"
	.byte $80 + $47 // end of string mark + 'G'

__kernal_message_verifying:
	.byte $0D
	.text "VERIFYIN"
	.byte $80 + $47 // end of string mark + 'G'

__kernal_message_saving:
	.byte $0D
	.text "SAVIN"
	.byte $80 + $47 // end of string mark + 'G'

__kernal_message_from_hex:
	.text " FROM "
	.byte $80 + $24 // end of string mark + '$'

__kernal_message_to_hex:
	.text " TO "
	.byte $80 + $24 // end of string mark + '$'

#if CONFIG_BANNER_PAL_NTSC

__kernal_message_pal:
	.text "PAL,"
	.byte $80 + $20 // end of string mark + space

__kernal_message_ntsc:
	.text "NTSC,"
	.byte $80 + $20 // end of string mark + space

#endif // CONFIG_BANNER_PAL_NTSC
