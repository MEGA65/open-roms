
;
; Vector tables to device-specific routines
;


dos_cmd_OPEN_vectab:

	!word dev_sd_cmd_OPEN
	!word dev_fd_cmd_OPEN
	!word dev_rd_cmd_OPEN


dos_cmd_CLOSE_vectab:

	!word dev_sd_cmd_CLOSE
	!word dev_fd_cmd_CLOSE
	!word dev_rd_cmd_CLOSE
