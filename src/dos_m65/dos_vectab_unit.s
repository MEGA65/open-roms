
;
; Vector tables to device-specific routines
;


dos_cmd_OPEN_vectab:

	!word unit_sd_cmd_OPEN
	!word unit_disk_cmd_OPEN
	!word unit_disk_cmd_OPEN


dos_cmd_CLOSE_vectab:

	!word unit_sd_cmd_CLOSE
	!word unit_fd_cmd_CLOSE
	!word unit_rd_cmd_CLOSE
