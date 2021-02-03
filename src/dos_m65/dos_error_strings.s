
;
; DOS error codes and strings
;


; XXX get rid of unnecessary error messages


dos_err_init_sdcard:

	!pet "m65 dos sdcard", 0

dos_err_init_floppy:

	!pet "m65 dos floppy", 0

dos_err_init_ramdisk:

	!pet "m65 dos ram disk", 0


; List compiled from various manuals (CBM 1571, CBM 1581, CMD FD4000, MSD Super Disk, IDE64)


dos_err_00: ; not an error

	!pet "ok", 0

dos_err_01: ; not an error

	!pet "files scratched", 0

dos_err_02: ; not an error

	!pet "partition selected", 0

dos_err_20: ; header not found
dos_err_21: ; no data addres mark
dos_err_22: ; block not found
dos_err_23: ; data error
dos_err_27: ; header error

	!pet "read error", 0

dos_err_25:

	!pet "write error", 0

dos_err_26:

	!pet "write protect on", 0

dos_err_29:

	!pet "disk changed", 0

dos_err_30: ; invalid characters in command
dos_err_31: ; unrecognized command
dos_err_32: ; command too long
dos_err_33: ; illegal file name
dos_err_34: ; missing file name

	!pet "syntax error", 0

dos_err_39:

	!pet "file not found", 0

dos_err_49: ; disk formatted, but format not supported

	!pet "invalid format", 0

dos_err_50:

	!pet "record not present", 0

dos_err_51:

	!pet "overflow in record", 0

dos_err_52:

	!pet "file too large", 0

dos_err_60:

	!pet "write file open", 0

dos_err_61:

	!pet "file not open", 0

dos_err_62:

	!pet "file not found", 0

dos_err_63:

	!pet "file exists", 0

dos_err_64:

	!pet "file type mismatch", 0

dos_err_65:

	!pet "no block", 0

dos_err_66:

	!pet "illegal track and sector", 0

dos_err_67:

	!pet "illegal system t or s", 0

dos_err_70:

	!pet "no channel", 0

dos_err_71:

	!pet "directory error", 0

dos_err_72:

	!pet "partition full", 0

dos_err_73:

	!pet "dos mismatch", 0

dos_err_74:

	!pet "drive not ready", 0

dos_err_75:

	!pet "format error", 0

dos_err_76:

	!pet "controller error", 0

dos_err_77:

	!pet "selected partition illegal", 0

dos_err_78:

	!pet "system error", 0

dos_err_79: ; SD2IEC compatible

	!pet "image invalid", 0
