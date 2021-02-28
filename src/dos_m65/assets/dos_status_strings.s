
;
; DOS error codes and strings
;


; XXX get rid of unnecessary error messages


dos_sts_init_sdcard:

	!pet "73,m65 dos sd card,00,00", 0

dos_sts_init_floppy:

	!pet "73,m65 dos floppy,00,00", 0

dos_sts_init_ramdisk:

	!pet "73,m65 dos ram disk,00,00", 0


; List compiled from various manuals (CBM 1571, CBM 1581, CMD FD4000, MSD Super Disk, IDE64)

dos_sts_00: ; not an error

	!pet " ok", 0

dos_sts_01: ; not an error

	!pet "files scratched", 0

dos_sts_02: ; not an error

	!pet "partition selected", 0

dos_sts_20: ; header not found
dos_sts_21: ; no data addres mark
dos_sts_22: ; block not found
dos_sts_23: ; data error
dos_sts_27: ; header error

	!pet "read error", 0

dos_sts_25:

	!pet "write error", 0

dos_sts_26:

	!pet "write protect on", 0

dos_sts_29:

	!pet "disk changed", 0

dos_sts_30: ; invalid characters in command
dos_sts_31: ; unrecognized command
dos_sts_32: ; command too long
dos_sts_33: ; illegal file name
dos_sts_34: ; missing file name

	!pet "syntax error", 0

dos_sts_39:

	!pet "file not found", 0

dos_sts_49: ; disk formatted, but format not supported

	!pet "invalid format", 0

dos_sts_50:

	!pet "record not present", 0

dos_sts_51:

	!pet "overflow in record", 0

dos_sts_52:

	!pet "file too large", 0

dos_sts_60:

	!pet "write file open", 0

dos_sts_61:

	!pet "file not open", 0

dos_sts_62:

	!pet "file not found", 0

dos_sts_63:

	!pet "file exists", 0

dos_sts_64:

	!pet "file type mismatch", 0

dos_sts_65:

	!pet "no block", 0

dos_sts_66:

	!pet "illegal track and sector", 0

dos_sts_67:

	!pet "illegal system t or s", 0

dos_sts_70:

	!pet "no channel", 0

dos_sts_71:

	!pet "directory error", 0

dos_sts_72:

	!pet "partition full", 0

dos_sts_73:

	!pet "dos mismatch", 0

dos_sts_74:

	!pet "drive not ready", 0

dos_sts_75:

	!pet "format error", 0

dos_sts_76:

	!pet "controller error", 0

dos_sts_77:

	!pet "selected partition illegal", 0

dos_sts_78:

	!pet "system error", 0

dos_sts_79: ; SD2IEC compatible

	!pet "image invalid", 0

dos_sts_XX: ; Open ROMs specific - unspecified error

	!pet "internal error", 0


dos_sts_tab_lo:

	!byte <dos_sts_00, <dos_sts_01, <dos_sts_02, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX
	!byte <dos_sts_XX, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX
	!byte <dos_sts_20, <dos_sts_21, <dos_sts_22, <dos_sts_23, <dos_sts_XX, <dos_sts_25, <dos_sts_26, <dos_sts_27, <dos_sts_XX, <dos_sts_29
	!byte <dos_sts_30, <dos_sts_31, <dos_sts_32, <dos_sts_33, <dos_sts_34, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX, <dos_sts_39
	!byte <dos_sts_XX, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX, <dos_sts_49
	!byte <dos_sts_50, <dos_sts_51, <dos_sts_52, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX, <dos_sts_XX
	!byte <dos_sts_60, <dos_sts_61, <dos_sts_62, <dos_sts_63, <dos_sts_64, <dos_sts_65, <dos_sts_66, <dos_sts_67, <dos_sts_XX, <dos_sts_XX
	!byte <dos_sts_70, <dos_sts_71, <dos_sts_72, <dos_sts_73, <dos_sts_74, <dos_sts_75, <dos_sts_76, <dos_sts_77, <dos_sts_78, <dos_sts_79
	!byte <dos_sts_XX

dos_sts_tab_hi:

	!byte >dos_sts_00, >dos_sts_01, >dos_sts_02, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX
	!byte >dos_sts_XX, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX
	!byte >dos_sts_20, >dos_sts_21, >dos_sts_22, >dos_sts_23, >dos_sts_XX, >dos_sts_25, >dos_sts_26, >dos_sts_27, >dos_sts_XX, >dos_sts_29
	!byte >dos_sts_30, >dos_sts_31, >dos_sts_32, >dos_sts_33, >dos_sts_34, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX, >dos_sts_39
	!byte >dos_sts_XX, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX, >dos_sts_49
	!byte >dos_sts_50, >dos_sts_51, >dos_sts_52, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX, >dos_sts_XX
	!byte >dos_sts_60, >dos_sts_61, >dos_sts_62, >dos_sts_63, >dos_sts_64, >dos_sts_65, >dos_sts_66, >dos_sts_67, >dos_sts_XX, >dos_sts_XX
	!byte >dos_sts_70, >dos_sts_71, >dos_sts_72, >dos_sts_73, >dos_sts_74, >dos_sts_75, >dos_sts_76, >dos_sts_77, >dos_sts_78, >dos_sts_79
	!byte >dos_sts_XX
