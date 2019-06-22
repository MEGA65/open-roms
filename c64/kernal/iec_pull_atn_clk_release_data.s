
iec_pull_atn_clk_release_data:

	;; Pulled CLK = DATA considered invalid; for extra robustness on non-emulated
	;; hardware give some lines few more cycles to stabilize; see page 10 of
	;; http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf

	lda CI2PRA
	ora #BIT_CI2PRA_ATN_OUT          ; pull
	sta CI2PRA
	ora #BIT_CI2PRA_CLK_OUT          ; pull
	sta CI2PRA
	and #$FF - BIT_CI2PRA_DAT_OUT    ; release
	sta CI2PRA
	rts
