// #LAYOUT# M65 * #TAKE
// #LAYOUT# *   * #IGNORE

//
// Names of ZP and low memory locations for the native Mega65 mode
//


	//
	// Page 0 - reused LDTB1
	//

	.label M65_TMP__K1   = $D9  // $D9      -- UNUSED -- temporary value for various Kernal routines
	.label M65_LPNT_BAS1 = $DA  // $DA-$DD  4-byte pointer for temporary usage within BASIC
	.label M65_LPNT_BAS2 = $DE  // $DE-$E1  4-byte pointer for temporary usage within BASIC
	.label M65_LPNT_SCR  = $E2  // $E2-$E5  4-byte pointer for temporary usage within BASIC and screen editor
	                            // E6      reserved for BASIC error handling routines, also in native mode
	.label M65_MAGICSTR  = $E7  // $E7-$E9  if equals 'M65' it means we are in native mode
	.label M65_LPNT_IRQ  = $EA  // $EA-$ED  4-byte pointer for temporary usage within interrupts
	.label M65_LPNT_KERN = $EE  // $EE-$F1  4-byte pointer for temporary usage by KERNAL
	.label M65_TMP__K2   = $F2  // $F2      -- UNUSED -- temporary value for various Kernal routines

	//
	// Pages 4-7 - reused screen memory
	//

	// $400-$57F - reserved for BASIC

	                               // $400-$57F  -- UNUSED -- reserved for BASIC

	// $580-$5FF - reserved for KERNAL

	.label M65_SCRTXTBASE   = $580 // $580-$583  base address of the screen memory for text modes
	.label M65_SCRGFXBASE   = $584 // $584-$587  -- NOT IMPLEMENTED -- base address of the screen memory for graphics modes
	.label M65_SCRMODE      = $588 //            0 = 40x25, 1 = 80x25, 2 = 80x50, (-- NOT IMPLEMENTED -- add $80 for graphics modes)
	.label M65_TXTWIN_X0    = $589 //            text window - top-left X coordinate, starting from 0
	.label M65_TXTWIN_Y0    = $58A //            text window - top-left Y coordinate, starting from 0
	.label M65_TXTWIN_X1    = $58B //            text window - bottom-right X coordinate + 1
	.label M65_TXTWIN_Y1    = $58C //            text window - bottom-right Y coordinate + 1
	                               // $58D-$5FF  -- UNUSED --
	.label M65_RS232_INBUF  = $600 // $600-$6FF  -- reserved for RS-232 input buffer --
	.label M65_RS232_OUTBUF = $700 // $700-$7FF  -- reserved for RS-232 output buffer --
