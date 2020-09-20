;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Startup banner, to be displayed during cold start
;


!macro  BANNER_TEXT {

!ifdef CONFIG_BRAND_CUSTOM_BUILD {
	!pet "open roms "
	+CONFIG_CUSTOM_BRAND
} else ifdef CONFIG_BRAND_GENERIC {
	!pet "open roms generic build"
} else ifdef CONFIG_BRAND_TESTING {
	!pet "open roms testing build"
} else ifdef CONFIG_BRAND_ULTIMATE_64 {
	!pet "open roms for ultimate 64"
}

}

startup_banner:

!ifdef CONFIG_BANNER_SIMPLE {

	!pet "    " 
	+BANNER_TEXT
	!byte $00

} else ifdef CONFIG_BANNER_FANCY {

	+BANNER_TEXT
	!byte $00

rainbow_logo:

	!set SET_COLOR_0 = $05
	!set SET_COLOR_1 = $1C
	!set SET_COLOR_2 = $9E
	!set SET_COLOR_3 = $1E
	!set SET_COLOR_4 = $9F

	!byte SET_COLOR_1, $12, $A4, $A4, $A4, $A4, $A4, $A4, $A4, $0D
    !byte SET_COLOR_2, $12, $A4, $A4, $A4, $A4, $A4, $A4, $0D
    !byte SET_COLOR_3, $12, $A4, $A4, $A4, $A4, $A4, $0D
    !byte SET_COLOR_4, $12, $A4, $A4, $A4, $A4, $92
    !byte SET_COLOR_0, $00

}
