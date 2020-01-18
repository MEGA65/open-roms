#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Values for IRQ generation timer - original idea was:
//
// (This value was calculated by running a custom IRQ handler on a C64
// with original KERNAL, and writing the values of $DC04/5 to the screen
// in the IRQ handler to see roughly what value the timers must be set to)
// ldy #<16380
// ldx #>16380

// Current values selected on the following assumptions:
//
// PAL C64 (https://codebase64.org/doku.php?id=base:cpu_clocking),
// is clocked at 0.985248 MHz, so that 1/60s is 16421 ($4025) CPU cycles
//
// NTSC C64 (https://codebase64.org/doku.php?id=base:cpu_clocking),
// is clocked at 1.022727 MHz, so that 1/60s is 17045 ($4295) CPU cycles


irq_timing_lo:                         // low bytes

	.byte <17045                       // NTSC
	.byte <16421                       // PAL


#endif // ROM layout