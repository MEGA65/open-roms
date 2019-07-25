
;;
;; Official Kernal routine, described in:
;;
;; - [RG64] C64 Programmer's Reference Guide   - page 296
;; - [CM64] Compute's Mapping the Commodore 64 - page 223/224
;; - https://www.pagetable.com/?p=1031, , https://github.com/mist64/cbmbus_doc
;;
;; CPU registers that has to be preserved (see [RG64]): .X, .Y
;;


second:

	;; Due to TKSA/SECOND command encoding (see https://www.pagetable.com/?p=1031),
	;; allowed channels are 0-15; report error if out of range
	cmp #$10
	bcs kernalerror_FILE_NOT_INPUT

	ora #$60

	jmp common_unlsn_second

