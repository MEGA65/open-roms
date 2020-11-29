;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Matrix for retrieving bucky key status on the C64 keyboard
;
; Values based on:
; - [CM64]  Computes Mapping the Commodore 64 - pages 58 (SHFLAG), 173 (matrix)
; - [CM128] Computes Mapping the Commodore 128 - pages 212 (SHFLAG), 290 (matrix)
; - https://github.com/MEGA65/c65-specifications/blob/master/c65manualupdated.txt
;

!ifndef CONFIG_LEGACY_SCNKEY {


kb_matrix_bucky_confmask: ; values to be written to CIA1_PRA

	!byte %11111101 ; SHIFT (left)
	!byte %10111111 ; SHIFT (right)
	!byte %01111111 ; VENDOR      
	!byte %01111111 ; CTRL
!ifdef CONFIG_KEYBOARD_C128 {
	!byte %11111111 ; C128
	!byte %11111111
}

__kb_matrix_bucky_confmask_end:


!ifdef CONFIG_KEYBOARD_C128 {

kb_matrix_bucky_confmask_c128: ; values to be written to VIC_XSCAN

	!byte %11111111
	!byte %11111111
	!byte %11111111
	!byte %11111111

	!byte %11111011 ; ALT
	!byte %11111011 ; NO_SCRL
}


kb_matrix_bucky_testmask: ; for AND with CIA1_PRB value

	!byte %10000000 ; SHIFT (left)
	!byte %00010000 ; SHIFT (right)
	!byte %00100000 ; VENDOR
	!byte %00000100 ; CTRL
!ifdef CONFIG_KEYBOARD_C128 {
	!byte %10000000 ; ALT
	!byte %00000001 ; NO_SCRL
}


kb_matrix_bucky_shflag: ; mask to be ORed to SHFLAG to mark key status

	!byte KEY_FLAG_SHIFT
	!byte KEY_FLAG_SHIFT
	!byte KEY_FLAG_VENDOR
	!byte KEY_FLAG_CTRL
!ifdef CONFIG_MB_M65 {
	!byte KEY_FLAG_ALT
	!byte KEY_FLAG_NO_SCRL
	!byte KEY_FLAG_CAPSL
} else ifdef CONFIG_KEYBOARD_C128 {
	!byte KEY_FLAG_ALT
	!byte KEY_FLAG_NO_SCRL
}



} ; no CONFIG_LEGACY_SCNKEY
