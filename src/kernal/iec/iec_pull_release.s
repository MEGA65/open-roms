;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Helper IEC routines to pull/release certain lines
;
; Order of operation is set for extra robustness, on non-emulated hardware
; lines might need few cycles to stabilize (released CLK = DATA considered valid),
; see page 10 of http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
;



!ifdef CONFIG_IEC {

!ifndef HAS_OPCODES_65C02 {


iec_pull_atn_clk_release_data:

	lda CIA2_PRA
	ora #BIT_CIA2_PRA_ATN_OUT          ; pull
	sta CIA2_PRA

	; FALLTROUGH

iec_pull_clk_release_data:

	lda CIA2_PRA
	ora #BIT_CIA2_PRA_CLK_OUT          ; pull
	sta CIA2_PRA

	; FALLTROUGH

iec_pull_clk_release_data_1:

	and #$FF - BIT_CIA2_PRA_DAT_OUT    ; release
	bne iec__pull_release_end          ; branch always

iec_pull_clk_release_data_oneshot:

	lda CIA2_PRA
	ora #BIT_CIA2_PRA_CLK_OUT          ; pull
	bne iec_pull_clk_release_data_1    ; branch always

iec_release_atn_clk_data:

	lda CIA2_PRA
	and #$FF - BIT_CIA2_PRA_ATN_OUT    ; release
	sta CIA2_PRA
	
	; FALLTROUGH
	
iec_release_clk_data:

	lda CIA2_PRA
	and #$FF - BIT_CIA2_PRA_DAT_OUT    ; release
	sta CIA2_PRA
	and #$FF - BIT_CIA2_PRA_CLK_OUT    ; release
	+bra iec__pull_release_end
	
iec_release_clk_pull_data:

	lda CIA2_PRA
	ora #BIT_CIA2_PRA_DAT_OUT          ; pull
	sta CIA2_PRA
	and #$FF - BIT_CIA2_PRA_CLK_OUT    ; release
	bne iec__pull_release_end          ; branch always

iec_pull_data_release_atn_clk:

	lda CIA2_PRA
	ora #BIT_CIA2_PRA_DAT_OUT          ; pull
	sta CIA2_PRA
	and #$FF - BIT_CIA2_PRA_CLK_OUT    ; release
	sta CIA2_PRA
	
	; FALLTROUGH

iec_release_atn:

	lda CIA2_PRA
	and #$FF - BIT_CIA2_PRA_ATN_OUT    ; release

	; FALLTROUGH

iec__pull_release_end:

	sta CIA2_PRA
	rts


} else {


	; 65C02 version

iec_pull_atn_clk_release_data:

	lda #BIT_CIA2_PRA_ATN_OUT
	tsb CIA2_PRA

	; FALLTROUGH

iec_pull_clk_release_data:

	lda #BIT_CIA2_PRA_CLK_OUT
	tsb CIA2_PRA
	lda #BIT_CIA2_PRA_DAT_OUT
	bra iec__pull_release_trb

iec_pull_clk_release_data_oneshot:

	lda CIA2_PRA
	ora #BIT_CIA2_PRA_CLK_OUT          ; pull
	and #$FF - BIT_CIA2_PRA_DAT_OUT    ; release
	sta CIA2_PRA
	rts

iec_release_atn_clk_data:

	lda #BIT_CIA2_PRA_ATN_OUT
	trb CIA2_PRA

	; FALLTROUGH

iec_release_clk_data:

	lda #BIT_CIA2_PRA_DAT_OUT
	trb CIA2_PRA
	bra iec__release_clk

iec_release_clk_pull_data:

	lda #BIT_CIA2_PRA_DAT_OUT
	tsb CIA2_PRA

	; FALLTROUGH

iec__release_clk:

	lda #BIT_CIA2_PRA_CLK_OUT
	bra iec__pull_release_trb

iec_pull_data_release_atn_clk:

	lda #BIT_CIA2_PRA_DAT_OUT
	tsb CIA2_PRA
	lda #(BIT_CIA2_PRA_CLK_OUT + BIT_CIA2_PRA_ATN_OUT)
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

iec_release_atn:

	lda #BIT_CIA2_PRA_ATN_OUT

	; FALLTROUGH

iec__pull_release_trb:

	trb CIA2_PRA
	rts


}

}
