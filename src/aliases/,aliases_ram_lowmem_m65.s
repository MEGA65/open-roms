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

	!addr M65_RS232_INBUF    = $400 ; $400-$4FF  -- reserved for RS-232 input buffer --
	!addr M65_RS232_OUTBUF   = $500 ; $500-$5FF  -- reserved for RS-232 output buffer --

	; $600-$77F - reserved for BASIC

	                                ; $600-$77F   -- UNUSED -- reserved for BASIC

	; $780-$7FF - reserved for KERNAL

	!addr M65_SCRSEG         = $780 ; $780-$781  segment address (2 higher bytes) of the screen memory
	!addr M65_SCRBASE        = $782 ; $782-$783  first byte of screen memory
	!addr M65_SCRGUARD       = $784 ; $784-$785  last byte of screen memory + 1  XXX is it needed?
	!addr M65_COLGUARD       = $786 ; $786-$787  last byte of colour memory + 1
	!addr M65_COLVIEW        = $788 ; $788-$789  first byte of color memory viewport
	!addr M65_COLVIEWMAX     = $78A ; $78A-$78B  largest allowed value of M65_COLVIEW
	!addr M65_SCRMODE        = $78C ;            0 = 40x25, 1 = 80x25, 2 = 80x50 
	!addr M65_SCRWINMODE     = $78D ;            $00 = normal mode, $FF = window enabled
	!addr M65_TXTWIN_X0      = $78E ;            text window - top-left X coordinate, starting from 0
	!addr M65_TXTWIN_Y0      = $78F ;            text window - top-left Y coordinate, starting from 0
	!addr M65_TXTWIN_X1      = $790 ;            text window - bottom-right X coordinate + 1
	!addr M65_TXTWIN_Y1      = $791 ;            text window - bottom-right Y coordinate + 1
	!addr M65_TXTROW_OFF     = $792 ; $792-$793  offset to the current text row from the viewport start
	!addr M65_SCRCOLMAX      = $794 ;            maximum allowed column
	!addr M65_ESCMODE        = $795 ;            flag - if set, escape mode is in effect
	!addr M65_KB_BUCKY       = $796 ;            result of bucky keys scan
	!addr M65_KB_COLSCAN     = $797 ; $797-$79F  results of keyboard scan, columns 0-8
	!addr M65_KB_PRESSED     = $7A0 ; $7A0-$7A2  keys pressed, used during scanning keyboard
	!addr M65_KB_PRESSED_OLD = $7A3 ; $7A3-$7A5  keys pressed during previous scan
	!addr M65_KB_PRESSED_NEW = $7A6 ; $7A6-$7A8  set of M65_KB_PRESSED minus M65_KB_PRESSED_OLD
	!addr M65_BELLDSBL       = $7A9 ;            flag - if set, disable the bell
	!addr M65_SOLIDCRSR      = $7AA ;            flag - if set, cursor is solid (does not flash)
	!addr M65_JOYCRSR        = $7AB ;            joystick to be used for cursor movement
	                                ; $7AC-$7C8  -- UNUSED --
	!addr M65_DMAGIC_LIST    = $7C9 ; $7C9-$7D7  reserved for DMAgic list, 15 bytes (modulo bytes are not needed)

	; $7D8-$7E7 - 4 32bit registers, reserved for parameters for future Kernal AP{I expansion

    !addr M65_R0             = $7D8 ; $7D8-$7DB 
    !addr M65_R1             = $7DC ; $7DC-$7DF
    !addr M65_R2             = $7E0 ; $7E0-$7E3
    !addr M65_R3             = $7E4 ; $7E4-$7E7

	; $7E8-$7FF - 24 free bytes, as in the legacy compatibility mode

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
