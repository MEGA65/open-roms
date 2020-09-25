;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Do not change - unless there is a really important reason!
; Ideally, locations of the following data should be constant - now and forever!
;
; If you want to integrate Open ROMs support in your emulator, FPGA computer, etc. - this
; is the official way to recognize the ROM and its revision.
;


rom_revision_basic:

	; $BF52

	!pet "or"                 ; project signature, "OR" stands for "Open ROMs"
	!byte CONFIG_ID           ; config file ID - this may change between revisions, without any warning

rom_revision_basic_string:

	; $BF55

!ifndef CONFIG_BRAND_CUSTOM {
	!pet "(devel snapshot)"   ; ROM revision string; up to 16 characters, string format will change in the future
} else {
	!pet "(custom build)"
}

	!byte $00                 ; marks the end of string

__rom_revision_basic_end:
