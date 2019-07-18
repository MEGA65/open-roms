
;;
;; Official Kernal routine, described in:
;;
;; - [RG64] C64 Programmer's Reference Guide   - page 296
;; - [CM64] Compute's Mapping the Commodore 64 - page 223/224
;;
;; CPU registers that has to be preserved (see [RG64]): .X, .Y
;;

;; XXX currently does not preserve registers, to be fixed!

second:

	;; see also https://www.pagetable.com/?p=1031, , https://github.com/mist64/cbmbus_doc

	and #$1F ; make sure bits encoding the command are cleared out
	ora #$60
	jmp iec_tx_command
