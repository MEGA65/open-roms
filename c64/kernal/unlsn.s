
;;
;; Official Kernal routine, described in:
;;
;; - [RG64] C64 Programmer's Reference Guide   - page 303
;; - [CM64] Compute's Mapping the Commodore 64 - page 224
;;
;; CPU registers that has to be preserved (see [RG64]): .X, .Y
;;

;; XXX currently does not preserve registers, to be fixed!

unlsn:

	;; This routine is documented in 'Compute's Mapping the Commodore 64', page 224
	
	;; First check whether we have something to be sent in the buffer
	lda C3PO
	beq +
	lda BSOUR
	sec ; send it with EOI
	jsr iec_tx_byte		; XXX what about the status of this operation?
	;; Mark the buffer as invalid
	lda #$00
	sta C3PO
*
	;; Buffer empty send the command
	lda #$3F
	jmp iec_tx_command


