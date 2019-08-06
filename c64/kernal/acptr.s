
;;
;; Official Kernal routine, described in:
;;
;; - [RG64] C64 Programmer's Reference Guide   - page 274
;; - [CM64] Compute's Mapping the Commodore 64 - page 224/225
;;
;; CPU registers that has to be preserved (see [RG64]): .Y
;;


acptr:
	jsr kernalstatus_reset
	jmp iec_rx_byte

