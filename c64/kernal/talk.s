
;;
;; Official Kernal routine, described in:
;;
;; - [RG64] C64 Programmer's Reference Guide   - page 301/302
;; - [CM64] Compute's Mapping the Commodore 64 - page 223
;; - https://www.pagetable.com/?p=1031, https://github.com/mist64/cbmbus_doc
;;
;; CPU registers that has to be preserved (see [RG64]): .X, .Y
;;


;; XXX shouldn't this do a turnaround?

talk:

	;; First check whether device number is correct
	jsr iec_devnum_check
	bcs kernalerror_DEVICE_NOT_FOUND
	;; Encode and execute the command
	ora #$40
	sta BSOUR
	jmp iec_tx_command
