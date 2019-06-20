; Function defined on pp272-273 of C64 Programmers Reference Guide
tksa:

	;; This routine is documented in 'C64 Programmer's Reference Guide', page 302 and
	;; https://www.pagetable.com/?p=1031, , https://github.com/mist64/cbmbus_doc
	ora #$F0
	jsr iec_tx_command
	bcs tksa_error
	jmp iec_turnaround_to_listen
	
tksa_error:
	rts
