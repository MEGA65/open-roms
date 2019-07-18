
;;
;; Official Kernal routine, described in:
;;
;; - [RG64] C64 Programmer's Reference Guide   - page 285
;; - [CM64] Compute's Mapping the Commodore 64 - page 223
;;
;; CPU registers that has to be preserved (see [RG64]): .X, .Y
;;

;; XXX currently does not preserve registers, to be fixed!

listen:

	;; This trivial routine is documented in 'Compute's Mapping the Commodore 64', page 223 and
	;; https://www.pagetable.com/?p=1031, , https://github.com/mist64/cbmbus_doc
	and #$1F ; make sure bits encoding the command are cleared out
	ora #$20
	jmp iec_tx_command
