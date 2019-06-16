	; Function defined on pp272-273 of C64 Programmers Reference Guide
	;; See also http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf


open:

	;; LAT / FAT / SAT support implemented according to
	;; 'Compute's Mapping the Commodore 64', page 52

	;; Check if we have space in tables

	ldy LDTND
	cpy #$0A
	bcs +
	bmi open_has_space
*
	jsr printf
	.byte "FULL", $0D, 0

	;; Table is full - according to https://codebase64.org/doku.php?id=base:kernalreference
	;; C flag set means error occured
	sec
	rts

open_has_space:

	;; Update the tables

	lda current_logical_filenum
	sta LAT, y
	lda current_device_number
	sta FAT, y
	lda current_secondary_address
	sta SAT, y

	iny
	sty LDTND

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
	lda current_device_number
	jsr listen
	bcs open_iec_error

	;; Indicate success
	lda #$00
	clc	

open_iec_error:
	;; Re-enable interrupts and return
	;; (iec_tx_byte will have set/cleared C flag and put result code
	;; in A if it was an error).
	cli
	rts
