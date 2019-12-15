
// Detect video system (PAL/NTSC), use Graham's method, as it's short and reliable
// see here: https://codebase64.org/doku.php?id=base:detect_pal_ntsc


setup_pal_ntsc:

	lda VIC_RASTER
!:
	cmp VIC_RASTER
	beq !-
	bmi setup_pal_ntsc

	// Result in A, if no interrupt happened during the test:
	// #$37 -> 312 rasterlines, PAL,  VIC 6569
	// #$06 -> 263 rasterlines, NTSC, VIC 6567R8
	// #$05 -> 262 rasterlines, NTSC, VIC 6567R56A

	cmp #$07
	bcc setup_ntsc

	// FALLTROUGH

setup_pal:

	// Set timer interval to ~1/60th of a second

	// (This value was calculated by running a custom IRQ handler on a C64
	// with original KERNAL, and writing the values of $DC04/5 to the screen
	// in the IRQ handler to see roughly what value the timers must be set to)
	// ldy #<16380
	// ldx #>16380

	// PAL C64 (https://codebase64.org/doku.php?id=base:cpu_clocking),
	// is clocked at 0.985248 MHz, so that 1/60s is 16421 ($4025) CPU cycles

	ldy #<16421
	ldx #>16421

	lda #$01

	// FALLTROUGH

setup_pal_ntsc_end:

	sty CIA1_TIMALO    // $DC04
	stx CIA1_TIMAHI    // $DC05

	sta TVSFLG

	rts

setup_ntsc:

	// Set timer interval to ~1/60th of a second
	
	// NTSC C64 (https://codebase64.org/doku.php?id=base:cpu_clocking),
	// is clocked at 1.022727 MHz, so that 1/60s is 17045 ($4295) CPU cycles

	ldy #<17045
	ldx #>17045

	lda #$00

	beq setup_pal_ntsc_end // branch always
