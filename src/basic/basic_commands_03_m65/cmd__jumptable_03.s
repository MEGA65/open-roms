// #LAYOUT# M65 BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Jumptable for BASIC commands with tokens prefixed by $03
//

.const command_03_list = List().add(

	cmd_rem // XXX just for testing
)


command_03_jumptable:

	// Note: 65C02 has the page boundary vector bug fixed!
	put_jumptable(command_03_list)
