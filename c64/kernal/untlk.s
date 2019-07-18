
;;
;; Official Kernal routine, described in:
;;
;; - [RG64] C64 Programmer's Reference Guide   - page 304
;; - [CM64] Compute's Mapping the Commodore 64 - page 224
;;
;; CPU registers that has to be preserved (see [RG64]): .X, .Y
;;

;; XXX currently does not preserve registers, to be fixed!
;; XXX shouldn't this do a turnaround?

untlk:

	;; This trivial routine is documented in 'Compute's Mapping the Commodore 64', page 224
	lda #$5F
	jmp iec_tx_command

