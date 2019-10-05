
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 280
// - [CM64] Compute's Mapping the Commodore 64 - page 242
//
// CPU registers that has to be preserved (see [RG64]): none
//


cint_real:

	// According to [CM64], this routine checks for PAL/NTSC. It's definitely not done
	// within the 'BRK' part, this can be easily checked - POKE something
	// to address 678 on a real C64, press STOP+RESTORE, the value won't change

	// Detect video system (PAL/NTSC), use Graham's method, as it's short and reliable
	// see here: https://codebase64.org/doku.php?id=base:detect_pal_ntsc

	lda #$C8 // preparation, as the VIC might be uninitialized
	sta VIC_SCROLX

cint_w0:
	lda VIC_RASTER
cint_w1:
	cmp VIC_RASTER
	beq cint_w1
	bmi cint_w0

	// Result in A, if no interrupt happened during the test:
	// #$37 -> 312 rasterlines, PAL,  VIC 6569
	// #$06 -> 263 rasterlines, NTSC, VIC 6567R8
	// #$05 -> 262 rasterlines, NTSC, VIC 6567R56A

	cmp #$07
	bcs cint_pal

cint_ntsc:

	// NTSC C64 (https://codebase64.org/doku.php?id=base:cpu_clocking),
	// is clocked at 1.022727 MHz, so that 1/60s is 17045 CPU cycles

	ldy #<17045
	ldx #>17045

	sty CIA1_TIMALO
	stx CIA1_TIMAHI

	lda #$00
	beq !+

cint_pal:

	lda #$01
!:
	sta TVSFLG

	// Setup KEYLOG vector - XXX is it proper place?

	lda #<setup_keydecode
	sta KEYLOG+0
	lda #>setup_keydecode
	sta KEYLOG+1

cint_brk: // entry for BRK and STOP+RESTORE - XXX, where should it start?

	jsr setup_vicii

	// Initialise cursor blink flags  (Compute's Mapping the 64 p215)
	lda #$00
	sta BLNSW

	// Set keyboard decode vector  (Compute's Mapping the 64 p215)

	// Set initial variables for our improved keyboard scan routine
	lda #$FF
	ldx #6
!:	sta BufferOld,x
	dex
	bpl !-
	sta BufferQuantity
	
	// Set key repeat delay (Compute's Mapping the 64 p215)
	// Making some numbers up here: Repeat every ~1/10th sec
	// But require key to be held for ~1/3sec before
	// repeating (Compute's Mapping the 64 p58)
	ldx #22-2 		// Fudge factor to match speed
	stx DELAY

	// Set current colour for text (Compute's Mapping the 64 p215)
	ldx #$01     // default is light blue ($0E), but we use a different one
	stx COLOR

	// Set maximum keyboard buffer size (Compute's Mapping the 64 p215)
	ldx #10
	stx XMAX
	// Put non-zero value in MODE to enable case switch
	stx MODE
	
	// Set default I/O devices (see SCINIT description at http://sta.c64.org/cbm64krnfunc.html)
	jsr clrchn_reset

	// Fallthrough/jump to screen clear routine (Compute's Mapping the 64 p215)
	jmp clear_screen
