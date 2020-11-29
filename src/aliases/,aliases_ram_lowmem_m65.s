;; #LAYOUT# M65 * #TAKE
;; #LAYOUT# *   * #IGNORE

;
; Names of ZP and low memory locations for the native MEGA65 mode
;


	;
	; Page 0 - reused LDTB1 and USER
	;

	!addr M65_TMP__K1   = $D9  ; $D9      -- UNUSED -- temporary value for various Kernal routines
	!addr M65_LPNT_BAS1 = $DA  ; $DA-$DD  4-byte pointer for temporary usage within BASIC
	!addr M65_LPNT_BAS2 = $DE  ; $DE-$E1  4-byte pointer for temporary usage within BASIC
	!addr M65_LPNT_SCR  = $E2  ; $E2-$E5  4-byte pointer for temporary usage within BASIC and screen editor
	                            ; E6      reserved for BASIC error handling routines, also in native mode
	!addr M65_MAGICSTR  = $E7  ; $E7-$E9  if equals 'M65' it means we are in native mode
	                            ; EA      reserved for BASIC error handling routines, also in native mode
	!addr M65_LPNT_IRQ  = $EB  ; $EB-$EE  4-byte pointer for temporary usage within interrupts
	!addr M65_LPNT_KERN = $EF  ; $EF-$F3  4-byte pointer for temporary usage by KERNAL
	!addr M65_TMP__K2   = $F4  ; $F4      -- UNUSED -- temporary value for various Kernal routines

	;
	; Page 0 - other reused values
	;

	!addr M65__TXTROW   = TBLX  ;         screen row
	!addr M65__TXTCOL   = PNTR  ;         screen column
	!addr M65__SCRINPUT = LSXP  ;         pointer to the screen input, within the screen segment

	;
	; Pages 4-7 - reused screen memory
	;

	; $400-$57F - reserved for BASIC

	                               ; $400-$57F  -- UNUSED -- reserved for BASIC

	; $580-$5FF - reserved for KERNAL

	!addr M65_SCRSEG         = $580 ; $580-$581  segment address (2 higher bytes) of the screen memory
	!addr M65_SCRBASE        = $582 ; $582-$583  first byte of screen memory
	!addr M65_SCRGUARD       = $584 ; $584-$585  last byte of screen memory + 1  XXX is it needed?
	!addr M65_COLGUARD       = $586 ; $586-$587  last byte of colour memory + 1
	!addr M65_COLVIEW        = $588 ; $588-$589  first byte of color memory viewport
	!addr M65_COLVIEWMAX     = $58A ; $58A-$58B  largest allowed value of M65_COLVIEW
	!addr M65_SCRMODE        = $58C ;            0 = 40x25, 1 = 80x25, 2 = 80x50 
	!addr M65_SCRWINMODE     = $58D ;            $00 = normal mode, $FF = window enabled
	!addr M65_TXTWIN_X0      = $58E ;            text window - top-left X coordinate, starting from 0
	!addr M65_TXTWIN_Y0      = $58F ;            text window - top-left Y coordinate, starting from 0
	!addr M65_TXTWIN_X1      = $590 ;            text window - bottom-right X coordinate + 1
	!addr M65_TXTWIN_Y1      = $591 ;            text window - bottom-right Y coordinate + 1
	!addr M65_TXTROW_OFF     = $592 ; $592-$593  offset to the current text row from the viewport start
	!addr M65_SCRCOLMAX      = $594 ;            maximum allowed column
	!addr M65_KB_BUCKY       = $595 ;            result of bucky keys scan
	!addr M65_KB_COLSCAN     = $596 ; $596-$59E  results of keyboard scan, columns 0-8
	!addr M65_KB_COLSUM      = $59F ;            sum (OR) of the M65_KB_COLSCAN
	!addr M65_KB_PRESSED     = $560 ; $560-$562  keys pressed, used during scanning keyboard
	!addr M65_KB_PRESSED_OLD = $563 ; $563-$565  keys pressed during previous scan
	                              ; $560-$5EB  -- UNUSED --
	!addr M65_DMAGIC_LIST  = $5F1 ; $5EF-$5FF  reserved for DMAgic list, 15 bytes (modulo bytes are not needed)
	!addr M65_RS232_INBUF  = $600 ; $600-$6FF  -- reserved for RS-232 input buffer --
	!addr M65_RS232_OUTBUF = $700 ; $700-$7FF  -- reserved for RS-232 output buffer --

	;
	; Addresses for configuring the DMA job
	;

	!addr M65_DMAJOB_SIZE_0    = M65_DMAGIC_LIST + 7
	!addr M65_DMAJOB_SIZE_1    = M65_DMAGIC_LIST + 8

	!addr M65_DMAJOB_SRC_0     = M65_DMAGIC_LIST + 9
	!addr M65_DMAJOB_SRC_1     = M65_DMAGIC_LIST + 10
	!addr M65_DMAJOB_SRC_2     = M65_DMAGIC_LIST + 11
	!addr M65_DMAJOB_SRC_3     = M65_DMAGIC_LIST + 2

	!addr M65_DMAJOB_DST_0     = M65_DMAGIC_LIST + 12
	!addr M65_DMAJOB_DST_1     = M65_DMAGIC_LIST + 13
	!addr M65_DMAJOB_DST_2     = M65_DMAGIC_LIST + 14
	!addr M65_DMAJOB_DST_3     = M65_DMAGIC_LIST + 4
