; Function defined on pp272-273 of C64 Programmers Reference Guide
tksa:

	;; This routine is documented in 'C64 Programmer's Reference Guide', page 302 and
	;; https://www.pagetable.com/?p=1031, , https://github.com/mist64/cbmbus_doc
	and #$1F ; make sure bits encoding the command are cleared out
	ora #$F0
	jmp iec_tx_command

