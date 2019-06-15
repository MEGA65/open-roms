	; Function defined on pp272-273 of C64 Programmers Reference Guide
	;; See also http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf


open:

	;; Kernal API is shared between several types of devices - we have
	;; to dispatch the call to appropriate subroutine

	lda current_device_number
	beq open_keyboard
	cmp #$01
	beq open_tape
	cmp #$02
	beq open_rs232
	cmp #$03
	beq open_screen
	cmp #$1F
	bcs +
	bmi open_iec
*
	;; Device numbers over 30 are not allowed on IEC bus

	;; FALLTHROUGH to error routine

open_keyboard:
open_tape:
open_screen:

	;; XXX implement support for these devices
	lda #$05 ; device not present
	sta IOSTATUS
	rts
	
open_rs232:

	;; XXX implement support for RS-232
	lda #$FF ; set every single error bit to discourage using RS-232
	sta RSSTAT
	rts

open_iec:

	;; XXX add FILENAM support, test it

	;; Sequence is:
	;; 1. Call current device to attention as LISTENER = $20 + device
	;; 2. 

	;; Disable IRQs, since timing matters!
	sei

	;; Begin sending under attention
	jsr iec_assert_atn

	;; CLK is now asserted, and we are ready to transmit a byte
	lda #$20 ; listen
	clc
	adc current_device_number
	jsr iec_tx_byte
	bcs open_error

	;; Indicate success
	lda #$00
	clc	

open_error:
	;; Re-enable interrupts and return
	;; (iec_tx_byte will have set/cleared C flag and put result code
	;; in A if it was an error).
	cli
	rts
