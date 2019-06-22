
iec_release_atn_clk_data:

	;; Released CLK = DATA considered valid; for extra robustness on non-emulated
	;; hardware give some lines few more cycles to stabilize; see page 10 of
	;; http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf

	lda CI2PRA
	and #$FF - BIT_CI2PRA_ATN_OUT    ; release
	sta CI2PRA
	and #$FF - BIT_CI2PRA_DAT_OUT    ; release
	sta CI2PRA
	and #$FF - BIT_CI2PRA_CLK_OUT    ; release
	sta CI2PRA
	rts

