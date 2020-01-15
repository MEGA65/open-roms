// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE


// https://csdb.dk/forums/index.php?roomid=11&topicid=5776
// Clear the CIA1 interrupt flag, and then fall through to
// the return from interrupt routine

clear_cia1_interrupt_flag_and_return_from_interrupt:

	// We have free choice of LDA, LDX or LDY to achieve this goal
	// in 3 bytes and minimum cycles. Thus we randomly choose LDY.
	ldy CIA1_ICR

	// FALL THROUGH to $EA81
