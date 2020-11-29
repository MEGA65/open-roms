;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Command string definitions for programmable keys
;


!ifdef CONFIG_PROGRAMMABLE_KEYS {


programmable_keys_codes:

	!ifdef CONFIG_KEYCMD_RUN  { !byte KEY_RUN }

	!ifdef CONFIG_KEYCMD_F1   { !byte KEY_F1  }
	!ifdef CONFIG_KEYCMD_F2   { !byte KEY_F2  }
	!ifdef CONFIG_KEYCMD_F3   { !byte KEY_F3  }
	!ifdef CONFIG_KEYCMD_F4   { !byte KEY_F4  }
	!ifdef CONFIG_KEYCMD_F5   { !byte KEY_F5  }
	!ifdef CONFIG_KEYCMD_F6   { !byte KEY_F6  }
	!ifdef CONFIG_KEYCMD_F7   { !byte KEY_F7  }
	!ifdef CONFIG_KEYCMD_F8   { !byte KEY_F8  }

!ifndef CONFIG_LEGACY_SCNKEY {

!ifdef CONFIG_KEYBOARD_C128 {

	!ifdef CONFIG_KEYCMD_HELP { !byte KEY_HELP }

} else ifdef CONFIG_MB_M65 {

	!ifdef CONFIG_KEYCMD_HELP { !byte KEY_HELP }

	!ifdef CONFIG_KEYCMD_F9   { !byte KEY_F9  }
	!ifdef CONFIG_KEYCMD_F10  { !byte KEY_F10 }
	!ifdef CONFIG_KEYCMD_F11  { !byte KEY_F11 }
	!ifdef CONFIG_KEYCMD_F12  { !byte KEY_F12 }
	!ifdef CONFIG_KEYCMD_F13  { !byte KEY_F13 }
	!ifdef CONFIG_KEYCMD_F14  { !byte KEY_F14 }


} }


__programmable_keys_codes_end:


programmable_keys_strings:

__str_offset_RUN:     !ifdef CONFIG_KEYCMD_RUN  { +CONFIG_KEYCMD_RUN
	!byte $00 }

__str_offset_F1:      !ifdef CONFIG_KEYCMD_F1   { +CONFIG_KEYCMD_F1
	!byte $00 }
__str_offset_F2:      !ifdef CONFIG_KEYCMD_F2   { +CONFIG_KEYCMD_F2
	!byte $00 }
__str_offset_F3:      !ifdef CONFIG_KEYCMD_F3   { +CONFIG_KEYCMD_F3
	!byte $00 }
__str_offset_F4:      !ifdef CONFIG_KEYCMD_F4   { +CONFIG_KEYCMD_F4
	!byte $00 }
__str_offset_F5:      !ifdef CONFIG_KEYCMD_F5   { +CONFIG_KEYCMD_F5
	!byte $00 }
__str_offset_F6:      !ifdef CONFIG_KEYCMD_F6   { +CONFIG_KEYCMD_F6
	!byte $00 }
__str_offset_F7:      !ifdef CONFIG_KEYCMD_F7   { +CONFIG_KEYCMD_F7
	!byte $00 }
__str_offset_F8:      !ifdef CONFIG_KEYCMD_F8   { +CONFIG_KEYCMD_F8
	!byte $00 }

!ifndef CONFIG_LEGACY_SCNKEY {

!ifdef CONFIG_KEYBOARD_C128 {

__str_offset_HELP:    !ifdef CONFIG_KEYCMD_HELP { +CONFIG_KEYCMD_HELP
	!byte $00 }

} else ifdef CONFIG_MB_M65 {

__str_offset_HELP:    !ifdef CONFIG_KEYCMD_HELP { +CONFIG_KEYCMD_HELP
	!byte $00 }

__str_offset_F9:      !ifdef CONFIG_KEYCMD_F9   { +CONFIG_KEYCMD_F9
	!byte $00 }
__str_offset_F10:     !ifdef CONFIG_KEYCMD_F10  { +CONFIG_KEYCMD_F10
	!byte $00 }
__str_offset_F11:     !ifdef CONFIG_KEYCMD_F11  { +CONFIG_KEYCMD_F11
	!byte $00 }
__str_offset_F12:     !ifdef CONFIG_KEYCMD_F12  { +CONFIG_KEYCMD_F12
	!byte $00 }
__str_offset_F13:     !ifdef CONFIG_KEYCMD_F13  { +CONFIG_KEYCMD_F13
	!byte $00 }
__str_offset_F14:     !ifdef CONFIG_KEYCMD_F14  { +CONFIG_KEYCMD_F14
	!byte $00 }

} }


__programmable_keys_strings_end:

	!if (__programmable_keys_strings_end - programmable_keys_strings > 255) {
		!error "Programmable keys took too much space"
	}


programmable_keys_offsets:

	!ifdef CONFIG_KEYCMD_RUN  { !byte __str_offset_RUN  - programmable_keys_strings }

	!ifdef CONFIG_KEYCMD_F1   { !byte __str_offset_F1   - programmable_keys_strings }
	!ifdef CONFIG_KEYCMD_F2   { !byte __str_offset_F2   - programmable_keys_strings }
	!ifdef CONFIG_KEYCMD_F3   { !byte __str_offset_F3   - programmable_keys_strings }
	!ifdef CONFIG_KEYCMD_F4   { !byte __str_offset_F4   - programmable_keys_strings }
	!ifdef CONFIG_KEYCMD_F5   { !byte __str_offset_F5   - programmable_keys_strings }
	!ifdef CONFIG_KEYCMD_F6   { !byte __str_offset_F6   - programmable_keys_strings }
	!ifdef CONFIG_KEYCMD_F7   { !byte __str_offset_F7   - programmable_keys_strings }
	!ifdef CONFIG_KEYCMD_F8   { !byte __str_offset_F8   - programmable_keys_strings }

!ifndef CONFIG_LEGACY_SCNKEY {

!ifdef CONFIG_KEYBOARD_C128 {

	!ifdef CONFIG_KEYCMD_HELP { !byte __str_offset_HELP - programmable_keys_strings }

} else ifdef CONFIG_MB_M65 {
	
	!ifdef CONFIG_KEYCMD_HELP { !byte __str_offset_HELP - programmable_keys_strings }

	!ifdef CONFIG_KEYCMD_F9   { !byte __str_offset_F9   - programmable_keys_strings }
	!ifdef CONFIG_KEYCMD_F10  { !byte __str_offset_F10  - programmable_keys_strings }
	!ifdef CONFIG_KEYCMD_F11  { !byte __str_offset_F11  - programmable_keys_strings }
	!ifdef CONFIG_KEYCMD_F12  { !byte __str_offset_F12  - programmable_keys_strings }
	!ifdef CONFIG_KEYCMD_F13  { !byte __str_offset_F13  - programmable_keys_strings }
	!ifdef CONFIG_KEYCMD_F14  { !byte __str_offset_F14  - programmable_keys_strings }

} }

}
