; Function defined on pp272-273 of C64 Programmers Reference Guide

chkout:

	;; Implemented according to 'C64 Programmers Reference Guide', page 278

	;; First retrieve the FAT/LAT/SAT table index (and check if file is open)

	; txa
	; jsr find_fls
	; bcs kernalerror_FILE_NOT_OPEN

	;; Now we have table index in Y - check if file is open for writing

	;; XXX continue implementation

	rts
