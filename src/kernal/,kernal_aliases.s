
;
; Aliases for legacy keyboard scan routine
;

!ifdef CONFIG_LEGACY_SCNKEY {

	; Low memory variables

	; Reuse RS232 variables, since they should not be used by other things.
	; Carefully avoid $A7 which is used by 64NET
	!addr KeyQuantity       = $A8  ; 1 byte
	!addr BufferNew         = $A9  ; 3 bytes
	!addr TempZP            = $B6  ; 1 byte
	; These should be initialized in CINT to $FF
	!addr BufferQuantity    = $B4  ; 1 byte
	!addr BufferOld         = $293 ; 3 bytes
	!addr Buffer 	         = $297 ; 4 bytes

	; $250-$258 is the 81st - 88th characters in BASIC input, a carry over from VIC-20
	; and not used on C64, so safe for us to use, probably.
	!addr ScanResult = $250 ; 8 bytes
}
