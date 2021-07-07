
;
; Vector tables to device-specific routines
;


dos_cmd_OPEN_vectab:

	!word card_sd_cmd_OPEN
	!word disk_xx_cmd_OPEN
	!word disk_xx_cmd_OPEN
	!word disk_xx_cmd_OPEN


dos_cmd_CLOSE_vectab:

	!word card_sd_cmd_CLOSE
	!word disk_fd_cmd_CLOSE
	!word disk_fd_cmd_CLOSE
	!word disk_rd_cmd_CLOSE