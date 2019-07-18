
iec_release_atn_clk_data:

	;; Released CLK = DATA considered valid; for extra robustness on non-emulated
	;; hardware give some lines few more cycles to stabilize; see page 10 of
	;; http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf

	lda CIA2_PRA
	and #$FF - BIT_CIA2_PRA_ATN_OUT    ; release
	sta CIA2_PRA
	and #$FF - BIT_CIA2_PRA_DAT_OUT    ; release
	sta CIA2_PRA
	and #$FF - BIT_CIA2_PRA_CLK_OUT    ; release
	sta CIA2_PRA
	rts

