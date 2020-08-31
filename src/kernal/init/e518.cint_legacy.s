// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Part of the official Kernal routine, described in:
//
// - [RG64] C64 Programmers Reference Guide   - page 280
// - [CM64] Computes Mapping the Commodore 64 - page 242
//
// CPU registers that has to be preserved (see [RG64]): none
//


cint_legacy: // $E518

	// Setup video and I/O
	// See here: https://csdb.dk/forums/index.php?roomid=11&topicid=17048&firstpost=22
	jsr vicii_init

	// Code below must be placed under $E51B, or some code will break - see here:
	// - https://csdb.dk/forums/index.php?roomid=11&topicid=17048&firstpost=2
	// Game 'Operacja Proboszcz' is one example.

	jmp cint_screen_keyboard // XXX try to fit the code here
