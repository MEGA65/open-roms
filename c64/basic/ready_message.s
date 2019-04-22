ready_message:
	;; See src/make_error_tables.c for packed message handling
	;; information.
	ldx #0
	jmp print_packed_message
