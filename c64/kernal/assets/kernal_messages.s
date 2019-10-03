
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


__kernal_messages_start:

__kernal_message_searching_for:
	.byte $0D
	.text "SEARCHING FOR "
	.byte 0

__kernal_message_loading:
	.byte $0D
	.text "LOADING"
	.byte 0

__kernal_message_verifying:
	.byte $0D
	.text "VERIFYING"
	.byte 0

__kernal_message_saving:
	.byte $0D
	.text "SAVING"
	.byte 0

__kernal_message_from_hex:
	.text " FROM $"
	.byte 0

__kernal_message_to_hex:
	.text " TO $"
	.byte 0
