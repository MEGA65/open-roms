
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

	lda #$01
	skip_2_bytes_trash_nvz

	// FALLTROUGH

setup_ntsc:

	lda #$00

	// FALLTROUGH

setup_pal_ntsc_end:

	sta TVSFLG

	// FALLTROUGH

setup_irq_timer: // entry point needed by UP9600 and CIA1 burst mod support

	// Sets up IRQ timer in CIA1 to ~1/60th of a second,
	// depending on the detected video system

	// Retrieve video system (0 - NTSC, 1 - PAL), assume PAL for unknown values

	ldx TVSFLG
	beq !+
	ldx #$01
!:
	// Setup interval for timer A in CIA1

	lda irq_timing_lo, x
	sta CIA1_TIMALO                    // $DC04
	lda irq_timing_hi, x
	sta CIA1_TIMAHI                    // $DC05

	rts
