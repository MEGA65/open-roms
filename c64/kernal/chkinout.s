
;;
;; Official Kernal routines, described in:
;;
;; - [RG64] C64 Programmer's Reference Guide   - page 275 (CHKIN) / 276 (CHKOUT)
;; - [CM64] Compute's Mapping the Commodore 64 - page 229
;;
;; CPU registers that has to be preserved (see [RG64]): .Y
;;


;; CHKIN implementation

chkin:

	;; Store Y for preservation
	tya
	pha

	;; Reset status
	jsr kernalstatus_reset

	;; First retrieve the FAT/LAT/SAT table index (and check if file is open)

	txa
	jsr find_fls
	bcs chkinout_file_not_open

	;; Now we have table index in Y - first filter out unsuitable devices

	lda FAT,Y
	cmp #$01
	beq chkinout_device_not_present ; tape not implemented
	cmp #$02
	beq chkinout_device_not_present ; RS-232 not implemented

	;; Fail if the file is open for writing (secondary address 1)
	
	lda LAT, Y
	cmp #$01
	beq chkinout_file_not_input

	;; For IEC devices, send TALK first
	lda FAT,Y
	jsr iec_devnum_check
	bcs chkin_set_device

	jsr talk
	bcs chkinout_end ; don't set DFLTN in case of failure

chkin_set_device:
	lda FAT,Y
	sta DFLTN
	clc ; for success
	;; FALLTROUGH

;; Common part for booth CHKIN and CHKOUT

chkinout_end:
	pla
	tay
	rts

chkinout_file_not_open:
	pla
	tay
	jmp kernalerror_FILE_NOT_OPEN

chkinout_device_not_present:
	pla
	tay
	jsr kernalstatus_DEVICE_NOT_FOUND
	jmp kernalerror_DEVICE_NOT_FOUND

chkinout_file_not_input:
	pla
	tay
	jmp kernalerror_FILE_NOT_INPUT

chkinout_file_not_output:
	pla
	tay
	jmp kernalerror_FILE_NOT_OUTPUT

chkinout_common:

;; CHKOUT implementation

chkout:

	;; Store Y for preservation
	tya
	pha

	;; Reset status
	jsr kernalstatus_reset

	;; First retrieve the FAT/LAT/SAT table index (and check if file is open)

	txa
	jsr find_fls
	bcs chkinout_file_not_open

	;; Now we have table index in Y - first filter out unsuitable devices

	lda FAT,Y
	cmp #$01
	beq chkinout_device_not_present ; tape not implemented
	cmp #$02
	beq chkinout_device_not_present ; RS-232 not implemented

	cmp #$00
	beq chkinout_file_not_output ; cannot output to keyboard - XXX check real ROM behaviour

	;; Fail if the file is open for reading (secondary address 0)
	
	lda LAT, Y
	beq chkinout_file_not_output

	;; For IEC devices, send LISTEN first
	lda FAT,Y
	jsr iec_devnum_check
	bcs chkin_set_device

	jsr listen
	bcs chkinout_end ; don't set DFLTO in case of failure

chkout_set_device:
	lda FAT,Y
	sta DFLTO
	clc ; for success

	jmp chkinout_end
