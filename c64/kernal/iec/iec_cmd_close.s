
;;
;; Kernal internal IEC routine
;;
;; - https://www.pagetable.com/?p=1031, https://github.com/mist64/cbmbus_doc
;;

iec_cmd_close:

	jsr iec_tx_flush

	;; Due to OPEN/CLOSE/TKSA/SECOND command encoding (see https://www.pagetable.com/?p=1031),
	;; allowed channels are 0-15; report error if out of range
	cmp #$10
	bcc + 
	jmp kernalerror_FILE_NOT_INPUT
*
	ora #$E0

	jmp common_open_close_unlsn_second
