;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Official Kernal routine, described in:
;
; - [RG64] C64 Programmers Reference Guide   - page 289
; - [CM64] Computes Mapping the Commodore 64 - page 230/231
;
; CPU registers that has to be preserved (see [RG64]): none
;


OPEN:

	; Reset status
	jsr kernalstatus_reset

	; Check if the logical file number is unique
	ldy LDTND
@1:
	beq @3
	dey
	lda LAT, y
	cmp LA
	bne @2
	jmp kernalerror_FILE_ALREADY_OPEN

@2: ; not yet open

	cpy #$00
	jmp @1
@3:
	; Check if we have space in tables

	ldy LDTND
	cpy #$0A
	bcc open_has_space

	; Table is full
	jmp kernalerror_TOO_MANY_OPEN_FILES

open_has_space:

	; Update the tables

	; LAT / FAT / SAT support implemented according to
	; 'Computes Mapping the Commodore 64', page 52

	lda LA
	sta LAT, y
	lda FA
	sta FAT, y
	lda SA
	sta SAT, y

	iny
	sty LDTND

	lda FA

!ifdef HAS_RS232 {

	cmp #$02
	+beq open_rs232
}

!ifdef CONFIG_IEC {

	jsr iec_check_devnum_oc
	+bcc open_iec
}	
	; FALLTROUGH

open_done_success:

	clc
	rts
