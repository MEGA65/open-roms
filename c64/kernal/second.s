; Function defined on pp272-273 of C64 Programmers Reference Guide
second:

	;; This trivial routine is documented in 'C64 Programmer's Reference Guide', page 296
	ora $60
	jmp iec_tx_byte
