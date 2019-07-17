
;;
;; Official Kernal routine, described in:
;;
;; - [RG64] C64 Programmer's Reference Guide   - page 275
;; - [CM64] Compute's Mapping the Commodore 64 - page 229
;;
;; CPU registers that has to be preserved (see [RG64]): .Y
;;

chkin:

	;; Implemented according to 'C64 Programmers Reference Guide', page 277

	;; First retrieve the FAT/LAT/SAT table index (and check if file is open)

	; txa
	; jsr find_fls
	; bcs kernalerror_FILE_NOT_OPEN

	;; Now we have table index in Y - check if file is open for reading

	;; XXX continue implementation

	rts


