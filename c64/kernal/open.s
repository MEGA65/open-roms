
;;
;; Official Kernal routine, described in:
;;
;; - [RG64] C64 Programmer's Reference Guide   - page 289
;; - [CM64] Compute's Mapping the Commodore 64 - page 230/231
;;
;; CPU registers that has to be preserved (see [RG64]): none
;;

;; XXX this is only a test implementation, does not do what the Kernal does!

open:

	;; LAT / FAT / SAT support implemented according to
	;; 'Compute's Mapping the Commodore 64', page 52

	;; Check if we have space in tables

	ldy LDTND
	cpy #$0A
	bcs +
	bmi open_has_space
*
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

	;; Part implemented according to https://www.pagetable.com/?p=1031, https://github.com/mist64/cbmbus_doc
	;; XXX note: this is only a temporary test implementation, real 'open' does not send anything to IEC,
	;; see http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf

	;; Request device to talk
	lda current_device_number
	jsr talk
	bcs open_iec_error

	;; Send secondary address
	lda current_secondary_address
	jsr second
	bcs open_iec_error

	;; Turnaround
	jsr iec_turnaround_to_listen
	bcs open_iec_error

	;; Indicate success
	lda #$00
	clc

open_iec_error:
	;; Carry flag will be set by low-level routines
	rts
