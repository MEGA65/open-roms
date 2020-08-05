// #LAYOUT# STD *       #TAKE
// #LAYOUT# X16 *       #IGNORE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Initialize random seed, afterwards generate random number in FAC1,
// try to gather as much entropy from different sources as possible
//

rnd_seed_init:

	eor CIA1_TIMALO                    // timer used for IRQ generation, use potential entropy from .A
	sta RNDX+3

	txa                                // .X might contain some entropy
	eor VIC_RASTER                     // lowest 8 bits of current raster line
	sta RNDX+1

	tya                                // .Y might contain some entropy
	eor CIA1_TIMAHI
	sta RNDX+4

	lda TIME+2                         // byte from jiffy counter might be useful too
	eor SID_RANDOM                     // not sure if SID set correctly, but it will not hurt
#if CONFIG_MB_MEGA_65
	eor VIC_XPOS                       // not sure if VIC-IV visible, but it will not hurt
#endif
	sta RNDX+2

	// RNDX+0 will be overwritten by generator

	jmp rnd_generate
