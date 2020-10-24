;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Well-known BASIC routine, described in:
;
; - [CM64] Computes Mapping the Commodore 64 - page 212
;
; Prints the start-up messages
;

INITMSG:

!ifdef CONFIG_MB_M65 {

	jsr map_BASIC_1
	jsr (VB1__INITMSG)

	; FALLTROUGH

INITMSG_end:
	
	jmp map_NORMAL

INITMSG_autoswitch:

	jsr map_BASIC_1
	jsr (VB1__INITMSG_autoswitch)
	bra INITMSG_end

} else ifdef ROM_LAYOUT_CRT {

	jsr map_BASIC_1
	jsr JB1__INITMSG
	jmp map_NORMAL

} else {

	jmp initmsg_real
}
