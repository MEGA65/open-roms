
set_sane_devnum:

	;; Take last device number, make sure it's a drive
	;; If not, set to 8 (first drive number)
	;; Device number is left in X, for SETFLS Kernal routine

	;; Note: if tape support is introduced here, make sure DOS wedge won't get broken

	ldx current_device_number
	cpx #$07
	bpl +
	bcs +
	ldx #$08
	stx current_device_number
*
	rts
