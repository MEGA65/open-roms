
;;
;; Official Kernal routine, described in:
;;
;; - [RG64] C64 Programmer's Reference Guide   - page 289
;; - [CM64] Compute's Mapping the Commodore 64 - page 230/231
;;
;; CPU registers that has to be preserved (see [RG64]): none
;;

;; XXX send the name to the drive (if it's length is non-zero)

open:

	;; Reset status
	jsr kernalstatus_reset

	;; Check if the logical file number is unique
	ldy LDTND
*
	beq +
	dey
	lda LAT, y
	cmp current_logical_filenum
	beq kernalerror_FILE_ALREADY_OPEN
	cpy #$00
	jmp -
*
	;; Check if we have space in tables

	ldy LDTND
	cpy #$0A
	bcc open_has_space
*
	;; Table is full
	jmp kernalerror_TOO_MANY_OPEN_FILES

open_has_space:

	;; Update the tables

	;; LAT / FAT / SAT support implemented according to
	;; 'Compute's Mapping the Commodore 64', page 52

	lda current_logical_filenum
	sta LAT, y
	lda current_device_number
	sta FAT, y
	lda current_secondary_address
	sta SAT, y

	iny
	sty LDTND
	
	clc
	rts

