
;;
;; Kernal internal IEC routine
;;
;; - https://www.pagetable.com/?p=1031, https://github.com/mist64/cbmbus_doc
;;


iec_cmd_open: ; similar to TKSA, but without turnaround

	;; Due to OPEN/CLOSE/TKSA/SECOND command encoding (see https://www.pagetable.com/?p=1031),
	;; allowed channels are 0-15; report error if out of range
	cmp #$10
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

