
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 280
// - [CM64] Compute's Mapping the Commodore 64 - page 242
//
// CPU registers that has to be preserved (see [RG64]): none
//

CINT:

	jsr cint_legacy

cint_check_pal_ntsc:

	// Detect video system (PAL/NTSC), use Graham's method, as it's short and reliable
	// see here: https://codebase64.org/doku.php?id=base:detect_pal_ntsc

	lda VIC_RASTER
!:
	cmp VIC_RASTER
	beq !-
	bmi cint_check_pal_ntsc

	// Result in A, if no interrupt happened during the test:
	// #$37 -> 312 rasterlines, PAL,  VIC 6569
	// #$06 -> 263 rasterlines, NTSC, VIC 6567R8
	// #$05 -> 262 rasterlines, NTSC, VIC 6567R56A

	cmp #$07
	bcc cont_done

cint_pal:

	// (This value was calculated by running a custom IRQ handler on a C64
	// with original KERNAL, and writing the values of $DC04/5 to the screen
	// in the IRQ handler to see roughly what value the timers must be set to)
	// ldy #<16380
	// ldx #>16380

	// PAL C64 (https://codebase64.org/doku.php?id=base:cpu_clocking),
	// is clocked at 0.985248 MHz, so that 1/60s is 16421 CPU cycles

	ldy #<16421
	ldx #>16421

	sty CIA1_TIMALO
	stx CIA1_TIMAHI

	lda #$01
!:
	sta TVSFLG

cont_done:
	rts
