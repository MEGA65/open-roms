
;
; Z80 emulator - precalculated data generator
;


Z80_table_gen:

	jsr PRIMM
	!pet $0D, "Generating CPU tables"
	!byte 0

	;
	; Generating:   XXX
	; Dependencies: NONE
	; Destroys:     NONE
	;

	; XXX add table generators

	;
	; The END
	;

	jsr PRIMM
	!pet "    done", $0D, $0D
	!byte 0
	
	rts
