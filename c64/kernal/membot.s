
;;
;; Official Kernal routine, described in:
;;
;; - [RG64] C64 Programmer's Reference Guide   - page 287/288
;; - [CM64] Compute's Mapping the Commodore 64 - page 240
;;
;; CPU registers that has to be preserved (see [RG64]): .A
;;

membot:

	bcc membot_set
	
	ldx MEMSTR+0
	ldy MEMSTR+1
	rts

membot_set:

	stx MEMSTR+0
	stx MEMSTR+1
	
	rts
