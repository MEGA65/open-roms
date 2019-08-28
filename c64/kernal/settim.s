
;;
;; Official Kernal routine, described in:
;;
;; - [RG64] C64 Programmer's Reference Guide   - page 299/300
;; - [CM64] Compute's Mapping the Commodore 64 - page 232
;;
;; CPU registers that has to be preserved (see [RG64]): .A, .X, .Y
;;

settim:

	;; Disable interrupts for the duration of the routine, to prevent
	;; jiffy clock update while changing it's values
	php
	sei

	;; Store the jiffy clock state
	sty TIME + 0
	stx TIME + 1
	sta TIME + 2

	;; Restore processor state and return
	plp
	rts

