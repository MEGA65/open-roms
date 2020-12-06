;; #LAYOUT# M65 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


cmd_joycrsr:

	; Make sure we are in MEGA65 native mode

	jsr helper_ensure_native_mode

	; Fetch joystick ID

	jsr fetch_uint8
	+bcs do_SYNTAX_error

	; Check if joystick ID is valid

	cmp #$03
	+bcs do_ILLEGAL_QUANTITY_error

	; Set the joystick responsible for moving cursor keys

	sta M65_JOYCRSR    ; XXX consider introducing Kernal call for this 
	rts
