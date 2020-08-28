// #LAYOUT# M65 * #TAKE
// #LAYOUT# *   * #IGNORE

//
// Names of ZP and low memory locations for the native Mega65 mode
//


	//
	// Page 0 - reused LDTB1 and USER
	//

	.label M65_TMP__K1   = $D9  // $D9      -- UNUSED -- temporary value for various Kernal routines
	.label M65_LPNT_BAS1 = $DA  // $DA-$DD  4-byte pointer for temporary usage within BASIC
	.label M65_LPNT_BAS2 = $DE  // $DE-$E1  4-byte pointer for temporary usage within BASIC
	.label M65_LPNT_SCR  = $E2  // $E2-$E5  4-byte pointer for temporary usage within BASIC and screen editor
	                            // E6      reserved for BASIC error handling routines, also in native mode
	.label M65_MAGICSTR  = $E7  // $E7-$E9  if equals 'M65' it means we are in native mode
	                            // EA      reserved for BASIC error handling routines, also in native mode
	.label M65_LPNT_IRQ  = $EB  // $EB-$EE  4-byte pointer for temporary usage within interrupts
	.label M65_LPNT_KERN = $EF  // $EF-$F3  4-byte pointer for temporary usage by KERNAL
	.label M65_TMP__K2   = $F4  // $F4      -- UNUSED -- temporary value for various Kernal routines

	//
	// Page 0 - other reused values
	//

	.label M65__TXTROW   = TBLX  //         screen row
	.label M65__TXTCOL   = PNTR  //         screen column
	.label M65__SCRINPUT = LSXP  //         pointer to the screen input, within the screen segment

	//
	// Pages 4-7 - reused screen memory
	//

	// $400-$57F - reserved for BASIC

	                               // $400-$57F  -- UNUSED -- reserved for BASIC

	// $580-$5FF - reserved for KERNAL

	.label M65_SCRSEG       = $580 // $580-$581  segment address (2 higher bytes) of the screen memory
	.label M65_SCRBASE      = $582 // $582-$583  first byte of screen memory
	.label M65_SCRGUARD     = $584 // $584-$585  last byte of screen memory + 1  XXX is it needed?
	.label M65_COLGUARD     = $586 // $586-$587  last byte of colour memory + 1
	.label M65_COLVIEW      = $588 // $588-$589  first byte of color memory viewport
	.label M65_COLVIEWMAX   = $58A // $58A-$58B  largest allowed value of M65_COLVIEW
	.label M65_SCRMODE      = $58C //            0 = 40x25, 1 = 80x25, 2 = 80x50 
	.label M65_SCRWINMODE   = $58D //            $00 = normal mode, $FF = window enabled
	.label M65_TXTWIN_X0    = $58E //            text window - top-left X coordinate, starting from 0
	.label M65_TXTWIN_Y0    = $58F //            text window - top-left Y coordinate, starting from 0
	.label M65_TXTWIN_X1    = $590 //            text window - bottom-right X coordinate + 1
	.label M65_TXTWIN_Y1    = $591 //            text window - bottom-right Y coordinate + 1
	.label M65_TXTROW_OFF   = $592 // $592-$593  offset to the current text row
	                               // $594-$5FF  -- UNUSED --
	.label M65_RS232_INBUF  = $600 // $600-$6FF  -- reserved for RS-232 input buffer --
	.label M65_RS232_OUTBUF = $700 // $700-$7FF  -- reserved for RS-232 output buffer --
