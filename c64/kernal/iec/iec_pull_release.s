// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Helper IEC routines to pull/release certain lines
//
// Order of operation is set for extra robustness, on non-emulated hardware
// lines might need few cycles to stabilize (released CLK = DATA considered valid),
// see page 10 of http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
//



#if CONFIG_IEC


iec_pull_atn_clk_release_data:

	lda CIA2_PRA
	ora #BIT_CIA2_PRA_ATN_OUT          // pull
	sta CIA2_PRA
	
	// FALLTROUGH

iec_pull_clk_release_data:

	lda CIA2_PRA
	ora #BIT_CIA2_PRA_CLK_OUT          // pull
	sta CIA2_PRA
!:
	and #$FF - BIT_CIA2_PRA_DAT_OUT    // release
	bne iec_pull_release_end           // branch always

iec_pull_clk_release_data_oneshot:

	lda CIA2_PRA
	ora #BIT_CIA2_PRA_CLK_OUT          // pull
	bne !-                             // branch always

iec_release_atn_clk_data:

	lda CIA2_PRA
	and #$FF - BIT_CIA2_PRA_ATN_OUT    // release
	sta CIA2_PRA
	
	// FALLTROUGH
	
iec_release_clk_data:

	lda CIA2_PRA
	and #$FF - BIT_CIA2_PRA_DAT_OUT    // release
	sta CIA2_PRA
	and #$FF - BIT_CIA2_PRA_CLK_OUT    // release
	jmp iec_pull_release_end
	
iec_release_clk_pull_data:

	lda CIA2_PRA
	ora #BIT_CIA2_PRA_DAT_OUT          // pull
	sta CIA2_PRA
	and #$FF - BIT_CIA2_PRA_CLK_OUT    // release
	bne iec_pull_release_end           // branch always

iec_pull_data_release_atn_clk:

	lda CIA2_PRA
	ora #BIT_CIA2_PRA_DAT_OUT          // pull
	sta CIA2_PRA
	and #$FF - BIT_CIA2_PRA_CLK_OUT    // release
	sta CIA2_PRA
	
	// FALLTROUGH

iec_release_atn:

	lda CIA2_PRA
	and #$FF - BIT_CIA2_PRA_ATN_OUT    // release

	// FALLTROUGH

iec_pull_release_end:

	sta CIA2_PRA
	rts


#endif // CONFIG_IEC
