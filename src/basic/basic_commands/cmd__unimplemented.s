// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Default handler for all not-yet-implemented commands
//
// Note: NOPs are here just to make debugging easier (no duplicated labels)!
//


cmd_for:
	nop
cmd_next:
	nop
cmd_data:
	nop
cmd_inputhash:
	nop
cmd_input:
	nop
cmd_read:
	nop
cmd_gosub:
	nop
cmd_return:
	nop
cmd_on:
	nop
cmd_wait:
	nop
cmd_def:
	nop
cmd_poke:
	nop
cmd_printhash:
	nop
cmd_cont:
	nop
cmd_cmd:
	nop
cmd_open:
	nop
cmd_close:
	nop
cmd_get:
	nop
cmd_tab:
	nop
cmd_spc:
	nop

	// Unimplemented tokens

	jmp do_NOT_IMPLEMENTED_error
