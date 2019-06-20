
iec_wait20us:

	;; Wait 20usec

	;; PAL:
	;; - CPU frequency 0.985248 MHz, we need to waste at least 21 cycles
	;; NTSC:
	;; - CPU frequency 1.022727 MHZ, we need to waste at least 20 cycles

	;; Waste cycles by reading some unimportant memory location
	;; in order not to clutter VICE debug logs

	ora $03FF    ; 4 cycles
	ora $03FF    ; 4 cycles
	rts          ; 6 cycles

	;;   6 cycles JSR to routine, 
    ;;  14 cycles routine with RTS
    ;;   1 cycle to fetch next instruction
    ;; ---
    ;;  21 cycles
