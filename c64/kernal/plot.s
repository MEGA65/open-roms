
;;
;; Official Kernal routine, described in:
;;
;; - [RG64] C64 Programmer's Reference Guide   - page 290
;; - [CM64] Compute's Mapping the Commodore 64 - page 215
;;
;; CPU registers that has to be preserved (see [RG64]): none
;;

plot:
	bcs plot_get

plot_set:
	sty current_screen_y
	stx current_screen_x

	;; Our implementation has different screen editor, updating any
	;; other variables (see [CM64]) seems to be unnecessary

	;; FALLTROUGH to save one byte on RTS

plot_get:
	ldy current_screen_y
	ldx current_screen_x
	rts

