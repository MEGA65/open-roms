
iec_wait100us:	

	;; Wait 100usec

	;; PAL:
	;; - CPU frequency 0.985248 MHz, we need to waste at least  99 cycles
	;; NTSC:
	;; - CPU frequency 1.022727 MHZ, we need to waste at least 103 cycles

	;; Waste cycles by reading some unimportant memory location
	;; (in a loop) in order not to clutter VICE debug logs

	;; Waste cycles in a loop

	ldy #$12   ; 2 cycles
*	dey        ; 2 cycles * 18
	bpl -      ; 3 cycles * 17 + 2 cycles
	rts        ; 6 cycles

	;;   6 cycles JSR to routine, 
    ;;  97 cycles routine with RTS
    ;;   1 cycle to fetch next instruction
    ;; ---
    ;;  104 cycles
