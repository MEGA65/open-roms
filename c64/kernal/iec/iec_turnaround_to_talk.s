// According to http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
// pages 7--8.
// See also https://www.pagetable.com/?p=1135, https://github.com/mist64/cbmbus_doc

iec_turnaround_to_talk:

	// Store .X and .Y on the stack - preserve them
	_phx
	_phy

	// Timing is critical here - execute on disabled IRQs
	php
	sei

	// First make sure both CLK, DATA and ATN are released at our side
	jsr iec_release_atn
	jsr iec_release_clk_data

	// Wait till device releases CLK line
	jsr iec_wait_for_clk_release

	// Pull CLK line, it should be held by talker
	jsr iec_pull_clk_release_data

	plp
	jmp iec_return_success

