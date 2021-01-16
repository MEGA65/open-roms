
;
; Helper code for debugging the monitor
;

; XXX disable this code once the monitor integration is complete

DBG_print_Buf_Index:

	php
	pha
	phx
	phy
	phz

	jsr PRIMM
	!pet $0D, "buf idx : ", 0

	lda Buf_Index
	jsr Print_Hex

	plz
	ply
	plx
	pla
	plp

	rts


DBG_print_long_pc:

	php
	pha
	phx
	phy
	phz

	jsr PRIMM
	!pet $0D, "long pc : ", 0

	lda Long_PC+3
	jsr Print_Hex
	lda Long_PC+2
	jsr Print_Hex
	lda Long_PC+1
	jsr Print_Hex
	lda Long_PC+0
	jsr Print_Hex

	jsr PRIMM
	!pet "  addr mode : ", 0

	lda Addr_Mode
	jsr Print_Hex

	jsr PRIMM
	!pet "  ::  ", 0

	plz
	ply
	plx
	pla
	plp

	rts

DBG_print_hex:

	php
	pha
	phx
	phy
	phz

	pha
	jsr PRIMM
	!pet $0D, "hex     : ", 0	
	pla

	jsr Print_Hex

	plz
	ply
	plx
	pla
	plp

	rts

DBG_print_CP1:

	php
	pha
	phx
	phy
	phz

	jsr PRIMM
	!pet $0D, "checkpoint 1", 0	

	jmp DBG_END

DBG_print_CP2:

	php
	pha
	phx
	phy
	phz

	jsr PRIMM
	!pet $0D, "checkpoint 2", 0	

	; FALLTROUGH

DBG_END:

	plz
	ply
	plx
	pla
	plp

	rts


