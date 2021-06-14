
;
; Close currently opened file
;


unit_fd_cmd_CLOSE:

	; XXX provide implementation

	jsr lowlevel_fdc_motor_off         ; disable drive motor  XXX only do this if no channel is opened

	jmp dos_EXIT_SEC
