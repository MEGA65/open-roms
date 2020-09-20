;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

; The IRQ is a commonly messed with thing on the C64,
; so we need to handle entry points that are commonly
; relied upon, including:
; $EA31 - Standard IRQ routine
; $EA61 - Check keyboard, but do not update timer? https://github.com/cc65/cc65/issues/324
; $EA81 - https://www.lemon64.com/forum/viewtopic.php?t=2112&sid=6ea01982b26da69783120a7923ca46fb
; Also the $0314 vector is widely used (e.g., https://www.lemon64.com/forum/viewtopic.php?t=2112&sid=6ea01982b26da69783120a7923ca46fb)


return_from_interrupt:

	; Restore registers and return
	; Sequence according to Computes Mapping the 64 p73

	+ply_trash_a
	+plx_trash_a
	pla

	; FALLTROUGH

return_from_interrupt_rti:

	rti
