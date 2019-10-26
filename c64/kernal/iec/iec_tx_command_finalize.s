
// Routine to finalize some IEC commands - which do not end in turnaround and are not followed by others
// Implemented based on https://www.pagetable.com/?p=1135, https://github.com/mist64/cbmbus_doc


iec_tx_command_finalize:

	// Store .X and .Y on the stack - preserve them
	phx_trash_a
	phy_trash_a

	// Give device some time to complete command reception, release ATN,
	// give it some time again before (possible) next command
	jsr iec_wait20us
	jsr iec_set_idle
	jsr iec_wait20us

	jmp iec_return_success
