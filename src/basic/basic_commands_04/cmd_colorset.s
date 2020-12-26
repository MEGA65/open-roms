;; #LAYOUT# M65 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


cmd_colorset:

	; Make sure we are in MEGA65 native mode

	jsr helper_ensure_native_mode

	; Fetch palette ID

	jsr fetch_uint8
	+bcs do_SYNTAX_error

	; Set the palette

	jsr m65_colorset
	+bcs do_ILLEGAL_QUANTITY_error

	rts
