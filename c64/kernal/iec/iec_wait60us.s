
iec_wait60us:

	;; Wait 60usec

	;; PAL:
	;; - CPU frequency 0.985248 MHz, we need to waste at least 60 cycles
	;; NTSC:
	;; - CPU frequency 1.022727 MHz, we need to waste at least 62 cycles

	;; Waste cycles in a loop

	ldy #$0A   ; 2 cycles
*	dey        ; 2 cycles * 10
	bpl -      ; 3 cycles * 9  + 2 cycles
	rts        ; 6 cycles

	;;   6 cycles JSR to routine, 
    ;;  57 cycles routine with RTS
    ;;   1 cycle to fetch next instruction
    ;; ---
    ;;  64 cycles

