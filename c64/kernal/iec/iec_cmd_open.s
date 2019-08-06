
;;
;; Kernal internal IEC routine
;;
;; - https://www.pagetable.com/?p=1031, https://github.com/mist64/cbmbus_doc
;;


iec_cmd_open: ; similar to TKSA, but without turnaround

	jsr iec_check_channel_openclose
	bcc +
	jmp kernalerror_FILE_NOT_INPUT
*
	ora #$F0

	;; FALLTROUGH

common_open_close_unlsn_second: ; common part of several commands

	sta IEC_TMP2
	jsr iec_tx_command
	bcs + ; branch if error
	jmp iec_tx_command_finalize
*
	rts

iec_check_channel_openclose:
	;; Due to OPEN/CLOSE/TKSA/SECOND command encoding (see https://www.pagetable.com/?p=1031),
	;; allowed channels are 0-15; report error if out of range
	cmp #$10
	bcc + 
	;; Workaround to allow reading executable files and disk directory
	;; using OPEN routine - see https://www.pagetable.com/?p=273 for
	;; example usage
	cmp #$60
	beq +
	sec ; mark unsuitable channel number
	rts
*
	clc ; mark suitable channel number
	rts
