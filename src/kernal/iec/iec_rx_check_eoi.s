;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Helper routine to check for EOI while receiving byte from IEC
;

!ifdef CONFIG_IEC {


iec_rx_check_eoi:

	; Wait for talker to pull CLK.
	; If over 200 usec (205 cycles on NTSC machine) , then it is EOI.
	; Loop iteraction takes 11 cycles, 19 full iterations are enough

	ldx #$13                           ; 2 cycles
@1:
	bit CIA2_PRA                       ; 4 cycles
	bvc iec_rx_check_eoi_done          ; 2 cycles if not jumped
	dex                                ; 2 cycles
    bne @1                             ; 3 cycles if jumped

    ; FALLTROUGH

iec_rx_check_eoi_confirm:

	; Timeout - either this is the last byte of stream, or the stream is empty at all.
	; Mark end of stream in IOSTATUS
	jsr kernalstatus_EOI

	; Pull data for 60 usec to confirm it
	jsr iec_release_clk_pull_data
	jsr iec_wait60us
	jsr iec_release_clk_data

iec_rx_check_eoi_done:

	rts
}
