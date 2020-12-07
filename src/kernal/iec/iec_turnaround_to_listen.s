;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

; According to http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
; pages 7--8.
; See also https://www.pagetable.com/?p=1135, https://github.com/mist64/cbmbus_doc


!ifdef CONFIG_IEC {


iec_turnaround_to_listen:

	; Store .X and .Y on the stack - preserve them
	+phx_trash_a
	+phy_trash_a

	; Timing is critical here - execute on disabled IRQs
	php
	sei

!ifdef CONFIG_MB_M65 {
	; If in native mode, switch to 1 MHz
	jsr m65_iec_slow
}

	; Pull DATA, release CLK and ATN (we are not sending commands)
	jsr iec_pull_data_release_atn_clk

	; Wait for clock line to be pulled by the drive
	ldx #$FF ; XXX should we really use that high number?
@1:
	lda CIA2_PRA
	rol    ; to put BIT_CIA2_PRA_CLK_IN as the last (sign) bit 
	bpl @2
	dex
	bne @1

	; Timeout - XXX what errors do original Kernal report?
	plp
	jmp iec_return_DEVICE_NOT_FOUND

	; CLK is pulled by the device, OK
@2:
	plp
	jmp iec_return_success
}
