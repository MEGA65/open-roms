
;;
;; Official Kernal routine, described in:
;;
;; - [RG64] C64 Programmer's Reference Guide   - page 281
;; - [CM64] Compute's Mapping the Commodore 64 - page 230
;;
;; CPU registers that has to be preserved (see [RG64]): .Y
;;

;; XXX currently does not preserve register Y, to be fixed!

clall:

	;; Original routine probably just sets LDTND to 0, but this is not really safe,
	;; so we actually close all the channels; at least IDE64 does the same for
	;; it's channels, see CLALL description in the IDE64 User's Guide

	ldy LDTND
	beq +
	dey
	lda LAT, y
	jsr close ; XXX jump through ICLOSE?
	jmp clall
*
	;; 'C64 Programmers Reference Guide', page 281, claims it calls CLRCHN too
	jmp clrchn
