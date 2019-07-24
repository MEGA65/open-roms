
;;
;; Official Kernal routine, described in:
;;
;; - [RG64] C64 Programmer's Reference Guide   - page 304
;; - [CM64] Compute's Mapping the Commodore 64 - page 224
;; - https://www.pagetable.com/?p=1031, , https://github.com/mist64/cbmbus_doc
;;
;; CPU registers that has to be preserved (see [RG64]): .X, .Y
;;


untlk:

	lda #$5F
	sta BSOUR
	jsr iec_tx_command
	bcs + ; branch if error
	jmp iec_turnaround_to_listen
*
	rts
