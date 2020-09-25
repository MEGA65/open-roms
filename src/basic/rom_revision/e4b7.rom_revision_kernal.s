;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Do not change - unless there is a really important reason!
; Ideally, locations of the following data should be constant - now and forever!
;
; If you want to integrate Open ROMs support in your emulator, FPGA computer, etc. - this
; is the official way to recognize the ROM and its revision.
;


	; $E4B7

	; This vector is to be used by non-Kernal ROMs, if they want to
	; complain about incompatible ROM releases - do not use it directly,
	; use a 'panic' pseudocommand with error code (will be passed using .A)
	; #P_ERR_ROM_MISMATCH - it should remain stable even between releases

!ifdef CONFIG_PANIC_SCREEN {
	!word panic
} else {
	!word hw_entry_reset
}


rom_revision_kernal:

	; $E4B9

	!pet "or"                 ; project signature, "OR" stands for "Open ROMs"
	!byte CONFIG_ID           ; config file ID - this may change between revisions, without any warning

rom_revision_kernal_string:

	; $E4BC

!ifndef CONFIG_BRAND_CUSTOM {
	!pet "(devel snapshot)"   ; ROM revision string; up to 16 characters, string format will change in the future
} else {
	!pet "(custom build)"
}

	!byte $00                 ; marks the end of string

__rom_revision_kernal_end:
