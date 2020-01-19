// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Prepare CIA timers for tape reading
//

//
// Checked under VICE, PAL, average of 256 pulses:
//
//     normal - short  - timer goes down to $A5
//     normal - medium - timer goes down to $7D
//     normal - long   - timer goes down to $52
//
//     turbo  - short  - timer goes down to $CD
//     turbo  - long   - timer goes down to $B1
//
//
// Measurement subroutine: .A should contain timer value, $C000-$C002 zeroed
//
//        clc
//        adc $C001
//        sta $C001
//        bcc !+
//        inc $C000
//    !:
//	      inc $C002
//	      beq !+
//	      rts
//    !:
//	      lda $C000
//	  .break         // .A contains our average
//        rts
//

#if CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO


tape_common_prepare_cia:

	// Setup CIA #2 timers
	
	ldx #$03                           // set timer A to 4 ticks
	stx CIA2_TIMALO // $DD04
	ldx #$00
	stx CIA2_TIMAHI // $DD05

	stx CIA2_TIMBHI // $DD07
	dex                                // puts $FF - for running timer B as long as possible
	stx CIA2_TIMBLO // $DD06

	// Let timer A run continuously

	ldx #%00010001                     // start timer, force latch reload
	stx CIA2_CRA    // $DD0E

	rts

#endif
