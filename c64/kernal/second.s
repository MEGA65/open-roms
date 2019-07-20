
;;
;; Official Kernal routine, described in:
;;
;; - [RG64] C64 Programmer's Reference Guide   - page 296
;; - [CM64] Compute's Mapping the Commodore 64 - page 223/224
;; - https://www.pagetable.com/?p=1031, , https://github.com/mist64/cbmbus_doc
;;
;; CPU registers that has to be preserved (see [RG64]): .X, .Y
;;


second:

	and #$1F ; make sure bits encoding the command are cleared out
	ora #$60
	sta BSOUR
	jmp iec_tx_command
