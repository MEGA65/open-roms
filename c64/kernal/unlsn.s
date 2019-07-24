
;;
;; Official Kernal routine, described in:
;;
;; - [RG64] C64 Programmer's Reference Guide   - page 303
;; - [CM64] Compute's Mapping the Commodore 64 - page 224
;; - https://www.pagetable.com/?p=1031, , https://github.com/mist64/cbmbus_doc
;;
;; CPU registers that has to be preserved (see [RG64]): .X, .Y
;;


unlsn:

	;; This routine is documented in 'Compute's Mapping the Commodore 64', page 224
	
	;; First check whether we have something to be sent in the buffer
	lda C3PO
	beq +
	sec ; send it with EOI
	jsr iec_tx_byte		; XXX what about the status of this operation?
*
	;; Buffer empty, send the command
	lda #$3F
	sta BSOUR
	jsr iec_tx_command
	bcs + ; branch if error
	jmp iec_tx_command_finalize
*
	rts
