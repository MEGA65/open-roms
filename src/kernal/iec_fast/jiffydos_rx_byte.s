;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; JiffyDOS protocol support for IEC - byte reception
;


!ifdef CONFIG_IEC_JIFFYDOS {


jiffydos_rx_byte:

	; Timing is critical, do not allow interrupts
	sei

	; Store .X and .Y on the stack - preserve them
	+phx_trash_a
	+phy_trash_a

	; Store previous sprite status on stack
	jsr jiffydos_prepare
	pha

	; Wait until device is ready to send (releases CLK)
	jsr iec_wait_for_clk_release

	; Prepare 'start sending' message
	lda CIA2_PRA
	and #$FF - BIT_CIA2_PRA_DAT_OUT    ; release
	tax

	; Wait for appropriate moment
	jsr jiffydos_wait_line

	; Ask device to start sending bits
	stx CIA2_PRA                       ; cycles: 4

	; Prepare 'data pull' byte, cycles: 3 + 2 + 2 = 7
	lda C3PO
	ora #BIT_CIA2_PRA_DAT_OUT          ; pull
	tax

	; Delay, JiffyDOS needs some time, 4 cycles
	+nop
	+nop

	; Get bits, cycles: 4 + 2 + 2 = 8
	lda CIA2_PRA                       ; bits 0 and 1 on CLK/DATA
	lsr
	lsr

	; Wait for the drive, cycles: 2
	+nop

	; Get bits, cycles: 4 + 2 + 2 = 8
	ora CIA2_PRA                       ; bits 2 and 3 on CLK/DATA
	lsr
	lsr

	; Get bits, cycles: 3 + 4 + 2 + 2 = 11
	eor C3PO
	eor CIA2_PRA                       ; bits 4 and 5 on CLK/DATA
	lsr
	lsr

	; Get bits, cycles: 3 + 4 = 7
	eor C3PO
	eor CIA2_PRA                       ; bits 6 and 7 on CLK/DATA

	; Preserve read byte, cycles: 3
	sta TBTCNT ; $A4 is a byte buffer according to http://sta.c64.org/cbm64mem.html

	; Delay, JiffyDOS needs some time; for PAL one NOP would be enough,
	; but NTSC machines are clocked slightly faster; cycles: 4
	+nop
	+nop

	; Retrieve status bits, cycles: 4
	bit CIA2_PRA

	; Pull DATA at the end, cycles: 4
	stx CIA2_PRA

	; If CLK line active - success
	bvc jiffydos_rx_byte_end

	; EOI or error, released DATA (highest byte set to 1) means error - see protocol analysis by Michael Steil, step R7a
	lda CIA2_PRA
	bmi jiffydos_rx_byte_error

	; EOI - no error
	jsr kernalstatus_EOI

	; FALLTROUGH

jiffydos_rx_byte_end:

	; Indicate that no byte waits in output buffer
	lda #$00
	sta C3PO

	; Restore proper IECPROTO value
	lda #IEC_JIFFY
	sta IECPROTO

	; Re-enable sprites
	pla
	sta VIC_SPENA

	; End byte reception
	jmp iec_rx_end

jiffydos_rx_byte_error:

	jsr kernalerror_IEC_TIMEOUT_READ
	bcs jiffydos_rx_byte_end           ; branch always
}
