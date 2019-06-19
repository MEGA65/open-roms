

;; XXX - TEMPORARY IMPLEMENTATION

;; https://www.pagetable.com/?p=1135, https://github.com/mist64/cbmbus_doc
;; https://www.c64-wiki.com/wiki/CIA#CIA_2

.alias CI2PRA $DD00

.alias BIT_IEC_ATN_OUT $08    ; 1 - low (pulled), 0 - high (released)
.alias BIT_IEC_CLK_OUT $10    ; 1 - low (pulled), 0 - high (released)
.alias BIT_IEC_DAT_OUT $20    ; 1 - low (pulled), 0 - high (released)
.alias BIT_IEC_CLK_IN  $40    ; 0 - low (pulled), 1 - high (released)
.alias BIT_IEC_DAT_IN  $80    ; 0 - low (pulled), 1 - high (released)


; XXX optimize these below

xxx_to_idle_state:
	lda CI2PRA
	ora #BIT_IEC_CLK_OUT                            ; pull
	and #$FF - BIT_IEC_DAT_OUT - BIT_IEC_ATN_OUT    ; release
	sta CI2PRA
	rts

xxx_pull_atn_clk_release_data:
	lda CI2PRA
	ora #BIT_IEC_ATN_OUT + BIT_IEC_CLK_OUT    ; pull
	and #$FF - BIT_IEC_DAT_OUT                ; release
	sta CI2PRA
	rts

xxx_pull_clk_release_data:
	lda CI2PRA
	ora #BIT_IEC_CLK_OUT          ; pull
	and #$FF - BIT_IEC_DAT_OUT    ; release
	sta CI2PRA
	rts

xxx_release_clk_data:
	lda CI2PRA
	and #$FF - BIT_IEC_CLK_OUT - BIT_IEC_DAT_OUT    ; release
	sta CI2PRA
	rts

xxx_release_clk_pull_data:
	lda CI2PRA
	and #$FF - BIT_IEC_CLK_OUT    ; release
	ora #BIT_IEC_DAT_OUT          ; pull
	sta CI2PRA
	rts

xxx_wait_for_data_release:
	lda CI2PRA
	;; Check the highest bit, which is DATA IN,
	;; (highest bit set = negative value)
	bpl xxx_wait_for_data_release
	rts



iec_tx_command:

	pha

	;; Notify all devices that we are going to send a byte
	;; and it is going to be a command (pulled ATN)
	jsr xxx_pull_atn_clk_release_data

	;; Give devices time to respond (response is mandatory!)
	jsr wait1ms

	;; Did at least one device respond by pulling DATA?
	lda CI2PRA
	and #BIT_IEC_DAT_IN
	beq +

	;; No devices present on the bus, so we can immediately return with device not found
	pla

	jsr printf
	.byte "DBG: NO DEVICES AT ALL", $0D, 0

	jsr xxx_to_idle_state
	jmp kernalerror_DEVICE_NOT_FOUND
*
	;; At least one device responded, but they are still allowed to stall
	;; (can be busy processing something), we have to wait till they are all
	;; ready (or bored with DOS attack...)
	;; - release back CLK, keep DATA released
	;; - afterwards wait till all devices also release DATA

	jsr xxx_release_clk_data
	jsr xxx_wait_for_data_release

	;; Pull CLK back to indicate that DATA is not valid, keep it for 60us
	;; Don't wait too long, as 200us or more is considered EOI

	jsr xxx_pull_clk_release_data
	jsr iec_wait60us

	;; Now, we can start transmission of 8 bits of data
	ldx #7
	pla

iec_tx_command_nextbit:
	;; Is next bit 0 or 1?
	lsr
	pha
	bcs +

	;; Bit is 0
	jsr xxx_release_clk_pull_data
	jmp iec_tx_command_bitset
*
	;; Bit is 1
	jsr xxx_release_clk_data
	
iec_tx_command_bitset:

	;; Wait 20us, so that device(s) can pick DATA
	jsr iec_wait20us

	;; Pull CLK for 20us again
	jsr xxx_pull_clk_release_data
	jsr iec_wait20us

	;; More bits to send?
	pla
	dex
	bpl iec_tx_command_nextbit

	;; XXX the flow below is REALLY dangerous, as if there are multiple devices,
	;; one can signal that it's busy much earlier (more than 100ms) than the other.
	;; Can we do something about it?

	;; All done - give devices time to tell if they are busy by pulling DATA
	;; They should do it within 1ms
	ldx #$FF
*	lda CI2PRA
	;; BPL here is checking that bit 7 of $DD00 clears,
	;; i.e, that the DATA line is pulled by drive
	bpl +
	dex
	bne -
	bpl iec_tx_command_done
*
	;; XXX wait 100ms
	
iec_tx_command_done:

	clc
	rts
