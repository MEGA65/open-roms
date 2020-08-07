// #LAYOUT# M65 * #TAKE
// #LAYOUT# *   * #IGNORE

//
// Names of ZP and low memory locations for the native Mega65 mode
//


	//
	// Page 0 - reused LDTB1
	//

	                            // $D9      -- UNUSED --
	.label M65_LPNT_BAS1 = $DA  // $DA-$DD  4-byte pointer for temporary usage within BASIC
	.label M65_LPNT_BAS2 = $DE  // $DE-$E1  4-byte pointer for temporary usage within BASIC
	.label M65_LPNT_SCR  = $E2  // $E2-$E5  4-byte pointer for temporary usage within BASIC and screen editor
	                            // E6      reserved for BASIC error handling routines, also in native mode
	.label M65_MAGICSTR  = $E7  // $E7-$E9  if equals 'M65' it means we are in native mode
	.label M65_LPNT_IRQ  = $EA  // $EA-$ED  4-byte pointer for temporary usage within interrupts
	.label M65_LPNT_KERN = $EE  // $EE-$F1  4-byte pointer for temporary usage by KERNAL
	                            // $F2      -- UNUSED --

	//
	// Pages 4-7 - reused screen memory
	//

	                               // $400-$57F -- UNUSED -- reserved for BASIC
	                               // $580-$5FF -- UNUSED -- reserved for KERNAL

	.label M65_RS232_INBUF  = $600 // $600-$6FF  -- reserved for RS-232 input buffer --
	.label M65_RS232_OUTBUF = $700 // $700-$7FF  -- reserved for RS-232 output buffer --
